package com.paulo.deliveryapi.modules.catalogo.model;

import com.paulo.deliveryapi.modules.restaurante.model.Restaurante;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "produto")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Relacionamento com Restaurante
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurante_id", nullable = false)
    private Restaurante restaurante;

    // Relacionamento com Categoria
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @Column(nullable = false, length = 255)
    private String nome;

    @Column(columnDefinition = "TEXT")
    private String descricao;

    // Valores Financeiros
    @Column(name = "preco_base", nullable = false)
    private BigDecimal precoBase;

    @Column(name = "preco_promocional")
    private BigDecimal precoPromocional;

    @Column(name = "imagem_url", length = 255)
    private String imagemUrl;

    @Column(name = "permite_observacao", nullable = false)
    private Boolean permiteObservacao;

    @Column(nullable = false)
    private Boolean ativo;

    // Auditoria
    @Column(name = "criado_em", nullable = false, updatable = false)
    private LocalDateTime criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private LocalDateTime atualizadoEm;

    protected void onCreate() {
        this.criadoEm = LocalDateTime.now();
        this.atualizadoEm = LocalDateTime.now();
        this.ativo = (this.ativo == null) ? true : this.ativo;
        this.permiteObservacao = (this.permiteObservacao == null) ? false : this.permiteObservacao;
    }

    protected void onUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }
}