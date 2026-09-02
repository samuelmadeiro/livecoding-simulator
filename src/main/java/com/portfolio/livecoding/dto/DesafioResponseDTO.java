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
        String contexto,
        String formatoEntrada,
        String formatoSaida,
        String exemplo,
        String restricoes,
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
                desafio.getContexto(),
                desafio.getFormatoEntrada(),
                desafio.getFormatoSaida(),
                desafio.getExemplo(),
                desafio.getRestricoes(),
                desafio.getTecnologia().getId(),
                desafio.getTecnologia().getNome()
        );
    }
}
