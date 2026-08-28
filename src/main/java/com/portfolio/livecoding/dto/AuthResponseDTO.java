package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.Role;

public record AuthResponseDTO(
        String token,
        String tipo,
        long expiraEmMs,
        String nome,
        String email,
        Role role
) {

    public static AuthResponseDTO bearer(String token, long expiraEmMs, String nome, String email, Role role) {
        return new AuthResponseDTO(token, "Bearer", expiraEmMs, nome, email, role);
    }
}
