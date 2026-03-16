CREATE TABLE pedido (
    id UUID PRIMARY KEY,
    codigo_curto VARCHAR(10) NOT NULL, -- Novo: O código de 4 ou 6 dígitos para o motoboy bipar/conferir
    restaurante_id UUID NOT NULL,
    usuario_id UUID NOT NULL,
    endereco_entrega_id UUID, -- Pode ser nulo se for 'Retirada no balcão'
    
    status VARCHAR(50) NOT NULL DEFAULT 'PENDENTE', -- PENDENTE, CONFIRMADO, PREPARANDO, SAIU_ENTREGA, ENTREGUE, CANCELADO
    
    -- Valores Financeiros (Fotografia do momento da compra)
    subtotal DECIMAL(10, 2) NOT NULL,
    taxa_entrega DECIMAL(10, 2) NOT NULL,
    desconto DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10, 2) NOT NULL,
    
    -- Pagamento
    forma_pagamento VARCHAR(50) NOT NULL, -- PIX, CARTAO_APP, DINHEIRO, MAQUINA_CARTAO
    troco_para DECIMAL(10, 2),
    
    -- Controle de Tempo e Informação
    observacao_geral TEXT,
    motivo_cancelamento VARCHAR(255),
    data_hora_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_entrega TIMESTAMP, -- Preenchido quando o status muda para ENTREGUE
    
    CONSTRAINT fk_pedido_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id),
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT fk_pedido_endereco FOREIGN KEY (endereco_entrega_id) REFERENCES endereco_usuario(id)
);