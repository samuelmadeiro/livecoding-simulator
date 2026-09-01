package com.portfolio.livecoding.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Cronometro de um desafio, aberto quando o candidato comeca e fechado quando ele envia.
 *
 * <p>O tempo gasto e medido aqui, no servidor, e nao num campo do corpo da submissao: qualquer
 * numero que o cliente mandasse seria aceito, e o painel do admin passaria a exibir ficcao.
 */
@Entity
@Table(name = "tentativas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Tentativa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "desafio_id", nullable = false)
    private Desafio desafio;

    @Column(name = "iniciado_em", nullable = false)
    private LocalDateTime iniciadoEm;

    /** Preenchido na submissao. Nulo enquanto a tentativa esta em aberto. */
    @Column(name = "finalizado_em")
    private LocalDateTime finalizadoEm;

    @PrePersist
    public void prePersist() {
        if (iniciadoEm == null) {
            iniciadoEm = LocalDateTime.now();
        }
    }
}
