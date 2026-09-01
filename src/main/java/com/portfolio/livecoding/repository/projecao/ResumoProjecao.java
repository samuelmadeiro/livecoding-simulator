package com.portfolio.livecoding.repository.projecao;

/** Totais gerais da plataforma. Com o banco vazio, as somas e medias voltam nulas. */
public interface ResumoProjecao {

    long getSubmissoes();

    Long getAprovadas();

    Double getPontuacaoMedia();

    Double getPrecisaoMedia();

    Double getDuracaoMedia();

    Long getDuracaoTotal();
}
