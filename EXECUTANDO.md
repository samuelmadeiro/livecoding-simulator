# Executando o LiveCoding Simulator no Windows

Passo a passo para clonar, subir e testar a API. Para a documentação dos endpoints, veja o
[README](README.md).

## 1. Pré-requisitos

**JDK 21.** O `pom.xml` fixa `<java.version>21</java.version>` sob Spring Boot 3.3.4, que não
suporta Java 25 — o build quebra no Lombok com `Fatal error compiling:
java.lang.ExceptionInInitializerError: com.sun.tools.javac.code.TypeTag :: UNKNOWN`.

Confira a versão ativa:

```powershell
java -version
```

Se não for 21, aponte o `JAVA_HOME` para um JDK 21 antes de rodar o Maven (vale só para a sessão
atual do PowerShell; para tornar permanente, use Variáveis de Ambiente do Windows):

```powershell
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.10"
```

**Maven não precisa estar instalado.** O repositório traz o wrapper `mvnw.cmd`, que baixa o Maven na
primeira execução (versão definida em `.mvn/wrapper/maven-wrapper.properties`).

**Porta 8080 livre** — é a porta configurada em `application.properties`.

## 2. Subir a aplicação

Na raiz do repositório:

```powershell
.\mvnw.cmd spring-boot:run
```

O log de sucesso é `Started LivecodingSimulatorApplication in X seconds`. A API fica em
`http://localhost:8080`.

Não há banco para instalar: o perfil padrão usa H2 em memória. Os dados são recriados a cada boot e
somem quando a aplicação para (`Ctrl+C`). Para um banco que sobrevive ao restart, veja a seção 8.

## 3. Dados de exemplo

O catálogo vem das migrations do Flyway (`src/main/resources/db/migration`), que rodam em todos os
perfis — inclusive no H2, que sobe em `MODE=PostgreSQL` justamente para aceitar o mesmo SQL do
banco de produção. Schema e conteúdo têm uma fonte de verdade só:

- tecnologias Java, Node, Python e SQL
- 14 desafios cobrindo os três níveis, os três tipos e as quatro tecnologias
- os critérios de correção de cada desafio, na tabela `criterios_avaliacao`

O `DataLoader` (ativo fora do perfil `prod`) só cria o usuário demo
`demo@livecoding.dev` / `demo12345` (role `CANDIDATO`) — a senha precisa passar pelo
`PasswordEncoder`, e produção não pode ganhar conta de teste.

Os ids não são estáveis entre bancos: consulte por título, não por `id 1`.

### Como a correção decide aprovado ou reprovado

Cada desafio tem vários critérios gravados no banco, e não uma palavra-chave fixa por tipo. Cada
critério é uma regex com um papel:

| Tipo | Efeito |
|---|---|
| `OBRIGATORIO` | Se falhar, reprova sozinho, por melhor que seja o resto |
| `PONTUAVEL` | Soma o `peso` para a nota de 0 a 100 |
| `PROIBIDO` | Se casar, reprova (ex.: `TODO` deixado no código) |

Aprova com **70** ou mais nos pontuáveis e nenhum obrigatório falhando. Comentários são removidos
antes da análise, então `// return` não conta mais como implementação. A nota fica gravada em
`submissoes.pontuacao` e a resposta da API detalha item a item o que passou e o que faltou.

Para ajustar a régua de um desafio, edite a tabela — não o código:

```sql
SELECT c.id, c.tipo, c.peso, c.descricao
FROM criterios_avaliacao c JOIN desafios d ON d.id = c.desafio_id
WHERE d.titulo = 'CRUD de Produtos';
```

## 4. Testando pelo PowerShell

Os exemplos `curl` do README são para bash. No PowerShell, `curl` é apelido de `Invoke-WebRequest` e
não aceita `-H` / `-d` — use `Invoke-RestMethod`.

Listar os desafios (rota pública):

```powershell
Invoke-RestMethod http://localhost:8080/api/desafios
```

Filtrar:

```powershell
Invoke-RestMethod "http://localhost:8080/api/desafios?nivel=ESTAGIO&tipo=ALGORITMO_EASY"
```

Login com o usuário demo, guardando o token:

```powershell
$login = Invoke-RestMethod -Method Post http://localhost:8080/api/auth/login -ContentType 'application/json' -Body '{"email":"demo@livecoding.dev","senha":"demo12345"}'
$token = $login.token
```

A resposta traz `token`, `tipo`, `expiraEmMs`, `nome`, `email` e `role`.

