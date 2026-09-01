-- Catalogo de desafios e criterios de correcao.
--
-- Tudo aqui e idempotente: o banco de desenvolvimento ja pode ter os dois desafios criados pelo
-- DataLoader antes desta migration existir. Nenhum INSERT informa id explicito, para nao
-- dessincronizar as sequences BIGSERIAL.
--
-- Sobre a coluna padrao: e uma regex avaliada com CASE_INSENSITIVE pelo ValidadorCodigoService.
-- OBRIGATORIO reprova sozinho, PONTUAVEL soma para a nota, PROIBIDO reprova se casar.

INSERT INTO tecnologias (nome)
SELECT 'Java' WHERE NOT EXISTS (SELECT 1 FROM tecnologias WHERE nome = 'Java');

INSERT INTO tecnologias (nome)
SELECT 'Node' WHERE NOT EXISTS (SELECT 1 FROM tecnologias WHERE nome = 'Node');

INSERT INTO tecnologias (nome)
SELECT 'Python' WHERE NOT EXISTS (SELECT 1 FROM tecnologias WHERE nome = 'Python');

INSERT INTO tecnologias (nome)
SELECT 'SQL' WHERE NOT EXISTS (SELECT 1 FROM tecnologias WHERE nome = 'SQL');


-- ---------------------------------------------------------------------------
-- 1. Contar Vogais (Java, estagio, algoritmo)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Contar Vogais',
       'Receba um texto e devolva quantas vogais ele contem. Maiusculas e minusculas contam igual.',
       'ESTAGIO', 'ALGORITMO_EASY', 20,
