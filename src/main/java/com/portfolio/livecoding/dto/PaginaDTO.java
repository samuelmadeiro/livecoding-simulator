package com.portfolio.livecoding.dto;

import java.util.List;
import java.util.function.Function;
import org.springframework.data.domain.Page;

/**
 * Uma fatia de resultado. Existe para o cliente nao receber o {@code Page} do Spring Data cru: o
 * JSON daquele tipo carrega o objeto {@code Pageable} inteiro e nao tem contrato estavel entre
 * versoes.
 *
 * @param conteudo     os itens desta pagina
 * @param pagina       indice da pagina atual, comecando em zero
 * @param tamanho      quantos itens cabem por pagina
 * @param totalItens   quantos itens o filtro inteiro rende, e nao apenas esta pagina
 * @param totalPaginas quantas paginas o filtro rende
 */
public record PaginaDTO<T>(
        List<T> conteudo,
        int pagina,
        int tamanho,
        long totalItens,
        int totalPaginas,
        boolean primeira,
        boolean ultima
) {

    /** Converte a pagina de entidades do Spring Data na pagina de DTOs que a API devolve. */
    public static <E, T> PaginaDTO<T> de(Page<E> pagina, Function<E, T> mapeador) {
        return new PaginaDTO<>(
                pagina.getContent().stream().map(mapeador).toList(),
                pagina.getNumber(),
                pagina.getSize(),
                pagina.getTotalElements(),
                pagina.getTotalPages(),
                pagina.isFirst(),
                pagina.isLast());
    }
}
