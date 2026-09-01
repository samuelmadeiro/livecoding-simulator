package com.portfolio.livecoding.entity;

import com.portfolio.livecoding.enums.StatusSubmissao;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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

@Entity
@Table(name = "submissoes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Submissao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "codigo_enviado", nullable = false, columnDefinition = "TEXT")
    private String codigoEnviado;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private StatusSubmissao status;

    @Column(name = "data_hora", nullable = false)
    private LocalDateTime dataHora;

    /** Nota de 0 a 100 dada pelo ValidadorCodigoService. Nula nas submissoes anteriores a V2. */
    @Column
    private Integer pontuacao;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "desafio_id", nullable = false)
    private Desafio desafio;

    @PrePersist
    public void prePersist() {
        if (dataHora == null) {
            dataHora = LocalDateTime.now();
        }
        if (status == null) {
            status = StatusSubmissao.PENDENTE;
        }
    }
}
