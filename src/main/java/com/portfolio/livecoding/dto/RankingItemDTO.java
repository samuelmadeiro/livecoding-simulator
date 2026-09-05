package com.portfolio.livecoding.dto;

/**
 * Uma linha do ranking publico.
 *
 * <p>Carrega apelido, e nunca nome completo ou e-mail: esta lista aparece para visitante anonimo
 * na home.
 */
public record RankingItemDTO(
        int posicao,
        String apelido,
        int pontos,
        int sequenciaAtual,
        long questoesResolvidas) {
}
