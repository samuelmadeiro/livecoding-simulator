package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.Dificuldade;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;

/**
 * Filtros opcionais da busca de desafios. Campos null = sem filtro.
 *
 * @param naoResolvidasPor id do candidato que quer ver so o que ainda falta. Nulo para visitante
 *                         anonimo e para quem nao pediu o recorte — nos dois casos o catalogo vem
 *                         inteiro. O filtro precisa do id, e nao de um booleano, porque "resolvida"
 *                         so existe em relacao a alguem.
 */
public record DesafioFiltroDTO(
        NivelVaga nivel,
        Long tecnologiaId,
        TipoDesafio tipo,
        Dificuldade dificuldade,
        Long naoResolvidasPor
) {

    /** Atalho para quem nao usa o recorte de nao resolvidas. */
    public DesafioFiltroDTO(NivelVaga nivel, Long tecnologiaId, TipoDesafio tipo, Dificuldade dificuldade) {
        this(nivel, tecnologiaId, tipo, dificuldade, null);
    }
}
