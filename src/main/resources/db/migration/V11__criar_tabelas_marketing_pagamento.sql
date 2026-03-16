-- Cupons de Desconto
CREATE TABLE cupom_desconto (
    id UUID PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    codigo VARCHAR(20) NOT NULL, -- Ex: "QUEROPIZZA10"
    tipo VARCHAR(20) NOT NULL, -- PERCENTUAL ou VALOR_FIXO
    valor DECIMAL(10, 2) NOT NULL,
    valor_minimo_pedido DECIMAL(10, 2) DEFAULT 0.00,
    data_validade TIMESTAMP,
    quantidade_disponivel INT, -- Nulo = uso ilimitado
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_cupom_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id)
);

-- Integração de Pagamento (Webhooks do Mercado Pago, Stripe, etc)
CREATE TABLE pagamento_pedido (
    id UUID PRIMARY KEY,
    pedido_id UUID NOT NULL UNIQUE,
    status_gateway VARCHAR(50) NOT NULL, -- approved, rejected, pending
    transacao_id_externo VARCHAR(255), -- O ID que o Mercado Pago devolve
    metodo_pagamento VARCHAR(50) NOT NULL,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id)
);

-- Avaliações de Usuários
CREATE TABLE avaliacao (
    id UUID PRIMARY KEY,
    pedido_id UUID NOT NULL UNIQUE,
    nota INT NOT NULL CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_avaliacao_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id)
);