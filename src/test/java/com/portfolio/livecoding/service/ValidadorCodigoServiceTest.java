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
        criterio.setDica("Dica cadastrada para " + descricao);
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
    @DisplayName("anotacao sem corpo de metodo nao chega a ser corrigida")
    void anotacaoSozinhaNaoBasta() {
        // O caso que esta classe existe para nao aprovar: a anotacao certa e nada mais.
        String codigo = "@RestController @GetMapping @RequestMapping(\"/produtos\")";

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
        assertThat(resultado.mensagemFeedback()).contains("corpo de metodo");
        assertThat(resultado.pontuacao()).isZero();
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
    @DisplayName("template reindentado e com o comentario apagado continua sendo o template")
    void templateReformatadoContinuaSendoTemplate() {
        String codigo = """
                @RestController
                public class ProdutoController {
                    // implementar depois
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("identico ao template");
    }

    @Test
    @DisplayName("template com um punhado de caracteres a mais nao conta como solucao")
    void quaseIdenticoAoTemplate() {
        String codigo = "@RestController public class ProdutoController { int x = 1; }";

        var resultado = validador.validar(codigo, desafioApiRest, criteriosApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("poucos caracteres a mais");
    }

    @Test
    @DisplayName("solucao completa retorna APROVADO com pontuacao e precisao cheias")
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
        assertThat(resultado.precisao()).isEqualTo(100);
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
        // Nota cheia nos pontuaveis e ainda assim precisao longe de 100: e a diferenca entre as
        // duas medidas — a nota so olha o que vale ponto, a precisao olha a regua inteira.
        assertThat(resultado.precisao()).isLessThan(100);
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
    @DisplayName("nota acima do minimo nao aprova sozinha se a precisao geral ficar baixa")
    void precisaoBaixaReprova() {
        // Um obrigatorio leve e dois pontuaveis pesados: a nota bate 70, mas a solucao cobre
        // pouco da regua inteira.
        List<CriterioAvaliacao> reguaDesbalanceada = List.of(
                criterio("Devolve o resultado com return", "return\\s+[^;]+;",
                        TipoCriterio.OBRIGATORIO, 1),
                criterio("Mapeia a rota /produtos", "produtos", TipoCriterio.PONTUAVEL, 14),
                criterio("Trata a lista vazia", "isEmpty", TipoCriterio.PONTUAVEL, 6));

        String codigo = """
                public class ProdutoController {
                    public List<Produto> listarProdutos() {
                        return montar();
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, reguaDesbalanceada);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.pontuacao()).isGreaterThanOrEqualTo(70);
        assertThat(resultado.precisao()).isLessThan(75);
        assertThat(resultado.mensagemFeedback()).contains("precisao");
    }

    @Test
    @DisplayName("desafio com regua curta demais nao aprova sozinho, vai para revisao manual")
    void reguaCurtaNaoAprova() {
        List<CriterioAvaliacao> reguaCurta = List.of(
                criterio("Expoe um endpoint de leitura (GET)", "(GetMapping|RequestMethod\\.GET)",
                        TipoCriterio.OBRIGATORIO, 1),
                criterio("Devolve o resultado com return", "return\\s+[^;]+;",
                        TipoCriterio.OBRIGATORIO, 1));

        String codigo = """
                @RestController
                public class ProdutoController {
                    @GetMapping("/produtos")
                    public List<Produto> listar() {
                        return repository.findAll();
                    }
                }
                """;

        var resultado = validador.validar(codigo, desafioApiRest, reguaCurta);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.PENDENTE);
        assertThat(resultado.mensagemFeedback()).contains("revisao manual");
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
    @DisplayName("desafio sem criterios nao aprova por palavra-chave: fica PENDENTE")
    void semCriteriosNaoAprovaPorPalavraChave() {
        // A heuristica antiga aprovava qualquer codigo com "mapping" num desafio de API REST.
        String codigo = "public class Solucao { public void nada() { int mapping = 1; } }";

        var resultado = validador.validar(codigo, desafioApiRest, List.of());

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.PENDENTE);
        assertThat(resultado.mensagemFeedback()).contains("revisao manual");
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

    @Test
    @DisplayName("cada item avaliado carrega tipo, peso e dica para o feedback")
    void itensCarregamTipoPesoEDica() {
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

        assertThat(resultado.itens())
                .allSatisfy(item -> {
                    assertThat(item.tipo()).isNotNull();
                    assertThat(item.peso()).isPositive();
                    assertThat(item.dica()).isNotBlank();
                });
    }
}
