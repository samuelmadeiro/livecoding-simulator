package com.portfolio.livecoding.repository.projecao;

import com.portfolio.livecoding.enums.TipoCriterio;

/** Quantas vezes um criterio de um desafio foi cobrado e quantas vezes foi atendido. */
public interface MetricaCriterioProjecao {

    Long getDesafioId();

    String getDescricao();

    TipoCriterio getTipo();

    Integer getPeso();

    long getAvaliacoes();

    long getAtendidas();
}
