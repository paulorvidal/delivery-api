package com.paulo.deliveryapi.modules.pedido.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "pagamento_pedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PagamentoPedido {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Relacionamento 1:1 com o Pedido
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pedido_id", nullable = false, unique = true)
    private Pedido pedido;

    @Column(name = "status_gateway", nullable = false, length = 50)
    private String statusGateway;

    @Column(name = "transacao_id_externo", length = 255)
    private String transacaoIdExterno;

    @Column(name = "metodo_pagamento", nullable = false, length = 50)
    private String metodoPagamento;

    @Column(name = "data_atualizacao", nullable = false)
    private LocalDateTime dataAtualizacao;

    @PrePersist
    @PreUpdate
    protected void onSaveOrUpdate() {
        this.dataAtualizacao = LocalDateTime.now();
    }
}