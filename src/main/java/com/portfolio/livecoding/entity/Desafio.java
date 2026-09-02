package com.portfolio.livecoding.entity;

import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
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

@Entity
@Table(name = "desafios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Desafio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descricao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private NivelVaga nivel;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private TipoDesafio tipo;

    @Column(name = "tempo_limite_minutos", nullable = false)
    private Integer tempoLimiteMinutos;

    @Column(name = "template_codigo", columnDefinition = "TEXT")
    private String templateCodigo;

    /*
     * Partes do enunciado. Ficam em colunas separadas, e nao dentro de descricao, para que toda
     * questao seja obrigada a responder as mesmas perguntas: por que isso existe, o que entra, o
     * que sai, um caso resolvido e o que nao vale. Nulas nos desafios anteriores a V5.
     */

    @Column(columnDefinition = "TEXT")
    private String contexto;

    @Column(name = "formato_entrada", columnDefinition = "TEXT")
    private String formatoEntrada;

    @Column(name = "formato_saida", columnDefinition = "TEXT")
    private String formatoSaida;

    @Column(columnDefinition = "TEXT")
    private String exemplo;

    @Column(columnDefinition = "TEXT")
    private String restricoes;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "tecnologia_id", nullable = false)
    private Tecnologia tecnologia;
}
