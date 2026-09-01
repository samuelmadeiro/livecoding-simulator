package com.portfolio.livecoding.repository.projecao;

import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;

/** Uma linha do painel do admin por desafio. Desafio sem submissao volta com contagem zero. */
public interface MetricaDesafioProjecao {

    Long getDesafioId();

    String getTitulo();

    NivelVaga getNivel();

    TipoDesafio getTipo();

    String getTecnologiaNome();

    Integer getTempoLimiteMinutos();

    long getSubmissoes();

    long getCandidatos();

    Long getAprovadas();

    Double getPontuacaoMedia();

    Double getPrecisaoMedia();

    Double getDuracaoMedia();
}
