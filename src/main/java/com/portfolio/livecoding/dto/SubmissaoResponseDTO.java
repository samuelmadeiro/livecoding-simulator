package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.StatusSubmissao;
import java.util.List;

/**
 * Resposta da correcao. A lista de criterios detalha o que foi avaliado — nunca inclui a regex
 * usada, so o texto humano de cada item e a dica.
 *
 * @param pontuacao       0 a 100 sobre os criterios que valem ponto.
 * @param precisao        0 a 100 sobre a regua inteira do desafio, obrigatorios inclusos.
 * @param duracaoSegundos tempo entre abrir o desafio e enviar. Nulo quando nao houve tentativa
 *                        cronometrada.
 * @param entrevistador   o retorno em forma de conversa, com dicas do que ajustar.
 */
public record SubmissaoResponseDTO(
        Long submissaoId,
        StatusSubmissao status,
        String mensagemFeedback,
        Integer pontuacao,
        Integer precisao,
        Integer duracaoSegundos,
        List<CriterioResultadoDTO> criterios,
        FalaEntrevistadorDTO entrevistador
) {
}
