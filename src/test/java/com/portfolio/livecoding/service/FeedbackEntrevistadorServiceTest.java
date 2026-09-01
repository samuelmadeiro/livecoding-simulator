package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.portfolio.livecoding.dto.FalaEntrevistadorDTO;
import com.portfolio.livecoding.dto.FalaEntrevistadorDTO.AjusteDTO;
import com.portfolio.livecoding.entity.CriterioAvaliacao;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.enums.TipoCriterio;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.service.ValidadorCodigoService.ItemAvaliado;
import com.portfolio.livecoding.service.ValidadorCodigoService.Resultado;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class FeedbackEntrevistadorServiceTest {

    private FeedbackEntrevistadorService servico;
    private Desafio desafio;

    @BeforeEach
    void setUp() {
        servico = new FeedbackEntrevistadorService();

        desafio = new Desafio();
        desafio.setId(1L);
        desafio.setTitulo("CRUD de Produtos");
        desafio.setNivel(NivelVaga.JUNIOR);
        desafio.setTipo(TipoDesafio.API_REST);
        desafio.setTempoLimiteMinutos(45);
    }

    private ItemAvaliado item(String descricao, TipoCriterio tipo, int peso, String dica,
                              boolean atendido) {
        CriterioAvaliacao criterio = new CriterioAvaliacao();
        criterio.setDescricao(descricao);
        criterio.setTipo(tipo);
        criterio.setPeso(peso);
        criterio.setDica(dica);
        return new ItemAvaliado(criterio, descricao, tipo, peso, dica, atendido);
    }

    @Test
    @DisplayName("reprovado: fala traz a dica cadastrada de cada criterio que falhou")
    void reprovadoTrazDicas() {
        Resultado resultado = new Resultado(StatusSubmissao.ERRO_TESTE,
                "Testes falharam.", 40, 55,
                List.of(
                        item("Declara a classe como controller REST", TipoCriterio.PONTUAVEL, 2,
                                "Marque a classe com @RestController.", true),
                        item("Expoe um endpoint de leitura (GET)", TipoCriterio.OBRIGATORIO, 1,
                                "Marque o metodo com @GetMapping.", false),
                        item("Busca os dados por um repositorio ou service", TipoCriterio.PONTUAVEL,
                                3, "Chame o repositorio.", false)));

        FalaEntrevistadorDTO fala = servico.gerar(desafio, resultado, 600, "Samuel Borba");

        assertThat(fala.entrevistador()).isNotBlank();
        assertThat(fala.abertura()).contains("Samuel");
        assertThat(fala.elogios()).isNotEmpty();
        assertThat(fala.ajustes()).extracting(AjusteDTO::dica)
                .contains("Marque o metodo com @GetMapping.", "Chame o repositorio.");
        // Obrigatorio primeiro: e o que mais custa e o que o candidato precisa ler antes.
        assertThat(fala.ajustes().getFirst().oQueFaltou()).isEqualTo("Expoe um endpoint de leitura (GET)");
        assertThat(fala.fechamento()).contains("Expoe um endpoint de leitura (GET)");
    }

    @Test
    @DisplayName("criterio sem dica cadastrada cai numa dica padrao pelo tipo")
    void dicaPadraoQuandoBancoNaoTemDica() {
        Resultado resultado = new Resultado(StatusSubmissao.ERRO_TESTE, "Testes falharam.", 20, 30,
                List.of(item("Trata a lista vazia", TipoCriterio.PONTUAVEL, 2, null, false)));

        FalaEntrevistadorDTO fala = servico.gerar(desafio, resultado, null, "Ana");

        assertThat(fala.ajustes()).hasSize(1);
        assertThat(fala.ajustes().getFirst().dica()).isNotBlank();
        assertThat(fala.comentarioTempo()).contains("não foi cronometrada");
    }

    @Test
    @DisplayName("explica a diferenca entre nota e precisao e que sinal isolado nao aprova")
    void explicaComoAvaliou() {
        Resultado resultado = new Resultado(StatusSubmissao.APROVADO, "Aprovado.", 100, 100,
                List.of(
                        item("Expoe um endpoint de leitura (GET)", TipoCriterio.OBRIGATORIO, 1,
                                "dica", true),
                        item("Mapeia a rota /produtos", TipoCriterio.PONTUAVEL, 3, "dica", true),
                        item("Nao deixe o TODO do template no codigo", TipoCriterio.PROIBIDO, 1,
                                "dica", true)));

        FalaEntrevistadorDTO fala = servico.gerar(desafio, resultado, 1200, "Samuel");

        assertThat(fala.comoAvaliei())
                .contains("100 de 100")
                .contains("100%")
                .contains("Nenhum critério sozinho aprova a questão");
        assertThat(fala.ajustes()).isEmpty();
        assertThat(fala.comentarioTempo()).contains("20 minutos");
    }

    @Test
    @DisplayName("tempo acima do limite do desafio aparece na fala")
    void comentaEstouroDeTempo() {
        Resultado resultado = new Resultado(StatusSubmissao.ERRO_TESTE, "Testes falharam.", 50, 50,
                List.of(item("Percorre o array", TipoCriterio.OBRIGATORIO, 1, "dica", false)));

        FalaEntrevistadorDTO fala = servico.gerar(desafio, resultado, 46 * 60, "Samuel");

        assertThat(fala.comentarioTempo()).contains("acima dos 45 minutos");
    }
}
