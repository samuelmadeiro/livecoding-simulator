package com.portfolio.livecoding.repository.especificacao;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.entity.Conquista;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.Dificuldade;
import com.portfolio.livecoding.enums.OrdemDesafios;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Order;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Subquery;
import java.util.ArrayList;
import java.util.List;
import org.springframework.data.jpa.domain.Specification;

/**
 * Monta a consulta do catalogo: filtros opcionais, ordenacao escolhida e a busca da tecnologia no
 * mesmo SELECT.
 *
 * <p>Substitui a JPQL fixa que existia antes. Com paginacao e ordenacao variavel, a alternativa
 * seria uma consulta declarada por combinacao — o ORDER BY nao aceita parametro em JPQL.
 */
public final class DesafioEspecificacao {

    private DesafioEspecificacao() {
    }

    public static Specification<Desafio> de(DesafioFiltroDTO filtro, OrdemDesafios ordem) {
        return (raiz, consulta, construtor) -> {
            /*
             * A mesma Specification e usada duas vezes: uma para os itens da pagina e outra para o
             * COUNT do total. Fetch e ORDER BY so fazem sentido na primeira — no count, o fetch
             * quebra a consulta e ordenar seria trabalho jogado fora.
             */
            if (!Long.class.equals(consulta.getResultType())) {
                raiz.fetch("tecnologia", JoinType.INNER);
                consulta.orderBy(ordenacao(raiz, construtor, ordem));
            }

            List<Predicate> condicoes = new ArrayList<>();
            if (filtro.nivel() != null) {
                condicoes.add(construtor.equal(raiz.get("nivel"), filtro.nivel()));
            }
            if (filtro.tipo() != null) {
                condicoes.add(construtor.equal(raiz.get("tipo"), filtro.tipo()));
            }
            if (filtro.dificuldade() != null) {
                condicoes.add(construtor.equal(raiz.get("dificuldade"), filtro.dificuldade()));
            }
            if (filtro.tecnologiaId() != null) {
                // Sem join: a chave estrangeira ja esta na propria linha do desafio.
                condicoes.add(construtor.equal(raiz.get("tecnologia").get("id"), filtro.tecnologiaId()));
            }
            if (filtro.naoResolvidasPor() != null) {
                condicoes.add(construtor.not(jaConquistada(raiz, consulta, construtor, filtro.naoResolvidasPor())));
            }
            return construtor.and(condicoes.toArray(Predicate[]::new));
        };
    }

    /**
     * "Existe conquista deste candidato para este desafio?" como subconsulta.
     *
     * <p>Fica no mesmo lugar dos demais filtros, e nao numa etapa posterior em memoria, porque o
     * catalogo e paginado: filtrar depois de paginar entregaria seis itens numa pagina de nove e um
     * total que nao bate com a lista.
     *
     * <p>Entra tambem na passagem de COUNT — o bloco acima so pula fetch e ordenacao, nao os
     * predicados —, entao o total e a lista contam a mesma coisa.
     */
    private static Predicate jaConquistada(Root<Desafio> raiz,
                                           CriteriaQuery<?> consulta,
                                           CriteriaBuilder construtor,
                                           Long usuarioId) {

        Subquery<Long> subconsulta = consulta.subquery(Long.class);
        Root<Conquista> conquista = subconsulta.from(Conquista.class);

        subconsulta.select(construtor.literal(1L))
                .where(construtor.and(
                        construtor.equal(conquista.get("desafio"), raiz),
                        construtor.equal(conquista.get("usuario").get("id"), usuarioId)));

        return construtor.exists(subconsulta);
    }

    /**
     * O id entra como segundo criterio em toda ordenacao. Sem esse desempate, duas questoes com o
     * mesmo titulo — ou o mesmo tempo — podem trocar de lugar entre uma pagina e outra, e a mesma
     * questao apareceria duas vezes ou nenhuma.
     */
    private static List<Order> ordenacao(Root<Desafio> raiz, CriteriaBuilder construtor, OrdemDesafios ordem) {
        Order porId = construtor.asc(raiz.get("id"));
        return switch (ordem) {
            case PADRAO -> List.of(porId);
            case TITULO -> List.of(construtor.asc(raiz.get("titulo")), porId);
            case TEMPO_CRESCENTE -> List.of(construtor.asc(raiz.get("tempoLimiteMinutos")), porId);
            case TEMPO_DECRESCENTE -> List.of(construtor.desc(raiz.get("tempoLimiteMinutos")), porId);
            case DIFICULDADE_CRESCENTE -> List.of(construtor.asc(peso(raiz, construtor)), porId);
            case DIFICULDADE_DECRESCENTE -> List.of(construtor.desc(peso(raiz, construtor)), porId);
        };
    }

    /**
     * Ordena pelo peso da constante, e nao pelo texto gravado: alfabeticamente o banco devolveria
     * DIFICIL, FACIL, MEDIO. O CASE nasce do proprio enum, entao uma dificuldade nova entra na
     * ordem certa sem ninguem lembrar de mexer aqui.
     */
    private static Expression<Integer> peso(Root<Desafio> raiz, CriteriaBuilder construtor) {
        CriteriaBuilder.Case<Integer> caso = construtor.selectCase();
        for (Dificuldade dificuldade : Dificuldade.values()) {
            caso = caso.when(construtor.equal(raiz.get("dificuldade"), dificuldade), dificuldade.getPeso());
        }
        return caso.otherwise(0);
    }
}