'public class Solucao {
    public int contarVogais(String texto) {
        // TODO: implementar
        return 0;
    }
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Contar Vogais');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Percorre o texto com laco ou stream', '(for|while|chars\s*\(|stream\s*\()', 'OBRIGATORIO', 1),
    ('Devolve o resultado com return', 'return\s+[^;]+;', 'OBRIGATORIO', 1),
    ('Compara os caracteres contra o conjunto de vogais', '(aeiou|indexOf|contains)', 'PONTUAVEL', 3),
    ('Trata maiusculas e minusculas', '(toLowerCase|toUpperCase|equalsIgnoreCase)', 'PONTUAVEL', 2),
    ('Acumula a contagem numa variavel', '(\+\+|\+=)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Contar Vogais'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 2. Cadastro de Clientes (Java, junior, API REST)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Cadastro de Clientes',
       'Implemente POST /clientes: receba o corpo da requisicao, valide os campos e responda 201 com o cliente salvo.',
       'JUNIOR', 'API_REST', 40,
'@RestController
@RequestMapping("/clientes")
public class ClienteController {

    // TODO: implementar o cadastro
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Cadastro de Clientes');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Expoe um endpoint de escrita (POST)', '(PostMapping|RequestMethod\.POST)', 'OBRIGATORIO', 1),
    ('Le o corpo da requisicao', '(RequestBody|@Valid)', 'OBRIGATORIO', 1),
    ('Responde 201 Created em vez do 200 padrao', '(HttpStatus\.CREATED|ResponseStatus|201)', 'PONTUAVEL', 3),
    ('Valida os dados recebidos', '(@Valid|@NotBlank|@NotNull|if\s*\()', 'PONTUAVEL', 2),
    ('Persiste o cliente por um repositorio ou service', '(repository|repositorio|service|servico)\s*\.\s*\w+\s*\(', 'PONTUAVEL', 3),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Cadastro de Clientes'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 3. Paginacao de Pedidos (Java, pleno, API REST)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Paginacao de Pedidos',
       'Implemente GET /pedidos com paginacao e ordenacao. A resposta deve trazer os itens da pagina e o total de registros.',
       'PLENO', 'API_REST', 50,
'@RestController
@RequestMapping("/pedidos")
public class PedidoController {

    // TODO: implementar a listagem paginada
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Paginacao de Pedidos');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Expoe um endpoint de leitura (GET)', '(GetMapping|RequestMethod\.GET)', 'OBRIGATORIO', 1),
    ('Recebe os parametros de paginacao', '(Pageable|RequestParam)', 'OBRIGATORIO', 1),
    ('Devolve um resultado paginado, nao uma List crua', '(Page\s*<|PageImpl|PageRequest)', 'PONTUAVEL', 3),
    ('Permite ordenar o resultado', '(Sort|orderBy|order by)', 'PONTUAVEL', 2),
    ('Define um tamanho de pagina padrao ou maximo', '(defaultValue|Math\.min)', 'PONTUAVEL', 2),
    ('Nao carregue a tabela inteira em memoria', 'findAll\s*\(\s*\)', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Paginacao de Pedidos'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 4. Agrupar Anagramas (Java, pleno, algoritmo)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Agrupar Anagramas',
       'Dada uma lista de palavras, agrupe as que sao anagramas entre si e devolva os grupos.',
       'PLENO', 'ALGORITMO_EASY', 35,
'import java.util.*;

public class Solucao {
    public List<List<String>> agrupar(List<String> palavras) {
        // TODO: implementar
        return List.of();
    }
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Agrupar Anagramas');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Percorre a lista de palavras', '(for|while|stream\s*\(|forEach)', 'OBRIGATORIO', 1),
    ('Devolve os grupos com return', 'return\s+[^;]+;', 'OBRIGATORIO', 1),
    ('Usa um Map para indexar os grupos', '(Map\s*<|HashMap|groupingBy|computeIfAbsent)', 'PONTUAVEL', 3),
    ('Normaliza a palavra para gerar a chave do grupo', '(sort|toCharArray|chars\s*\()', 'PONTUAVEL', 3),
    ('Monta a lista de saida a partir dos grupos', '(values\s*\(\s*\)|ArrayList|LinkedList)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Agrupar Anagramas'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 5. Inverter Palavras da Frase (Node, estagio, algoritmo)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Inverter Palavras da Frase',
       'Receba uma frase e devolva outra com as palavras na ordem inversa, sem espacos sobrando.',
       'ESTAGIO', 'ALGORITMO_EASY', 20,
'function inverterPalavras(frase) {
    // TODO: implementar
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Node'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Inverter Palavras da Frase');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Devolve o resultado com return', 'return\s+\S+', 'OBRIGATORIO', 1),
    ('Separa a frase em palavras', '(split|match)\s*\(', 'OBRIGATORIO', 1),
    ('Inverte a ordem das palavras', '(reverse|reduceRight|unshift)', 'PONTUAVEL', 3),
    ('Remonta a frase numa string', '(join\s*\(|\+=)', 'PONTUAVEL', 2),
    ('Trata espacos extras na entrada', '(trim|filter)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Inverter Palavras da Frase'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 6. API de Tarefas (Node, junior, API REST)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'API de Tarefas',
       'Monte as rotas GET /tarefas e POST /tarefas em Express. O POST deve recusar corpo sem titulo.',
       'JUNIOR', 'API_REST', 40,
'const express = require("express");
const router = express.Router();

// TODO: implementar as rotas

module.exports = router;',
       t.id
FROM tecnologias t
WHERE t.nome = 'Node'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'API de Tarefas');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Registra a rota de leitura', '\.get\s*\(', 'OBRIGATORIO', 1),
    ('Registra a rota de escrita', '\.post\s*\(', 'OBRIGATORIO', 1),
    ('Le o corpo da requisicao no POST', 'req\s*\.\s*body', 'PONTUAVEL', 3),
    ('Responde 201 ao criar e 400 quando o corpo e invalido', '(status\s*\(\s*201|status\s*\(\s*400)', 'PONTUAVEL', 3),
    ('Valida o titulo antes de salvar', '(if\s*\(|&&)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'API de Tarefas'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 7. Middleware de Autenticacao (Node, pleno, API REST)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Middleware de Autenticacao',
       'Escreva um middleware Express que leia o header Authorization, valide o token JWT e bloqueie a requisicao com 401 quando o token faltar ou for invalido.',
       'PLENO', 'API_REST', 45,
'function autenticar(req, res, next) {
    // TODO: implementar
}

module.exports = autenticar;',
       t.id
FROM tecnologias t
WHERE t.nome = 'Node'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Middleware de Autenticacao');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Le o header Authorization', '(authorization|headers)', 'OBRIGATORIO', 1),
    ('Segue a cadeia de middlewares com next()', 'next\s*\(\s*\)', 'OBRIGATORIO', 1),
    ('Responde 401 quando o token falta ou nao vale', 'status\s*\(\s*401', 'PONTUAVEL', 3),
    ('Verifica a assinatura do token', '(verify|decode|jwt)', 'PONTUAVEL', 3),
    ('Descarta o prefixo Bearer antes de validar', '(Bearer|split\s*\(|slice\s*\(|replace\s*\()', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Middleware de Autenticacao'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 8. Media de Notas (Python, estagio, algoritmo)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Media de Notas',
       'Receba uma lista de notas e devolva a media. Lista vazia deve devolver 0, sem estourar excecao.',
       'ESTAGIO', 'ALGORITMO_EASY', 20,
'def media(notas):
    # TODO: implementar
    return 0',
       t.id
FROM tecnologias t
WHERE t.nome = 'Python'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Media de Notas');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Devolve o resultado com return', 'return\s+\S+', 'OBRIGATORIO', 1),
    ('Soma as notas da lista', '(sum\s*\(|for\s+\w+\s+in|\+=)', 'OBRIGATORIO', 1),
    ('Divide pela quantidade de elementos', '(len\s*\(|/)', 'PONTUAVEL', 3),
    ('Trata a lista vazia antes de dividir', '(if\s+not|len\s*\(\s*\w+\s*\)\s*==\s*0|if\s+\w+\s*:)', 'PONTUAVEL', 3),
    ('Usa nomes de variavel descritivos', '(total|soma|quantidade|media)', 'PONTUAVEL', 1),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Media de Notas'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 9. Verificador de Palindromo (Python, junior, algoritmo)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Verificador de Palindromo',
       'Diga se um texto e palindromo. Ignore espacos, pontuacao e diferenca entre maiusculas e minusculas.',
       'JUNIOR', 'ALGORITMO_EASY', 25,
'def eh_palindromo(texto):
    # TODO: implementar
    return False',
       t.id
FROM tecnologias t
WHERE t.nome = 'Python'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Verificador de Palindromo');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Devolve o resultado com return', 'return\s+\S+', 'OBRIGATORIO', 1),
    ('Compara o texto com a versao invertida', '(\[\s*::\s*-\s*1\s*\]|reversed\s*\(|while)', 'OBRIGATORIO', 1),
    ('Normaliza maiusculas e minusculas', '(lower\s*\(|upper\s*\()', 'PONTUAVEL', 3),
    ('Descarta espacos e pontuacao', '(isalnum|replace\s*\(|join\s*\(|sub\s*\()', 'PONTUAVEL', 3),
    ('Devolve booleano em vez de string', '(True|False|==)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Verificador de Palindromo'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 10. Endpoint de Relatorio (Python, pleno, API REST)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Endpoint de Relatorio',
       'Com FastAPI, exponha GET /relatorio recebendo data inicial e final como parametros de query e devolvendo o total do periodo. Datas invalidas respondem 422 ou 400.',
       'PLENO', 'API_REST', 45,
'from fastapi import APIRouter

router = APIRouter()

# TODO: implementar o endpoint',
       t.id
FROM tecnologias t
WHERE t.nome = 'Python'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Endpoint de Relatorio');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Registra a rota de leitura', '(@router\.get|@app\.get)', 'OBRIGATORIO', 1),
    ('Declara a funcao que atende a rota', 'def\s+\w+\s*\(', 'OBRIGATORIO', 1),
    ('Recebe o periodo como parametro', '(Query|date|data_inicial|inicio)', 'PONTUAVEL', 3),
    ('Tipa os parametros para o FastAPI validar', '(:\s*date|:\s*str|:\s*int|Optional)', 'PONTUAVEL', 2),
    ('Trata periodo invalido com erro HTTP', '(HTTPException|status_code|raise)', 'PONTUAVEL', 3),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Endpoint de Relatorio'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 11. Relatorio de Vendas por Mes (SQL, junior, banco de dados)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Relatorio de Vendas por Mes',
       'Nas tabelas pedidos(id, cliente_id, valor, data) e clientes(id, nome), escreva a consulta que devolve o total vendido por mes, do mes mais recente para o mais antigo.',
       'JUNIOR', 'BANCO_DADOS', 30,
'-- TODO: escrever a consulta
SELECT 1;',
       t.id
FROM tecnologias t
WHERE t.nome = 'SQL'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Relatorio de Vendas por Mes');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Faz uma consulta na tabela de pedidos', 'select[\s\S]+from\s+pedidos', 'OBRIGATORIO', 1),
    ('Agrupa o resultado', 'group\s+by', 'OBRIGATORIO', 1),
    ('Soma o valor dos pedidos', 'sum\s*\(', 'PONTUAVEL', 3),
    ('Agrupa por mes, nao pela data cheia', '(date_trunc|extract|to_char|month)', 'PONTUAVEL', 3),
    ('Ordena do mes mais recente para o mais antigo', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Relatorio de Vendas por Mes'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- 12. Clientes sem Pedido (SQL, pleno, banco de dados)
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Clientes sem Pedido',
       'Nas tabelas clientes(id, nome) e pedidos(id, cliente_id, data), liste os clientes que nunca fizeram pedido nos ultimos 12 meses. Nao use subconsulta correlacionada.',
       'PLENO', 'BANCO_DADOS', 35,
'-- TODO: escrever a consulta
SELECT 1;',
       t.id
FROM tecnologias t
WHERE t.nome = 'SQL'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Clientes sem Pedido');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Faz uma consulta na tabela de clientes', 'select[\s\S]+from\s+clientes', 'OBRIGATORIO', 1),
    ('Relaciona clientes com pedidos', '(join|not\s+exists|not\s+in)', 'OBRIGATORIO', 1),
    ('Preserva os clientes sem correspondencia', '(left\s+join|not\s+exists|except)', 'PONTUAVEL', 3),
    ('Filtra quem nao tem pedido', '(is\s+null|not\s+exists|not\s+in)', 'PONTUAVEL', 3),
    ('Recorta a janela de 12 meses', '(interval|date_trunc|current_date|now\s*\(|year)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Clientes sem Pedido'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);


