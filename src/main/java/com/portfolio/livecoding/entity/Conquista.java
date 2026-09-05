package com.portfolio.livecoding.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Registro de que um candidato ja pontuou numa questao.
 *
 * <p>Existe para o ranking nao ser inflavel: sem ele, bastaria reenviar a mesma questao facil
 * varias vezes. O indice unico de (usuario, desafio) e quem garante isso de verdade — uma
 * checagem na aplicacao passaria batido em dois envios simultaneos.
 *
 * <p>Os pontos ficam gravados na linha em vez de recalculados a partir do nivel do desafio: se a
 * regra de pontuacao mudar amanha, o historico continua explicando o placar de hoje.
 */
@Entity
@Table(name = "conquistas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Conquista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "desafio_id", nullable = false)
    private Desafio desafio;

    @Column(nullable = false)
    private Integer pontos;

    /** Precisao da submissao que conquistou a questao, para o perfil mostrar como foi. */
    @Column(nullable = false)
    private Integer precisao;

    @Column(name = "conquistado_em", nullable = false)
    private LocalDateTime conquistadoEm;
}
