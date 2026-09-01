package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.repository.projecao.MetricaDesafioProjecao;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface DesafioRepository extends JpaRepository<Desafio, Long> {

    /**
     * Busca com filtros opcionais: qualquer parametro null e ignorado.
     * O join fetch evita N+1 ao montar o DesafioResponseDTO.
     */
    @Query("""
            SELECT d FROM Desafio d
            JOIN FETCH d.tecnologia t
            WHERE (:nivel IS NULL OR d.nivel = :nivel)
              AND (:tecnologiaId IS NULL OR t.id = :tecnologiaId)
              AND (:tipo IS NULL OR d.tipo = :tipo)
            ORDER BY d.id
            """)
    List<Desafio> buscarComFiltros(@Param("nivel") NivelVaga nivel,
                                   @Param("tecnologiaId") Long tecnologiaId,
                                   @Param("tipo") TipoDesafio tipo);

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
