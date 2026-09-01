package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.TentativaResponseDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Tentativa;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.TentativaRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Cronometro das questoes: abre quando o candidato comeca o desafio e fecha quando ele envia.
 *
 * <p>O tempo e medido pelo relogio do servidor porque e dado de avaliacao: um campo
 * "tempoGastoSegundos" no corpo da submissao seria preenchido pelo cliente, e o painel do admin
 * passaria a mostrar o numero que cada candidato escolheu mostrar.
 */
@Service
@RequiredArgsConstructor
public class TentativaService {

    /**
     * Uma tentativa aberta ha mais do que este multiplo do tempo limite esta abandonada, nao em
     * andamento: quem volta no dia seguinte comeca outra em vez de aparecer com 14 horas de
     * "raciocinio".
     */
    private static final int MULTIPLO_DE_ABANDONO = 2;

    /** Piso do abandono, para desafios de tempo limite curto. */
    private static final Duration ABANDONO_MINIMO = Duration.ofHours(1);

    private final TentativaRepository tentativaRepository;
    private final DesafioRepository desafioRepository;
    private final UsuarioRepository usuarioRepository;

    /**
     * Abre o cronometro, ou devolve o que ja estava aberto. Recarregar a pagina no meio da questao
     * nao pode zerar o relogio — por isso a tentativa em aberto e reaproveitada.
     */
    @Transactional
    public TentativaResponseDTO iniciar(Long desafioId, String emailUsuario) {
        Desafio desafio = buscarDesafio(desafioId);
        Usuario usuario = buscarUsuario(emailUsuario);
        LocalDateTime agora = LocalDateTime.now();

        Tentativa tentativa = tentativaRepository
                .findFirstByUsuarioIdAndDesafioIdAndFinalizadoEmIsNullOrderByIniciadoEmDesc(
                        usuario.getId(), desafioId)
                .filter(aberta -> !abandonada(aberta, desafio, agora))
                .orElseGet(() -> abrir(usuario, desafio, agora));

        return new TentativaResponseDTO(
                tentativa.getId(),
                desafio.getId(),
                tentativa.getIniciadoEm(),
                desafio.getTempoLimiteMinutos(),
                segundosAte(tentativa.getIniciadoEm(), agora));
    }

    /**
     * Fecha o cronometro da submissao e devolve o tempo gasto, ou null quando nao havia tentativa
     * valida — submissao feita direto pela API, por exemplo, sem passar pela tela do desafio.
     */
    @Transactional
    public Integer fechar(Usuario usuario, Desafio desafio, Long tentativaId) {
        LocalDateTime agora = LocalDateTime.now();

        Optional<Tentativa> encontrada = tentativaId == null
                ? tentativaRepository
                        .findFirstByUsuarioIdAndDesafioIdAndFinalizadoEmIsNullOrderByIniciadoEmDesc(
                                usuario.getId(), desafio.getId())
                // O id vem do cliente: so vale se a tentativa for do proprio usuario e do desafio
                // que ele diz estar respondendo.
                : tentativaRepository.findByIdAndUsuarioId(tentativaId, usuario.getId())
                        .filter(t -> t.getDesafio().getId().equals(desafio.getId()));

        Tentativa tentativa = encontrada
                .filter(t -> t.getFinalizadoEm() == null)
                .filter(t -> !abandonada(t, desafio, agora))
                .orElse(null);

        if (tentativa == null) {
            return null;
        }

        tentativa.setFinalizadoEm(agora);
        tentativaRepository.save(tentativa);

        return (int) segundosAte(tentativa.getIniciadoEm(), agora);
    }

    private Tentativa abrir(Usuario usuario, Desafio desafio, LocalDateTime agora) {
        Tentativa tentativa = new Tentativa();
        tentativa.setUsuario(usuario);
        tentativa.setDesafio(desafio);
        tentativa.setIniciadoEm(agora);
        return tentativaRepository.save(tentativa);
    }

    private boolean abandonada(Tentativa tentativa, Desafio desafio, LocalDateTime agora) {
        Duration limite = desafio.getTempoLimiteMinutos() == null
                ? ABANDONO_MINIMO
                : Duration.ofMinutes((long) desafio.getTempoLimiteMinutos() * MULTIPLO_DE_ABANDONO);

        if (limite.compareTo(ABANDONO_MINIMO) < 0) {
            limite = ABANDONO_MINIMO;
        }

        return Duration.between(tentativa.getIniciadoEm(), agora).compareTo(limite) > 0;
    }

    private long segundosAte(LocalDateTime inicio, LocalDateTime fim) {
        long segundos = Duration.between(inicio, fim).toSeconds();
        return Math.max(segundos, 0);
    }

    private Desafio buscarDesafio(Long desafioId) {
        return desafioRepository.findById(desafioId)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Desafio nao encontrado: id " + desafioId));
    }

    private Usuario buscarUsuario(String email) {
        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuario nao encontrado: " + email));
    }
}
