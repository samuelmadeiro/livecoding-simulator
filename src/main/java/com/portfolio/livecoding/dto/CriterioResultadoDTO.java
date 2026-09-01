package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.TipoCriterio;

/**
 * Um item do feedback: o que era esperado, quanto vale e se a submissao atendeu.
 * Nao carrega a regex do criterio — so o texto humano e a dica.
 */
public record CriterioResultadoDTO(
        String descricao,
        boolean atendido,
        TipoCriterio tipo,
        int peso,
        String dica
) {
}
