package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.CriterioResultadoDTO;
import com.portfolio.livecoding.dto.SubmissaoRequestDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.entity.CriterioAvaliacao;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Submissao;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.CriterioAvaliacaoRepository;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.SubmissaoRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
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

        Submissao submissao = new Submissao();
        submissao.setCodigoEnviado(request.codigoEnviado());
        submissao.setStatus(resultado.status());
        submissao.setPontuacao(resultado.pontuacao());
        submissao.setDataHora(LocalDateTime.now());
        submissao.setUsuario(usuario);
        submissao.setDesafio(desafio);

        Submissao salva = submissaoRepository.save(submissao);

        List<CriterioResultadoDTO> detalhamento = resultado.itens().stream()
                .map(item -> new CriterioResultadoDTO(item.descricao(), item.atendido()))
                .toList();

        return new SubmissaoResponseDTO(salva.getId(), salva.getStatus(),
                resultado.mensagemFeedback(), salva.getPontuacao(), detalhamento);
    }
}
