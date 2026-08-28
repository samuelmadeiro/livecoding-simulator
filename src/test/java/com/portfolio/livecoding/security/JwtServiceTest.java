package com.portfolio.livecoding.security;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Base64;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class JwtServiceTest {

    private static final String SEGREDO =
            Base64.getEncoder().encodeToString("chave-de-teste-com-256-bits-ok!!".getBytes());
    private static final String OUTRO_SEGREDO =
            Base64.getEncoder().encodeToString("outra-chave-com-256-bits-aqui!!!".getBytes());

    private final JwtService jwtService = new JwtService(SEGREDO, 3_600_000L);

    @Test
    @DisplayName("token gerado carrega o email no subject e a role como claim")
    void tokenCarregaSubjectERole() {
        String token = jwtService.gerarToken("demo@livecoding.dev", "CANDIDATO");

        assertThat(jwtService.tokenValido(token)).isTrue();
        assertThat(jwtService.extrairEmail(token)).isEqualTo("demo@livecoding.dev");
        assertThat(jwtService.extrairRole(token)).isEqualTo("CANDIDATO");
    }

    @Test
    @DisplayName("token assinado com outra chave e rejeitado")
    void assinaturaInvalida() {
        JwtService outroEmissor = new JwtService(OUTRO_SEGREDO, 3_600_000L);
        String tokenIntruso = outroEmissor.gerarToken("invasor@livecoding.dev", "ADMIN");

        assertThat(jwtService.tokenValido(tokenIntruso)).isFalse();
        assertThat(jwtService.extrairEmail(tokenIntruso)).isNull();
    }

    @Test
    @DisplayName("token expirado e rejeitado")
    void tokenExpirado() {
        JwtService emissorExpirado = new JwtService(SEGREDO, -1_000L);
        String token = emissorExpirado.gerarToken("demo@livecoding.dev", "CANDIDATO");

        assertThat(jwtService.tokenValido(token)).isFalse();
        assertThat(jwtService.extrairEmail(token)).isNull();
    }

    @Test
    @DisplayName("token adulterado e rejeitado")
    void tokenAdulterado() {
        String token = jwtService.gerarToken("demo@livecoding.dev", "CANDIDATO");
        String adulterado = token.substring(0, token.length() - 4) + "AAAA";

        assertThat(jwtService.tokenValido(adulterado)).isFalse();
    }

    @Test
    @DisplayName("texto que nao e um JWT e rejeitado sem lancar excecao")
    void tokenMalformado() {
        assertThat(jwtService.tokenValido("nao-e-um-jwt")).isFalse();
        assertThat(jwtService.extrairEmail("")).isNull();
    }
}
