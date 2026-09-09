package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Conquista;
import com.portfolio.livecoding.enums.NivelVaga;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ConquistaRepository extends JpaRepository<Conquista, Long> {

    boolean existsByUsuarioIdAndDesafioId(Long usuarioId, Long desafioId);

    /**
     * Ids das questoes que o candidato ja conquistou, entre as informadas.
     *
     * <p>Recebe os ids da pagina em vez de devolver o historico inteiro: marcar nove cards nao
     * precisa carregar as 255 conquistas de quem ja resolveu tudo.
     */
    @Query("""
            SELECT c.desafio.id FROM Conquista c
            WHERE c.usuario.id = :usuarioId AND c.desafio.id IN :desafioIds
            """)
    List<Long> idsConquistadosEntre(@Param("usuarioId") Long usuarioId,
                                    @Param("desafioIds") List<Long> desafioIds);

    long countByUsuarioId(Long usuarioId);

    /**
     * Niveis que o candidato mais praticou, do mais frequente para o menos.
     *
     * <p>Serve para a sugestao do painel apontar uma questao do nivel em que a pessoa esta, e nao
     * uma de estagio para quem ja resolve pleno. Devolve lista, e nao um valor: quem esta comecando
     * nao tem conquista nenhuma, e ai a decisao e de quem chamou.
     */
    @Query("""
            SELECT c.desafio.nivel FROM Conquista c
            WHERE c.usuario.id = :usuarioId
            GROUP BY c.desafio.nivel
            ORDER BY COUNT(c) DESC
            """)
    List<NivelVaga> niveisMaisPraticados(@Param("usuarioId") Long usuarioId);

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
