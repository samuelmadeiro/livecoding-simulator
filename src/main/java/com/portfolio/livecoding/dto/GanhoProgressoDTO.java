package com.portfolio.livecoding.dto;

/**
 * O que a submissao mexeu no progresso do candidato.
 *
 * <p>Vai junto da correcao para a tela poder comemorar na hora, sem uma segunda requisicao.
 * {@code primeiraVez} distingue a questao recem-conquistada da questao refeita: refazer nao paga
 * de novo, e a tela precisa dizer isso em vez de deixar a pessoa achar que perdeu pontos.
 */
public record GanhoProgressoDTO(
        int pontosGanhos,
        boolean primeiraVez,
        int sequenciaAtual,
        boolean sequenciaCresceu) {
}
