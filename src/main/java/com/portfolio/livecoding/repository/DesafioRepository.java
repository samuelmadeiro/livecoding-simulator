package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.projecao.MetricaDesafioProjecao;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * A busca do catalogo nao mora aqui: filtros opcionais, ordenacao escolhida pelo cliente e
 * paginacao viram uma Specification (ver DesafioEspecificacao), que o JpaSpecificationExecutor
 * executa.
 */
public interface DesafioRepository extends JpaRepository<Desafio, Long>, JpaSpecificationExecutor<Desafio> {

    /**
     * Uma linha por desafio para o painel do admin. LEFT JOIN mantem no relatorio o desafio que
     * ninguem tentou ainda — que e justamente a informacao util para quem cuida do catalogo.
     */
    @Query("""
            SELECT d.id AS desafioId,
                   d.titulo AS titulo,
                   d.nivel AS nivel,
                   d.tipo AS tipo,
                   t.nome AS tecnologiaNome,
                   d.tempoLimiteMinutos AS tempoLimiteMinutos,
                   COUNT(s.id) AS submissoes,
                   COUNT(DISTINCT s.usuario.id) AS candidatos,
                   SUM(CASE WHEN s.status = :aprovado THEN 1L ELSE 0L END) AS aprovadas,
                   AVG(s.pontuacao) AS pontuacaoMedia,
                   AVG(s.precisao) AS precisaoMedia,
                   AVG(s.duracaoSegundos) AS duracaoMedia
            FROM Desafio d
            JOIN d.tecnologia t
            LEFT JOIN Submissao s ON s.desafio = d
            GROUP BY d.id, d.titulo, d.nivel, d.tipo, t.nome, d.tempoLimiteMinutos
            ORDER BY COUNT(s.id) DESC, d.id ASC
            """)
    List<MetricaDesafioProjecao> metricasPorDesafio(@Param("aprovado") StatusSubmissao aprovado);
}
