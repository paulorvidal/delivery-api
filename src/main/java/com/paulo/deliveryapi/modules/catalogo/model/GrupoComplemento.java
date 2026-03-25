package com.paulo.deliveryapi.modules.catalogo.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "grupo_complemento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GrupoComplemento {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Relacionamento forte com o Produto
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "produto_id", nullable = false)
    private Produto produto;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(nullable = false)
    private Boolean obrigatorio;

    @Column(name = "minimo_escolhas")
    private Integer minimoEscolhas;

    @Column(name = "maximo_escolhas")
    private Integer maximoEscolhas;

    // Garante as regras de quantidade e obrigatoriedade do seu banco
    @PrePersist
    protected void onCreate() {
        this.obrigatorio = (this.obrigatorio != null) ? this.obrigatorio : false;
        this.minimoEscolhas = (this.minimoEscolhas != null) ? this.minimoEscolhas : 0;
        this.maximoEscolhas = (this.maximoEscolhas != null) ? this.maximoEscolhas : 1;
    }
}