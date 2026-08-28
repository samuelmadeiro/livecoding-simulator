package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;

public record DesafioResponseDTO(
        Long id,
        String titulo,
        String descricao,
        NivelVaga nivel,
        TipoDesafio tipo,
        Integer tempoLimiteMinutos,
        String templateCodigo,
        Long tecnologiaId,
        String tecnologiaNome
) {

    public static DesafioResponseDTO fromEntity(Desafio desafio) {
        return new DesafioResponseDTO(
                desafio.getId(),
                desafio.getTitulo(),
                desafio.getDescricao(),
                desafio.getNivel(),
                desafio.getTipo(),
                desafio.getTempoLimiteMinutos(),
                desafio.getTemplateCodigo(),
                desafio.getTecnologia().getId(),
                desafio.getTecnologia().getNome()
        );
    }
}
