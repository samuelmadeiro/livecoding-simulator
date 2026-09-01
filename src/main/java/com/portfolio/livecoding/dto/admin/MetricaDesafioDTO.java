package com.portfolio.livecoding.dto.admin;

import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
import java.util.List;

/**
 * Uma linha da tabela de desafios.
 *
 * @param precisaoMedia   media da precisao das submissoes deste desafio: a "% de precisao" do
 *                        exercicio.
 * @param criterios       precisao criterio a criterio, do mais falhado para o menos.
 * @param criterioCritico descricao do criterio que mais reprova aqui. Nulo enquanto ninguem tentou.
 */
public record MetricaDesafioDTO(
        Long desafioId,
        String titulo,
        NivelVaga nivel,
        TipoDesafio tipo,
        String tecnologiaNome,
        Integer tempoLimiteMinutos,
        long submissoes,
        long candidatos,
        long aprovadas,
        int taxaAprovacao,
        Integer pontuacaoMedia,
        Integer precisaoMedia,
        Integer tempoMedioSegundos,
        String criterioCritico,
        List<MetricaCriterioDTO> criterios
) {
}