Enviar uma submissão (rota autenticada):

```powershell
Invoke-RestMethod -Method Post http://localhost:8080/api/submissoes -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json' -Body '{"desafioId":1,"codigoEnviado":"@GetMapping public List<Produto> listar() { return repo.findAll(); }"}'
```

Resposta esperada:

```json
{"submissaoId":1,"status":"APROVADO","mensagemFeedback":"Todos os testes simulados passaram. Bom trabalho!"}
```

Se isso funcionou, o ambiente está completo: banco, seed, JWT e correção automática.

## 5. Subir o front-end

A interface fica em `frontend/` (React + TypeScript + Tailwind). Com o back-end no ar, em outro
terminal:

```powershell
cd frontend
npm install
npm run dev
```

Abre em `http://localhost:5173` — origem ja liberada no CORS do back-end
(`app.cors.allowed-origins`). Entre com o usuario demo e percorra o fluxo: filtrar o catalogo,
abrir um desafio, escrever a solucao e enviar para correcao.

Para apontar o front para outro back-end, defina `VITE_API_URL` antes do `npm run dev`.

## 6. Console do H2

`http://localhost:8080/h2-console` — JDBC URL `jdbc:h2:mem:livecoding`, usuário `sa`, senha vazia.
A rota é liberada no `SecurityConfig`, com `frameOptions sameOrigin` para o console renderizar.

## 7. Testes automatizados

```powershell
.\mvnw.cmd test
```

## 8. Perfil `pg` (PostgreSQL local, com dados de exemplo)

Perfil de desenvolvimento que troca o H2 pelo PostgreSQL da máquina, mantendo o `DataLoader`
ativo. As tabelas passam a existir em disco: sobrevivem ao restart e podem ser consultadas por
`psql` com `\dt`, `SELECT` e `WHERE`.

Pré-requisito: o banco `livecoding` precisa existir (o Flyway cria as tabelas, não o banco).

```powershell
& "C:\Program Files\PostgreSQL8in\createdb.exe" -U postgres -h 127.0.0.1 -p 8090 livecoding
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=pg"
```

Conexão padrão: `jdbc:postgresql://localhost:8090/livecoding`, usuário `postgres`, senha
`postgres` — sobrescreva por `DB_URL`, `DB_USER` e `DB_PASSWORD`. A porta 8090 é a da instalação
local; num PostgreSQL padrão troque para 5432 via `DB_URL`.

Consultando depois de subir:

```powershell
& "C:\Program Files\PostgreSQL8in\psql.exe" -U postgres -h 127.0.0.1 -p 8090 -d livecoding
```

```sql
\dt
SELECT id, nome, email, role FROM usuarios;
SELECT titulo, nivel FROM desafios WHERE nivel = 'JUNIOR';
```

## 9. Perfil `prod` (PostgreSQL)

Exige um PostgreSQL rodando e a variável `JWT_SECRET` — `application-prod.properties` não tem
default e a aplicação não sobe sem ela. O schema é criado pelo Flyway no boot
(`src/main/resources/db/migration`); o `ddl-auto` é `validate` e apenas confere se o resultado bate
com as entidades. Basta o banco existir e estar vazio.

```powershell
$env:JWT_SECRET = "<chave base64 de 256 bits>"
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=prod"
```

As aspas em volta do `-D...` são necessárias no PowerShell. Banco configurável por `DB_URL`,
`DB_USER` e `DB_PASSWORD`.

## 10. Problemas comuns

| Sintoma | Causa / solução |
|---|---|
| `ExceptionInInitializerError: com.sun.tools.javac.code.TypeTag :: UNKNOWN` no compile | JDK maior que 21. Ajuste o `JAVA_HOME` (passo 1). |
| `.\mvnw.cmd` não reconhecido | Rode da raiz do repositório e mantenha o `.\` na frente. |
| `Port 8080 was already in use` | `netstat -ano \| findstr :8080` e encerre o processo, ou suba em outra porta: `.\mvnw.cmd spring-boot:run "-Dspring-boot.run.arguments=--server.port=8081"` |
| 401 em `POST /api/submissoes` | Token ausente, malformado ou expirado (validade padrão: 1 hora). Refaça o login. |
| `Could not resolve placeholder 'JWT_SECRET'` | Perfil `prod` sem a variável de ambiente definida. |
| Dados sumiram | Esperado: H2 é em memória e reinicia limpo a cada boot. |
