package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.admin.MetricaCriterioDTO;
import com.portfolio.livecoding.dto.admin.MetricaDesafioDTO;
import com.portfolio.livecoding.dto.admin.MetricaUsuarioDTO;
import com.portfolio.livecoding.dto.admin.PainelAdminDTO;
import com.portfolio.livecoding.dto.admin.ResumoAdminDTO;
import com.portfolio.livecoding.dto.admin.SubmissaoRecenteDTO;
import com.portfolio.livecoding.entity.Submissao;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.ResultadoCriterioRepository;
import com.portfolio.livecoding.repository.SubmissaoRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import com.portfolio.livecoding.repository.projecao.MetricaCriterioProjecao;
import com.portfolio.livecoding.repository.projecao.MetricaDesafioProjecao;
import com.portfolio.livecoding.repository.projecao.MetricaUsuarioProjecao;
import com.portfolio.livecoding.repository.projecao.ResumoProjecao;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Monta o painel do admin. Todo o trabalho pesado vive em quatro consultas agregadas — somar e
 * contar em memoria sobre findAll() funcionaria com 14 desafios e cairia junto com o catalogo.
 */
@Service
@RequiredArgsConstructor
public class AdminMetricasService {

    /** Quantas submissoes o historico recente mostra. */
    private static final int LIMITE_RECENTES = 20;

    private final UsuarioRepository usuarioRepository;
    private final DesafioRepository desafioRepository;
    private final SubmissaoRepository submissaoRepository;
    private final ResultadoCriterioRepository resultadoCriterioRepository;

    @Transactional(readOnly = true)
    public PainelAdminDTO montarPainel() {
        return new PainelAdminDTO(
                montarResumo(),
                listarUsuarios(),
                listarDesafios(),
                listarUltimasSubmissoes());
    }

    private ResumoAdminDTO montarResumo() {
        ResumoProjecao total = submissaoRepository.resumir(StatusSubmissao.APROVADO);

        long submissoes = total.getSubmissoes();
        long aprovadas = ouZero(total.getAprovadas());

        return new ResumoAdminDTO(
                usuarioRepository.countByRole(Role.CANDIDATO),
                desafioRepository.count(),
                submissoes,
                aprovadas,
                percentual(aprovadas, submissoes),
                arredondar(total.getPontuacaoMedia()),
                arredondar(total.getPrecisaoMedia()),
                arredondar(total.getDuracaoMedia()),
                total.getDuracaoTotal());
    }

    private List<MetricaUsuarioDTO> listarUsuarios() {
        return usuarioRepository.metricasPorUsuario(StatusSubmissao.APROVADO).stream()
                .map(this::converter)
                .toList();
    }

    private MetricaUsuarioDTO converter(MetricaUsuarioProjecao linha) {
        long aprovadas = ouZero(linha.getAprovadas());

        return new MetricaUsuarioDTO(
                linha.getUsuarioId(),
                linha.getNome(),
                linha.getEmail(),
                linha.getRole(),
                linha.getSubmissoes(),
                aprovadas,
                percentual(aprovadas, linha.getSubmissoes()),
                arredondar(linha.getPontuacaoMedia()),
                arredondar(linha.getPrecisaoMedia()),
                arredondar(linha.getDuracaoMedia()),
                linha.getDuracaoTotal(),
                linha.getUltimaSubmissao());
    }

    private List<MetricaDesafioDTO> listarDesafios() {
        // Uma consulta so para o catalogo inteiro, agrupada aqui por desafio: o alternativo seria
        // uma consulta de criterios por desafio, ou seja, N+1 na tela do admin.
        Map<Long, List<MetricaCriterioDTO>> criteriosPorDesafio =
                resultadoCriterioRepository.agregarPorDesafio().stream()
                        .collect(Collectors.groupingBy(MetricaCriterioProjecao::getDesafioId,
                                Collectors.mapping(this::converter, Collectors.toList())));

        return desafioRepository.metricasPorDesafio(StatusSubmissao.APROVADO).stream()
                .map(linha -> converter(linha, ordenarPorDificuldade(
                        criteriosPorDesafio.getOrDefault(linha.getDesafioId(), List.of()))))
                .toList();
    }

    /** Do criterio que mais reprova para o que menos reprova: e essa a leitura util do painel. */
    private List<MetricaCriterioDTO> ordenarPorDificuldade(List<MetricaCriterioDTO> criterios) {
        return criterios.stream()
                .sorted(Comparator.comparingInt(MetricaCriterioDTO::taxaAcerto)
                        .thenComparing(MetricaCriterioDTO::descricao))
                .toList();
    }

    private MetricaCriterioDTO converter(MetricaCriterioProjecao linha) {
        return new MetricaCriterioDTO(
                linha.getDescricao(),
                linha.getTipo(),
                linha.getPeso() == null ? 1 : linha.getPeso(),
                linha.getAvaliacoes(),
                linha.getAtendidas(),
                percentual(linha.getAtendidas(), linha.getAvaliacoes()));
    }

    private MetricaDesafioDTO converter(MetricaDesafioProjecao linha,
                                        List<MetricaCriterioDTO> criterios) {
        long aprovadas = ouZero(linha.getAprovadas());

        return new MetricaDesafioDTO(
                linha.getDesafioId(),
                linha.getTitulo(),
                linha.getNivel(),
                linha.getTipo(),
                linha.getTecnologiaNome(),
                linha.getTempoLimiteMinutos(),
                linha.getSubmissoes(),
                linha.getCandidatos(),
                aprovadas,
                percentual(aprovadas, linha.getSubmissoes()),
                arredondar(linha.getPontuacaoMedia()),
                arredondar(linha.getPrecisaoMedia()),
                arredondar(linha.getDuracaoMedia()),
                criterioCritico(criterios),
                criterios);
    }

    /**
     * O criterio que mais reprova. Com todos em 100% nao existe criterio critico: apontar o
     * primeiro da lista sugeriria um problema onde nao ha nenhum.
     */
    private String criterioCritico(List<MetricaCriterioDTO> criterios) {
        return criterios.stream()
                .filter(criterio -> criterio.taxaAcerto() < 100)
                .map(MetricaCriterioDTO::descricao)
                .findFirst()
                .orElse(null);
    }

    private List<SubmissaoRecenteDTO> listarUltimasSubmissoes() {
        return submissaoRepository.ultimas(PageRequest.of(0, LIMITE_RECENTES)).stream()
                .map(this::converter)
                .toList();
    }

    private SubmissaoRecenteDTO converter(Submissao submissao) {
        return new SubmissaoRecenteDTO(
                submissao.getId(),
                submissao.getUsuario().getNome(),
                submissao.getUsuario().getEmail(),
                submissao.getDesafio().getTitulo(),
                submissao.getStatus(),
                submissao.getPontuacao(),
                submissao.getPrecisao(),
                submissao.getDuracaoSegundos(),
                submissao.getDataHora());
    }

    /** Sem denominador nao existe percentual: zero submissoes vira 0%, e nao divisao por zero. */
    private int percentual(long parte, long total) {
        return total == 0 ? 0 : Math.round(100f * parte / total);
    }

    private Integer arredondar(Double media) {
        return media == null ? null : (int) Math.round(media);
    }

    private long ouZero(Long valor) {
        return valor == null ? 0L : valor;
    }
}
