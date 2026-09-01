package com.portfolio.livecoding.entity;

import com.portfolio.livecoding.enums.StatusSubmissao;
import jakarta.persistence.CascadeType;
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
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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

    /**
     * Percentual de precisao: quanto do peso total de criterios do desafio a submissao acertou,
     * contando obrigatorios, pontuaveis e proibidos. Diferente de {@link #pontuacao}, que so olha
     * os pontuaveis. Nula nas submissoes anteriores a V4.
     */
    @Column
    private Integer precisao;

    /**
     * Tempo entre abrir o desafio e enviar a solucao. Vem da tentativa aberta no servidor, nunca
     * de um campo do corpo da requisicao. Nulo quando nao houve tentativa registrada.
     */
    @Column(name = "duracao_segundos")
    private Integer duracaoSegundos;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "desafio_id", nullable = false)
    private Desafio desafio;

    /** Detalhamento da correcao, criterio a criterio. E o que alimenta o painel do admin. */
    @OneToMany(mappedBy = "submissao", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ResultadoCriterio> resultados = new ArrayList<>();

    public void adicionarResultado(ResultadoCriterio resultado) {
        resultado.setSubmissao(this);
        resultados.add(resultado);
    }

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
