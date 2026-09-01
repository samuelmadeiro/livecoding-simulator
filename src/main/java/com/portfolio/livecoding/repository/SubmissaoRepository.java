package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Submissao;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.projecao.ResumoProjecao;
import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SubmissaoRepository extends JpaRepository<Submissao, Long> {

    List<Submissao> findByUsuarioIdOrderByDataHoraDesc(Long usuarioId);

    List<Submissao> findByDesafioId(Long desafioId);

    /** Totais da plataforma inteira para os cartoes do topo do painel. */
    @Query("""
            SELECT COUNT(s.id) AS submissoes,
                   SUM(CASE WHEN s.status = :aprovado THEN 1L ELSE 0L END) AS aprovadas,
                   AVG(s.pontuacao) AS pontuacaoMedia,
                   AVG(s.precisao) AS precisaoMedia,
                   AVG(s.duracaoSegundos) AS duracaoMedia,
                   SUM(s.duracaoSegundos) AS duracaoTotal
            FROM Submissao s
            """)
    ResumoProjecao resumir(@Param("aprovado") StatusSubmissao aprovado);

    /**
     * Ultimas submissoes de todo mundo, para a lista do painel. O JOIN FETCH e obrigatorio aqui:
     * com open-in-view desligado, ler usuario e desafio fora da transacao estouraria lazy.
     */
    @Query("""
            SELECT s FROM Submissao s
            JOIN FETCH s.usuario
            JOIN FETCH s.desafio
            ORDER BY s.dataHora DESC
            """)
    List<Submissao> ultimas(Pageable pagina);
}
