package com.portfolio.livecoding.entity;

import com.portfolio.livecoding.enums.TipoCriterio;
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
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * O que uma submissao atendeu, criterio a criterio.
 *
 * <p>Guardar so a nota final responde "passou?"; guardar linha a linha responde "onde as pessoas
 * travam neste desafio?", que e a pergunta do painel do admin. A descricao, o tipo e o peso sao
 * copiados do criterio no momento da correcao: se a regua do desafio mudar amanha, o historico
 * continua contando o que foi cobrado hoje.
 */
@Entity
@Table(name = "resultados_criterio")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class ResultadoCriterio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "submissao_id", nullable = false)
    private Submissao submissao;

    /** Nulo quando o criterio de origem foi apagado depois da correcao. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "criterio_id")
    private CriterioAvaliacao criterio;

    @Column(nullable = false, length = 200)
    private String descricao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TipoCriterio tipo;

    @Column(nullable = false)
    private Integer peso;

    @Column(nullable = false)
    private boolean atendido;
}
