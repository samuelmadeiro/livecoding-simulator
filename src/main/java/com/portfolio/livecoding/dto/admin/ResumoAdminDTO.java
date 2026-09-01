package com.portfolio.livecoding.dto.admin;

/**
 * Cartoes do topo do painel. Medias voltam nulas quando ainda nao ha submissao com o dado —
 * tempo, por exemplo, so existe em submissao feita com o cronometro aberto.
 */
public record ResumoAdminDTO(
        long candidatos,
        long desafios,
        long submissoes,
        long aprovadas,
        int taxaAprovacao,
        Integer pontuacaoMedia,
        Integer precisaoMedia,
        Integer tempoMedioSegundos,
        Long tempoTotalSegundos
) {
}
