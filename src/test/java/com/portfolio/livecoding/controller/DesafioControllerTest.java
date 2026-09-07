package com.portfolio.livecoding.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.PaginaDTO;
import com.portfolio.livecoding.enums.Dificuldade;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.OrdemDesafios;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.service.DesafioService;
import com.portfolio.livecoding.service.TentativaService;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(DesafioController.class)
@AutoConfigureMockMvc(addFilters = false)
class DesafioControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private DesafioService desafioService;

    /** O controller tambem abre o cronometro da questao; aqui so o catalogo esta sob teste. */
    @MockBean
    private TentativaService tentativaService;

    private static final DesafioResponseDTO DESAFIO = new DesafioResponseDTO(
            10L,
            "CRUD de Produtos",
            "Implemente o endpoint GET /produtos.",
            NivelVaga.JUNIOR,
            Dificuldade.MEDIO,
            TipoDesafio.API_REST,
            45,
            "// TODO",
            "A equipe de vendas precisa listar o catalogo na tela de pedidos.",
            "Nenhum parametro.",
            "Lista de produtos em JSON.",
            "GET /produtos -> [{\"id\":1,\"nome\":\"Teclado\"}]",
            "Sem paginacao nesta versao.",
            1L,
            "Java");

    private static final PaginaDTO<DesafioResponseDTO> PAGINA =
            new PaginaDTO<>(List.of(DESAFIO), 0, 9, 14, 2, true, false);

    @Test
    @DisplayName("GET /api/desafios retorna 200, a pagina e os metadados dela")
    void listar() throws Exception {
        when(desafioService.listar(any(), any(), anyInt(), anyInt())).thenReturn(PAGINA);

        mockMvc.perform(get("/api/desafios"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.conteudo[0].id").value(10))
                .andExpect(jsonPath("$.conteudo[0].titulo").value("CRUD de Produtos"))
                .andExpect(jsonPath("$.conteudo[0].dificuldade").value("MEDIO"))
                .andExpect(jsonPath("$.conteudo[0].tecnologiaNome").value("Java"))
                .andExpect(jsonPath("$.totalItens").value(14))
                .andExpect(jsonPath("$.totalPaginas").value(2))
                .andExpect(jsonPath("$.ultima").value(false));
    }

    @Test
    @DisplayName("sem query params vale a ordem padrao, primeira pagina e o tamanho padrao")
    void listarUsaOsPadroes() throws Exception {
        when(desafioService.listar(any(), any(), anyInt(), anyInt())).thenReturn(PAGINA);

        mockMvc.perform(get("/api/desafios")).andExpect(status().isOk());

        verify(desafioService).listar(any(), eq(OrdemDesafios.PADRAO), eq(0), eq(9));
    }

    @Test
    @DisplayName("GET /api/desafios com query params monta o DesafioFiltroDTO")
    void listarComFiltros() throws Exception {
        when(desafioService.listar(any(), any(), anyInt(), anyInt())).thenReturn(PAGINA);

        mockMvc.perform(get("/api/desafios")
                        .param("nivel", "JUNIOR")
                        .param("tecnologiaId", "1")
                        .param("tipo", "API_REST")
                        .param("dificuldade", "FACIL"))
                .andExpect(status().isOk());

        ArgumentCaptor<DesafioFiltroDTO> captor = ArgumentCaptor.forClass(DesafioFiltroDTO.class);
        verify(desafioService).listar(captor.capture(), any(), anyInt(), anyInt());
        DesafioFiltroDTO filtro = captor.getValue();

        assertThat(filtro.nivel()).isEqualTo(NivelVaga.JUNIOR);
        assertThat(filtro.tecnologiaId()).isEqualTo(1L);
        assertThat(filtro.tipo()).isEqualTo(TipoDesafio.API_REST);
        assertThat(filtro.dificuldade()).isEqualTo(Dificuldade.FACIL);
    }

    @Test
    @DisplayName("ordenar, pagina e tamanho chegam ao service como foram pedidos")
    void listarComOrdenacaoEPaginacao() throws Exception {
        when(desafioService.listar(any(), any(), anyInt(), anyInt())).thenReturn(PAGINA);

        mockMvc.perform(get("/api/desafios")
                        .param("ordenar", "DIFICULDADE_DECRESCENTE")
                        .param("pagina", "2")
                        .param("tamanho", "5"))
                .andExpect(status().isOk());

        verify(desafioService).listar(any(), eq(OrdemDesafios.DIFICULDADE_DECRESCENTE), eq(2), eq(5));
    }

    @Test
    @DisplayName("ordenacao desconhecida vira 400, e nao 500")
    void ordenacaoInvalida() throws Exception {
        mockMvc.perform(get("/api/desafios").param("ordenar", "POR_SORTE"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/desafios/{id} retorna 200 quando existe")
    void buscarPorId() throws Exception {
        when(desafioService.buscarPorId(10L)).thenReturn(DESAFIO);

        mockMvc.perform(get("/api/desafios/10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.templateCodigo").value("// TODO"));
    }

    @Test
    @DisplayName("GET /api/desafios/{id} inexistente retorna 404 tratado pelo handler")
    void buscarPorIdInexistente() throws Exception {
        when(desafioService.buscarPorId(999L))
                .thenThrow(new RecursoNaoEncontradoException("Desafio nao encontrado: id 999"));

        mockMvc.perform(get("/api/desafios/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.mensagem").value("Desafio nao encontrado: id 999"));
    }
}
