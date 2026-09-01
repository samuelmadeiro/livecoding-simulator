package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.ResultadoCriterio;
import com.portfolio.livecoding.repository.projecao.MetricaCriterioProjecao;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ResultadoCriterioRepository extends JpaRepository<ResultadoCriterio, Long> {

    /**
     * Taxa de acerto de cada criterio, por desafio. Uma consulta agregada para o catalogo inteiro:
     * uma por desafio seria N+1 no painel.
     *
     * <p>O agrupamento e pela descricao, e nao pelo criterio_id, de proposito — criterio apagado
     * deixa criterio_id nulo e o historico ainda precisa aparecer no relatorio.
     */
    @Query("""
            SELECT s.desafio.id AS desafioId,
                   r.descricao AS descricao,
                   r.tipo AS tipo,
                   MAX(r.peso) AS peso,
                   COUNT(r.id) AS avaliacoes,
                   SUM(CASE WHEN r.atendido = TRUE THEN 1L ELSE 0L END) AS atendidas
            FROM ResultadoCriterio r
            JOIN r.submissao s
            GROUP BY s.desafio.id, r.descricao, r.tipo
            ORDER BY s.desafio.id, r.descricao
            """)
    List<MetricaCriterioProjecao> agregarPorDesafio();
}
