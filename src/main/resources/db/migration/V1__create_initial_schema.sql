-- 1. Núcleo de Identidade e Lojista (Sem dependências fortes)
CREATE TABLE perfil (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

CREATE TABLE restaurante (
    id UUID PRIMARY KEY,
    slug VARCHAR(100) NOT NULL UNIQUE,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL,
    descricao VARCHAR(500),
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    telefone_contato VARCHAR(20),
    
    -- Customização Visual
    cor_primaria VARCHAR(10),
    logo_url VARCHAR(255),
    capa_url VARCHAR(255),
    
    -- Regras de Negócio e Delivery
    pedido_minimo DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    taxa_entrega_base DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    frete_gratis_acima_de DECIMAL(10, 2),
    tempo_min_entrega INT,
    tempo_max_entrega INT,
    aceita_retirada BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Endereço Físico do Restaurante
    cep VARCHAR(10),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf VARCHAR(2),
    
    -- Status
    aberto BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Auditoria
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Usuários e Endereços (Dependem de Perfil e Restaurante)
CREATE TABLE usuario (
    id UUID PRIMARY KEY,
    perfil_id INT NOT NULL,
    restaurante_id UUID, 
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_usuario_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(id),
    CONSTRAINT fk_usuario_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id)
);

CREATE TABLE endereco_usuario (
    id UUID PRIMARY KEY,
    usuario_id UUID NOT NULL,
    cep VARCHAR(10) NOT NULL,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    ponto_referencia VARCHAR(255),
    padrao BOOLEAN NOT NULL DEFAULT FALSE, 
    
    CONSTRAINT fk_endereco_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);

-- 3. Catálogo e Configurações da Loja (Dependem de Restaurante)
CREATE TABLE categoria (
    id UUID PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    ordem_exibicao INT DEFAULT 0,
    ativa BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_categoria_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id)
);

CREATE TABLE produto (
    id UUID PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco_base DECIMAL(10, 2) NOT NULL,
    preco_promocional DECIMAL(10, 2),
    imagem_url VARCHAR(255),
    permite_observacao BOOLEAN NOT NULL DEFAULT TRUE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_produto_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE grupo_complemento (
    id UUID PRIMARY KEY,
    produto_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL,
    obrigatorio BOOLEAN NOT NULL DEFAULT FALSE,
    minimo_escolhas INT DEFAULT 0,
    maximo_escolhas INT DEFAULT 1,
    
    CONSTRAINT fk_grupo_produto FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE
);

CREATE TABLE complemento (
    id UUID PRIMARY KEY,
    grupo_complemento_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco_adicional DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_complemento_grupo FOREIGN KEY (grupo_complemento_id) REFERENCES grupo_complemento(id) ON DELETE CASCADE
);

CREATE TABLE horario_funcionamento (
    id SERIAL PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    dia_semana INT NOT NULL,
    horario_abertura TIME NOT NULL,
    horario_fechamento TIME NOT NULL,
    
    CONSTRAINT fk_horario_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE
);

CREATE TABLE cupom_desconto (
    id UUID PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    valor_minimo_pedido DECIMAL(10, 2) DEFAULT 0.00,
    data_validade TIMESTAMP,
    quantidade_disponivel INT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_cupom_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id)
);

-- 4. Vendas e Transações (Dependem de quase tudo)
CREATE TABLE pedido (
    id UUID PRIMARY KEY,
    codigo_curto VARCHAR(10) NOT NULL,
    restaurante_id UUID NOT NULL,
    usuario_id UUID NOT NULL,
    endereco_entrega_id UUID,
    
    status VARCHAR(50) NOT NULL DEFAULT 'PENDENTE',
    
    subtotal DECIMAL(10, 2) NOT NULL,
    taxa_entrega DECIMAL(10, 2) NOT NULL,
    desconto DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10, 2) NOT NULL,
    
    forma_pagamento VARCHAR(50) NOT NULL,
    troco_para DECIMAL(10, 2),
    
    observacao_geral TEXT,
    motivo_cancelamento VARCHAR(255),
    data_hora_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_entrega TIMESTAMP,
    
    CONSTRAINT fk_pedido_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id),
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT fk_pedido_endereco FOREIGN KEY (endereco_entrega_id) REFERENCES endereco_usuario(id)
);

CREATE TABLE item_pedido (
    id UUID PRIMARY KEY,
    pedido_id UUID NOT NULL,
    produto_id UUID NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    observacao VARCHAR(255),
    
    CONSTRAINT fk_item_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (produto_id) REFERENCES produto(id)
);

CREATE TABLE pagamento_pedido (
    id UUID PRIMARY KEY,
    pedido_id UUID NOT NULL UNIQUE,
    status_gateway VARCHAR(50) NOT NULL,
    transacao_id_externo VARCHAR(255),
    metodo_pagamento VARCHAR(50) NOT NULL,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id)
);

CREATE TABLE avaliacao (
    id UUID PRIMARY KEY,
    pedido_id UUID NOT NULL UNIQUE,
    nota INT NOT NULL CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_avaliacao_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id)
);