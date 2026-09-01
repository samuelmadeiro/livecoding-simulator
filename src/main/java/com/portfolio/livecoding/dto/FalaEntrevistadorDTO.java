package com.portfolio.livecoding.dto;

import java.util.List;

/**
 * O retorno que um entrevistador daria ao candidato depois de olhar o codigo.
 *
 * <p>Existe porque uma lista de itens verdes e vermelhos diz o que falhou, mas nao ensina nada:
 * quem sai de uma entrevista real sai com a fala da pessoa do outro lado — o que agradou, onde a
 * solucao trava, qual caminho seguir e como a avaliacao foi feita.
 */
public record FalaEntrevistadorDTO(
        String entrevistador,
        String cargo,
        String abertura,
        List<String> elogios,
        List<AjusteDTO> ajustes,
        String comentarioTempo,
        String comoAvaliei,
        String fechamento
) {

    /** Um ponto a corrigir: o que faltou, a dica de caminho e por que aquilo pesa. */
    public record AjusteDTO(String oQueFaltou, String dica, String porQueImporta) {
    }
}
