CREATE TABLE horario_funcionamento (
    id SERIAL PRIMARY KEY,
    restaurante_id UUID NOT NULL,
    dia_semana INT NOT NULL, -- 1 = Domingo, 2 = Segunda...
    horario_abertura TIME NOT NULL,
    horario_fechamento TIME NOT NULL,
    
    CONSTRAINT fk_horario_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE
);