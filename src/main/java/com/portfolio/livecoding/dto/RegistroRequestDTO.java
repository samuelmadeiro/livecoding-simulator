package com.portfolio.livecoding.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegistroRequestDTO(

        @NotBlank(message = "nome e obrigatorio")
        @Size(max = 120, message = "nome deve ter no maximo 120 caracteres")
        String nome,

        @NotBlank(message = "email e obrigatorio")
        @Email(message = "email invalido")
        @Size(max = 150, message = "email deve ter no maximo 150 caracteres")
        String email,

        @NotBlank(message = "senha e obrigatoria")
        @Size(min = 8, message = "senha deve ter no minimo 8 caracteres")
        String senha
) {
}
