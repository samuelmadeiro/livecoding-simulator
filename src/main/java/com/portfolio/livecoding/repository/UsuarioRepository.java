package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.projecao.MetricaUsuarioProjecao;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByEmail(String email);

    long countByRole(Role role);

    /**
     * Uma linha por usuario para o painel do admin: quantas submissoes, quantas aprovadas, medias
     * de nota, precisao e tempo.
     *
     * <p>LEFT JOIN de proposito: quem se cadastrou e ainda nao enviou nada precisa aparecer no
     * painel com zero, e nao sumir dele. O status aprovado entra como parametro em vez de literal
     * de enum para o JPQL nao depender do nome qualificado da constante.
     */
    @Query("""
            SELECT u.id AS usuarioId,
                   u.nome AS nome,
                   u.email AS email,
                   u.role AS role,
                   COUNT(s.id) AS submissoes,
                   SUM(CASE WHEN s.status = :aprovado THEN 1L ELSE 0L END) AS aprovadas,
                   AVG(s.pontuacao) AS pontuacaoMedia,
                   AVG(s.precisao) AS precisaoMedia,
                   AVG(s.duracaoSegundos) AS duracaoMedia,
                   SUM(s.duracaoSegundos) AS duracaoTotal,
                   MAX(s.dataHora) AS ultimaSubmissao
            FROM Usuario u
            LEFT JOIN Submissao s ON s.usuario = u
            GROUP BY u.id, u.nome, u.email, u.role
            ORDER BY COUNT(s.id) DESC, u.nome ASC
            """)
    List<MetricaUsuarioProjecao> metricasPorUsuario(@Param("aprovado") StatusSubmissao aprovado);
}
