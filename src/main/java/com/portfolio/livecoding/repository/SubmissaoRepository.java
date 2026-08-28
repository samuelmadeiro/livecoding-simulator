package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Submissao;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SubmissaoRepository extends JpaRepository<Submissao, Long> {

    List<Submissao> findByUsuarioIdOrderByDataHoraDesc(Long usuarioId);

    List<Submissao> findByDesafioId(Long desafioId);
}
