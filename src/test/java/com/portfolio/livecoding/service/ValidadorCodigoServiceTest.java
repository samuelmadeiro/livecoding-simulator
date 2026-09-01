package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.portfolio.livecoding.entity.CriterioAvaliacao;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Tecnologia;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.enums.TipoCriterio;
import com.portfolio.livecoding.enums.TipoDesafio;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class ValidadorCodigoServiceTest {

    private ValidadorCodigoService validador;
    private Desafio desafioApiRest;

    /** Espelha o que a migration V3 cadastra para um desafio de API REST. */
    private List<CriterioAvaliacao> criteriosApiRest;

    @BeforeEach
    void setUp() {
        validador = new ValidadorCodigoService();

        Tecnologia java = new Tecnologia();
        java.setId(1L);
        java.setNome("Java");

        desafioApiRest = new Desafio();
        desafioApiRest.setId(1L);
        desafioApiRest.setTitulo("CRUD de Produtos");
        desafioApiRest.setDescricao("Implemente o endpoint GET /produtos.");
        desafioApiRest.setNivel(NivelVaga.JUNIOR);
        desafioApiRest.setTipo(TipoDesafio.API_REST);
        desafioApiRest.setTempoLimiteMinutos(45);
        desafioApiRest.setTemplateCodigo("@RestController public class ProdutoController { }");
        desafioApiRest.setTecnologia(java);

        criteriosApiRest = List.of(
                criterio("Expoe um endpoint de leitura (GET)", "(GetMapping|RequestMethod\\.GET)",
                        TipoCriterio.OBRIGATORIO, 1),
                criterio("Devolve o resultado com return", "return\\s+[^;]+;",
                        TipoCriterio.OBRIGATORIO, 1),
                criterio("Mapeia a rota /produtos", "produtos", TipoCriterio.PONTUAVEL, 3),
                criterio("Busca os dados por um repositorio ou service",
                        "(repository|repositorio|service|servico)\\s*\\.\\s*\\w+\\s*\\(",
                        TipoCriterio.PONTUAVEL, 3),
                criterio("Declara a classe como controller REST", "(RestController|Controller)",
                        TipoCriterio.PONTUAVEL, 2),
                criterio("Nao deixe o TODO do template no codigo", "TODO",
                        TipoCriterio.PROIBIDO, 1));
    }

    private CriterioAvaliacao criterio(String descricao, String padrao, TipoCriterio tipo, int peso) {
        CriterioAvaliacao criterio = new CriterioAvaliacao();
        criterio.setDescricao(descricao);
        criterio.setPadrao(padrao);
        criterio.setTipo(tipo);
        criterio.setPeso(peso);
        criterio.setDesafio(desafioApiRest);
        return criterio;
    }

    @Test
    @DisplayName("codigo abaixo do tamanho minimo retorna ERRO_COMPILACAO")
    void codigoCurto() {
        var resultado = validador.validar("int x;", desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
        assertThat(resultado.mensagemFeedback()).contains("muito curto");
    }

    @Test
    @DisplayName("chaves desbalanceadas retorna ERRO_COMPILACAO")
    void chavesDesbalanceadas() {
        String codigo = "@GetMapping public List<Produto> listar() { return repo.findAll();";

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
        assertThat(resultado.mensagemFeedback()).contains("desbalanceados");
    }

    @Test
    @DisplayName("codigo identico ao template retorna ERRO_TESTE")
    void codigoIgualAoTemplate() {
        var resultado = validador.validar(desafioApiRest.getTemplateCodigo(), desafioApiRest,
                criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("identico ao template");
    }

    @Test
    @DisplayName("solucao completa retorna APROVADO com pontuacao cheia e um item por criterio")
    void codigoAprovado() {
        String codigo = """
                @RestController
                public class ProdutoController {
                    @GetMapping("/produtos")
                    public List<Produto> listar() {
                        return repository.findAll();
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.APROVADO);
        assertThat(resultado.pontuacao()).isEqualTo(100);
        assertThat(resultado.itens()).hasSize(criteriosApiRest.size());
        assertThat(resultado.itens()).allMatch(ValidadorCodigoService.ItemAvaliado::atendido);
    }

    @Test
    @DisplayName("criterio OBRIGATORIO nao atendido reprova mesmo com o resto pontuando")
    void obrigatorioFaltandoReprova() {
        // Tem rota, controller e repositorio (todos os pontuaveis), mas nenhum GetMapping.
        String codigo = """
                @RestController
                public class ProdutoController {
                    public List<Produto> produtos() {
                        return repository.findAll();
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.pontuacao()).isEqualTo(100);
        assertThat(resultado.itens())
                .filteredOn(item -> item.descricao().contains("endpoint de leitura"))
                .allMatch(item -> !item.atendido());
    }

    @Test
    @DisplayName("criterio PROIBIDO que casa reprova e nomeia o problema")
    void proibidoReprova() {
        String codigo = """
                @RestController
                public class ProdutoController {
                    @GetMapping("/produtos")
                    public List<Produto> listar() {
                        // TODO: paginar
                        return repository.findAll();
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("todo");
    }

    @Test
    @DisplayName("pontuacao abaixo do minimo reprova mesmo com os obrigatorios atendidos")
    void pontuacaoParcialReprova() {
        // Atende os dois obrigatorios e so o pontuavel de peso 2 (Controller): 2 de 8 = 25.
        String codigo = """
                public class Cadastro {
                    @GetMapping
                    public List<Item> listar() {
                        return montar();
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.pontuacao()).isLessThan(70);
        assertThat(resultado.mensagemFeedback()).contains("Solucao parcial");
    }

    @Test
    @DisplayName("palavra-chave escondida em comentario nao conta como implementacao")
    void comentarioNaoContaComoCodigo() {
        String codigo = """
                public class ProdutoController {
                    // @GetMapping("/produtos") return repository.findAll();
                    public void nadaDemais() {
                        System.out.println(1);
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.itens())
                .filteredOn(item -> item.descricao().contains("endpoint de leitura"))
                .allMatch(item -> !item.atendido());
    }

    @Test
    @DisplayName("desafio sem criterios cadastrados cai na heuristica antiga por tipo")
    void semCriteriosUsaFallback() {
        String codigo = "public class Solucao { public void nadaDemais() { System.out.println(1); } }";

        var resultado = validador.validar(codigo, desafioApiRest, List.of());

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("mapping");
        assertThat(resultado.itens()).isEmpty();
    }

    @Test
    @DisplayName("codigo nulo nao lanca excecao e retorna ERRO_COMPILACAO")
    void codigoNulo() {
        var resultado = validador.validar(null, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
    }

    @Test
    @DisplayName("regex invalida no banco nao derruba a correcao")
    void regexInvalidaNaoQuebra() {
        List<CriterioAvaliacao> quebrado = List.of(
                criterio("Criterio com regex invalida", "(", TipoCriterio.PONTUAVEL, 1));

        String codigo = "public class Solucao { public int x() { return 1; } }";

        var resultado = validador.validar(codigo, desafioApiRest, quebrado);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.pontuacao()).isZero();
    }
}
