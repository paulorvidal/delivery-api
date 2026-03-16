CREATE TABLE grupo_complemento (
    id UUID PRIMARY KEY,
    produto_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL, -- Ex: "Escolha o ponto da carne" ou "Adicionais"
    obrigatorio BOOLEAN NOT NULL DEFAULT FALSE,
    minimo_escolhas INT DEFAULT 0,
    maximo_escolhas INT DEFAULT 1,
    
    CONSTRAINT fk_grupo_produto FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE
);

CREATE TABLE complemento (
    id UUID PRIMARY KEY,
    grupo_complemento_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL, -- Ex: "Bem passada" ou "Bacon"
    descricao VARCHAR(255),
    preco_adicional DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_complemento_grupo FOREIGN KEY (grupo_complemento_id) REFERENCES grupo_complemento(id) ON DELETE CASCADE
);