package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.repository.projecao.MetricaUsuarioProjecao;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
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

    boolean existsByApelido(String apelido);

    /**
     * Ranking publico: mais pontos primeiro, sequencia como desempate.
     *
     * <p>Quem nunca pontuou fica de fora. Uma tabela de classificacao cheia de zeros nao e prova
     * social, e ainda exporia o apelido de quem so criou conta e nunca praticou.
     */
    @Query("""
            SELECT u FROM Usuario u
            WHERE u.pontos > 0
            ORDER BY u.pontos DESC, u.sequenciaAtual DESC, u.apelido ASC
            """)
    List<Usuario> ranking(Pageable pagina);

    /**
     * Quantos candidatos estao a frente de uma pontuacao. Serve para dizer a posicao de alguem sem
     * carregar a tabela inteira.
     *
     * <p>O desempate por id mantem a posicao estavel entre dois candidatos com os mesmos pontos:
     * sem ele, a posicao mostrada oscilaria a cada leitura.
     */
    @Query("""
            SELECT COUNT(u) FROM Usuario u
            WHERE u.pontos > :pontos
               OR (u.pontos = :pontos AND u.id < :usuarioId)
            """)
    long quantosNaFrente(@Param("pontos") int pontos, @Param("usuarioId") Long usuarioId);
}
