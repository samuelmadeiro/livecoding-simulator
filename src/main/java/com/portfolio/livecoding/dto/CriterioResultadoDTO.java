package com.portfolio.livecoding.dto;

/**
 * Um item do feedback: o que era esperado e se a submissao atendeu.
 * Nao carrega a regex do criterio — so o texto humano.
 */
public record CriterioResultadoDTO(String descricao, boolean atendido) {
}
