CREATE TABLE item_pedido (
    id UUID PRIMARY KEY,
    pedido_id UUID NOT NULL,
    produto_id UUID NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL, -- Importante: Copia o preço do produto no dia. Não pode ler da tabela produto, senão altera o histórico se o preço subir amanhã.
    subtotal DECIMAL(10, 2) NOT NULL,
    observacao VARCHAR(255), -- "Ponto da carne: bem passada"
    
    CONSTRAINT fk_item_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (produto_id) REFERENCES produto(id)
);