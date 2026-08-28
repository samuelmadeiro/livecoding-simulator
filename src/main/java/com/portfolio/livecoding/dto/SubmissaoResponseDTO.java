package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.StatusSubmissao;

public record SubmissaoResponseDTO(
        Long submissaoId,
        StatusSubmissao status,
        String mensagemFeedback
) {
}
