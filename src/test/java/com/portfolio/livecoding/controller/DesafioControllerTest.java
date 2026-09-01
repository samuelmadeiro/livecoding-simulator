package com.portfolio.livecoding.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.enums.NivelVaga;
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
            TipoDesafio.API_REST,
            45,
            "// TODO",
            1L,
            "Java");

    @Test
    @DisplayName("GET /api/desafios retorna 200 e a lista")
    void listar() throws Exception {
        when(desafioService.listar(any())).thenReturn(List.of(DESAFIO));

        mockMvc.perform(get("/api/desafios"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(10))
                .andExpect(jsonPath("$[0].titulo").value("CRUD de Produtos"))
                .andExpect(jsonPath("$[0].tecnologiaNome").value("Java"));
    }

    @Test
    @DisplayName("GET /api/desafios com query params monta o DesafioFiltroDTO")
    void listarComFiltros() throws Exception {
        when(desafioService.listar(any())).thenReturn(List.of(DESAFIO));

        mockMvc.perform(get("/api/desafios")
                        .param("nivel", "JUNIOR")
                        .param("tecnologiaId", "1")
                        .param("tipo", "API_REST"))
                .andExpect(status().isOk());

        ArgumentCaptor<DesafioFiltroDTO> captor = ArgumentCaptor.forClass(DesafioFiltroDTO.class);
        verify(desafioService).listar(captor.capture());
        DesafioFiltroDTO filtro = captor.getValue();

        assertThat(filtro.nivel()).isEqualTo(NivelVaga.JUNIOR);
        assertThat(filtro.tecnologiaId()).isEqualTo(1L);
        assertThat(filtro.tipo()).isEqualTo(TipoDesafio.API_REST);
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
