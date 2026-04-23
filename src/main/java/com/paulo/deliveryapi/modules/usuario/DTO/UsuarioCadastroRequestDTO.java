// UsuarioCadastroRequestDTO.java (O que entra)
package com.paulo.deliveryapi.modules.usuario.DTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UsuarioCadastroRequestDTO {

    @NotBlank(message = "O nome é obrigatório")
    private String nomeCompleto;

    private String cpf; // Opcional no cadastro inicial, por exemplo

    @NotBlank(message = "O telefone é obrigatório")
    private String telefone;

    @NotBlank(message = "O e-mail é obrigatório")
    @Email(message = "Formato de e-mail inválido")
    private String email;

    @NotBlank(message = "A senha é obrigatória")
    private String senha;
}