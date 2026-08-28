package com.portfolio.livecoding.dto;

import jakarta.validation.constraints.NotBlank;

public record LoginRequestDTO(

        @NotBlank(message = "email e obrigatorio")
        String email,

        @NotBlank(message = "senha e obrigatoria")
        String senha
) {
}
