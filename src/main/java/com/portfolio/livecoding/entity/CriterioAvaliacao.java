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
 * Um sinal avaliado na correcao de um desafio. Varios criterios por desafio substituem a
 * palavra-chave unica que decidia aprovado/reprovado antes.
 *
 * <p>O campo {@code padrao} e uma regex e nunca deve ser exposto pela API: entregar a regex ao
 * candidato e entregar a resposta. Por isso {@link Desafio} nao tem uma colecao mapeada para ca —
 * o DesafioResponseDTO serializa a entidade e o vazamento seria automatico.
 */
@Entity
@Table(name = "criterios_avaliacao")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class CriterioAvaliacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "desafio_id", nullable = false)
    private Desafio desafio;

    /** Texto mostrado ao candidato no feedback. */
    @Column(nullable = false, length = 200)
    private String descricao;

    /** Regex aplicada ao codigo enviado, sempre case-insensitive. */
    @Column(nullable = false, columnDefinition = "TEXT")
    private String padrao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TipoCriterio tipo;

    /** Peso na nota. So conta para criterios PONTUAVEL. */
    @Column(nullable = false)
    private Integer peso;
}
