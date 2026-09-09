package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.PaginaDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.OrdemDesafios;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.repository.ConquistaRepository;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import com.portfolio.livecoding.repository.especificacao.DesafioEspecificacao;
import java.util.List;
import java.util.Set;
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
    private final ConquistaRepository conquistaRepository;
    private final UsuarioRepository usuarioRepository;

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

        return listar(filtro, ordem, pagina, tamanho, null);
    }

    /**
     * Uma pagina do catalogo, marcando o que o candidato ja resolveu.
     *
     * @param email         quem esta olhando, ou nulo para visitante anonimo. Nulo faz cada item
     *                      sair com {@code resolvido} nulo, e nao false.
     * @param naoResolvidas recorta so o que falta. Sem candidato conhecido o pedido e ignorado, e
     *                      nao vira erro: quem nao entrou nao pediu nada invalido, apenas nao ha a
     *                      quem a pergunta se refira.
     */
    @Transactional(readOnly = true)
    public PaginaDTO<DesafioResponseDTO> listar(DesafioFiltroDTO filtro,
                                                OrdemDesafios ordem,
                                                int pagina,
                                                int tamanho,
                                                String email,
                                                boolean naoResolvidas) {

        Long usuarioId = email == null
                ? null
                : usuarioRepository.findByEmail(email).map(Usuario::getId).orElse(null);

        return listar(
                naoResolvidas && usuarioId != null ? comRecorteDePendentes(filtro, usuarioId) : filtro,
                ordem,
                pagina,
                tamanho,
                usuarioId);
    }

    private static DesafioFiltroDTO comRecorteDePendentes(DesafioFiltroDTO filtro, Long usuarioId) {
        return new DesafioFiltroDTO(
                filtro.nivel(), filtro.tecnologiaId(), filtro.tipo(), filtro.dificuldade(), usuarioId);
    }

    /** Sobrecarga interna: aqui o candidato ja chega resolvido em id. */
    @Transactional(readOnly = true)
    public PaginaDTO<DesafioResponseDTO> listar(DesafioFiltroDTO filtro,
                                                OrdemDesafios ordem,
                                                int pagina,
                                                int tamanho,
                                                Long usuarioId) {

        OrdemDesafios ordemEfetiva = ordem != null ? ordem : OrdemDesafios.PADRAO;

        /*
         * PageRequest sem Sort de proposito: quando o Pageable vem ordenado, o Spring Data
         * sobrescreve o ORDER BY que a Specification montou — e e la que mora a ordenacao por
         * dificuldade, que precisa do CASE em vez do nome da coluna.
         */
        Page<Desafio> fatia = desafioRepository.findAll(
                DesafioEspecificacao.de(filtro, ordemEfetiva),
                PageRequest.of(Math.max(pagina, 0), tamanhoValido(tamanho)));

        Set<Long> resolvidos = resolvidosNaPagina(fatia, usuarioId);

        return PaginaDTO.de(fatia, desafio -> DesafioResponseDTO.fromEntity(
                desafio,
                usuarioId == null ? null : resolvidos.contains(desafio.getId())));
    }

    /**
     * Quais questoes desta pagina o candidato ja conquistou.
     *
     * <p>Uma consulta para a pagina inteira, e nao uma por card: com nove itens na tela, a versao
     * ingenua faria nove idas ao banco para responder a mesma pergunta.
     */
    private Set<Long> resolvidosNaPagina(Page<Desafio> fatia, Long usuarioId) {
        if (usuarioId == null || fatia.isEmpty()) {
            return Set.of();
        }

        List<Long> idsDaPagina = fatia.getContent().stream().map(Desafio::getId).toList();
        return Set.copyOf(conquistaRepository.idsConquistadosEntre(usuarioId, idsDaPagina));
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
