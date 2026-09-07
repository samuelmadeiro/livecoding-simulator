package com.portfolio.livecoding.enums;

/**
 * Ordenacoes que o catalogo aceita. E uma lista fechada de proposito: o cliente escolhe uma
 * constante, nunca o nome de uma coluna, entao nao ha como pedir ordenacao por um campo que a API
 * nao quer expor.
 */
public enum OrdemDesafios {

    /** Ordem de cadastro. E a do catalogo montado a mao pelas migrations. */
    PADRAO,
    DIFICULDADE_CRESCENTE,
    DIFICULDADE_DECRESCENTE,
    TITULO,
    TEMPO_CRESCENTE,
    TEMPO_DECRESCENTE
}
