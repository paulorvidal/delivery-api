package com.paulo.deliveryapi.modules.restaurante.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "restaurante")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Restaurante {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true, length = 100)
    private String slug;

    @Column(name = "razao_social", nullable = false, length = 255)
    private String razaoSocial;

    @Column(name = "nome_fantasia", nullable = false, length = 255)
    private String nomeFantasia;

    @Column(length = 500)
    private String descricao;

    @Column(nullable = false, unique = true, length = 20)
    private String cnpj;

    @Column(name = "telefone_contato", length = 20)
    private String telefoneContato;

    // Customização Visual
    @Column(name = "cor_primaria", length = 10)
    private String corPrimaria;

    @Column(name = "logo_url")
    private String logoUrl;

    @Column(name = "capa_url")
    private String capaUrl;

    // Regras de Negócio
    @Column(name = "pedido_minimo", nullable = false)
    private BigDecimal pedidoMinimo = BigDecimal.ZERO;

    @Column(name = "taxa_entrega_base", nullable = false)
    private BigDecimal taxaEntregaBase = BigDecimal.ZERO;

    @Column(name = "frete_gratis_acima_de")
    private BigDecimal freteGratisAcimaDe;

    @Column(name = "tempo_min_entrega")
    private Integer tempoMinEntrega;

    @Column(name = "tempo_max_entrega")
    private Integer tempoMaxEntrega;

    @Column(name = "aceita_retirada", nullable = false)
    private Boolean aceitaRetirada = false;

    // Endereço Físico
    @Column(length = 10)
    private String cep;
    private String logradouro;
    @Column(length = 20)
    private String numero;
    @Column(length = 100)
    private String bairro;
    @Column(length = 100)
    private String cidade;
    @Column(length = 2)
    private String uf;

    // Status
    @Column(nullable = false)
    private Boolean aberto = false;

    @Column(nullable = false)
    private Boolean ativo = true;

    // Auditoria
    @Column(name = "criado_em", nullable = false, updatable = false)
    private LocalDateTime criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private LocalDateTime atualizadoEm;

    @PrePersist
    protected void onCreate() {
        this.criadoEm = LocalDateTime.now();
        this.atualizadoEm = LocalDateTime.now();
        this.ativo = (this.ativo != null) ? this.ativo : true;
        this.aberto = (this.aberto != null) ? this.aberto : false;
    }

    @PreUpdate
    protected void onUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }
}