package com.portfolio.livecoding.service;

import com.portfolio.livecoding.entity.Conquista;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.ConquistaRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

/**
 * Regras de progresso: sequencia de dias praticados e pontos por questao conquistada.
 *
 * <p>As duas contam coisas diferentes de proposito. A sequencia mede constancia e sobe com
 * qualquer tentativa, inclusive a que reprova — quem tentou e errou praticou. Os pontos medem
 * resultado e so entram quando a questao e aprovada, uma vez por questao.
 */
@Service
@RequiredArgsConstructor
public class ProgressoService {

    /**
     * Pontos por nivel. Questao de pleno vale cinco vezes a de estagio porque, sem isso, moer
     * questao facil renderia mais que encarar a dificil, e o ranking premiaria o caminho errado.
     */
    private static final int PONTOS_ESTAGIO = 10;
    private static final int PONTOS_JUNIOR = 25;
    private static final int PONTOS_PLENO = 50;

    private final UsuarioRepository usuarioRepository;
    private final ConquistaRepository conquistaRepository;

    /** O que mudou no progresso depois de uma submissao, para a resposta contar ao candidato. */
    public record Ganho(int pontosGanhos, boolean primeiraVez, int sequenciaAtual, boolean sequenciaCresceu) {
        public static Ganho nenhum(int sequenciaAtual, boolean sequenciaCresceu) {
            return new Ganho(0, false, sequenciaAtual, sequenciaCresceu);
        }
    }

    /**
     * Registra a pratica do dia e credita os pontos quando a questao e aprovada pela primeira vez.
     *
     * <p>Roda dentro da transacao da submissao: se a gravacao da submissao falhar depois, o
     * progresso nao pode ficar creditado.
     */
    public Ganho registrar(Usuario usuario, Desafio desafio, StatusSubmissao status, int precisao) {
        boolean sequenciaCresceu = atualizarSequencia(usuario, LocalDate.now());

        if (status != StatusSubmissao.APROVADO) {
            usuarioRepository.save(usuario);
            return Ganho.nenhum(usuario.getSequenciaAtual(), sequenciaCresceu);
        }

        if (conquistaRepository.existsByUsuarioIdAndDesafioId(usuario.getId(), desafio.getId())) {
            // Questao ja paga. A pessoa pode refazer a vontade, mas o placar nao se move.
            usuarioRepository.save(usuario);
            return Ganho.nenhum(usuario.getSequenciaAtual(), sequenciaCresceu);
        }

        int pontos = calcularPontos(desafio.getNivel(), precisao);

        Conquista conquista = new Conquista();
        conquista.setUsuario(usuario);
        conquista.setDesafio(desafio);
        conquista.setPontos(pontos);
        conquista.setPrecisao(precisao);
        conquista.setConquistadoEm(LocalDateTime.now());

        try {
            conquistaRepository.save(conquista);
        } catch (DataIntegrityViolationException duplicada) {
            // Dois envios simultaneos da mesma questao: o indice unico barrou o segundo, e e ele
            // quem manda. A pratica do dia continua valendo; os pontos ja foram creditados pelo
            // envio que chegou primeiro.
            usuarioRepository.save(usuario);
            return Ganho.nenhum(usuario.getSequenciaAtual(), sequenciaCresceu);
        }

        usuario.setPontos(usuario.getPontos() + pontos);
        usuarioRepository.save(usuario);

        return new Ganho(pontos, true, usuario.getSequenciaAtual(), sequenciaCresceu);
    }

    /**
     * Sequencia de dias consecutivos com pratica.
     *
     * <p>Tres casos: ja praticou hoje e nada muda; praticou ontem e a sequencia cresce; qualquer
     * outro intervalo reinicia em 1. O recorde e guardado a parte para a pessoa nao perder o que
     * ja construiu quando falha um dia.
     *
     * @return true quando a sequencia cresceu nesta chamada.
     */
    private boolean atualizarSequencia(Usuario usuario, LocalDate hoje) {
        LocalDate ultimo = usuario.getUltimoDiaPraticado();

        if (hoje.equals(ultimo)) {
            return false;
        }

        int nova = ultimo != null && hoje.equals(ultimo.plusDays(1)) ? usuario.getSequenciaAtual() + 1 : 1;

        usuario.setSequenciaAtual(nova);
        usuario.setUltimoDiaPraticado(hoje);

        if (nova > usuario.getSequenciaRecorde()) {
            usuario.setSequenciaRecorde(nova);
        }

        return true;
    }

    /**
     * Pontos da questao, proporcionais a precisao da solucao.
     *
     * <p>Aprovar com 70 de precisao nao pode valer o mesmo que aprovar com 100: a nota parcial
     * rende pontos parciais, e refazer melhor nao adianta, porque a questao so paga uma vez. E
     * deliberado — o incentivo e fazer bem na primeira, como numa prova de verdade.
     */
    private int calcularPontos(NivelVaga nivel, int precisao) {
        int base = switch (nivel) {
            case ESTAGIO -> PONTOS_ESTAGIO;
            case JUNIOR -> PONTOS_JUNIOR;
            case PLENO, SENIOR -> PONTOS_PLENO;
        };

        return Math.max(1, Math.round(base * precisao / 100f));
    }
}
