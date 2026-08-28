package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
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
}
