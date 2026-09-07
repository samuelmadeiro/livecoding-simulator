package com.portfolio.livecoding.enums;

/**
 * Quanto o desafio cobra de quem resolve. Eixo proprio, separado de {@link NivelVaga}: nivel diz
 * para qual vaga a questao serve, dificuldade diz o tamanho do problema. Um desafio de PLENO pode
 * ser FACIL e um de ESTAGIO pode ser DIFICIL.
 *
 * <p>O peso existe para ordenar. Sem ele, ordenar pelo nome da constante devolveria DIFICIL,
 * FACIL, MEDIO — alfabetico, e nao progressivo.
 */
public enum Dificuldade {

    FACIL(1),
    MEDIO(2),
    DIFICIL(3);

    private final int peso;

    Dificuldade(int peso) {
        this.peso = peso;
    }

    public int getPeso() {
        return peso;
    }
}
