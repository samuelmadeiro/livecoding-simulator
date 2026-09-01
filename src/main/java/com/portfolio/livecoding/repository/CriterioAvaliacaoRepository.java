package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.CriterioAvaliacao;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CriterioAvaliacaoRepository extends JpaRepository<CriterioAvaliacao, Long> {

    List<CriterioAvaliacao> findByDesafioIdOrderById(Long desafioId);
}
