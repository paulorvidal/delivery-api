package com.paulo.deliveryapi.modules.catalogo.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "complemento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Complemento {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Relacionamento com o Grupo
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "grupo_complemento_id", nullable = false)
    private GrupoComplemento grupoComplemento;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(length = 255)
    private String descricao;

    @Column(name = "preco_adicional", nullable = false)
    private BigDecimal precoAdicional;

    @Column(nullable = false)
    private Boolean ativo;

    @PrePersist
    protected void onCreate() {
        this.precoAdicional = (this.precoAdicional != null) ? this.precoAdicional : BigDecimal.ZERO;
        this.ativo = (this.ativo != null) ? this.ativo : true;
    }
}