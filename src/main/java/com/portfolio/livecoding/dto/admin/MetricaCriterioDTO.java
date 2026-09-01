package com.portfolio.livecoding.dto.admin;

import com.portfolio.livecoding.enums.TipoCriterio;

/**
 * Precisao de um criterio dentro de um desafio: de todas as vezes que ele foi cobrado, em quantas
 * a submissao atendeu. E a leitura que diz onde as pessoas travam — a nota media do desafio diz
 * que ele e dificil, esta linha diz por que.
 */
public record MetricaCriterioDTO(
        String descricao,
        TipoCriterio tipo,
        int peso,
        long avaliacoes,
        long atendidas,
        int taxaAcerto
) {
}
