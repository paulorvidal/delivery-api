// UsuarioResponseDTO.java (O que devolvemos)
package com.paulo.deliveryapi.modules.usuario.DTO;

import java.util.UUID;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UsuarioResponseDTO {
    private UUID id;
    private String nomeCompleto;
    private String email;
    private String perfil; // Devolvemos apenas o nome do perfil (ex: ROLE_CLIENTE)
}