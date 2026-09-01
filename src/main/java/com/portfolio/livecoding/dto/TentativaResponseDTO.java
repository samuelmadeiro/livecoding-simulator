package com.portfolio.livecoding.dto;

import java.time.LocalDateTime;

/**
 * Cronometro aberto para um desafio. O front usa {@code decorridoSegundos} como ponto de partida
 * do relogio na tela — quem recarrega a pagina no meio da questao nao ganha tempo de volta.
 */
public record TentativaResponseDTO(
        Long tentativaId,
        Long desafioId,
        LocalDateTime iniciadoEm,
        Integer tempoLimiteMinutos,
        long decorridoSegundos
) {
}