-- ---------------------------------------------------------------------------
-- Desafios que ja existiam antes desta migration: so os criterios.
-- ---------------------------------------------------------------------------
INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'CRUD de Produtos',
       'Implemente o endpoint GET /produtos retornando a lista de produtos.',
       'JUNIOR', 'API_REST', 45,
'@RestController
public class ProdutoController {
    // TODO: implementar
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'CRUD de Produtos');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Expoe um endpoint de leitura (GET)', '(GetMapping|RequestMethod\.GET)', 'OBRIGATORIO', 1),
    ('Devolve o resultado com return', 'return\s+[^;]+;', 'OBRIGATORIO', 1),
    ('Mapeia a rota /produtos', 'produtos', 'PONTUAVEL', 3),
    ('Busca os dados por um repositorio ou service', '(repository|repositorio|service|servico)\s*\.\s*\w+\s*\(', 'PONTUAVEL', 3),
    ('Declara a classe como controller REST', '(RestController|Controller)', 'PONTUAVEL', 2),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'CRUD de Produtos'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);

INSERT INTO desafios (titulo, descricao, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT 'Soma de Pares',
       'Dado um array de inteiros, retorne a soma dos numeros pares.',
       'ESTAGIO', 'ALGORITMO_EASY', 20,
'function somaPares(numeros) {
    // TODO: implementar
}',
       t.id
FROM tecnologias t
WHERE t.nome = 'Node'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = 'Soma de Pares');

INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso
FROM desafios d
CROSS JOIN (VALUES
    ('Devolve o resultado com return', 'return\s+\S+', 'OBRIGATORIO', 1),
    ('Percorre o array', '(for|while|forEach|filter|reduce|map)', 'OBRIGATORIO', 1),
    ('Testa a paridade do numero', '%\s*2', 'PONTUAVEL', 3),
    ('Acumula a soma', '(\+=|reduce|sum|total)', 'PONTUAVEL', 3),
    ('Trata o array vazio sem quebrar', '(length|\?\?|\|\||=\s*0)', 'PONTUAVEL', 1),
    ('Nao deixe o TODO do template no codigo', 'TODO', 'PROIBIDO', 1)
) AS v (descricao, padrao, tipo, peso)
WHERE d.titulo = 'Soma de Pares'
  AND NOT EXISTS (SELECT 1 FROM criterios_avaliacao c WHERE c.desafio_id = d.id);
