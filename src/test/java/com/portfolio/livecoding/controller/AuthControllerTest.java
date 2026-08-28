package com.portfolio.livecoding.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.portfolio.livecoding.dto.AuthResponseDTO;
import com.portfolio.livecoding.dto.LoginRequestDTO;
import com.portfolio.livecoding.dto.RegistroRequestDTO;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.exception.EmailJaCadastradoException;
import com.portfolio.livecoding.service.AuthService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(AuthController.class)
@AutoConfigureMockMvc(addFilters = false)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AuthService authService;

    private static final AuthResponseDTO RESPOSTA = AuthResponseDTO.bearer(
            "token-fake", 3_600_000L, "Candidato Demo", "demo@livecoding.dev", Role.CANDIDATO);

    @Test
    @DisplayName("POST /api/auth/register retorna 201 com o token")
    void registrar() throws Exception {
        when(authService.registrar(any(RegistroRequestDTO.class))).thenReturn(RESPOSTA);

        String body = "{\"nome\":\"Candidato Demo\",\"email\":\"demo@livecoding.dev\",\"senha\":\"demo12345\"}";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.token").value("token-fake"))
                .andExpect(jsonPath("$.tipo").value("Bearer"))
                .andExpect(jsonPath("$.role").value("CANDIDATO"));
    }

    @Test
    @DisplayName("POST /api/auth/register com email ja existente retorna 409")
    void registrarEmailDuplicado() throws Exception {
        when(authService.registrar(any(RegistroRequestDTO.class)))
                .thenThrow(new EmailJaCadastradoException("Email ja cadastrado: demo@livecoding.dev"));

        String body = "{\"nome\":\"Outro\",\"email\":\"demo@livecoding.dev\",\"senha\":\"demo12345\"}";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409))
                .andExpect(jsonPath("$.mensagem").value("Email ja cadastrado: demo@livecoding.dev"));
    }

    @Test
    @DisplayName("POST /api/auth/register com senha curta e email invalido retorna 400")
    void registrarPayloadInvalido() throws Exception {
        String body = "{\"nome\":\"\",\"email\":\"nao-e-email\",\"senha\":\"123\"}";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.erros.nome").exists())
                .andExpect(jsonPath("$.erros.email").exists())
                .andExpect(jsonPath("$.erros.senha").exists());
    }

    @Test
    @DisplayName("POST /api/auth/login retorna 200 com o token")
    void login() throws Exception {
        when(authService.autenticar(any(LoginRequestDTO.class))).thenReturn(RESPOSTA);

        String body = "{\"email\":\"demo@livecoding.dev\",\"senha\":\"demo12345\"}";

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").value("token-fake"))
                .andExpect(jsonPath("$.email").value("demo@livecoding.dev"));
    }

    @Test
    @DisplayName("POST /api/auth/login com credenciais invalidas retorna 401")
    void loginCredenciaisInvalidas() throws Exception {
        when(authService.autenticar(any(LoginRequestDTO.class)))
                .thenThrow(new BadCredentialsException("Bad credentials"));

        String body = "{\"email\":\"demo@livecoding.dev\",\"senha\":\"errada\"}";

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.mensagem").value("Email ou senha invalidos."));
    }
}
