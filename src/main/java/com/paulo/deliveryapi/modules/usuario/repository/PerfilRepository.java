// PerfilRepository.java
package com.paulo.deliveryapi.modules.usuario.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.paulo.deliveryapi.modules.usuario.model.Perfil;

public interface PerfilRepository extends JpaRepository<Perfil, Integer> {
    Optional<Perfil> findByNome(String nome);
}