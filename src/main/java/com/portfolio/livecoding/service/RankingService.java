package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.ConquistaResumoDTO;
import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.ProgressoDTO;
import com.portfolio.livecoding.dto.RankingItemDTO;
import com.portfolio.livecoding.entity.Conquista;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.OrdemDesafios;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.ConquistaRepository;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** Leitura do ranking publico e do progresso individual. */
@Service
@RequiredArgsConstructor
public class RankingService {

    /** Quantas linhas do ranking a home mostra. */
    private static final int TAMANHO_RANKING = 10;

    /** Quantas conquistas recentes o painel lista. */
    private static final int HISTORICO_RECENTE = 5;

    private final UsuarioRepository usuarioRepository;
    private final ConquistaRepository conquistaRepository;
    private final DesafioRepository desafioRepository;
    private final DesafioService desafioService;

    @Transactional(readOnly = true)
    public List<RankingItemDTO> ranking() {
        List<Usuario> melhores = usuarioRepository.ranking(PageRequest.of(0, TAMANHO_RANKING));

        return montarLinhas(melhores);
    }

    /**
     * A proxima questao sugerida: uma que o candidato ainda nao resolveu, no nivel que ele mais
     * pratica.
     *
     * <p>Quem esta comecando nao tem historico, entao cai em estagio. Quem ja resolveu tudo do
     * nivel preferido recebe qualquer questao pendente, e so entao a sugestao fica vazia — o painel
     * trata esse caso mostrando o link do catalogo.
     */
    @Transactional(readOnly = true)
    public Optional<DesafioResponseDTO> proximaQuestao(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Usuario nao encontrado: " + email));

        NivelVaga nivelPreferido = conquistaRepository.niveisMaisPraticados(usuario.getId())
                .stream()
                .findFirst()
                .orElse(NivelVaga.ESTAGIO);

        return primeiraPendente(usuario.getId(), nivelPreferido)
                .or(() -> primeiraPendente(usuario.getId(), null));
    }

    private Optional<DesafioResponseDTO> primeiraPendente(Long usuarioId, NivelVaga nivel) {
        DesafioFiltroDTO filtro = new DesafioFiltroDTO(nivel, null, null, null, usuarioId);

        return desafioService.listar(filtro, OrdemDesafios.PADRAO, 0, 1, usuarioId)
                .conteudo()
                .stream()
                .findFirst();
    }

    @Transactional(readOnly = true)
    public ProgressoDTO progressoDe(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Usuario nao encontrado: " + email));

        List<Conquista> recentes = conquistaRepository.ultimasDoUsuario(usuario.getId())
                .stream()
                .limit(HISTORICO_RECENTE)
                .toList();

        // Sem pontos nao ha posicao: mostrar "1o lugar" para quem nunca resolveu nada seria mentira.
        Integer posicao = usuario.getPontos() > 0
                ? (int) usuarioRepository.quantosNaFrente(usuario.getPontos(), usuario.getId()) + 1
                : null;

        return new ProgressoDTO(
                usuario.getApelido(),
                usuario.getPontos(),
                usuario.getSequenciaAtual(),
                usuario.getSequenciaRecorde(),
                usuario.getUltimoDiaPraticado(),
                LocalDate.now().equals(usuario.getUltimoDiaPraticado()),
                conquistaRepository.countByUsuarioId(usuario.getId()),
                desafioRepository.count(),
                posicao,
                recentes.stream().map(this::resumo).toList());
    }

    private List<RankingItemDTO> montarLinhas(List<Usuario> usuarios) {
        return java.util.stream.IntStream.range(0, usuarios.size())
                .mapToObj(indice -> {
                    Usuario usuario = usuarios.get(indice);
                    return new RankingItemDTO(
                            indice + 1,
                            usuario.getApelido(),
                            usuario.getPontos(),
                            usuario.getSequenciaAtual(),
                            conquistaRepository.countByUsuarioId(usuario.getId()));
                })
                .toList();
    }

    private ConquistaResumoDTO resumo(Conquista conquista) {
        return new ConquistaResumoDTO(
                conquista.getDesafio().getId(),
                conquista.getDesafio().getTitulo(),
                conquista.getDesafio().getTecnologia().getNome(),
                conquista.getDesafio().getNivel(),
                conquista.getPontos(),
                conquista.getPrecisao(),
                conquista.getConquistadoEm());
    }
}
