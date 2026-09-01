package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.CriterioResultadoDTO;
import com.portfolio.livecoding.dto.FalaEntrevistadorDTO;
import com.portfolio.livecoding.dto.SubmissaoRequestDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.entity.CriterioAvaliacao;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.ResultadoCriterio;
import com.portfolio.livecoding.entity.Submissao;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.CriterioAvaliacaoRepository;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.SubmissaoRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import com.portfolio.livecoding.service.ValidadorCodigoService.ItemAvaliado;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SubmissaoService {

    private final SubmissaoRepository submissaoRepository;
    private final DesafioRepository desafioRepository;
    private final UsuarioRepository usuarioRepository;
    private final CriterioAvaliacaoRepository criterioAvaliacaoRepository;
    private final ValidadorCodigoService validadorCodigoService;
    private final FeedbackEntrevistadorService feedbackEntrevistadorService;
    private final TentativaService tentativaService;

    @Transactional
    public SubmissaoResponseDTO registrar(SubmissaoRequestDTO request, String emailUsuario) {
        Desafio desafio = desafioRepository.findById(request.desafioId())
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Desafio nao encontrado: id " + request.desafioId()));

        Usuario usuario = usuarioRepository.findByEmail(emailUsuario)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuario nao encontrado: " + emailUsuario));

        List<CriterioAvaliacao> criterios =
                criterioAvaliacaoRepository.findByDesafioIdOrderById(desafio.getId());

        ValidadorCodigoService.Resultado resultado =
                validadorCodigoService.validar(request.codigoEnviado(), desafio, criterios);

        Integer duracaoSegundos = tentativaService.fechar(usuario, desafio, request.tentativaId());

        Submissao submissao = new Submissao();
        submissao.setCodigoEnviado(request.codigoEnviado());
        submissao.setStatus(resultado.status());
        submissao.setPontuacao(resultado.pontuacao());
        submissao.setPrecisao(resultado.precisao());
        submissao.setDuracaoSegundos(duracaoSegundos);
        submissao.setDataHora(LocalDateTime.now());
        submissao.setUsuario(usuario);
        submissao.setDesafio(desafio);

        // O detalhamento vai para o banco junto com a submissao: e dele que sai a taxa de acerto
        // por criterio no painel do admin.
        resultado.itens().forEach(item -> submissao.adicionarResultado(linhaDeHistorico(item)));

        Submissao salva = submissaoRepository.save(submissao);

        FalaEntrevistadorDTO entrevistador = feedbackEntrevistadorService.gerar(
                desafio, resultado, duracaoSegundos, usuario.getNome());

        return new SubmissaoResponseDTO(
                salva.getId(),
                salva.getStatus(),
                resultado.mensagemFeedback(),
                salva.getPontuacao(),
                salva.getPrecisao(),
                salva.getDuracaoSegundos(),
                resultado.itens().stream().map(this::linhaDeFeedback).toList(),
                entrevistador);
    }

    private ResultadoCriterio linhaDeHistorico(ItemAvaliado item) {
        ResultadoCriterio linha = new ResultadoCriterio();
        linha.setCriterio(item.criterio());
        linha.setDescricao(item.descricao());
        linha.setTipo(item.tipo());
        linha.setPeso(item.peso());
        linha.setAtendido(item.atendido());
        return linha;
    }

    private CriterioResultadoDTO linhaDeFeedback(ItemAvaliado item) {
        return new CriterioResultadoDTO(
                item.descricao(), item.atendido(), item.tipo(), item.peso(), item.dica());
    }
}
