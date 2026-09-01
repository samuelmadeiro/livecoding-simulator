package com.portfolio.livecoding.enums;

/** Papel de um criterio na correcao de um desafio. */
public enum TipoCriterio {

    /** Falhou, reprova a submissao, por melhor que seja a pontuacao do resto. */
    OBRIGATORIO,

    /** Soma peso para a nota final. A aprovacao depende do limiar. */
    PONTUAVEL,

    /** Se casar, reprova. Usado para sinais de codigo incompleto ou solucao proibida. */
    PROIBIDO
}
