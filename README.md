# LiveCoding Simulator

API REST que simula entrevistas técnicas de live coding: o candidato busca desafios filtrados por
nível de vaga, tecnologia e tipo, recebe um template de código e envia sua solução, que passa por
uma correção automática simulada.

Projeto de portfólio focado em vagas de Estágio / Júnior back-end.

## Stack

- Java 21
- Spring Boot 3.3.4 (Web, Data JPA, Validation, Security)
- JWT via jjwt 0.12.6, senhas em BCrypt
- H2 em memória (dev/test) e PostgreSQL, ambos com o mesmo schema e seed via Flyway
- Lombok
- JUnit 5 + Mockito + MockMvc
- Maven Wrapper
- Front-end em React 19 + TypeScript + Tailwind v4 (pasta `frontend/`)

## Como rodar

Passo a passo completo para Windows (pré-requisitos, PowerShell, troubleshooting):
[EXECUTANDO.md](EXECUTANDO.md).

```bash
./mvnw spring-boot:run
```

A aplicação sobe em `http://localhost:8080`. As migrations do Flyway criam o schema e o catálogo
— 4 tecnologias, 14 desafios e os critérios de correção de cada um — e o `DataLoader` cria o
usuário demo.

Para um PostgreSQL de verdade, com as tabelas gravadas em disco:
`./mvnw spring-boot:run -Dspring-boot.run.profiles=pg` (detalhes em [EXECUTANDO.md](EXECUTANDO.md)).

Credenciais do usuário demo: `demo@livecoding.dev` / `demo12345`.
Credenciais do admin em desenvolvimento: `admin@livecoding.dev` / `admin12345` (configuráveis por
`ADMIN_EMAIL` e `ADMIN_SENHA`; o perfil `prod` não cria admin sem essas variáveis).

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

## Front-end

A pasta [`frontend/`](frontend/) tem a interface que consome esta API: catalogo filtravel, editor
de codigo com cronometro, correcao na tela com o retorno do entrevistador e, para quem entra com
uma conta `ADMIN`, a pagina `/admin` com o painel de metricas. Com o back-end no ar:

```bash
cd frontend && npm install && npm run dev
```

Sobe em `http://localhost:5173`, origem liberada por `app.cors.allowed-origins`. As decisoes de
design e as limitacoes conhecidas estao no [README do front](frontend/README.md).

## Endpoints

| Método | Rota | Auth | Descrição |
|---|---|---|---|
| POST | `/api/auth/register` | público | Cadastra o candidato e já devolve o token |
| POST | `/api/auth/login` | público | Autentica e devolve o token |
| GET | `/api/desafios` | público | Lista desafios. Query params opcionais: `nivel`, `tecnologiaId`, `tipo` |
| GET | `/api/desafios/{id}` | público | Detalha um desafio, incluindo o template de código |
| POST | `/api/desafios/{id}/iniciar` | **JWT** | Abre (ou recupera) o cronômetro da questão |
| POST | `/api/submissoes` | **JWT** | Recebe o código do candidato, corrige e persiste a submissão |
| GET | `/api/admin/metricas` | **JWT + ADMIN** | Painel: tempo e % de acerto por candidato, precisão por exercício |

### Autenticação

API stateless com JWT. O token vai no header `Authorization: Bearer <token>` e carrega o email
no `subject` e a role como claim. Roles: `CANDIDATO` (padrão no cadastro) e `ADMIN`, que abre o
painel em `/api/admin/**` e a página `/admin` do front.

A conta de admin é criada no boot pelo `AdminBootstrap`, a partir de `app.admin.email` e
`app.admin.senha`. Em desenvolvimento os defaults são `admin@livecoding.dev` / `admin12345`. O
perfil `prod` **não** tem default: sem `ADMIN_EMAIL` e `ADMIN_SENHA` no ambiente, nenhum admin
nasce — e um e-mail que já exista como candidato é promovido a `ADMIN` sem ter a senha reescrita.

A submissão é sempre atribuída ao dono do token — o cliente não escolhe o usuário.

O segredo de assinatura vem de `app.jwt.secret`. O valor no `application.properties` é **apenas
para desenvolvimento**: em produção defina a variável de ambiente `JWT_SECRET` (base64, 256 bits).
O perfil `prod` não tem default — a aplicação não sobe sem ela. Expiração padrão: 1 hora
(`JWT_EXPIRACAO_MS`).

### Enums

- `NivelVaga`: `ESTAGIO`, `JUNIOR`, `PLENO`, `SENIOR`
- `TipoDesafio`: `API_REST`, `ALGORITMO_EASY`, `BANCO_DADOS`
- `StatusSubmissao`: `PENDENTE`, `APROVADO`, `ERRO_COMPILACAO`, `ERRO_TESTE`
- `TipoCriterio`: `OBRIGATORIO`, `PONTUAVEL`, `PROIBIDO`

### Correção: nota, precisão e tempo

Cada submissão volta com dois números diferentes e um tempo:

- **nota** (0 a 100): quanto a solução entregou dos critérios `PONTUAVEL`, cada um com seu peso;
- **precisão** (0 a 100): quanto ela cobriu da régua inteira do desafio — obrigatórios (contando
  dobrado), pontuáveis e proibidos. É a "% de precisão" que o painel agrega por exercício;
- **duração**: medida pelo servidor, entre `POST /api/desafios/{id}/iniciar` e a submissão.

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

