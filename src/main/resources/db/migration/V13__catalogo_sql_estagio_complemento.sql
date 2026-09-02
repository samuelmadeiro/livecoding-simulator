-- Complemento do catalogo SQL de estagio: as duas questoes que faltavam para fechar 50.
--
-- Elas vem numa migration propria, e nao dentro da V12, porque a V12 ja foi aplicada. Editar
-- migration aplicada muda o checksum e quebra o Flyway em qualquer banco que ja tenha rodado ela.
--
-- Mesmo banco ficticio das demais questoes de SQL:
--   clientes(id, nome, email, cidade, estado, criado_em)
--   produtos(id, nome, categoria, preco, estoque)
--   pedidos(id, cliente_id, data, status, valor)
--   itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario)

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'ESTAGIO', 'BANCO_DADOS', v.tempo, v.template, t.id
FROM (VALUES

('Clientes Cadastrados por Mes (SQL)',
 'Escreva a consulta que conta quantos clientes foram cadastrados em cada mes de 2024.',
 'Curva de aquisicao mes a mes e o grafico que abre a reuniao de marketing. Agrupar por mes exige recortar a parte da data que interessa: agrupar pela coluna crua produz um grupo por dia, ou ate por segundo, e o grafico vira ruido.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna criado_em guarda data e hora.',
 'Duas colunas: o mes e a quantidade de clientes, do mes mais antigo para o mais recente. Somente 2024.',
 'mes        | novos
2024-01-01 | 45
2024-02-01 | 52',
 'Agrupe por mes, nao pela data completa. Somente cadastros de 2024 entram.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos Acima da Media de Preco (SQL)',
 'Escreva a consulta que lista nome e preco dos produtos mais caros que a media do catalogo.',
 'Classificar item como premium comeca por essa comparacao. E o primeiro contato com subconsulta: a media precisa ser calculada antes para so entao servir de criterio, e ela nao cabe no WHERE como agregacao direta.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Duas colunas, nome e preco, do mais caro para o mais barato.',
 'nome     | preco
Notebook | 4500.00
Monitor  | 899.00',
 'Nao e possivel usar AVG direto no WHERE: a media precisa vir de uma subconsulta.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'SQL'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Clientes Cadastrados por Mes (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Clientes Cadastrados por Mes (SQL)', 'Agrupa o resultado', 'group\s+by', 'OBRIGATORIO', 1, 'A contagem por mes exige GROUP BY.'),
('Clientes Cadastrados por Mes (SQL)', 'Recorta a data ate o mes', '(date_trunc|extract|to_char)', 'PONTUAVEL', 3, 'Agrupar pela coluna crua cria um grupo por horario. Recorte a data ate o mes.'),
('Clientes Cadastrados por Mes (SQL)', 'Conta os cadastros de cada mes', 'count\s*\(', 'PONTUAVEL', 3, 'COUNT transforma cada mes num numero.'),
('Clientes Cadastrados por Mes (SQL)', 'Restringe ao ano de 2024', '2024', 'PONTUAVEL', 2, 'O enunciado pede apenas os cadastros de 2024.'),
('Clientes Cadastrados por Mes (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede o mes e a contagem.'),

('Produtos Acima da Media de Preco (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos Acima da Media de Preco (SQL)', 'Calcula a media numa subconsulta', 'select[\s\S]*\(\s*select', 'OBRIGATORIO', 1, 'A media precisa ser calculada antes, dentro de uma subconsulta.'),
('Produtos Acima da Media de Preco (SQL)', 'Usa AVG sobre o preco', 'avg\s*\(', 'PONTUAVEL', 3, 'A media do catalogo sai de AVG sobre a coluna preco.'),
('Produtos Acima da Media de Preco (SQL)', 'Compara o preco com a media', '>', 'PONTUAVEL', 3, 'O filtro compara o preco de cada produto com a media calculada.'),
('Produtos Acima da Media de Preco (SQL)', 'Ordena do mais caro para o mais barato', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do mais caro para o mais barato.'),
('Produtos Acima da Media de Preco (SQL)', 'Nao use AVG direto no WHERE', 'where[^()]*avg\s*\(', 'PROIBIDO', 1, 'Agregacao nao pode ir direto no WHERE: ela precisa vir de uma subconsulta.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'SQL'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
