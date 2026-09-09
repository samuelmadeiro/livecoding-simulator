package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.Dificuldade;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;

/**
 * @param resolvido se o candidato ja conquistou esta questao. <b>Nulo</b> para visitante anonimo,
 *                  e nao false: "ainda nao resolvi" e "nao sei quem voce e" sao respostas
 *                  diferentes, e o front usa a distincao para nao mostrar selo a quem nao entrou.
 */
public record DesafioResponseDTO(
        Long id,
        String titulo,
        String descricao,
        NivelVaga nivel,
        Dificuldade dificuldade,
        TipoDesafio tipo,
        Integer tempoLimiteMinutos,
        String templateCodigo,
        String contexto,
        String formatoEntrada,
        String formatoSaida,
        String exemplo,
        String restricoes,
        Long tecnologiaId,
        String tecnologiaNome,
        Boolean resolvido
) {

    /** Sem candidato conhecido: o campo resolvido sai nulo. */
    public static DesafioResponseDTO fromEntity(Desafio desafio) {
        return fromEntity(desafio, null);
    }

    public static DesafioResponseDTO fromEntity(Desafio desafio, Boolean resolvido) {
        return new DesafioResponseDTO(
                desafio.getId(),
                desafio.getTitulo(),
                desafio.getDescricao(),
                desafio.getNivel(),
                desafio.getDificuldade(),
                desafio.getTipo(),
                desafio.getTempoLimiteMinutos(),
                desafio.getTemplateCodigo(),
                desafio.getContexto(),
                desafio.getFormatoEntrada(),
                desafio.getFormatoSaida(),
                desafio.getExemplo(),
                desafio.getRestricoes(),
                desafio.getTecnologia().getId(),
                desafio.getTecnologia().getNome(),
                resolvido
        );
    }
}
