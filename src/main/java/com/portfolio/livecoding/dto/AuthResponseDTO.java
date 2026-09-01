package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.enums.Role;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NotNull;

public record AuthResponseDTO(
        String token,
        String tipo,
        long expiraEmMs,
        String nome,
        String email,
        Role role
) {

    @Contract("_, _, _, _, _ -> new")
    public static @NotNull AuthResponseDTO bearer(String token, long expiraEmMs, String nome, String email, Role role) {
        return new AuthResponseDTO(token, "Bearer", expiraEmMs, nome, email, role);
    }
}
