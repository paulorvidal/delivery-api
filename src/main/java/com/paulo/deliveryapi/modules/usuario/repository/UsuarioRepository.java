// UsuarioRepository.java
package com.paulo.deliveryapi.modules.usuario.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.paulo.deliveryapi.modules.usuario.model.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, UUID> {
    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    boolean existsByCpf(String cpf);
}