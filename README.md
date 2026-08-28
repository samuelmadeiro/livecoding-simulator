# LiveCoding Simulator

API REST que simula entrevistas técnicas de live coding: o candidato busca desafios filtrados por
nível de vaga, tecnologia e tipo, recebe um template de código e envia sua solução, que passa por
uma correção automática simulada.

Projeto de portfólio focado em vagas de Estágio / Júnior back-end.

## Stack

- Java 21
- Spring Boot 3.3.4 (Web, Data JPA, Validation)
- H2 em memória (dev/test) e PostgreSQL (perfil `prod`)
- Lombok
- JUnit 5 + Mockito + MockMvc
- Maven Wrapper

## Como rodar

```bash
./mvnw spring-boot:run
```

A aplicação sobe em `http://localhost:8080`. O `DataLoader` popula o H2 com 1 usuário demo,
3 tecnologias (Java, Node, Python) e 2 desafios.

Console do H2: `http://localhost:8080/h2-console`
JDBC URL `jdbc:h2:mem:livecoding` · usuário `sa` · senha vazia.

Rodar os testes:

```bash
./mvnw test
```

Rodar contra PostgreSQL:

```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=prod
```

Configurável por variáveis de ambiente `DB_URL`, `DB_USER`, `DB_PASSWORD`.

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/desafios` | Lista desafios. Query params opcionais: `nivel`, `tecnologiaId`, `tipo` |
| GET | `/api/desafios/{id}` | Detalha um desafio, incluindo o template de código |
| POST | `/api/submissoes` | Recebe o código do candidato, corrige e persiste a submissão |

`POST /api/submissoes` aceita o header opcional `X-Usuario-Id` (default `1`, o usuário demo).
Enquanto o projeto não tem Spring Security, é assim que a submissão é associada ao candidato.

### Enums

- `NivelVaga`: `ESTAGIO`, `JUNIOR`, `PLENO`
- `TipoDesafio`: `API_REST`, `ALGORITMO_EASY`, `BANCO_DADOS`
- `StatusSubmissao`: `PENDENTE`, `APROVADO`, `ERRO_COMPILACAO`, `ERRO_TESTE`

## Exemplos

Listar todos os desafios:

```bash
curl http://localhost:8080/api/desafios
```

Filtrar por nível e tipo:

```bash
curl "http://localhost:8080/api/desafios?nivel=ESTAGIO&tipo=ALGORITMO_EASY"
```

Desafio inexistente (404 do `GlobalExceptionHandler`):

```bash
curl -i http://localhost:8080/api/desafios/999
```

Submissão aprovada:

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"@GetMapping public List<Produto> listar() { return repo.findAll(); }\"}"
```

Submissão com código curto demais (`ERRO_COMPILACAO`):

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"int x;\"}"
```

Submissão sem a palavra-chave esperada pelo tipo do desafio (`ERRO_TESTE`):

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"public class Solucao { public void nada() { } }\"}"
```

Body inválido (400 com o mapa de erros de validação):

```bash
curl -i -X POST http://localhost:8080/api/submissoes -H "Content-Type: application/json" -d "{\"desafioId\":1}"
```

## Arquitetura

```
com.portfolio.livecoding
├── config       DataLoader (seed do H2, ativo fora do perfil prod)
├── controller   DesafioController, SubmissaoController
├── dto          records de request/response e filtro
├── entity       Usuario, Tecnologia, Desafio, Submissao
├── enums        NivelVaga, TipoDesafio, StatusSubmissao
├── exception    RecursoNaoEncontradoException, GlobalExceptionHandler
├── repository   interfaces JpaRepository
└── service      DesafioService, SubmissaoService, ValidadorCodigoService
```

Pontos de destaque:

- `DesafioRepository.buscarComFiltros` resolve os três filtros opcionais em uma única JPQL
  (`:param IS NULL OR ...`) com `JOIN FETCH` na tecnologia, evitando N+1.
- `ValidadorCodigoService` isola a correção. Hoje aplica heurísticas estáticas — tamanho mínimo,
  chaves e parênteses balanceados, código idêntico ao template, palavra-chave esperada por
  `TipoDesafio`. **Não executa o código enviado.** É o ponto de troca para um runner em sandbox
  (Docker / Judge0) no futuro.
- `spring.jpa.open-in-view=false`, mapeamento entidade→DTO na service, sem vazar entidade JPA na API.

## Próximos passos

- Spring Security + JWT, substituindo o header `X-Usuario-Id`
- Execução real do código em sandbox
- Histórico de submissões por usuário (`GET /api/submissoes`)
- Migrations com Flyway no lugar de `ddl-auto`
