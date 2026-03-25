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