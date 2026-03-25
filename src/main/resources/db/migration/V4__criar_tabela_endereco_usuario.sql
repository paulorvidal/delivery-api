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