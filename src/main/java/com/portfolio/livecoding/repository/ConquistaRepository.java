package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Conquista;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ConquistaRepository extends JpaRepository<Conquista, Long> {

    boolean existsByUsuarioIdAndDesafioId(Long usuarioId, Long desafioId);

    long countByUsuarioId(Long usuarioId);

    /** As ultimas conquistas do candidato, para o painel mostrar o que ele resolveu por ultimo. */
    @Query("""
            SELECT c FROM Conquista c
            JOIN FETCH c.desafio d
            JOIN FETCH d.tecnologia
            WHERE c.usuario.id = :usuarioId
            ORDER BY c.conquistadoEm DESC
            """)
    List<Conquista> ultimasDoUsuario(@Param("usuarioId") Long usuarioId);
}
