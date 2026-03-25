package com.paulo.deliveryapi.modules.catalogo.model;

import com.paulo.deliveryapi.modules.restaurante.model.Restaurante;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "categoria")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Categoria {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Tradução da CONSTRAINT fk_categoria_restaurante
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurante_id", nullable = false)
    private Restaurante restaurante;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(length = 255)
    private String descricao;

    @Column(name = "ordem_exibicao")
    private Integer ordemExibicao;

    @Column(nullable = false)
    private Boolean ativa;

    // Garante os valores DEFAULT do seu banco caso o Front-end mande nulo
    @PrePersist
    protected void onCreate() {
        this.ativa = (this.ativa != null) ? this.ativa : true;
        this.ordemExibicao = (this.ordemExibicao != null) ? this.ordemExibicao : 0;
    }
}