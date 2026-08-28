package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.SubmissaoRequestDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Submissao;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.SubmissaoRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SubmissaoService {

    private final SubmissaoRepository submissaoRepository;
    private final DesafioRepository desafioRepository;
    private final UsuarioRepository usuarioRepository;
    private final ValidadorCodigoService validadorCodigoService;

    @Transactional
    public SubmissaoResponseDTO registrar(SubmissaoRequestDTO request, String emailUsuario) {
        Desafio desafio = desafioRepository.findById(request.desafioId())
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Desafio nao encontrado: id " + request.desafioId()));

        Usuario usuario = usuarioRepository.findByEmail(emailUsuario)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuario nao encontrado: " + emailUsuario));

        ValidadorCodigoService.Resultado resultado =
                validadorCodigoService.validar(request.codigoEnviado(), desafio);

        Submissao submissao = new Submissao();
        submissao.setCodigoEnviado(request.codigoEnviado());
        submissao.setStatus(resultado.status());
        submissao.setDataHora(LocalDateTime.now());
        submissao.setUsuario(usuario);
        submissao.setDesafio(desafio);

        Submissao salva = submissaoRepository.save(submissao);

        return new SubmissaoResponseDTO(salva.getId(), salva.getStatus(), resultado.mensagemFeedback());
    }
}
