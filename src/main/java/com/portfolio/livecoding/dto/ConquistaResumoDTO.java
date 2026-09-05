package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.NivelVaga;
import java.time.LocalDateTime;

/** Uma questao ja conquistada, como aparece no historico do painel. */
public record ConquistaResumoDTO(
        Long desafioId,
        String titulo,
        String tecnologia,
        NivelVaga nivel,
        int pontos,
        int precisao,
        LocalDateTime conquistadoEm) {
}
