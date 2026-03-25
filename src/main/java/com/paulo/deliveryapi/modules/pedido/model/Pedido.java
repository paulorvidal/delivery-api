package com.paulo.deliveryapi.modules.pedido.model;

import com.paulo.deliveryapi.modules.restaurante.model.Restaurante;
import com.paulo.deliveryapi.modules.usuario.model.EnderecoUsuario;
import com.paulo.deliveryapi.modules.usuario.model.Usuario;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.List;

@Entity
@Table(name = "pedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "codigo_curto", nullable = false, length = 10)
    private String codigoCurto;

    // Relacionamentos Fortes (Chaves Estrangeiras)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurante_id", nullable = false)
    private Restaurante restaurante;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "endereco_entrega_id")
    private EnderecoUsuario enderecoEntrega;

    @Column(nullable = false, length = 50)
    private String status = "PENDENTE";

    // O relacionamento com os itens do pedido
    @OneToMany(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ItemPedido> itens;

    // Valores Financeiros
    @Column(nullable = false)
    private BigDecimal subtotal;

    @Column(name = "taxa_entrega", nullable = false)
    private BigDecimal taxaEntrega;

    @Column(nullable = false)
    private BigDecimal desconto = BigDecimal.ZERO;

    @Column(nullable = false)
    private BigDecimal total;

    // Campos de Pagamento da Tabela Pedido
    @Column(name = "forma_pagamento", nullable = false, length = 50)
    private String formaPagamento;

    @Column(name = "troco_para")
    private BigDecimal trocoPara;

    // A MÁGICA DO 1:1 - Ligando o Pedido com a Tabela de Pagamento Externa e
    // Avaliação
    @OneToOne(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    private PagamentoPedido pagamento;

    @OneToOne(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    private Avaliacao avaliacao;

    // Controle de Tempo e Informação
    @Column(name = "observacao_geral", columnDefinition = "TEXT")
    private String observacaoGeral;

    @Column(name = "motivo_cancelamento", length = 255)
    private String motivoCancelamento;

    @Column(name = "data_hora_pedido", nullable = false, updatable = false)
    private LocalDateTime dataHoraPedido;

    @Column(name = "data_hora_entrega")
    private LocalDateTime dataHoraEntrega;

    @PrePersist
    protected void onCreate() {
        this.dataHoraPedido = LocalDateTime.now();
        this.status = (this.status != null) ? this.status : "PENDENTE";
        this.desconto = (this.desconto != null) ? this.desconto : BigDecimal.ZERO;
    }
}