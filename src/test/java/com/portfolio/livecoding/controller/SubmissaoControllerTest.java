package com.portfolio.livecoding.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.portfolio.livecoding.dto.CriterioResultadoDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.service.SubmissaoService;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(SubmissaoController.class)
@AutoConfigureMockMvc(addFilters = false)
@WithMockUser(username = "demo@livecoding.dev")
class SubmissaoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SubmissaoService submissaoService;

    static final String EMAIL = "demo@livecoding.dev";

    private static final String CODIGO_VALIDO =
            "@GetMapping public List<Produto> listar() { return repo.findAll(); }";

    @Test
    @DisplayName("POST /api/submissoes retorna 201 com o feedback da correcao")
    void criar() throws Exception {
        when(submissaoService.registrar(any(), eq(EMAIL)))
                .thenReturn(new SubmissaoResponseDTO(5L, StatusSubmissao.APROVADO,
                        "Todos os requisitos essenciais foram atendidos. Pontuacao: 100 de 100.",
                        100, List.of(new CriterioResultadoDTO("Expoe um endpoint de leitura (GET)", true))));

        String body = "{\"desafioId\": 1, \"codigoEnviado\": \"" + CODIGO_VALIDO + "\"}";

        mockMvc.perform(post("/api/submissoes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(header().string("Location", "/api/submissoes/5"))
                .andExpect(jsonPath("$.submissaoId").value(5))
                .andExpect(jsonPath("$.status").value("APROVADO"))
                .andExpect(jsonPath("$.pontuacao").value(100))
                .andExpect(jsonPath("$.criterios[0].descricao")
                        .value("Expoe um endpoint de leitura (GET)"))
                .andExpect(jsonPath("$.criterios[0].atendido").value(true));
    }

    @Test
    @DisplayName("POST /api/submissoes atribui a submissao ao usuario autenticado, nao a um id do cliente")
    void criarUsaUsuarioAutenticado() throws Exception {
        when(submissaoService.registrar(any(), eq(EMAIL)))
                .thenReturn(new SubmissaoResponseDTO(6L, StatusSubmissao.ERRO_TESTE, "Testes falharam.",
                        40, List.of(new CriterioResultadoDTO("Soma o valor dos pedidos", false))));

        String body = "{\"desafioId\": 1, \"codigoEnviado\": \"" + CODIGO_VALIDO + "\"}";

        mockMvc.perform(post("/api/submissoes")
                        .header("X-Usuario-Id", "7")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("ERRO_TESTE"));

        // O header legado e ignorado: o service so recebe o email do principal.
        verify(submissaoService).registrar(any(), eq(EMAIL));
    }

    @Test
    @DisplayName("POST /api/submissoes sem codigoEnviado retorna 400 com os erros de validacao")
    void criarSemCodigo() throws Exception {
        String body = "{\"desafioId\": 1}";

        mockMvc.perform(post("/api/submissoes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.erros.codigoEnviado").exists());
    }

    @Test
    @DisplayName("POST /api/submissoes com desafio inexistente retorna 404")
    void criarDesafioInexistente() throws Exception {
        when(submissaoService.registrar(any(), any()))
                .thenThrow(new RecursoNaoEncontradoException("Desafio nao encontrado: id 999"));

        String body = "{\"desafioId\": 999, \"codigoEnviado\": \"" + CODIGO_VALIDO + "\"}";

        mockMvc.perform(post("/api/submissoes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.mensagem").value("Desafio nao encontrado: id 999"));
    }
}
