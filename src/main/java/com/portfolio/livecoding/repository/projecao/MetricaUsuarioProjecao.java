package com.portfolio.livecoding.repository.projecao;

import com.portfolio.livecoding.enums.Role;
import java.time.LocalDateTime;

/**
 * Uma linha do painel do admin por candidato. As medias voltam como Double e podem ser nulas:
 * usuario sem submissao nenhuma nao tem media de nada.
 */
public interface MetricaUsuarioProjecao {

    Long getUsuarioId();

    String getNome();

    String getEmail();

    Role getRole();

    long getSubmissoes();

    Long getAprovadas();

    Double getPontuacaoMedia();

    Double getPrecisaoMedia();

    Double getDuracaoMedia();

    Long getDuracaoTotal();

    LocalDateTime getUltimaSubmissao();
}
