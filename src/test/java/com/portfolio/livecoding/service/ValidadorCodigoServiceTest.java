package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Tecnologia;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.enums.TipoDesafio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class ValidadorCodigoServiceTest {

    private ValidadorCodigoService validador;
    private Desafio desafioApiRest;

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
    }

    @Test
    @DisplayName("codigo abaixo do tamanho minimo retorna ERRO_COMPILACAO")
    void codigoCurto() {
        var resultado = validador.validar("int x;", desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
        assertThat(resultado.mensagemFeedback()).contains("muito curto");
    }

    @Test
    @DisplayName("chaves desbalanceadas retorna ERRO_COMPILACAO")
    void chavesDesbalanceadas() {
        String codigo = "@GetMapping public List<Produto> listar() { return repo.findAll();";

        var resultado = validador.validar(codigo, desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
        assertThat(resultado.mensagemFeedback()).contains("desbalanceados");
    }

    @Test
    @DisplayName("codigo identico ao template retorna ERRO_TESTE")
    void codigoIgualAoTemplate() {
        var resultado = validador.validar(desafioApiRest.getTemplateCodigo(), desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("identico ao template");
    }

    @Test
    @DisplayName("codigo sem a palavra-chave do tipo retorna ERRO_TESTE")
    void semPalavraChave() {
        String codigo = "public class Solucao { public void nadaDemais() { System.out.println(1); } }";

        var resultado = validador.validar(codigo, desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("mapping");
    }

    @Test
    @DisplayName("codigo valido para API_REST retorna APROVADO")
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

        var resultado = validador.validar(codigo, desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.APROVADO);
    }

    @Test
    @DisplayName("ALGORITMO_EASY exige a palavra-chave return")
    void algoritmoExigeReturn() {
        desafioApiRest.setTipo(TipoDesafio.ALGORITMO_EASY);
        String semReturn = "function somaPares(numeros) { let total = 0; numeros.forEach(n => total += n); }";

        var resultado = validador.validar(semReturn, desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_TESTE);
        assertThat(resultado.mensagemFeedback()).contains("return");
    }

    @Test
    @DisplayName("codigo nulo nao lanca excecao e retorna ERRO_COMPILACAO")
    void codigoNulo() {
        var resultado = validador.validar(null, desafioApiRest);

        assertThat(resultado.status()).isEqualTo(StatusSubmissao.ERRO_COMPILACAO);
    }
}
