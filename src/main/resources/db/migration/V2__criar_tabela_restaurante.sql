CREATE TABLE restaurante (
    id UUID PRIMARY KEY,
    slug VARCHAR(100) NOT NULL UNIQUE,
    razao_social VARCHAR(255) NOT NULL,          -- Novo: Exigência fiscal/nota
    nome_fantasia VARCHAR(255) NOT NULL,
    descricao VARCHAR(500),                      -- Novo: "A melhor pizza da região..."
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    telefone_contato VARCHAR(20),
    
    -- Customização Visual
    cor_primaria VARCHAR(10),
    logo_url VARCHAR(255),
    capa_url VARCHAR(255),
    
    -- Regras de Negócio e Delivery
    pedido_minimo DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Novo: iFood usa muito isso
    taxa_entrega_base DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    frete_gratis_acima_de DECIMAL(10, 2),               -- Novo: Estratégia de vendas
    tempo_min_entrega INT,
    tempo_max_entrega INT,
    aceita_retirada BOOLEAN NOT NULL DEFAULT FALSE,     -- Novo: Takeaway (Retirada no balcão)
    
    -- Endereço Físico do Restaurante
    cep VARCHAR(10),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf VARCHAR(2),
    
    -- Status
    aberto BOOLEAN NOT NULL DEFAULT FALSE, -- O dono ligou/desligou a loja hoje?
    ativo BOOLEAN NOT NULL DEFAULT TRUE,   -- A loja pagou a mensalidade do seu sistema?
    
    -- Auditoria
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);