Submissão que não atende os critérios do desafio (`ERRO_TESTE`, com a lista do que faltou):

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"public class Solucao { public void nada() { } }\"}"
```

Body inválido (400 com o mapa de erros de validação):

```bash
curl -i -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1}"
```

Abrir o cronômetro da questão e enviar fechando a tentativa:

```bash
TENTATIVA=$(curl -s -X POST http://localhost:8080/api/desafios/1/iniciar -H "Authorization: Bearer $TOKEN" | jq -r .tentativaId)
```

```bash
curl -X POST http://localhost:8080/api/submissoes -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"desafioId\":1,\"codigoEnviado\":\"public class Solucao { public int contarVogais(String t) { int total = 0; for (char c : t.toLowerCase().toCharArray()) { if (\\\"aeiou\\\".indexOf(c) >= 0) { total++; } } return total; } }\",\"tentativaId\":$TENTATIVA}"
```

Painel do admin (403 com token de candidato):

```bash
ADMIN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"admin@livecoding.dev\",\"senha\":\"admin12345\"}" | jq -r .token)
```

```bash
curl -s http://localhost:8080/api/admin/metricas -H "Authorization: Bearer $ADMIN" | jq .resumo
```

## Arquitetura

```
com.portfolio.livecoding
├── config       DataLoader (usuario demo, fora do perfil prod), AdminBootstrap (conta de admin)
├── controller   AuthController, DesafioController, SubmissaoController, AdminController
├── dto          records de request/response, filtro e os DTOs do painel em dto/admin
├── entity       Usuario, Tecnologia, Desafio, Submissao, CriterioAvaliacao,
│                Tentativa (cronometro), ResultadoCriterio (correcao item a item)
├── enums        NivelVaga, TipoDesafio, StatusSubmissao, Role, TipoCriterio
├── exception    RecursoNaoEncontradoException, EmailJaCadastradoException, GlobalExceptionHandler
├── repository   interfaces JpaRepository + projecao/ (linhas agregadas do painel)
├── security     SecurityConfig, JwtService, JwtAuthenticationFilter,
│                UsuarioDetailsService, RestAuthenticationEntryPoint
└── service      AuthService, DesafioService, SubmissaoService, ValidadorCodigoService,
                 TentativaService, FeedbackEntrevistadorService, AdminMetricasService
```

Pontos de destaque:

- `DesafioRepository.buscarComFiltros` resolve os três filtros opcionais em uma única JPQL
  (`:param IS NULL OR ...`) com `JOIN FETCH` na tecnologia, evitando N+1.
- `ValidadorCodigoService` isola a correção. Aplica as checagens estruturais (tamanho mínimo,
  chaves e parênteses balanceados, código igual — ou quase igual — ao template, ausência de corpo
  de método/função/consulta) e depois avalia os critérios que o desafio tem cadastrados na tabela
  `criterios_avaliacao`: `OBRIGATORIO` reprova sozinho, `PONTUAVEL` soma peso para a nota de 0 a
  100, `PROIBIDO` reprova se casar. Comentários são removidos antes da análise, então uma
  palavra-chave escondida em comentário não conta como implementação. A régua de cada desafio se
  ajusta por SQL, sem recompilar. **Não executa o código enviado.** É o ponto de troca para um
  runner em sandbox (Docker / Judge0) no futuro.
- **Nenhum sinal isolado aprova uma questão.** Aprovar exige, ao mesmo tempo: nenhum `PROIBIDO`
  casado, todos os `OBRIGATORIO` atendidos, nota ≥ 70 e precisão ≥ 75%. Um desafio com menos de
  três critérios nunca aprova sozinho, e desafio sem critério nenhum deixou de aprovar por
  palavra-chave do tipo (o antigo "achou `mapping`, passou"): a submissão fica `PENDENTE`, para
  revisão manual. Um `@GetMapping` solto, sem corpo de método, nem chega à fase de critérios.
- `FeedbackEntrevistadorService` devolve a correção como a fala de um entrevistador: o que agradou,
  o que ajustar (com a `dica` cadastrada para cada critério, que aponta o caminho sem entregar a
  solução), um comentário sobre o tempo e a explicação de como a nota e a precisão foram formadas.
  Sem chamada a modelo de linguagem: o texto é montado por regra a partir do resultado da correção.
- `TentativaService` mede o tempo no relógio do servidor, entre `POST /api/desafios/{id}/iniciar` e
  a submissão. O corpo da submissão informa qual tentativa está sendo fechada, nunca quantos
  segundos levou — dado de avaliação vindo do cliente é dado que o cliente escolhe.
- `AdminMetricasService` monta o painel em quatro consultas agregadas (`GROUP BY` no banco, com
  `LEFT JOIN` para candidato sem envio e desafio sem tentativa aparecerem com zero). A taxa de
  acerto por critério sai de `resultados_criterio`, gravada junto com cada submissão: é ela que diz
  em qual ponto de cada exercício as pessoas travam, coisa que a nota final não conta.
- `spring.jpa.open-in-view=false`, mapeamento entidade→DTO na service, sem vazar entidade JPA na API.
- Schema e catálogo versionados no Flyway (`db/migration`), aplicados em todos os perfis: o H2
  sobe em `MODE=PostgreSQL` para aceitar o mesmo SQL do banco de produção, e o Hibernate roda em
  `ddl-auto=validate` em qualquer perfil. `MigracaoSchemaTest` aplica o diretório inteiro no H2,
  então uma divergência entre o SQL e as entidades quebra o build, não o deploy.
- `GlobalExceptionHandler` cobre também o que não foi previsto: um handler de `Exception` registra
  a causa no log e devolve 500 com mensagem genérica, sem expor SQL nem stack ao cliente. As
  exceções próprias do Spring MVC (rota inexistente, verbo errado, enum inválido em query param)
  implementam `ErrorResponse` e mantêm o status original em vez de virarem 500. No perfil `prod`,
  `server.error.include-message=never` fecha a última porta de vazamento.
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
- CRUD de desafios restrito a `ADMIN`, editando critérios e dicas pela própria página do painel
