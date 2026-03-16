CREATE TABLE produto (
    id UUID PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco_base DECIMAL(10, 2) NOT NULL,
    preco_promocional DECIMAL(10, 2), -- Se preenchido, o Front-end risca o preço base e mostra esse
    imagem_url VARCHAR(255),
    permite_observacao BOOLEAN NOT NULL DEFAULT TRUE, -- Novo: O cliente pode escrever "Sem cebola"?
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_produto_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);