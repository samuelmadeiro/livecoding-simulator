package com.portfolio.livecoding.dto.admin;

import com.portfolio.livecoding.enums.StatusSubmissao;
import java.time.LocalDateTime;

/** Linha do histórico recente: quem enviou, em qual desafio, com que nota e em quanto tempo. */
public record SubmissaoRecenteDTO(
        Long submissaoId,
        String candidato,
        String email,
        String desafio,
        StatusSubmissao status,
        Integer pontuacao,
        Integer precisao,
        Integer duracaoSegundos,
        LocalDateTime dataHora
) {
}
