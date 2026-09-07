package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.PaginaDTO;
import com.portfolio.livecoding.enums.Dificuldade;
import com.portfolio.livecoding.enums.OrdemDesafios;
import com.portfolio.livecoding.repository.DesafioRepository;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

/**
 * Catalogo de verdade: H2 com as migrations aplicadas, consulta chegando ao banco. O teste de
 * unidade cobre o contrato do service com mock; aqui o que esta sob prova e o SQL que a
 * Specification gera — ordenacao por dificuldade, filtro e recorte de pagina.
 */
@SpringBootTest
@TestPropertySource(properties = {
        "spring.datasource.url=jdbc:h2:mem:catalogo;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;"
                + "DEFAULT_NULL_ORDERING=HIGH;DB_CLOSE_DELAY=-1",
        "spring.jpa.hibernate.ddl-auto=validate",
        "spring.flyway.enabled=true",
        "spring.jpa.show-sql=false"
})
class DesafioCatalogoTest {

    private static final DesafioFiltroDTO SEM_FILTRO = new DesafioFiltroDTO(null, null, null, null);

    @Autowired
    private DesafioService desafioService;

    @Autowired
    private DesafioRepository desafioRepository;

    @Test
    @DisplayName("a pagina traz so o pedaco pedido, mas conta o catalogo inteiro")
    void paginaRecortaSemPerderOTotal() {
        long total = desafioRepository.count();
        PaginaDTO<DesafioResponseDTO> primeira =
                desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, 5);

        assertThat(total).isGreaterThan(5);
        assertThat(primeira.conteudo()).hasSize(5);
        assertThat(primeira.totalItens()).isEqualTo(total);
        assertThat(primeira.totalPaginas()).isEqualTo((int) Math.ceil(total / 5.0));
        assertThat(primeira.primeira()).isTrue();
        assertThat(primeira.ultima()).isFalse();
    }

    @Test
    @DisplayName("percorrer as paginas ve cada desafio uma vez, sem repetir nem pular")
    void paginasCobremOCatalogoUmaVezSo() {
        List<Long> vistos = new ArrayList<>();
        int pagina = 0;
        boolean ultima = false;

        while (!ultima) {
            PaginaDTO<DesafioResponseDTO> fatia =
                    desafioService.listar(SEM_FILTRO, OrdemDesafios.TITULO, pagina, 4);
            fatia.conteudo().forEach(desafio -> vistos.add(desafio.id()));
            ultima = fatia.ultima();
            pagina++;
        }

        assertThat(vistos).hasSize((int) desafioRepository.count()).doesNotHaveDuplicates();
    }

    @Test
    @DisplayName("ordenar por dificuldade segue o peso da constante, e nao a ordem alfabetica")
    void ordenaPorDificuldade() {
        List<Integer> pesos = pesos(OrdemDesafios.DIFICULDADE_CRESCENTE);
        assertThat(pesos).isSorted();

        assertThat(pesos(OrdemDesafios.DIFICULDADE_DECRESCENTE)).isSortedAccordingTo((a, b) -> b - a);
    }

    @Test
    @DisplayName("ordenar por titulo devolve o catalogo em ordem alfabetica")
    void ordenaPorTitulo() {
        List<String> titulos = desafioService
                .listar(SEM_FILTRO, OrdemDesafios.TITULO, 0, DesafioService.TAMANHO_MAXIMO)
                .conteudo()
                .stream()
                .map(DesafioResponseDTO::titulo)
                .toList();

        assertThat(titulos).isSorted();
    }

    @Test
    @DisplayName("ordenar por tempo poe as questoes curtas na frente")
    void ordenaPorTempo() {
        List<Integer> tempos = desafioService
                .listar(SEM_FILTRO, OrdemDesafios.TEMPO_CRESCENTE, 0, DesafioService.TAMANHO_MAXIMO)
                .conteudo()
                .stream()
                .map(DesafioResponseDTO::tempoLimiteMinutos)
                .toList();

        assertThat(tempos).isSorted();
    }

    @Test
    @DisplayName("filtrar por dificuldade devolve so aquela dificuldade, e o total acompanha")
    void filtraPorDificuldade() {
        DesafioFiltroDTO soFaceis = new DesafioFiltroDTO(null, null, null, Dificuldade.FACIL);

        PaginaDTO<DesafioResponseDTO> pagina =
                desafioService.listar(soFaceis, OrdemDesafios.PADRAO, 0, DesafioService.TAMANHO_MAXIMO);

        assertThat(pagina.conteudo()).isNotEmpty();
        assertThat(pagina.conteudo()).allMatch(desafio -> desafio.dificuldade() == Dificuldade.FACIL);
        assertThat(pagina.totalItens()).isPositive().isLessThan(desafioRepository.count());
    }

    @Test
    @DisplayName("toda questao do catalogo tem dificuldade depois da migration V22")
    void catalogoInteiroTemDificuldade() {
        PaginaDTO<DesafioResponseDTO> tudo =
                desafioService.listar(SEM_FILTRO, OrdemDesafios.PADRAO, 0, DesafioService.TAMANHO_MAXIMO);

        assertThat(tudo.conteudo()).isNotEmpty();
        assertThat(tudo.conteudo()).allMatch(desafio -> desafio.dificuldade() != null);
    }

    private List<Integer> pesos(OrdemDesafios ordem) {
        return desafioService.listar(SEM_FILTRO, ordem, 0, DesafioService.TAMANHO_MAXIMO)
                .conteudo()
                .stream()
                .map(desafio -> desafio.dificuldade().getPeso())
                .toList();
    }
}
