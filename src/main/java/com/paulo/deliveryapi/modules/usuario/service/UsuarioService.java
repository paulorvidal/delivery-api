// UsuarioService.java
package com.paulo.deliveryapi.modules.usuario.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.paulo.deliveryapi.modules.usuario.DTO.UsuarioCadastroRequestDTO;
import com.paulo.deliveryapi.modules.usuario.DTO.UsuarioResponseDTO;
import com.paulo.deliveryapi.modules.usuario.model.Perfil;
import com.paulo.deliveryapi.modules.usuario.model.Usuario;
import com.paulo.deliveryapi.modules.usuario.repository.PerfilRepository;
import com.paulo.deliveryapi.modules.usuario.repository.UsuarioRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PerfilRepository perfilRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public UsuarioResponseDTO cadastrarCliente(UsuarioCadastroRequestDTO dto) {

        // 1. Validação básica (Você pode criar exceptions customizadas depois)
        if (usuarioRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("E-mail já cadastrado!");
        }

        // 2. Busca o perfil de Cliente (Segurança)
        Perfil perfilCliente = perfilRepository.findByNome("ROLE_CLIENTE")
                .orElseThrow(() -> new RuntimeException("Perfil não encontrado no banco de dados"));

        // 3. Monta a entidade
        Usuario novoUsuario = Usuario.builder()
                .nomeCompleto(dto.getNomeCompleto())
                .cpf(dto.getCpf())
                .telefone(dto.getTelefone())
                .email(dto.getEmail())
                .senhaHash(passwordEncoder.encode(dto.getSenha())) // Criptografa a senha!
                .perfil(perfilCliente)
                // restaurante não é setado, pois ele é um cliente global
                .build();

        // 4. Salva no banco
        Usuario usuarioSalvo = usuarioRepository.save(novoUsuario);

        // 5. Retorna o DTO limpo
        return UsuarioResponseDTO.builder()
                .id(usuarioSalvo.getId())
                .nomeCompleto(usuarioSalvo.getNomeCompleto())
                .email(usuarioSalvo.getEmail())
                .perfil(usuarioSalvo.getPerfil().getNome())
                .build();
    }
}