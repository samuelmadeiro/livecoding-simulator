package com.portfolio.livecoding.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.portfolio.livecoding.entity.Conquista;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.ConquistaRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import java.time.LocalDate;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ProgressoServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private ConquistaRepository conquistaRepository;

    @InjectMocks
    private ProgressoService progressoService;

    private Usuario usuario;
    private Desafio desafio;

    @BeforeEach
    void setUp() {
        usuario = new Usuario();
        usuario.setId(1L);
        usuario.setNome("Ana");
        usuario.setApelido("Ana");
        usuario.setPontos(0);
        usuario.setSequenciaAtual(0);
        usuario.setSequenciaRecorde(0);

        desafio = new Desafio();
        desafio.setId(10L);
        desafio.setNivel(NivelVaga.JUNIOR);
    }

    @Test
    @DisplayName("aprovacao inedita credita pontos proporcionais a precisao")
    void aprovacaoIneditaCreditaPontos() {
        when(conquistaRepository.existsByUsuarioIdAndDesafioId(1L, 10L)).thenReturn(false);

        var ganho = progressoService.registrar(usuario, desafio, StatusSubmissao.APROVADO, 100);

        // Junior vale 25 e a precisao foi cheia.
        assertThat(ganho.pontosGanhos()).isEqualTo(25);
        assertThat(ganho.primeiraVez()).isTrue();
        assertThat(usuario.getPontos()).isEqualTo(25);
        verify(conquistaRepository).save(any(Conquista.class));
    }

    @Test
    @DisplayName("precisao parcial rende pontos parciais")
    void precisaoParcialRendeMenos() {
        when(conquistaRepository.existsByUsuarioIdAndDesafioId(anyLong(), anyLong())).thenReturn(false);

        var ganho = progressoService.registrar(usuario, desafio, StatusSubmissao.APROVADO, 80);

        assertThat(ganho.pontosGanhos()).isEqualTo(20);
    }

    @Test
    @DisplayName("refazer questao ja conquistada nao credita pontos de novo")
    void questaoRepetidaNaoPagaDuasVezes() {
        usuario.setPontos(25);
        when(conquistaRepository.existsByUsuarioIdAndDesafioId(1L, 10L)).thenReturn(true);

        var ganho = progressoService.registrar(usuario, desafio, StatusSubmissao.APROVADO, 100);

        assertThat(ganho.pontosGanhos()).isZero();
        assertThat(ganho.primeiraVez()).isFalse();
        assertThat(usuario.getPontos()).isEqualTo(25);
        verify(conquistaRepository, never()).save(any(Conquista.class));
    }

    @Test
    @DisplayName("submissao reprovada nao pontua, mas conta como pratica do dia")
    void reprovadaContaPraticaSemPontuar() {
        var ganho = progressoService.registrar(usuario, desafio, StatusSubmissao.ERRO_TESTE, 40);

        assertThat(ganho.pontosGanhos()).isZero();
        assertThat(usuario.getPontos()).isZero();
        // Quem tentou e errou praticou: a sequencia sobe.
        assertThat(usuario.getSequenciaAtual()).isEqualTo(1);
        assertThat(usuario.getUltimoDiaPraticado()).isEqualTo(LocalDate.now());
        verify(conquistaRepository, never()).save(any(Conquista.class));
    }

    @Test
    @DisplayName("praticar no dia seguinte aumenta a sequencia")
    void diaSeguinteAumentaSequencia() {
        usuario.setUltimoDiaPraticado(LocalDate.now().minusDays(1));
        usuario.setSequenciaAtual(4);
        usuario.setSequenciaRecorde(4);

        var ganho = progressoService.registrar(usuario, desafio, StatusSubmissao.ERRO_TESTE, 0);

        assertThat(usuario.getSequenciaAtual()).isEqualTo(5);
        assertThat(usuario.getSequenciaRecorde()).isEqualTo(5);
        assertThat(ganho.sequenciaCresceu()).isTrue();
    }

    @Test
    @DisplayName("faltar um dia reinicia a sequencia sem apagar o recorde")
    void faltarUmDiaReinicia() {
        usuario.setUltimoDiaPraticado(LocalDate.now().minusDays(2));
        usuario.setSequenciaAtual(9);
        usuario.setSequenciaRecorde(9);

        progressoService.registrar(usuario, desafio, StatusSubmissao.ERRO_TESTE, 0);

        assertThat(usuario.getSequenciaAtual()).isEqualTo(1);
        // O recorde e memoria do que a pessoa ja conseguiu: falhar um dia nao apaga isso.
        assertThat(usuario.getSequenciaRecorde()).isEqualTo(9);
    }

    @Test
    @DisplayName("segunda submissao no mesmo dia nao conta a sequencia duas vezes")
    void mesmoDiaNaoContaDuasVezes() {
        usuario.setUltimoDiaPraticado(LocalDate.now());
        usuario.setSequenciaAtual(3);

        var ganho = progressoService.registrar(usuario, desafio, StatusSubmissao.ERRO_TESTE, 0);

        assertThat(usuario.getSequenciaAtual()).isEqualTo(3);
        assertThat(ganho.sequenciaCresceu()).isFalse();
    }

    @Test
    @DisplayName("questao de pleno vale mais que a de estagio")
    void nivelPesaNaPontuacao() {
        when(conquistaRepository.existsByUsuarioIdAndDesafioId(anyLong(), anyLong())).thenReturn(false);

        desafio.setNivel(NivelVaga.ESTAGIO);
        int estagio = progressoService.registrar(usuario, desafio, StatusSubmissao.APROVADO, 100).pontosGanhos();

        Usuario outro = new Usuario();
        outro.setId(2L);
        outro.setPontos(0);
        outro.setSequenciaAtual(0);
        outro.setSequenciaRecorde(0);
        desafio.setNivel(NivelVaga.PLENO);
        int pleno = progressoService.registrar(outro, desafio, StatusSubmissao.APROVADO, 100).pontosGanhos();

        assertThat(estagio).isEqualTo(10);
        assertThat(pleno).isEqualTo(50);
    }
}
