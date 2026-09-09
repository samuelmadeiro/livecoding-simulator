package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.PaginaDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Tecnologia;
import com.portfolio.livecoding.enums.Dificuldade;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.OrdemDesafios;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.repository.ConquistaRepository;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

@ExtendWith(MockitoExtension.class)
class DesafioServiceTest {

    @Mock
    private DesafioRepository desafioRepository;

    @Mock
    private ConquistaRepository conquistaRepository;

    @Mock
    private UsuarioRepository usuarioRepository;

    @InjectMocks
    private DesafioService desafioService;

    private Desafio desafio;

    private static final DesafioFiltroDTO SEM_FILTRO = new DesafioFiltroDTO(null, null, null, null);

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
        desafio.setDificuldade(Dificuldade.MEDIO);
        desafio.setTipo(TipoDesafio.API_REST);
        desafio.setTempoLimiteMinutos(45);
        desafio.setTemplateCodigo("// TODO");
        desafio.setTecnologia(java);
    }

    private void repositorioDevolveUmDesafio(int pagina, int tamanho, long total) {
        when(desafioRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(desafio), PageRequest.of(pagina, tamanho), total));
    }

    @Test
    @DisplayName("listar mapeia a pagina de entidades para a pagina de DTOs")
    void listarMapeiaPagina() {
        repositorioDevolveUmDesafio(0, 9, 1);

        PaginaDTO<DesafioResponseDTO> pagina =
                desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, 9);

        assertThat(pagina.conteudo()).hasSize(1);
        assertThat(pagina.conteudo().getFirst().id()).isEqualTo(10L);
        assertThat(pagina.conteudo().getFirst().tecnologiaNome()).isEqualTo("Java");
        assertThat(pagina.conteudo().getFirst().dificuldade()).isEqualTo(Dificuldade.MEDIO);
        assertThat(pagina.totalItens()).isEqualTo(1);
        assertThat(pagina.primeira()).isTrue();
        assertThat(pagina.ultima()).isTrue();
    }

    @Test
    @DisplayName("sem candidato conhecido, resolvido sai nulo em vez de false")
    void visitanteAnonimoNaoRecebeMarcaDeResolvido() {
        repositorioDevolveUmDesafio(0, 9, 1);

        PaginaDTO<DesafioResponseDTO> pagina =
                desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, 9, null, false);

        // Nulo, e nao false: "ainda nao resolvi" e "nao sei quem voce e" sao respostas diferentes.
        assertThat(pagina.conteudo().getFirst().resolvido()).isNull();
        verify(conquistaRepository, never()).idsConquistadosEntre(any(), any());
    }

    @Test
    @DisplayName("com candidato, marca as questoes ja conquistadas numa consulta so")
    void marcaResolvidasDoCandidato() {
        Usuario candidato = new Usuario();
        candidato.setId(7L);
        when(usuarioRepository.findByEmail("ana@exemplo.com")).thenReturn(Optional.of(candidato));
        repositorioDevolveUmDesafio(0, 9, 1);
        when(conquistaRepository.idsConquistadosEntre(7L, List.of(10L))).thenReturn(List.of(10L));

        PaginaDTO<DesafioResponseDTO> pagina =
                desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, 9, "ana@exemplo.com", false);

        assertThat(pagina.conteudo().getFirst().resolvido()).isTrue();
        // Uma consulta para a pagina inteira, e nao uma por card.
        verify(conquistaRepository).idsConquistadosEntre(7L, List.of(10L));
    }

    @Test
    @DisplayName("pedir so as pendentes sem estar logado devolve o catalogo inteiro, sem erro")
    void recorteDePendentesExigeCandidato() {
        repositorioDevolveUmDesafio(0, 9, 255);

        PaginaDTO<DesafioResponseDTO> pagina =
                desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, 9, null, true);

        /*
         * Sem candidato, o recorte e ignorado em vez de virar erro: quem nao entrou nao pediu nada
         * invalido, apenas nao ha a quem a pergunta "ja resolvi isto?" se refira. O total continua
         * sendo o do catalogo, e nenhuma conquista e consultada.
         */
        assertThat(pagina.totalItens()).isEqualTo(255);
        assertThat(pagina.conteudo().getFirst().resolvido()).isNull();
        verify(conquistaRepository, never()).idsConquistadosEntre(any(), any());
    }

    @Test
    @DisplayName("listar pede a pagina sem Sort, para nao sobrescrever o ORDER BY da Specification")
    void listarNaoOrdenaPeloPageable() {
        repositorioDevolveUmDesafio(1, 9, 20);

        desafioService.listar(SEM_FILTRO, OrdemDesafios.DIFICULDADE_CRESCENTE, 1, 9);

        assertThat(pageableUsado().getSort().isSorted()).isFalse();
    }

    @Test
    @DisplayName("tamanho acima do teto e cortado, e nao rejeitado")
    void tamanhoAcimaDoTeto() {
        repositorioDevolveUmDesafio(0, DesafioService.TAMANHO_MAXIMO, 100);

        desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, 10_000);

        assertThat(pageableUsado().getPageSize()).isEqualTo(DesafioService.TAMANHO_MAXIMO);
    }

    @Test
    @DisplayName("tamanho zero ou negativo cai no padrao e pagina negativa vira a primeira")
    void faixaInvalidaEhCorrigida() {
        repositorioDevolveUmDesafio(0, DesafioService.TAMANHO_PADRAO, 1);

        desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, -3, 0);

        Pageable usado = pageableUsado();
        assertThat(usado.getPageNumber()).isZero();
        assertThat(usado.getPageSize()).isEqualTo(DesafioService.TAMANHO_PADRAO);
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

    @SuppressWarnings("unchecked")
    private Pageable pageableUsado() {
        ArgumentCaptor<Pageable> captor = ArgumentCaptor.forClass(Pageable.class);
        verify(desafioRepository).findAll(any(Specification.class), captor.capture());
        return captor.getValue();
    }
}
