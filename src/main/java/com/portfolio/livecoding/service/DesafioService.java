package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.PaginaDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.OrdemDesafios;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.especificacao.DesafioEspecificacao;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DesafioService {

    /** Cabe em uma tela sem rolagem longa e ainda mostra variedade de nivel e tecnologia. */
    public static final int TAMANHO_PADRAO = 9;

    /**
     * Teto do que um cliente pode pedir por pagina. Sem ele, `?tamanho=100000` traria o catalogo
     * inteiro em uma resposta so — que e exatamente o que a paginacao existe para evitar.
     */
    public static final int TAMANHO_MAXIMO = 48;

    private final DesafioRepository desafioRepository;

    /**
     * Uma pagina do catalogo. Filtros nulos sao ignorados; pagina e tamanho fora da faixa sao
     * corrigidos aqui, e nao rejeitados: um link velho com `?pagina=-1` deve abrir o catalogo, e
     * nao devolver erro na cara de quem clicou.
     */
    @Transactional(readOnly = true)
    public PaginaDTO<DesafioResponseDTO> listar(DesafioFiltroDTO filtro,
                                                OrdemDesafios ordem,
                                                int pagina,
                                                int tamanho) {

        OrdemDesafios ordemEfetiva = ordem != null ? ordem : OrdemDesafios.PADRAO;

        /*
         * PageRequest sem Sort de proposito: quando o Pageable vem ordenado, o Spring Data
         * sobrescreve o ORDER BY que a Specification montou — e e la que mora a ordenacao por
         * dificuldade, que precisa do CASE em vez do nome da coluna.
         */
        Page<Desafio> fatia = desafioRepository.findAll(
                DesafioEspecificacao.de(filtro, ordemEfetiva),
                PageRequest.of(Math.max(pagina, 0), tamanhoValido(tamanho)));

        return PaginaDTO.de(fatia, DesafioResponseDTO::fromEntity);
    }

    @Transactional(readOnly = true)
    public DesafioResponseDTO buscarPorId(Long id) {
        return desafioRepository.findById(id)
                .map(DesafioResponseDTO::fromEntity)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Desafio nao encontrado: id " + id));
    }

    private static int tamanhoValido(int tamanho) {
        if (tamanho <= 0) {
            return TAMANHO_PADRAO;
        }
        return Math.min(tamanho, TAMANHO_MAXIMO);
    }
}
