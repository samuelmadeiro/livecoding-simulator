package com.portfolio.livecoding.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record SubmissaoRequestDTO(

        @NotNull(message = "desafioId e obrigatorio")
        Long desafioId,

        @NotBlank(message = "codigoEnviado nao pode ser vazio")
        String codigoEnviado
) {
}
