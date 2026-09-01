package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.StatusSubmissao;
import java.util.List;

/**
 * Resposta da correcao. A lista de criterios detalha o que foi avaliado — nunca inclui a regex
 * usada, so o texto humano de cada item.
 */
public record SubmissaoResponseDTO(
        Long submissaoId,
        StatusSubmissao status,
        String mensagemFeedback,
        Integer pontuacao,
        List<CriterioResultadoDTO> criterios
) {
}
