# LiveCoding Simulator

API REST que simula entrevistas técnicas de live coding: o candidato busca desafios filtrados por
nível de vaga, tecnologia e tipo, recebe um template de código e envia sua solução, que passa por
uma correção automática simulada.

Projeto de portfólio focado em vagas de Estágio / Júnior back-end.

## Stack

- Java 21
- Spring Boot 3.3.4 (Web, Data JPA, Validation, Security)
- JWT via jjwt 0.12.6, senhas em BCrypt
- H2 em memória (dev/test) e PostgreSQL (perfil `prod`)
- Lombok
- JUnit 5 + Mockito + MockMvc
- Maven Wrapper

## Como rodar

Passo a passo completo para Windows (pré-requisitos, PowerShell, troubleshooting):
[EXECUTANDO.md](EXECUTANDO.md).

```bash
./mvnw spring-boot:run
```

A aplicação sobe em `http://localhost:8080`. O `DataLoader` popula o H2 com 1 usuário demo,
3 tecnologias (Java, Node, Python) e 2 desafios.

Credenciais do usuário demo: `demo@livecoding.dev` / `demo12345`.

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

| Método | Rota | Auth | Descrição |
|---|---|---|---|
| POST | `/api/auth/register` | público | Cadastra o candidato e já devolve o token |
| POST | `/api/auth/login` | público | Autentica e devolve o token |
| GET | `/api/desafios` | público | Lista desafios. Query params opcionais: `nivel`, `tecnologiaId`, `tipo` |
| GET | `/api/desafios/{id}` | público | Detalha um desafio, incluindo o template de código |
| POST | `/api/submissoes` | **JWT** | Recebe o código do candidato, corrige e persiste a submissão |

### Autenticação

API stateless com JWT. O token vai no header `Authorization: Bearer <token>` e carrega o email
no `subject` e a role como claim. Roles: `CANDIDATO` (padrão no cadastro) e `ADMIN` (reservado
para o futuro CRUD de desafios).

A submissão é sempre atribuída ao dono do token — o cliente não escolhe o usuário.

O segredo de assinatura vem de `app.jwt.secret`. O valor no `application.properties` é **apenas
para desenvolvimento**: em produção defina a variável de ambiente `JWT_SECRET` (base64, 256 bits).
O perfil `prod` não tem default — a aplicação não sobe sem ela. Expiração padrão: 1 hora
(`JWT_EXPIRACAO_MS`).

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

Cadastrar um candidato:

```bash
curl -X POST http://localhost:8080/api/auth/register -H "Content-Type: application/json" -d "{\"nome\":\"Candidato Novo\",\"email\":\"novo@livecoding.dev\",\"senha\":\"segredo123\"}"
```

Login com o usuário demo, guardando o token:

```bash
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"demo@livecoding.dev\",\"senha\":\"demo12345\"}" | jq -r .token)
```

Submissão sem token (401):

```bash
curl -i -X POST http://localhost:8080/api/submissoes -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"@GetMapping public List<Produto> listar() { return repo.findAll(); }\"}"
```

Submissão aprovada, autenticada:

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"@GetMapping public List<Produto> listar() { return repo.findAll(); }\"}"
```

Submissão com código curto demais (`ERRO_COMPILACAO`):

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"int x;\"}"
```

Submissão sem a palavra-chave esperada pelo tipo do desafio (`ERRO_TESTE`):

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"public class Solucao { public void nada() { } }\"}"
```

Body inválido (400 com o mapa de erros de validação):

```bash
curl -i -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1}"
```

## Arquitetura

```
com.portfolio.livecoding
├── config       DataLoader (seed do H2, ativo fora do perfil prod)
├── controller   AuthController, DesafioController, SubmissaoController
├── dto          records de request/response e filtro
├── entity       Usuario, Tecnologia, Desafio, Submissao
├── enums        NivelVaga, TipoDesafio, StatusSubmissao, Role
├── exception    RecursoNaoEncontradoException, EmailJaCadastradoException, GlobalExceptionHandler
├── repository   interfaces JpaRepository
├── security     SecurityConfig, JwtService, JwtAuthenticationFilter,
│                UsuarioDetailsService, RestAuthenticationEntryPoint
└── service      AuthService, DesafioService, SubmissaoService, ValidadorCodigoService
```

Pontos de destaque:

- `DesafioRepository.buscarComFiltros` resolve os três filtros opcionais em uma única JPQL
  (`:param IS NULL OR ...`) com `JOIN FETCH` na tecnologia, evitando N+1.
- `ValidadorCodigoService` isola a correção. Hoje aplica heurísticas estáticas — tamanho mínimo,
  chaves e parênteses balanceados, código idêntico ao template, palavra-chave esperada por
  `TipoDesafio`. **Não executa o código enviado.** É o ponto de troca para um runner em sandbox
  (Docker / Judge0) no futuro.
- `spring.jpa.open-in-view=false`, mapeamento entidade→DTO na service, sem vazar entidade JPA na API.
- Segurança stateless: `SessionCreationPolicy.STATELESS`, CSRF desabilitado (não há sessão nem
  formulário), 401 devolvido em JSON pelo `RestAuthenticationEntryPoint` no lugar da página de
  login padrão. `Usuario` continua uma entidade JPA pura — a adaptação ao `UserDetails` fica no
  `UsuarioDetailsService`.
- O `JwtAuthenticationFilter` é declarado como `@Bean` no `SecurityConfig`, não como `@Component`:
  um `Filter` anotado com `@Component` também seria registrado na cadeia do servlet container e
  rodaria duas vezes por requisição.

## Próximos passos

- Refresh token e revogação
- Execução real do código em sandbox
- Histórico de submissões por usuário (`GET /api/submissoes`)
- Migrations com Flyway no lugar de `ddl-auto`
