package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;

/**
 * Filtros opcionais da busca de desafios. Campos null = sem filtro.
 */
public record DesafioFiltroDTO(
        NivelVaga nivel,
        Long tecnologiaId,
        TipoDesafio tipo
) {
}
