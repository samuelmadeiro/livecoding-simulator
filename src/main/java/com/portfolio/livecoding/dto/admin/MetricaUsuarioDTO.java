package com.portfolio.livecoding.dto.admin;

import com.portfolio.livecoding.enums.Role;
import java.time.LocalDateTime;

/**
 * Uma linha da tabela de candidatos.
 *
 * @param taxaAcerto         percentual de submissoes aprovadas sobre o total enviado.
 * @param precisaoMedia      media da precisao das submissoes: o quanto, em media, a pessoa cobriu
 *                           da regua dos desafios que tentou.
 * @param tempoMedioSegundos media do tempo por submissao cronometrada.
 */
public record MetricaUsuarioDTO(
        Long usuarioId,
        String nome,
        String email,
        Role role,
        long submissoes,
        long aprovadas,
        int taxaAcerto,
        Integer pontuacaoMedia,
        Integer precisaoMedia,
        Integer tempoMedioSegundos,
        Long tempoTotalSegundos,
        LocalDateTime ultimaSubmissao
) {
}
