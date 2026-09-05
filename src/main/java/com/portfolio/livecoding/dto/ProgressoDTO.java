package com.portfolio.livecoding.dto;

import java.time.LocalDate;
import java.util.List;

/** O progresso do candidato logado, como o painel dele precisa mostrar. */
public record ProgressoDTO(
        String apelido,
        int pontos,
        int sequenciaAtual,
        int sequenciaRecorde,
        LocalDate ultimoDiaPraticado,
        /** true quando ainda nao houve pratica hoje: e o que o painel usa para cobrar o dia. */
        boolean praticouHoje,
        long questoesResolvidas,
        long questoesDisponiveis,
        /** Posicao no ranking geral. Nulo enquanto a pessoa nao pontuou. */
        Integer posicaoNoRanking,
        List<ConquistaResumoDTO> ultimasConquistas) {
}
