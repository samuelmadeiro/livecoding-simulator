package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.portfolio.livecoding.dto.SubmissaoRequestDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.dto.admin.MetricaDesafioDTO;
import com.portfolio.livecoding.dto.admin.MetricaUsuarioDTO;
import com.portfolio.livecoding.dto.admin.PainelAdminDTO;
import com.portfolio.livecoding.repository.DesafioRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * Painel do admin de ponta a ponta: envia submissoes de verdade e confere o que as consultas
 * agregadas devolvem. As asercoes sao por "pelo menos", e nao por igualdade — o banco H2 e
 * compartilhado com os outros testes que sobem o mesmo contexto.
 */
@SpringBootTest
class AdminMetricasServiceTest {

    private static final String EMAIL_DEMO = "demo@livecoding.dev";

    private static final String CODIGO_BOM = """
            @RestController
            public class ProdutoController {
                @GetMapping("/produtos")
                public List<Produto> listar() {
                    return repository.findAll();
                }
            }
            """;

    /** Sem @GetMapping: falha o criterio obrigatorio do desafio. */
    private static final String CODIGO_INCOMPLETO = """
            public class ProdutoController {
                public List<Produto> listar() {
                    return montarNaMao();
                }
            }
            """;

    @Autowired
    private AdminMetricasService adminMetricasService;

    @Autowired
    private SubmissaoService submissaoService;

    @Autowired
    private TentativaService tentativaService;

    @Autowired
    private DesafioRepository desafioRepository;

    @Test
    @DisplayName("painel agrega submissoes, taxa de acerto e precisao por criterio")
    void painelAgregaMetricas() {
        long desafioId = idDoCrudDeProdutos();

        submissaoService.registrar(new SubmissaoRequestDTO(desafioId, CODIGO_BOM, null), EMAIL_DEMO);
        submissaoService.registrar(new SubmissaoRequestDTO(desafioId, CODIGO_INCOMPLETO, null),
                EMAIL_DEMO);

        PainelAdminDTO painel = adminMetricasService.montarPainel();

        assertThat(painel.resumo().submissoes()).isGreaterThanOrEqualTo(2);
        assertThat(painel.resumo().aprovadas()).isGreaterThanOrEqualTo(1);
        assertThat(painel.resumo().taxaAprovacao()).isBetween(0, 100);
        assertThat(painel.ultimasSubmissoes()).isNotEmpty();

        MetricaUsuarioDTO demo = painel.usuarios().stream()
                .filter(usuario -> EMAIL_DEMO.equals(usuario.email()))
                .findFirst()
                .orElseThrow();

        assertThat(demo.submissoes()).isGreaterThanOrEqualTo(2);
        assertThat(demo.aprovadas()).isGreaterThanOrEqualTo(1);
        assertThat(demo.taxaAcerto()).isBetween(0, 100);
        assertThat(demo.precisaoMedia()).isNotNull();

        MetricaDesafioDTO desafio = painel.desafios().stream()
                .filter(linha -> linha.desafioId() == desafioId)
                .findFirst()
                .orElseThrow();

        assertThat(desafio.submissoes()).isGreaterThanOrEqualTo(2);
        assertThat(desafio.precisaoMedia()).isNotNull();
        assertThat(desafio.criterios()).isNotEmpty();
        // O criterio critico e o de menor taxa de acerto: com uma submissao sem @GetMapping,
        // "Expoe um endpoint de leitura (GET)" nao pode aparecer com 100%.
        assertThat(desafio.criterios().getFirst().taxaAcerto())
                .isLessThanOrEqualTo(desafio.criterios().getLast().taxaAcerto());
        assertThat(desafio.criterioCritico()).isNotBlank();
    }

    @Test
    @DisplayName("usuario sem submissao nenhuma continua aparecendo no painel, com zero")
    void usuarioSemSubmissaoAparece() {
        PainelAdminDTO painel = adminMetricasService.montarPainel();

        assertThat(painel.usuarios())
                .anyMatch(usuario -> "admin@livecoding.dev".equals(usuario.email()));
    }

    @Test
    @DisplayName("tempo gasto vem da tentativa aberta no servidor, nao do corpo da requisicao")
    void tempoVemDaTentativa() {
        long desafioId = idDoCrudDeProdutos();

        tentativaService.iniciar(desafioId, EMAIL_DEMO);

        SubmissaoResponseDTO resposta = submissaoService.registrar(
                new SubmissaoRequestDTO(desafioId, CODIGO_BOM, null), EMAIL_DEMO);

        assertThat(resposta.duracaoSegundos()).isNotNull().isGreaterThanOrEqualTo(0);
        assertThat(resposta.precisao()).isNotNull();
        assertThat(resposta.entrevistador()).isNotNull();
        assertThat(resposta.entrevistador().comentarioTempo()).isNotBlank();
    }

    @Test
    @DisplayName("submissao sem tentativa aberta fica sem tempo, e nao com tempo inventado")
    void submissaoSemTentativaNaoTemTempo() {
        long desafioId = idDoDesafio("Contar Vogais");

        SubmissaoResponseDTO resposta = submissaoService.registrar(
                new SubmissaoRequestDTO(desafioId,
                        "public class Solucao { public int contarVogais(String texto) { "
                                + "int total = 0; for (char c : texto.toLowerCase().toCharArray()) "
                                + "{ if (\"aeiou\".indexOf(c) >= 0) { total++; } } return total; } }",
                        null),
                EMAIL_DEMO);

        assertThat(resposta.duracaoSegundos()).isNull();
    }

    private long idDoCrudDeProdutos() {
        return idDoDesafio("CRUD de Produtos");
    }

    private long idDoDesafio(String titulo) {
        return desafioRepository.findAll().stream()
                .filter(desafio -> titulo.equals(desafio.getTitulo()))
                .findFirst()
                .orElseThrow()
                .getId();
    }
}
