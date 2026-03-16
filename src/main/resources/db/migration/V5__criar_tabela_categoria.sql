CREATE TABLE categoria (
    id UUID PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    ordem_exibicao INT DEFAULT 0, -- Para o dono escolher qual categoria aparece no topo
    ativa BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_categoria_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id)
);