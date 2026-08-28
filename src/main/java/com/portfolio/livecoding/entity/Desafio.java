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
import jakarta.persistence.Lob;
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

    @Lob
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

    @Lob
    @Column(name = "template_codigo", columnDefinition = "TEXT")
    private String templateCodigo;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "tecnologia_id", nullable = false)
    private Tecnologia tecnologia;
}
