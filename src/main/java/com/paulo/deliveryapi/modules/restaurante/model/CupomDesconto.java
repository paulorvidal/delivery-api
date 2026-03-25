package com.paulo.deliveryapi.modules.restaurante.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "cupom_desconto")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CupomDesconto {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurante_id", nullable = false)
    private Restaurante restaurante;

    @Column(nullable = false, length = 20)
    private String codigo;

    @Column(nullable = false, length = 20)
    private String tipo;

    @Column(nullable = false)
    private BigDecimal valor;

    @Column(name = "valor_minimo_pedido")
    private BigDecimal valorMinimoPedido;

    @Column(name = "data_validade")
    private LocalDateTime dataValidade;

    @Column(name = "quantidade_disponivel")
    private Integer quantidadeDisponivel;

    @Column(nullable = false)
    private Boolean ativo;

    @PrePersist
    protected void onCreate() {
        this.ativo = (this.ativo != null) ? this.ativo : true;
        this.valorMinimoPedido = (this.valorMinimoPedido != null) ? this.valorMinimoPedido : BigDecimal.ZERO;
    }
}
