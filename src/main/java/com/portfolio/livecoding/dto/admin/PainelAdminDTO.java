package com.portfolio.livecoding.dto.admin;

import java.util.List;

/**
 * Tudo o que a pagina do admin desenha, numa resposta so. Sao quatro consultas agregadas no
 * servidor; quebrar em quatro endpoints faria o front abrir quatro requisicoes para montar uma
 * tela unica.
 */
public record PainelAdminDTO(
        ResumoAdminDTO resumo,
        List<MetricaUsuarioDTO> usuarios,
        List<MetricaDesafioDTO> desafios,
        List<SubmissaoRecenteDTO> ultimasSubmissoes
) {
}
