package com.portfolio.livecoding.db;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

/**
 * Garante que as migrations descrevem exatamente o que as entidades JPA esperam.
 * Roda no H2 em modo de compatibilidade PostgreSQL, com o Flyway aplicando db/migration e o
 * Hibernate em ddl-auto=validate: qualquer coluna faltando, sobrando ou com tipo incompativel
 * derruba o contexto e o teste falha. Sem isso, a divergencia so apareceria no deploy.
 *
 * <p>Como o Flyway roda o diretorio inteiro, migrations novas passam a ser cobertas sozinhas.
 */
@SpringBootTest
@TestPropertySource(properties = {
        "spring.datasource.url=jdbc:h2:mem:migracao;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;"
                + "DEFAULT_NULL_ORDERING=HIGH;DB_CLOSE_DELAY=-1",
        "spring.jpa.hibernate.ddl-auto=validate",
        "spring.flyway.enabled=true",
        "spring.jpa.show-sql=false"
})
class MigracaoSchemaTest {

    @Test
    void schemaDaMigracaoBateComAsEntidades() {
        // O proprio boot do contexto e a asercao.
    }
}
