-- Catalogo SQL, nivel pleno: 9 questoes.
--
-- No pleno a consulta correta nao basta: as questoes cobram deduplicacao com janela, comparacao
-- entre linhas vizinhas, recursao, pivo e as armadilhas que so aparecem em base grande, como o
-- NOT IN que devolve vazio por causa de um unico NULL.
--
-- Mesmo banco ficticio das demais questoes de SQL:
--   clientes(id, nome, email, cidade, estado, criado_em)
--   produtos(id, nome, categoria, preco, estoque)
--   pedidos(id, cliente_id, data, status, valor)
--   itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario)

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'PLENO', 'BANCO_DADOS', v.tempo, v.template, t.id
FROM (VALUES

('Remover Clientes Duplicados (SQL)',
 'Escreva a consulta que devolve o id dos clientes duplicados por e-mail, mantendo apenas o cadastro mais antigo de cada e-mail.',
 'Antes de criar uma restricao de unicidade alguem precisa decidir qual linha fica e quais saem. A questao pede o passo de identificacao, que e o mais delicado: escolher errado apaga o cadastro com historico e mantem o vazio.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna email pode ser nula.',
 'Uma coluna com o id dos cadastros que devem sair, em ordem crescente. O mais antigo de cada e-mail nao entra.',
 'id
88
92',
 'Cadastro com e-mail nulo nunca e duplicata. Empate de data desempata pelo menor id.',
 45,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Retencao Mes a Mes (SQL)',
 'Escreva a consulta que mostra, para cada mes, quantos clientes compraram nele e tambem compraram no mes seguinte.',
 'Retencao e o indicador que decide se a empresa cresce ou so troca de clientes. A dificuldade e comparar o mesmo conjunto consigo mesmo deslocado no tempo, sem contar duas vezes o cliente que fez varios pedidos no mesmo mes.',
 'Tabelas pedidos(id, cliente_id, data, status, valor) e clientes(id, nome, ...).',
 'Tres colunas: o mes, quantos clientes compraram nele e quantos desses voltaram no mes seguinte, do mes mais antigo para o mais recente.',
 'mes        | compraram | retidos
2024-01-01 | 120       | 45',
 'Cliente com varios pedidos no mesmo mes conta uma vez. Considere apenas pedidos pagos.',
 55,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Hierarquia de Categorias (SQL)',
 'Considerando que categorias(id, nome, pai_id) forma uma arvore, escreva a consulta que devolve todas as categorias descendentes da categoria de id 1, em qualquer profundidade.',
 'Arvore de categorias, estrutura organizacional e arvore de comentarios sao o mesmo problema. Sem consulta recursiva, alguem escreve um JOIN por nivel e o codigo quebra no dia em que aparece um nivel a mais.',
 'Tabela categorias(id, nome, pai_id). A raiz tem pai_id nulo. A profundidade e desconhecida.',
 'Duas colunas: id e nome de cada descendente, em qualquer ordem. A propria categoria 1 nao entra.',
 'id | nome
7  | Perifericos
9  | Teclados',
 'A profundidade e desconhecida: nao escreva um JOIN por nivel. Use consulta recursiva.',
 55,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos que Nunca Foram Vendidos com NOT IN (SQL)',
 'Escreva a consulta que lista os produtos que nunca aparecem em itens_pedido, sabendo que a coluna produto_id pode conter nulo.',
 'Esta questao existe por causa de um bug real e silencioso: NOT IN com uma subconsulta que devolve um unico NULL nao retorna nada, porque a comparacao vira desconhecida. O relatorio sai vazio e ninguem desconfia, porque nao ha erro nem aviso.',
 'Tabelas produtos(id, nome, ...) e itens_pedido(id, pedido_id, produto_id, ...). A coluna produto_id pode ser nula por causa de importacao antiga.',
 'Uma coluna com o nome do produto, em ordem alfabetica.',
 'nome
Cabo HDMI',
 'A subconsulta pode devolver NULL. O resultado nao pode vir vazio por causa disso.',
 45,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Faturamento por Categoria em Colunas (SQL)',
 'Escreva a consulta que mostra, por mes, o faturamento de cada uma das tres categorias principais em colunas separadas.',
 'Planilha que a diretoria le tem mes na linha e categoria na coluna, e o banco entrega o contrario. Girar linha em coluna e a tarefa que aparece toda vez que alguem pede o relatorio em formato de planilha.',
 'Tabelas itens_pedido, produtos e pedidos, ligadas por produto_id e pedido_id. As categorias sao Informatica, Perifericos e Acessorios.',
 'Quatro colunas: o mes e o faturamento de cada uma das tres categorias, do mes mais antigo para o mais recente. Mes sem venda numa categoria mostra 0.',
 'mes        | informatica | perifericos | acessorios
2024-01-01 | 15320.00    | 8200.00     | 0.00',
 'Mes sem venda numa categoria precisa mostrar 0, e nao vazio. Uma unica varredura da tabela.',
 55,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Mediana do Valor dos Pedidos (SQL)',
 'Escreva a consulta que devolve a mediana do valor dos pedidos pagos.',
 'Media e mediana contam historias diferentes, e num conjunto com poucos pedidos gigantes a media engana. SQL nao tem funcao de mediana em todo banco, entao a questao mede se a pessoa sabe construir a estatistica a partir de ordenacao e contagem.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Uma unica linha com a mediana. Com quantidade par de pedidos, e a media dos dois valores centrais.',
 'mediana
189.90',
 'Com quantidade par de pedidos, a mediana e a media dos dois centrais. Considere apenas pedidos pagos.',
 50,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Sequencia de Meses sem Compra (SQL)',
 'Escreva a consulta que mostra, para cada cliente, o maior intervalo em dias entre dois pedidos consecutivos dele.',
 'Maior intervalo entre compras indica risco de perda do cliente e alimenta modelo de churn. A questao junta janela particionada com agregacao sobre o resultado dela, que e o encadeamento que separa junior de pleno.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, data, ...).',
 'Duas colunas: nome do cliente e o maior intervalo em dias, do maior intervalo para o menor. Cliente com um unico pedido nao entra.',
 'nome       | maior_intervalo
Bruno Lima | 210',
 'O intervalo e por cliente. Cliente com um unico pedido fica de fora, porque nao ha intervalo.',
 55,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Primeiro Pedido de Cada Cliente com Detalhe (SQL)',
 'Escreva a consulta que mostra, para cada cliente, os dados completos do primeiro pedido dele: id, data e valor.',
 'Diferente de pegar so a data mais antiga, aqui e preciso trazer a linha inteira daquele pedido. E o caso em que GROUP BY nao resolve: o MIN da data e o valor do pedido podem vir de linhas diferentes, e o relatorio sai com dados misturados.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, data, status, valor).',
 'Quatro colunas: nome do cliente, id do pedido, data e valor, em ordem alfabetica de nome. Empate de data desempata pelo menor id.',
 'nome       | pedido_id | data       | valor
Ana Souza  | 45        | 2021-03-14 | 120.00',
 'MIN em cada coluna mistura linhas diferentes. A linha precisa vir inteira do mesmo pedido.',
 50,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos Comprados Juntos (SQL)',
 'Escreva a consulta que lista os pares de produtos que aparecem no mesmo pedido, com quantas vezes isso aconteceu.',
 'E a base de quem comprou isso tambem comprou aquilo. A questao exige autojuncao da tabela de itens, e o cuidado esta em nao gerar o par do produto consigo mesmo nem contar o mesmo par duas vezes em ordens trocadas.',
 'Tabela itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, ...).',
 'Tres colunas: nome do primeiro produto, nome do segundo e a quantidade de pedidos em que apareceram juntos, da maior quantidade para a menor.',
 'produto_a | produto_b | vezes
Notebook  | Mouse     | 42',
 'Nao gere o par do produto com ele mesmo. Cada par aparece uma unica vez, nao duas em ordens trocadas.',
 55,
 '-- TODO: escrever a consulta
SELECT 1;')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'SQL'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Remover Clientes Duplicados (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Remover Clientes Duplicados (SQL)', 'Numera os cadastros de cada e-mail', '(row_number|rank|min\s*\()', 'OBRIGATORIO', 1, 'Numerar dentro de cada e-mail permite manter o primeiro e marcar o resto.'),
('Remover Clientes Duplicados (SQL)', 'Particiona por e-mail', '(partition\s+by[\s\S]{0,40}email|group\s+by[\s\S]*email)', 'PONTUAVEL', 3, 'A numeracao reinicia a cada e-mail.'),
('Remover Clientes Duplicados (SQL)', 'Ordena pelo cadastro mais antigo', '(order\s+by[\s\S]*criado_em|min\s*\(\s*criado_em)', 'PONTUAVEL', 3, 'O que fica e o mais antigo, entao a ordenacao dentro do grupo e por criado_em.'),
('Remover Clientes Duplicados (SQL)', 'Descarta o e-mail nulo', 'is\s+not\s+null', 'PONTUAVEL', 2, 'Varios clientes sem e-mail nao sao duplicatas, e apaga-los seria perda de dado.'),
('Remover Clientes Duplicados (SQL)', 'Nao apague dado nesta consulta', '\bdelete\b', 'PROIBIDO', 1, 'O enunciado pede apenas a identificacao dos ids: a exclusao e outro passo.'),

('Retencao Mes a Mes (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A base da retencao sao os pedidos.'),
('Retencao Mes a Mes (SQL)', 'Compara o mes com o seguinte', '(interval|lead\s*\(|\+\s*1|join)', 'OBRIGATORIO', 1, 'A retencao compara o conjunto de clientes de um mes com o do mes seguinte.'),
('Retencao Mes a Mes (SQL)', 'Agrupa por mes', '(date_trunc|extract|to_char)', 'PONTUAVEL', 3, 'A serie e mensal, entao a data precisa ser recortada ate o mes.'),
('Retencao Mes a Mes (SQL)', 'Conta cada cliente uma vez por mes', 'distinct', 'PONTUAVEL', 3, 'Cliente com tres pedidos no mes nao pode contar como tres clientes.'),
('Retencao Mes a Mes (SQL)', 'Considera apenas pedidos pagos', 'pago', 'PONTUAVEL', 2, 'Pedido cancelado nao representa cliente ativo.'),
('Retencao Mes a Mes (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Hierarquia de Categorias (SQL)', 'Usa consulta recursiva', 'with\s+recursive', 'OBRIGATORIO', 1, 'Profundidade desconhecida pede WITH RECURSIVE.'),
('Hierarquia de Categorias (SQL)', 'Define o ponto de partida da recursao', '(=\s*1|id\s*=\s*1|pai_id\s*=\s*1)', 'OBRIGATORIO', 1, 'A parte nao recursiva ancora a busca na categoria 1.'),
('Hierarquia de Categorias (SQL)', 'Une o passo recursivo', 'union', 'PONTUAVEL', 3, 'UNION liga o caso base ao passo que desce um nivel.'),
('Hierarquia de Categorias (SQL)', 'Liga o filho ao pai', 'pai_id', 'PONTUAVEL', 3, 'Cada nivel encontra os filhos comparando pai_id com o id do nivel anterior.'),
('Hierarquia de Categorias (SQL)', 'Traz id e nome dos descendentes', 'select[\s\S]*nome', 'PONTUAVEL', 2, 'O enunciado pede id e nome de cada descendente.'),
('Hierarquia de Categorias (SQL)', 'Nao escreva um JOIN por nivel', 'join[\s\S]{0,200}join[\s\S]{0,200}join[\s\S]{0,200}join', 'PROIBIDO', 1, 'Um JOIN por nivel quebra no dia em que a arvore ganha mais um nivel.'),

('Produtos que Nunca Foram Vendidos com NOT IN (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta parte de produtos.'),
('Produtos que Nunca Foram Vendidos com NOT IN (SQL)', 'Protege a comparacao contra o nulo', '(not\s+exists|is\s+not\s+null|left\s+join)', 'OBRIGATORIO', 1, 'NOT EXISTS, LEFT JOIN ou um filtro de nulo evitam o resultado vazio.'),
('Produtos que Nunca Foram Vendidos com NOT IN (SQL)', 'Relaciona produto com item', 'produto_id', 'PONTUAVEL', 3, 'A ligacao e entre produtos.id e itens_pedido.produto_id.'),
('Produtos que Nunca Foram Vendidos com NOT IN (SQL)', 'Testa a ausencia de venda', '(not\s+exists|is\s+null|not\s+in)', 'PONTUAVEL', 3, 'A pergunta e sobre ausencia, e nao sobre presenca.'),
('Produtos que Nunca Foram Vendidos com NOT IN (SQL)', 'Ordena por nome', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica.'),
('Produtos que Nunca Foram Vendidos com NOT IN (SQL)', 'Nao use NOT IN sem tratar o nulo', 'not\s+in\s*\(\s*select\s+produto_id\s+from\s+itens_pedido\s*\)', 'PROIBIDO', 1, 'Um unico NULL na subconsulta faz o NOT IN devolver nenhuma linha, sem erro e sem aviso.'),

('Faturamento por Categoria em Colunas (SQL)', 'Cruza itens com produtos e pedidos', 'join[\s\S]*join', 'OBRIGATORIO', 1, 'A categoria vem de produtos e a data vem de pedidos.'),
('Faturamento por Categoria em Colunas (SQL)', 'Gira a categoria para coluna', '(case|filter\s*\(|pivot)', 'OBRIGATORIO', 1, 'CASE dentro da agregacao transforma cada categoria numa coluna.'),
('Faturamento por Categoria em Colunas (SQL)', 'Agrupa por mes', '(date_trunc|extract|to_char)', 'PONTUAVEL', 3, 'A linha do relatorio e o mes.'),
('Faturamento por Categoria em Colunas (SQL)', 'Cita as tres categorias', 'Informatica[\s\S]*Perifericos[\s\S]*Acessorios', 'PONTUAVEL', 3, 'As tres categorias pedidas viram as tres colunas.'),
('Faturamento por Categoria em Colunas (SQL)', 'Mostra zero onde nao houve venda', '(coalesce|else\s+0)', 'PONTUAVEL', 2, 'Mes sem venda na categoria precisa mostrar 0, e nao vazio.'),
('Faturamento por Categoria em Colunas (SQL)', 'Nao faca uma consulta por categoria', 'union\s+all[\s\S]*union\s+all', 'PROIBIDO', 1, 'Empilhar uma consulta por categoria varre a tabela tres vezes e devolve linhas, nao colunas.'),

('Mediana do Valor dos Pedidos (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Mediana do Valor dos Pedidos (SQL)', 'Ordena os valores para achar o centro', '(order\s+by|percentile_cont|row_number)', 'OBRIGATORIO', 1, 'A mediana depende da ordenacao dos valores.'),
('Mediana do Valor dos Pedidos (SQL)', 'Localiza a posicao central', '(percentile_cont|count\s*\(|row_number)', 'PONTUAVEL', 3, 'A posicao central sai da contagem total de linhas.'),
('Mediana do Valor dos Pedidos (SQL)', 'Trata a quantidade par', '(%\s*2|percentile_cont|avg\s*\()', 'PONTUAVEL', 3, 'Com quantidade par, a mediana e a media dos dois valores centrais.'),
('Mediana do Valor dos Pedidos (SQL)', 'Considera apenas pedidos pagos', 'pago', 'PONTUAVEL', 2, 'Pedido cancelado nao entra na estatistica.'),
('Mediana do Valor dos Pedidos (SQL)', 'Nao devolva a media no lugar da mediana', 'select\s+avg\s*\(\s*valor\s*\)\s+from\s+pedidos', 'PROIBIDO', 1, 'Media e mediana contam historias diferentes: com poucos pedidos gigantes, a media engana.'),

('Sequencia de Meses sem Compra (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e as datas na tabela de pedidos.'),
('Sequencia de Meses sem Compra (SQL)', 'Compara cada pedido com o anterior do cliente', 'lag\s*\(', 'OBRIGATORIO', 1, 'LAG traz a data do pedido anterior sem autojuncao.'),
('Sequencia de Meses sem Compra (SQL)', 'Particiona por cliente', 'partition\s+by', 'PONTUAVEL', 3, 'Sem PARTITION BY, o pedido anterior pode ser de outro cliente.'),
('Sequencia de Meses sem Compra (SQL)', 'Agrega o maior intervalo por cliente', 'max\s*\(', 'PONTUAVEL', 3, 'Depois de calcular os intervalos, o maior deles e o resultado por cliente.'),
('Sequencia de Meses sem Compra (SQL)', 'Descarta o cliente com um unico pedido', '(is\s+not\s+null|having)', 'PONTUAVEL', 2, 'Com um pedido so nao ha intervalo: o LAG devolve nulo e a linha precisa sair.'),
('Sequencia de Meses sem Compra (SQL)', 'Nao ordene a janela sem particionar', 'over\s*\(\s*order\s+by', 'PROIBIDO', 1, 'Janela sem particao mistura os pedidos de todos os clientes numa fila so.'),

('Primeiro Pedido de Cada Cliente com Detalhe (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e os dados do pedido na outra tabela.'),
('Primeiro Pedido de Cada Cliente com Detalhe (SQL)', 'Seleciona a linha inteira do primeiro pedido', '(row_number|distinct\s+on|lateral)', 'OBRIGATORIO', 1, 'Para trazer a linha inteira, numere os pedidos do cliente e fique com o primeiro.'),
('Primeiro Pedido de Cada Cliente com Detalhe (SQL)', 'Particiona por cliente', 'partition\s+by', 'PONTUAVEL', 3, 'A numeracao reinicia a cada cliente.'),
('Primeiro Pedido de Cada Cliente com Detalhe (SQL)', 'Ordena pelo pedido mais antigo', 'order\s+by[\s\S]*data', 'PONTUAVEL', 3, 'O primeiro pedido e o de data mais antiga.'),
('Primeiro Pedido de Cada Cliente com Detalhe (SQL)', 'Desempata pelo menor id', 'id', 'PONTUAVEL', 2, 'Dois pedidos na mesma data precisam de um criterio estavel de desempate.'),
('Primeiro Pedido de Cada Cliente com Detalhe (SQL)', 'Nao agregue coluna por coluna', 'min\s*\(\s*data[\s\S]{0,80}min\s*\(\s*valor', 'PROIBIDO', 1, 'MIN em cada coluna mistura linhas diferentes e o relatorio sai com dados de pedidos distintos.'),

('Produtos Comprados Juntos (SQL)', 'Faz autojuncao da tabela de itens', 'itens_pedido[\s\S]*join[\s\S]*itens_pedido', 'OBRIGATORIO', 1, 'Os pares saem cruzando a tabela de itens com ela mesma pelo pedido.'),
('Produtos Comprados Juntos (SQL)', 'Liga os itens pelo mesmo pedido', 'pedido_id', 'OBRIGATORIO', 1, 'Dois produtos so formam par quando estao no mesmo pedido.'),
('Produtos Comprados Juntos (SQL)', 'Evita o par do produto com ele mesmo', '(<|>|<>|!=)', 'PONTUAVEL', 3, 'Sem essa condicao, todo produto forma par consigo mesmo.'),
('Produtos Comprados Juntos (SQL)', 'Conta cada par uma unica vez', '<', 'PONTUAVEL', 3, 'Comparar os ids com menor que, e nao com diferente, evita o mesmo par em ordens trocadas.'),
('Produtos Comprados Juntos (SQL)', 'Agrupa e conta as ocorrencias', '(group\s+by[\s\S]*count|count\s*\()', 'PONTUAVEL', 2, 'A quantidade de pedidos em que o par apareceu sai de COUNT sobre o agrupamento.'),
('Produtos Comprados Juntos (SQL)', 'Nao use apenas diferente na comparacao', '<>\s*\w*\.?produto_id', 'PROIBIDO', 1, 'Com diferente, o par A-B e o par B-A aparecem os dois e a contagem dobra.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'SQL'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
