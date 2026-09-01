package com.portfolio.livecoding.security;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.portfolio.livecoding.entity.Submissao;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.SubmissaoRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

/**
 * Cadeia de seguranca de ponta a ponta, com os filtros reais ligados.
 * O Flyway ja populou o catalogo e o DataLoader criou o usuario demo.
 */
@SpringBootTest
@AutoConfigureMockMvc
class SecurityIntegrationTest {

    // Precisa atender os criterios que a V3 cadastra para o CRUD de Produtos: rota GET, retorno,
    // mencao a produtos, acesso por repositorio e a classe declarada como controller.
    private static final String CODIGO =
            "@RestController class ProdutoController { @GetMapping public List<Produto> "
                    + "listarProdutos() { return repository.findAll(); } }";

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private SubmissaoRepository submissaoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private DesafioRepository desafioRepository;

    @Test
    @DisplayName("catalogo de desafios continua publico")
    void catalogoPublico() throws Exception {
        mockMvc.perform(get("/api/desafios"))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/desafios/1"))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("POST /api/submissoes sem token retorna 401 em JSON")
    void submissaoSemTokenNegada() throws Exception {
        mockMvc.perform(post("/api/submissoes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(corpoSubmissao()))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.status").value(401));
    }

    @Test
    @DisplayName("POST /api/submissoes com token adulterado retorna 401")
    void submissaoComTokenAdulteradoNegada() throws Exception {
        String token = login("demo@livecoding.dev", "demo12345");
        String adulterado = token.substring(0, token.length() - 4) + "AAAA";

        mockMvc.perform(post("/api/submissoes")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + adulterado)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(corpoSubmissao()))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("login com senha errada retorna 401")
    void loginSenhaErrada() throws Exception {
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"demo@livecoding.dev\",\"senha\":\"errada\"}"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.mensagem").value("Email ou senha inválidos."));
    }

    @Test
    @DisplayName("fluxo completo: register, login e submissao atribuida ao dono do token")
    void fluxoCompleto() throws Exception {
        String email = "candidato.novo@livecoding.dev";

        String respostaRegistro = mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nome\":\"Candidato Novo\",\"email\":\"" + email
                                + "\",\"senha\":\"segredo123\"}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.role").value("CANDIDATO"))
                .andReturn().getResponse().getContentAsString();

        assertThat(objectMapper.readTree(respostaRegistro).get("token").asText()).isNotBlank();

        // Registrar o mesmo email de novo deve conflitar.
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nome\":\"Outro\",\"email\":\"" + email
                                + "\",\"senha\":\"segredo123\"}"))
                .andExpect(status().isConflict());

        String token = login(email, "segredo123");

        String respostaSubmissao = mockMvc.perform(post("/api/submissoes")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(corpoSubmissao(idDoCrudDeProdutos())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("APROVADO"))
                .andReturn().getResponse().getContentAsString();

        long submissaoId = objectMapper.readTree(respostaSubmissao).get("submissaoId").asLong();
        Submissao salva = submissaoRepository.findById(submissaoId).orElseThrow();
        Long idEsperado = usuarioRepository.findByEmail(email).orElseThrow().getId();

        // A submissao pertence ao dono do token, nao a um id escolhido pelo cliente.
        // getId() no proxy lazy nao precisa de sessao aberta.
        assertThat(salva.getUsuario().getId()).isEqualTo(idEsperado);
    }

    private String login(String email, String senha) throws Exception {
        String resposta = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"" + email + "\",\"senha\":\"" + senha + "\"}"))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();

        JsonNode json = objectMapper.readTree(resposta);
        return json.get("token").asText();
    }

    private String corpoSubmissao() {
        return corpoSubmissao(1L);
    }

    private String corpoSubmissao(long desafioId) {
        return "{\"desafioId\": " + desafioId + ", \"codigoEnviado\": \"" + CODIGO + "\"}";
    }

    /** O id vem do banco: a ordem do seed pode mudar quando novas migrations forem adicionadas. */
    private long idDoCrudDeProdutos() {
        return desafioRepository.findAll().stream()
                .filter(d -> "CRUD de Produtos".equals(d.getTitulo()))
                .findFirst()
                .orElseThrow()
                .getId();
    }
}
