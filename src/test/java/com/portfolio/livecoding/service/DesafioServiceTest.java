package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Tecnologia;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.DesafioRepository;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class DesafioServiceTest {

    @Mock
    private DesafioRepository desafioRepository;

    @InjectMocks
    private DesafioService desafioService;

    private Desafio desafio;

    @BeforeEach
    void setUp() {
        Tecnologia java = new Tecnologia();
        java.setId(1L);
        java.setNome("Java");

        desafio = new Desafio();
        desafio.setId(10L);
        desafio.setTitulo("CRUD de Produtos");
        desafio.setDescricao("Implemente o endpoint GET /produtos.");
        desafio.setNivel(NivelVaga.JUNIOR);
        desafio.setTipo(TipoDesafio.API_REST);
        desafio.setTempoLimiteMinutos(45);
        desafio.setTemplateCodigo("// TODO");
        desafio.setTecnologia(java);
    }

    @Test
    @DisplayName("listar sem filtros repassa nulls ao repository e mapeia para DTO")
    void listarSemFiltros() {
        when(desafioRepository.buscarComFiltros(isNull(), isNull(), isNull()))
                .thenReturn(List.of(desafio));

        List<com.portfolio.livecoding.dto.DesafioResponseDTO> resultado =
                desafioService.listar(new DesafioFiltroDTO(null, null, null));

        assertThat(resultado).hasSize(1);
        assertThat(resultado.getFirst().id()).isEqualTo(10L);
        assertThat(resultado.getFirst().tecnologiaNome()).isEqualTo("Java");
        assertThat(resultado.getFirst().templateCodigo()).isEqualTo("// TODO");
    }

    @Test
    @DisplayName("listar com filtros repassa cada campo do DesafioFiltroDTO")
    void listarComFiltros() {
        DesafioFiltroDTO filtro = new DesafioFiltroDTO(NivelVaga.JUNIOR, 1L, TipoDesafio.API_REST);
        when(desafioRepository.buscarComFiltros(NivelVaga.JUNIOR, 1L, TipoDesafio.API_REST))
                .thenReturn(List.of(desafio));

        assertThat(desafioService.listar(filtro)).hasSize(1);
        verify(desafioRepository).buscarComFiltros(NivelVaga.JUNIOR, 1L, TipoDesafio.API_REST);
    }

    @Test
    @DisplayName("buscarPorId retorna o DTO quando o desafio existe")
    void buscarPorIdExistente() {
        when(desafioRepository.findById(10L)).thenReturn(Optional.of(desafio));

        assertThat(desafioService.buscarPorId(10L).titulo()).isEqualTo("CRUD de Produtos");
    }

    @Test
    @DisplayName("buscarPorId lanca RecursoNaoEncontradoException quando nao existe")
    void buscarPorIdInexistente() {
        when(desafioRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> desafioService.buscarPorId(999L))
                .isInstanceOf(RecursoNaoEncontradoException.class)
                .hasMessageContaining("999");
    }
}
