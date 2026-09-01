package com.portfolio.livecoding.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * @param tentativaId opcional: o cronometro aberto em POST /api/desafios/{id}/iniciar. O tempo
 *                    gasto e calculado no servidor a partir dele — o cliente informa qual
 *                    tentativa esta fechando, nunca quantos segundos levou.
 */
public record SubmissaoRequestDTO(

        @NotNull(message = "desafioId e obrigatorio")
        Long desafioId,

        @NotBlank(message = "codigoEnviado nao pode ser vazio")
        String codigoEnviado,

        Long tentativaId
) {
}
