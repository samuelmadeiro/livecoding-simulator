-- Catalogo SQL, nivel junior: 24 questoes.
--
-- Um degrau acima do estagio: HAVING, subconsulta, CTE, janela e as perguntas que so se respondem
-- combinando duas agregacoes. Continua sendo entrevista de junior, entao nada de plano de execucao
-- nem de reescrita para performance: o foco e produzir o numero certo.
--
-- Mesmo banco ficticio das demais questoes de SQL:
--   clientes(id, nome, email, cidade, estado, criado_em)
--   produtos(id, nome, categoria, preco, estoque)
--   pedidos(id, cliente_id, data, status, valor)
--   itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario)

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'JUNIOR', 'BANCO_DADOS', v.tempo, v.template, t.id
FROM (VALUES

('Clientes com Mais de Cinco Pedidos (SQL)',
 'Escreva a consulta que lista o nome dos clientes com mais de cinco pedidos e quantos pedidos cada um fez.',
 'Definir quem entra no programa de fidelidade comeca por um corte de frequencia. A questao existe para separar WHERE de HAVING: filtrar cliente por quantidade de pedidos so e possivel depois de agrupar, e tentar fazer isso no WHERE e o erro que todo mundo comete uma vez.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, ...).',
 'Duas colunas: nome do cliente e a quantidade de pedidos, da maior quantidade para a menor.',
 'nome       | pedidos
Ana Souza  | 12
Bruno Lima | 7',
 'Cliente com exatamente cinco pedidos nao entra. O corte por quantidade acontece depois do agrupamento.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Receita por Categoria (SQL)',
 'Escreva a consulta que soma a receita gerada por cada categoria de produto, considerando quantidade vezes preco unitario.',
 'Saber de onde vem o dinheiro e a primeira pergunta de qualquer analise de mix. A questao exige atravessar tres tabelas e mostra que receita nao esta gravada em lugar nenhum: ela e calculada linha a linha antes de ser somada.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, categoria, ...).',
 'Duas colunas: categoria e a receita total arredondada em duas casas, da maior receita para a menor.',
 'categoria    | receita
Informatica  | 128400.00
Perifericos  | 45300.50',
 'Use o preco gravado no item, nao o preco atual do produto.',
 30,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Primeiro Pedido de Cada Cliente (SQL)',
 'Escreva a consulta que mostra, para cada cliente, a data do primeiro pedido que ele fez.',
 'Data de primeira compra alimenta calculo de tempo de vida do cliente e analise de coorte. E a agregacao MIN dentro de um agrupamento, e o cuidado esta em nao confundir a data mais antiga do cliente com a data mais antiga da tabela.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, data, ...).',
 'Duas colunas: nome do cliente e a data do primeiro pedido, do cliente mais antigo para o mais recente.',
 'nome       | primeiro_pedido
Ana Souza  | 2021-03-14
Bruno Lima | 2022-08-01',
 'Clientes sem pedido nao aparecem nesta consulta.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Taxa de Cancelamento por Mes (SQL)',
 'Escreva a consulta que mostra, para cada mes, quantos pedidos foram feitos, quantos foram cancelados e o percentual de cancelamento.',
 'E o indicador que dispara investigacao quando sobe. A questao ensina a contar condicionalmente: dois numeros diferentes saem do mesmo conjunto de linhas, sem precisar de duas consultas nem de dois filtros.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Tres colunas: o mes, o total de pedidos e o percentual de cancelados arredondado em duas casas, do mes mais recente para o mais antigo.',
 'mes        | total | percentual_cancelado
2024-12-01 | 320   | 4.38',
 'O percentual precisa sair com casas decimais: divisao entre inteiros trunca e devolve zero.',
 35,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Tres Produtos Mais Vendidos por Categoria (SQL)',
 'Escreva a consulta que mostra os tres produtos mais vendidos de cada categoria, em unidades.',
 'Vitrine por secao e reposicao por linha de produto pedem esse recorte. E o caso classico de top N por grupo, que LIMIT nao resolve: LIMIT corta o resultado inteiro, e aqui o corte precisa acontecer dentro de cada categoria.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, ...) e produtos(id, nome, categoria, ...).',
 'Tres colunas: categoria, nome do produto e as unidades vendidas, ordenadas por categoria e depois pelas unidades em ordem decrescente.',
 'categoria    | nome     | unidades
Informatica  | Notebook | 320
Perifericos  | Teclado  | 890',
 'LIMIT sozinho corta o resultado inteiro: o corte precisa ser por categoria.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes que Compraram Uma Unica Vez (SQL)',
 'Escreva a consulta que lista o nome dos clientes que fizeram exatamente um pedido.',
 'Cliente de compra unica e o publico de campanha de recompra, e o volume desse grupo diz muito sobre retencao. Repete o HAVING, agora com igualdade em vez de corte, e reforca que a condicao recai sobre o grupo.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, ...).',
 'Duas colunas: nome do cliente e a data do unico pedido, em ordem alfabetica de nome.',
 'nome        | data
Carla Dias  | 2024-05-02',
 'Cliente sem pedido nenhum nao entra. A condicao de quantidade recai sobre o grupo.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Categorias Acima da Receita Media (SQL)',
 'Escreva a consulta que lista as categorias cuja receita e maior que a receita media entre todas as categorias.',
 'Comparar cada grupo contra a media dos grupos e uma pergunta comum de analise e uma das mais confusas de escrever: a media so existe depois que todas as receitas foram calculadas, entao a consulta precisa de dois passos.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, categoria, ...).',
 'Duas colunas: categoria e a receita, da maior para a menor.',
 'categoria    | receita
Informatica  | 128400.00',
 'A media e entre categorias, nao entre itens. Use CTE ou subconsulta: a receita precisa existir antes de virar criterio.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Ranking de Clientes por Gasto (SQL)',
 'Escreva a consulta que lista os clientes com o total gasto e a posicao de cada um no ranking.',
 'Ranking com posicao explicita aparece em programa de pontos e em relatorio comercial. A questao apresenta funcao de janela e a diferenca entre RANK e ROW_NUMBER, que so importa quando ha empate, e empate sempre acontece.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, valor, ...).',
 'Tres colunas: posicao, nome do cliente e total gasto, do maior gasto para o menor. Clientes empatados dividem a mesma posicao.',
 'posicao | nome       | total
1       | Ana Souza  | 15200.00
2       | Bruno Lima | 15200.00',
 'Empate precisa receber a mesma posicao. ROW_NUMBER desempata de forma arbitraria e nao serve aqui.',
 35,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Faturamento Mes a Mes com Comparativo (SQL)',
 'Escreva a consulta que mostra o faturamento de cada mes e o faturamento do mes anterior, lado a lado.',
 'Comparar com o mes anterior e o que transforma um numero solto em tendencia. Sem funcao de janela isso vira um autojoin desconfortavel; com LAG, e uma linha. E a questao que costuma abrir os olhos de quem so conhecia GROUP BY.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Tres colunas: o mes, o faturamento do mes e o faturamento do mes anterior, do mes mais antigo para o mais recente. O primeiro mes nao tem anterior.',
 'mes        | faturamento | mes_anterior
2024-01-01 | 15320.00    |
2024-02-01 | 18200.00    | 15320.00',
 'Considere apenas pedidos pagos. O primeiro mes fica com o comparativo vazio.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Media de Itens por Pedido (SQL)',
 'Escreva a consulta que devolve a media de itens distintos por pedido.',
 'Tamanho medio do carrinho orienta frete e embalagem. A dificuldade e a agregacao em dois niveis: primeiro conta-se por pedido, depois calcula-se a media dessas contagens. Fazer tudo num passo devolve um numero que parece certo e nao e.',
 'Tabela itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario).',
 'Uma unica linha com a media de itens por pedido, arredondada em duas casas.',
 'media_itens
2.85',
 'Conte itens por pedido antes de tirar a media. Pedido sem item nao entra no calculo.',
 35,
 '-- TODO: escrever a consulta
SELECT 1;'),

('E-mails Duplicados no Cadastro (SQL)',
 'Escreva a consulta que lista os e-mails cadastrados para mais de um cliente, com a quantidade de cadastros.',
 'Duplicidade de cadastro quebra login, cobranca e comunicacao. Achar os duplicados antes de criar a restricao de unicidade e passo obrigatorio de qualquer limpeza de base.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna email pode ser nula.',
 'Duas colunas: o e-mail e a quantidade de cadastros, da maior quantidade para a menor.',
 'email             | cadastros
ana@exemplo.com   | 3',
 'E-mail nulo nao conta como duplicidade, mesmo havendo varios clientes sem e-mail.',
 30,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Participacao de Cada Categoria na Receita (SQL)',
 'Escreva a consulta que mostra a receita de cada categoria e quanto ela representa, em percentual, da receita total.',
 'Grafico de participacao e leitura obrigatoria de reuniao comercial. A questao exige comparar cada grupo com o total geral, que e outro nivel de agregacao: sem window function, o total precisa vir de uma subconsulta.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, categoria, ...).',
 'Tres colunas: categoria, receita e o percentual arredondado em duas casas, da maior participacao para a menor. A soma dos percentuais fecha em 100.',
 'categoria    | receita    | participacao
Informatica  | 128400.00  | 73.90
Perifericos  | 45300.50   | 26.10',
 'O percentual usa a receita total de todas as categorias como base, nao a receita da propria categoria.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Mes de Maior Faturamento (SQL)',
 'Escreva a consulta que devolve o mes que mais faturou e o valor faturado nele.',
 'Identificar o pico do ano orienta planejamento de estoque e de equipe. A questao junta agregacao mensal com ordenacao e limite, e mostra que nem toda pergunta de maximo se resolve com MAX quando voce tambem precisa saber a qual grupo ele pertence.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Uma unica linha com duas colunas: o mes e o faturamento.',
 'mes        | faturamento
2024-11-01 | 42800.00',
 'Considere apenas pedidos pagos. Devolva uma unica linha.',
 30,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos com Estoque Abaixo da Media da Categoria (SQL)',
 'Escreva a consulta que lista os produtos cujo estoque e menor que a media de estoque da propria categoria.',
 'Reposicao inteligente compara o produto com os pares dele, e nao com o catalogo inteiro: estoque de 5 e critico em periferico e normal em produto de alto valor. A comparacao contra a media do grupo e o coracao da questao.',
 'Tabela produtos(id, nome, categoria, preco, estoque). A coluna estoque pode ser nula.',
 'Tres colunas: categoria, nome e estoque, ordenadas por categoria e depois por estoque crescente. Produto com estoque nulo fica de fora.',
 'categoria    | nome     | estoque
Perifericos  | Webcam   | 2',
 'A media e da categoria do proprio produto, nao do catalogo inteiro.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedido com Mais Itens (SQL)',
 'Escreva a consulta que devolve o id do pedido com mais itens distintos e quantos itens ele tem.',
 'Pedido grande demais costuma indicar erro de integracao ou compra corporativa, e os dois casos merecem olhar. Repete agrupamento com ordenacao e limite, agora sobre a tabela de itens.',
 'Tabela itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario).',
 'Uma unica linha com duas colunas: id do pedido e a quantidade de itens.',
 'pedido_id | itens
455       | 14',
 'Conte itens distintos do pedido, nao a soma das quantidades.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes de Multiplas Categorias (SQL)',
 'Escreva a consulta que lista os clientes que ja compraram produtos de mais de tres categorias diferentes.',
 'Amplitude de compra separa cliente que so repete o mesmo item de quem explora o catalogo, e isso muda a estrategia de recomendacao. A questao exige contar valores distintos dentro de um grupo, que e diferente de contar linhas.',
 'Tabelas clientes, pedidos, itens_pedido e produtos, ligadas por cliente_id, pedido_id e produto_id.',
 'Duas colunas: nome do cliente e a quantidade de categorias distintas, da maior quantidade para a menor.',
 'nome       | categorias
Ana Souza  | 5',
 'Cliente com exatamente tres categorias nao entra. Conte categorias distintas, nao itens.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Receita Acumulada por Mes (SQL)',
 'Escreva a consulta que mostra o faturamento de cada mes e o acumulado do ano ate aquele mes.',
 'Acompanhar a meta anual exige o acumulado, nao so o numero do mes. E o caso classico de soma com janela: sem ela, alguem escreve uma subconsulta correlacionada que roda uma vez por linha e fica lenta assim que a tabela cresce.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Tres colunas: o mes, o faturamento do mes e o acumulado, do mes mais antigo para o mais recente.',
 'mes        | faturamento | acumulado
2024-01-01 | 15320.00    | 15320.00
2024-02-01 | 18200.00    | 33520.00',
 'Considere apenas pedidos pagos. O acumulado do primeiro mes e igual ao faturamento dele.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes Inativos ha Seis Meses (SQL)',
 'Escreva a consulta que lista os clientes cujo ultimo pedido foi ha mais de seis meses, com a data desse ultimo pedido.',
 'Base de reativacao sai daqui, e o corte por recencia e o mesmo raciocinio de churn. A questao junta agregacao com aritmetica de data, e o cuidado esta em comparar o ultimo pedido do cliente, e nao qualquer pedido dele.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, data, ...).',
 'Duas colunas: nome do cliente e a data do ultimo pedido, do mais antigo para o mais recente. Clientes sem pedido nao entram.',
 'nome        | ultimo_pedido
Carla Dias  | 2023-11-02',
 'O corte usa o ultimo pedido de cada cliente. Nao inclua quem comprou dentro dos ultimos seis meses.',
 35,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos Vendidos Abaixo do Preco Atual (SQL)',
 'Escreva a consulta que lista os itens vendidos por um preco unitario menor que o preco atual do produto.',
 'Auditoria de desconto e investigacao de erro de tabela de preco comecam por essa comparacao. Ela deixa claro por que o item guarda o proprio preco: sem isso, nao haveria como saber por quanto a venda saiu de fato.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, preco, ...).',
 'Quatro colunas: nome do produto, preco praticado, preco atual e a diferenca, da maior diferenca para a menor.',
 'nome     | praticado | atual  | diferenca
Monitor  | 799.00    | 899.00 | 100.00',
 'A diferenca e o preco atual menos o praticado, calculada na consulta.',
 30,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Consolidar Status em Grupos (SQL)',
 'Escreva a consulta que agrupa os pedidos em concluidos, em aberto e cancelados, e conta quantos existem em cada grupo.',
 'Painel executivo nao mostra dez status: mostra tres blocos. A questao usa CASE para criar uma categoria que nao existe no banco e agrupa por ela, que e o padrao de qualquer visao consolidada.',
 'Tabela pedidos(id, cliente_id, data, status, valor). O status pago conta como concluido, pendente como em aberto, e cancelado como cancelado.',
 'Duas colunas: o grupo e a quantidade de pedidos, da maior quantidade para a menor.',
 'grupo      | total
concluido  | 340
em aberto  | 55',
 'Status fora dos tres casos previstos precisa cair num grupo, sem virar nulo.',
 30,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Dias entre Pedidos do Cliente (SQL)',
 'Escreva a consulta que mostra, para cada pedido, quantos dias se passaram desde o pedido anterior do mesmo cliente.',
 'Intervalo entre compras alimenta previsao de recompra e alerta de abandono. Sem funcao de janela, isso vira um autojoin com subconsulta correlacionada; com LAG particionado por cliente, sai em uma linha.',
 'Tabelas pedidos(id, cliente_id, data, ...) e clientes(id, nome, ...).',
 'Tres colunas: nome do cliente, data do pedido e os dias desde o anterior. O primeiro pedido de cada cliente fica com o intervalo vazio.',
 'nome       | data       | dias_desde_anterior
Ana Souza  | 2024-03-01 |
Ana Souza  | 2024-03-20 | 19',
 'O calculo e por cliente: o pedido anterior de outro cliente nao serve de referencia.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos sem Venda no Ano (SQL)',
 'Escreva a consulta que lista os produtos que nao tiveram nenhuma venda em 2024, mesmo tendo vendido em anos anteriores.',
 'Encalhe recente e diferente de produto que nunca vendeu, e confundir os dois esconde o problema. A dificuldade e filtrar o periodo sem descartar os produtos que voce justamente quer encontrar: o filtro precisa entrar na condicao de juncao, e nao no WHERE.',
 'Tabelas produtos(id, nome, ...), itens_pedido(id, pedido_id, produto_id, ...) e pedidos(id, data, ...).',
 'Uma coluna com o nome do produto, em ordem alfabetica.',
 'nome
Cabo HDMI',
 'Filtrar o ano no WHERE elimina as linhas nulas do LEFT JOIN e devolve resultado vazio.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Ticket Medio por Cliente e Geral (SQL)',
 'Escreva a consulta que mostra o ticket medio de cada cliente ao lado do ticket medio geral da loja.',
 'Comparar o cliente com a media da base e o que separa relatorio descritivo de relatorio acionavel. Repete a comparacao entre dois niveis de agregacao, que e o assunto mais cobrado em entrevista de SQL de junior.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, valor, ...).',
 'Tres colunas: nome do cliente, ticket medio dele e o ticket medio geral, ambos arredondados em duas casas, do maior ticket para o menor.',
 'nome       | ticket | ticket_geral
Ana Souza  | 380.00 | 238.47',
 'O ticket geral e o mesmo em todas as linhas: ele nao depende do cliente.',
 35,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes que Nunca Cancelaram (SQL)',
 'Escreva a consulta que lista os clientes que ja compraram e nunca tiveram um pedido cancelado.',
 'Cliente sem historico de cancelamento e candidato natural a limite de credito maior. A questao mistura presenca e ausencia na mesma pergunta, e mostra por que filtrar status diferente de cancelado no WHERE devolve a resposta errada.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, status, ...).',
 'Uma coluna com o nome do cliente, em ordem alfabetica. Cliente sem nenhum pedido nao entra.',
 'nome
Bruno Lima',
 'Filtrar status diferente de cancelado traz clientes que tem um cancelado e outros pedidos. A condicao e sobre o conjunto.',
 40,
 '-- TODO: escrever a consulta
SELECT 1;')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'SQL'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Clientes com Mais de Cinco Pedidos (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e os pedidos na outra tabela.'),
('Clientes com Mais de Cinco Pedidos (SQL)', 'Filtra o grupo com HAVING', 'having', 'OBRIGATORIO', 1, 'Quantidade de pedidos so existe depois do agrupamento, entao o corte vai no HAVING.'),
('Clientes com Mais de Cinco Pedidos (SQL)', 'Agrupa por cliente', 'group\s+by', 'PONTUAVEL', 3, 'Contar por cliente exige GROUP BY.'),
('Clientes com Mais de Cinco Pedidos (SQL)', 'Aplica o corte acima de cinco', '>\s*5', 'PONTUAVEL', 3, 'O enunciado diz mais de cinco: com >= o cliente de cinco pedidos entra indevidamente.'),
('Clientes com Mais de Cinco Pedidos (SQL)', 'Ordena da maior quantidade para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do cliente com mais pedidos para o com menos.'),
('Clientes com Mais de Cinco Pedidos (SQL)', 'Nao filtre a contagem no WHERE', 'where[\s\S]*count\s*\(', 'PROIBIDO', 1, 'O WHERE roda antes do agrupamento e nao enxerga a contagem.'),

('Receita por Categoria (SQL)', 'Cruza itens com produtos', 'join', 'OBRIGATORIO', 1, 'A categoria esta em produtos e a quantidade em itens_pedido.'),
('Receita por Categoria (SQL)', 'Agrupa por categoria', 'group\s+by[\s\S]*categoria', 'OBRIGATORIO', 1, 'A receita por categoria exige GROUP BY.'),
('Receita por Categoria (SQL)', 'Calcula quantidade vezes preco', 'quantidade\s*\*|\*\s*preco_unitario', 'PONTUAVEL', 3, 'Receita nao esta gravada: e calculada linha a linha antes de somar.'),
('Receita por Categoria (SQL)', 'Soma a receita do grupo', 'sum\s*\(', 'PONTUAVEL', 3, 'SUM sobre a expressao calculada produz a receita da categoria.'),
('Receita por Categoria (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 2, 'Valor monetario nao vai para a tela com dez casas decimais.'),
('Receita por Categoria (SQL)', 'Nao use o preco atual do produto', 'p\.preco\b', 'PROIBIDO', 1, 'O preco do produto muda com o tempo: a receita usa o preco praticado na venda.'),

('Primeiro Pedido de Cada Cliente (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e a data na tabela de pedidos.'),
('Primeiro Pedido de Cada Cliente (SQL)', 'Agrupa por cliente', 'group\s+by', 'OBRIGATORIO', 1, 'A data mais antiga precisa ser calculada dentro de cada cliente.'),
('Primeiro Pedido de Cada Cliente (SQL)', 'Busca a data mais antiga', 'min\s*\(', 'PONTUAVEL', 3, 'MIN sobre a data devolve o primeiro pedido do grupo.'),
('Primeiro Pedido de Cada Cliente (SQL)', 'Agrupa tambem pelo id do cliente', 'group\s+by[\s\S]*id', 'PONTUAVEL', 3, 'Agrupar so pelo nome junta dois clientes homonimos.'),
('Primeiro Pedido de Cada Cliente (SQL)', 'Ordena pela data do primeiro pedido', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede do cliente mais antigo para o mais recente.'),
('Primeiro Pedido de Cada Cliente (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede duas colunas.'),

('Taxa de Cancelamento por Mes (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Taxa de Cancelamento por Mes (SQL)', 'Conta condicionalmente os cancelados', '(case|filter\s*\()', 'OBRIGATORIO', 1, 'CASE dentro da agregacao conta so os cancelados sem excluir as demais linhas.'),
('Taxa de Cancelamento por Mes (SQL)', 'Agrupa por mes', '(date_trunc|extract|to_char)', 'PONTUAVEL', 3, 'Agrupar pela data crua cria um grupo por dia. Recorte a data ate o mes.'),
('Taxa de Cancelamento por Mes (SQL)', 'Calcula o percentual', '(100|\*\s*100)', 'PONTUAVEL', 3, 'A proporcao vira percentual multiplicando por 100.'),
('Taxa de Cancelamento por Mes (SQL)', 'Evita a divisao inteira', '(::\s*numeric|1\.0|cast|decimal|round)', 'PONTUAVEL', 2, 'Divisao entre inteiros trunca e o percentual sai zerado.'),
('Taxa de Cancelamento por Mes (SQL)', 'Nao filtre so os cancelados', 'where[\s\S]*cancelado', 'PROIBIDO', 1, 'Filtrar no WHERE elimina os demais pedidos e o total do mes se perde.'),

('Tres Produtos Mais Vendidos por Categoria (SQL)', 'Cruza itens com produtos', 'join', 'OBRIGATORIO', 1, 'A categoria esta em produtos e a quantidade em itens_pedido.'),
('Tres Produtos Mais Vendidos por Categoria (SQL)', 'Numera as linhas dentro de cada categoria', '(row_number|rank|dense_rank)', 'OBRIGATORIO', 1, 'Top N por grupo pede funcao de janela particionada.'),
('Tres Produtos Mais Vendidos por Categoria (SQL)', 'Particiona por categoria', 'partition\s+by', 'PONTUAVEL', 3, 'PARTITION BY reinicia a numeracao a cada categoria.'),
('Tres Produtos Mais Vendidos por Categoria (SQL)', 'Ordena pelas unidades dentro da janela', 'over\s*\(', 'PONTUAVEL', 3, 'A ordenacao dentro da janela define quem sao os tres primeiros.'),
('Tres Produtos Mais Vendidos por Categoria (SQL)', 'Corta em tres por categoria', '<=\s*3', 'PONTUAVEL', 2, 'O corte usa a posicao calculada, num nivel externo a janela.'),
('Tres Produtos Mais Vendidos por Categoria (SQL)', 'Nao corte com LIMIT', 'limit', 'PROIBIDO', 1, 'LIMIT corta o resultado inteiro e devolve tres linhas no total, nao tres por categoria.'),

('Clientes que Compraram Uma Unica Vez (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e os pedidos na outra tabela.'),
('Clientes que Compraram Uma Unica Vez (SQL)', 'Filtra o grupo com HAVING', 'having', 'OBRIGATORIO', 1, 'A condicao recai sobre a quantidade do grupo, entao vai no HAVING.'),
('Clientes que Compraram Uma Unica Vez (SQL)', 'Exige exatamente um pedido', '=\s*1', 'PONTUAVEL', 3, 'O enunciado pede exatamente um pedido, nao ate um.'),
('Clientes que Compraram Uma Unica Vez (SQL)', 'Agrupa por cliente', 'group\s+by', 'PONTUAVEL', 3, 'Contar por cliente exige GROUP BY.'),
('Clientes que Compraram Uma Unica Vez (SQL)', 'Traz a data do unico pedido', '(min\s*\(|max\s*\()', 'PONTUAVEL', 2, 'Com um pedido so, MIN e MAX devolvem a mesma data, e a coluna precisa ser agregada.'),
('Clientes que Compraram Uma Unica Vez (SQL)', 'Nao filtre a contagem no WHERE', 'where[\s\S]*count\s*\(', 'PROIBIDO', 1, 'O WHERE roda antes do agrupamento e nao enxerga a contagem.'),

('Categorias Acima da Receita Media (SQL)', 'Calcula a receita por categoria', 'group\s+by[\s\S]*categoria', 'OBRIGATORIO', 1, 'A receita de cada categoria precisa existir antes de qualquer comparacao.'),
('Categorias Acima da Receita Media (SQL)', 'Usa CTE ou subconsulta', '(with|\(\s*select)', 'OBRIGATORIO', 1, 'A media entre categorias so existe depois que as receitas foram calculadas.'),
('Categorias Acima da Receita Media (SQL)', 'Soma quantidade vezes preco', 'sum\s*\(', 'PONTUAVEL', 3, 'A receita sai da soma de quantidade vezes preco unitario.'),
('Categorias Acima da Receita Media (SQL)', 'Compara com a media das receitas', 'avg\s*\(', 'PONTUAVEL', 3, 'A media e calculada sobre as receitas ja agrupadas, nao sobre os itens.'),
('Categorias Acima da Receita Media (SQL)', 'Ordena da maior receita para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede da maior receita para a menor.'),
('Categorias Acima da Receita Media (SQL)', 'Nao compare com a media dos itens', 'having[\s\S]*avg\s*\(\s*quantidade', 'PROIBIDO', 1, 'A media pedida e entre categorias, nao entre linhas de item.'),

('Ranking de Clientes por Gasto (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e o valor na tabela de pedidos.'),
('Ranking de Clientes por Gasto (SQL)', 'Calcula a posicao com funcao de janela', '(rank|dense_rank|row_number)', 'OBRIGATORIO', 1, 'A posicao no ranking sai de uma funcao de janela.'),
('Ranking de Clientes por Gasto (SQL)', 'Da a mesma posicao a quem empata', '(rank\s*\(|dense_rank)', 'PONTUAVEL', 3, 'ROW_NUMBER desempata de forma arbitraria: com empate, o certo e RANK.'),
('Ranking de Clientes por Gasto (SQL)', 'Soma o gasto de cada cliente', 'sum\s*\(', 'PONTUAVEL', 3, 'O criterio do ranking e o total gasto.'),
('Ranking de Clientes por Gasto (SQL)', 'Ordena a janela pelo gasto decrescente', 'over\s*\(', 'PONTUAVEL', 2, 'A ordenacao dentro do OVER define quem fica em primeiro.'),
('Ranking de Clientes por Gasto (SQL)', 'Nao numere sem tratar empate', 'row_number', 'PROIBIDO', 1, 'ROW_NUMBER da posicoes diferentes para clientes que gastaram o mesmo valor.'),

('Faturamento Mes a Mes com Comparativo (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Faturamento Mes a Mes com Comparativo (SQL)', 'Busca o valor do mes anterior', '(lag\s*\(|lead\s*\()', 'OBRIGATORIO', 1, 'LAG olha para a linha anterior sem precisar de autojoin.'),
('Faturamento Mes a Mes com Comparativo (SQL)', 'Agrupa por mes', '(date_trunc|extract|to_char)', 'PONTUAVEL', 3, 'O faturamento e mensal, entao a data precisa ser recortada ate o mes.'),
('Faturamento Mes a Mes com Comparativo (SQL)', 'Soma o faturamento do mes', 'sum\s*\(', 'PONTUAVEL', 3, 'SUM sobre valor produz o faturamento do periodo.'),
('Faturamento Mes a Mes com Comparativo (SQL)', 'Considera apenas pedidos pagos', 'pago', 'PONTUAVEL', 2, 'Pedido cancelado nao entra no faturamento.'),
('Faturamento Mes a Mes com Comparativo (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Media de Itens por Pedido (SQL)', 'Consulta a tabela de itens', 'from\s+itens_pedido', 'OBRIGATORIO', 1, 'A contagem de itens sai de itens_pedido.'),
('Media de Itens por Pedido (SQL)', 'Agrega em dois niveis', '(with|\(\s*select)', 'OBRIGATORIO', 1, 'Primeiro conta-se por pedido; a media dessas contagens vem depois.'),
('Media de Itens por Pedido (SQL)', 'Conta os itens de cada pedido', 'count\s*\(', 'PONTUAVEL', 3, 'A contagem por pedido e o passo interno.'),
('Media de Itens por Pedido (SQL)', 'Calcula a media das contagens', 'avg\s*\(', 'PONTUAVEL', 3, 'A media e calculada sobre o resultado do agrupamento, nao sobre as linhas cruas.'),
('Media de Itens por Pedido (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 2, 'A media crua sai com muitas casas decimais.'),
('Media de Itens por Pedido (SQL)', 'Nao divida contagem por contagem direto', 'count\s*\([\s\S]{0,40}\)\s*/\s*count', 'PROIBIDO', 1, 'Dividir duas contagens na mesma consulta ignora os pedidos e devolve outro numero.'),

('E-mails Duplicados no Cadastro (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('E-mails Duplicados no Cadastro (SQL)', 'Filtra o grupo com HAVING', 'having', 'OBRIGATORIO', 1, 'Duplicidade e uma condicao sobre a contagem do grupo.'),
('E-mails Duplicados no Cadastro (SQL)', 'Agrupa por e-mail', 'group\s+by[\s\S]*email', 'PONTUAVEL', 3, 'O agrupamento e por e-mail, que e o que pode se repetir.'),
('E-mails Duplicados no Cadastro (SQL)', 'Exige mais de um cadastro', '>\s*1', 'PONTUAVEL', 3, 'Duplicado significa dois ou mais: a condicao e maior que 1.'),
('E-mails Duplicados no Cadastro (SQL)', 'Descarta o e-mail nulo', '(is\s+not\s+null|not\s+null)', 'PONTUAVEL', 2, 'Varios clientes sem e-mail nao sao duplicidade, sao cadastro incompleto.'),
('E-mails Duplicados no Cadastro (SQL)', 'Nao use DISTINCT no lugar do agrupamento', 'select\s+distinct', 'PROIBIDO', 1, 'DISTINCT esconde a repeticao; a questao pede justamente contar quantas vezes ela ocorre.'),

('Participacao de Cada Categoria na Receita (SQL)', 'Cruza itens com produtos', 'join', 'OBRIGATORIO', 1, 'A categoria esta em produtos e a quantidade em itens_pedido.'),
('Participacao de Cada Categoria na Receita (SQL)', 'Compara o grupo com o total geral', '(over\s*\(|with|\(\s*select)', 'OBRIGATORIO', 1, 'O total de todas as categorias e outro nivel de agregacao: vem de janela, CTE ou subconsulta.'),
('Participacao de Cada Categoria na Receita (SQL)', 'Soma a receita por categoria', 'sum\s*\(', 'PONTUAVEL', 3, 'A receita da categoria sai de SUM sobre quantidade vezes preco.'),
('Participacao de Cada Categoria na Receita (SQL)', 'Calcula o percentual', '(100|\*\s*100)', 'PONTUAVEL', 3, 'A proporcao vira percentual multiplicando por 100.'),
('Participacao de Cada Categoria na Receita (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 2, 'Percentual com dez casas decimais nao vai para a tela.'),
('Participacao de Cada Categoria na Receita (SQL)', 'Nao divida a receita por ela mesma', 'sum\s*\([^)]*\)\s*/\s*sum\s*\(\s*quantidade', 'PROIBIDO', 1, 'A base do percentual e a receita total, nao a da propria categoria.'),

('Mes de Maior Faturamento (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Mes de Maior Faturamento (SQL)', 'Agrupa por mes', '(date_trunc|extract|to_char)', 'OBRIGATORIO', 1, 'O faturamento e mensal: a data precisa ser recortada ate o mes.'),
('Mes de Maior Faturamento (SQL)', 'Soma o faturamento do mes', 'sum\s*\(', 'PONTUAVEL', 3, 'SUM sobre valor produz o faturamento do periodo.'),
('Mes de Maior Faturamento (SQL)', 'Ordena do maior faturamento para o menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'O mes de pico fica no topo depois da ordenacao decrescente.'),
('Mes de Maior Faturamento (SQL)', 'Devolve uma unica linha', '(limit\s*1|fetch\s+first|top\s+1)', 'PONTUAVEL', 2, 'O enunciado pede um mes so.'),
('Mes de Maior Faturamento (SQL)', 'Nao filtre um mes especifico', 'where[\s\S]*data\s*=', 'PROIBIDO', 1, 'O mes de pico precisa ser descoberto pela consulta, nao informado nela.'),

('Produtos com Estoque Abaixo da Media da Categoria (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos com Estoque Abaixo da Media da Categoria (SQL)', 'Compara com a media do grupo', '(over\s*\(|\(\s*select|with)', 'OBRIGATORIO', 1, 'A media da categoria vem de janela, CTE ou subconsulta correlacionada.'),
('Produtos com Estoque Abaixo da Media da Categoria (SQL)', 'Calcula a media do estoque', 'avg\s*\(', 'PONTUAVEL', 3, 'AVG sobre estoque produz a media de referencia.'),
('Produtos com Estoque Abaixo da Media da Categoria (SQL)', 'Restringe a media a propria categoria', '(partition\s+by|categoria\s*=|group\s+by[\s\S]*categoria)', 'PONTUAVEL', 3, 'A media precisa ser da categoria do produto, nao do catalogo inteiro.'),
('Produtos com Estoque Abaixo da Media da Categoria (SQL)', 'Descarta o estoque nulo', '(is\s+not\s+null|not\s+null)', 'PONTUAVEL', 2, 'Produto sem estoque informado nao pode ser comparado com media nenhuma.'),
('Produtos com Estoque Abaixo da Media da Categoria (SQL)', 'Nao compare com a media geral', 'avg\s*\(\s*estoque\s*\)\s*from\s+produtos\s*\)', 'PROIBIDO', 1, 'A media do catalogo inteiro mistura categorias de perfis muito diferentes.'),

('Pedido com Mais Itens (SQL)', 'Consulta a tabela de itens', 'from\s+itens_pedido', 'OBRIGATORIO', 1, 'A contagem de itens sai de itens_pedido.'),
('Pedido com Mais Itens (SQL)', 'Agrupa por pedido', 'group\s+by[\s\S]*pedido_id', 'OBRIGATORIO', 1, 'Contar itens por pedido exige GROUP BY.'),
('Pedido com Mais Itens (SQL)', 'Conta os itens do pedido', 'count\s*\(', 'PONTUAVEL', 3, 'A pergunta e quantos itens, entao a agregacao e COUNT.'),
('Pedido com Mais Itens (SQL)', 'Ordena da maior contagem para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'O pedido com mais itens fica no topo.'),
('Pedido com Mais Itens (SQL)', 'Devolve uma unica linha', '(limit\s*1|fetch\s+first|top\s+1)', 'PONTUAVEL', 2, 'O enunciado pede um pedido so.'),
('Pedido com Mais Itens (SQL)', 'Nao some quantidades no lugar de contar', 'sum\s*\(\s*quantidade', 'PROIBIDO', 1, 'Somar quantidade responde quantas unidades, e a pergunta e quantos itens distintos.'),

('Clientes de Multiplas Categorias (SQL)', 'Atravessa as quatro tabelas', 'join[\s\S]*join[\s\S]*join', 'OBRIGATORIO', 1, 'Do cliente ate a categoria sao tres juncoes: pedidos, itens e produtos.'),
('Clientes de Multiplas Categorias (SQL)', 'Conta categorias distintas', 'count\s*\(\s*distinct', 'OBRIGATORIO', 1, 'Sem DISTINCT, a contagem soma itens repetidos da mesma categoria.'),
('Clientes de Multiplas Categorias (SQL)', 'Agrupa por cliente', 'group\s+by', 'PONTUAVEL', 3, 'A contagem acontece dentro de cada cliente.'),
('Clientes de Multiplas Categorias (SQL)', 'Filtra o grupo com HAVING', 'having', 'PONTUAVEL', 3, 'A condicao recai sobre a contagem do grupo.'),
('Clientes de Multiplas Categorias (SQL)', 'Exige mais de tres categorias', '>\s*3', 'PONTUAVEL', 2, 'O enunciado diz mais de tres: com >= entra quem tem exatamente tres.'),
('Clientes de Multiplas Categorias (SQL)', 'Nao conte linhas no lugar de categorias', 'count\s*\(\s*\*\s*\)', 'PROIBIDO', 1, 'COUNT(*) conta itens comprados, nao categorias diferentes.'),

('Receita Acumulada por Mes (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Receita Acumulada por Mes (SQL)', 'Calcula o acumulado com janela', 'over\s*\(', 'OBRIGATORIO', 1, 'A soma acumulada sai de SUM com OVER, sem subconsulta por linha.'),
('Receita Acumulada por Mes (SQL)', 'Ordena a janela pelo mes', 'over\s*\([\s\S]{0,60}order\s+by', 'PONTUAVEL', 3, 'Sem ORDER BY dentro do OVER, a soma nao acumula: ela repete o total.'),
('Receita Acumulada por Mes (SQL)', 'Agrupa o faturamento por mes', '(date_trunc|extract|to_char)', 'PONTUAVEL', 3, 'O acumulado e mensal, entao a base precisa estar agrupada por mes.'),
('Receita Acumulada por Mes (SQL)', 'Considera apenas pedidos pagos', 'pago', 'PONTUAVEL', 2, 'Pedido cancelado nao entra no faturamento.'),
('Receita Acumulada por Mes (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Clientes Inativos ha Seis Meses (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e a data na tabela de pedidos.'),
('Clientes Inativos ha Seis Meses (SQL)', 'Busca o ultimo pedido de cada cliente', 'max\s*\(', 'OBRIGATORIO', 1, 'MAX sobre a data devolve o pedido mais recente do cliente.'),
('Clientes Inativos ha Seis Meses (SQL)', 'Aplica o corte por recencia', '(interval|months|current_date|now\s*\()', 'PONTUAVEL', 3, 'O corte compara a data com a de hoje menos seis meses.'),
('Clientes Inativos ha Seis Meses (SQL)', 'Filtra o grupo com HAVING', 'having', 'PONTUAVEL', 3, 'A condicao recai sobre o MAX do grupo, entao vai no HAVING.'),
('Clientes Inativos ha Seis Meses (SQL)', 'Agrupa por cliente', 'group\s+by', 'PONTUAVEL', 2, 'O ultimo pedido precisa ser calculado dentro de cada cliente.'),
('Clientes Inativos ha Seis Meses (SQL)', 'Nao filtre pedido a pedido no WHERE', 'where[\s\S]*data\s*<[\s\S]*interval', 'PROIBIDO', 1, 'Filtrar por pedido traz quem comprou ontem e tambem ha um ano.'),

('Produtos Vendidos Abaixo do Preco Atual (SQL)', 'Cruza itens com produtos', 'join\s+produtos', 'OBRIGATORIO', 1, 'O preco atual esta em produtos e o praticado em itens_pedido.'),
('Produtos Vendidos Abaixo do Preco Atual (SQL)', 'Compara os dois precos', 'preco_unitario\s*<|<\s*\w*\.?preco\b', 'OBRIGATORIO', 1, 'A comparacao e entre o preco praticado e o preco atual do produto.'),
('Produtos Vendidos Abaixo do Preco Atual (SQL)', 'Calcula a diferenca', '-', 'PONTUAVEL', 3, 'A diferenca e o preco atual menos o praticado.'),
('Produtos Vendidos Abaixo do Preco Atual (SQL)', 'Nomeia a coluna calculada', '\bas\b', 'PONTUAVEL', 3, 'Coluna calculada sem alias sai ilegivel no relatorio.'),
('Produtos Vendidos Abaixo do Preco Atual (SQL)', 'Ordena da maior diferenca para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede da maior diferenca para a menor.'),
('Produtos Vendidos Abaixo do Preco Atual (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede quatro colunas especificas.'),

('Consolidar Status em Grupos (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Consolidar Status em Grupos (SQL)', 'Cria o grupo com CASE', 'case', 'OBRIGATORIO', 1, 'O grupo consolidado nao existe no banco: CASE o constroi.'),
('Consolidar Status em Grupos (SQL)', 'Mapeia os tres status conhecidos', '(pago[\s\S]*pendente|pendente[\s\S]*cancelado)', 'PONTUAVEL', 3, 'Os tres status previstos precisam aparecer no mapeamento.'),
('Consolidar Status em Grupos (SQL)', 'Agrupa pelo grupo criado', 'group\s+by', 'PONTUAVEL', 3, 'A contagem acontece sobre a categoria construida pelo CASE.'),
('Consolidar Status em Grupos (SQL)', 'Trata o status fora dos casos previstos', 'else', 'PONTUAVEL', 2, 'CASE sem ELSE devolve nulo para status novo, e o grupo some do relatorio.'),
('Consolidar Status em Grupos (SQL)', 'Nao filtre status no WHERE', 'where[\s\S]*status', 'PROIBIDO', 1, 'O enunciado pede todos os pedidos distribuidos nos tres grupos.'),

('Dias entre Pedidos do Cliente (SQL)', 'Cruza pedidos com clientes', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e as datas na tabela de pedidos.'),
('Dias entre Pedidos do Cliente (SQL)', 'Busca a data do pedido anterior', 'lag\s*\(', 'OBRIGATORIO', 1, 'LAG olha a linha anterior sem autojoin.'),
('Dias entre Pedidos do Cliente (SQL)', 'Particiona por cliente', 'partition\s+by', 'PONTUAVEL', 3, 'Sem PARTITION BY, o pedido anterior pode ser de outro cliente.'),
('Dias entre Pedidos do Cliente (SQL)', 'Ordena a janela pela data', 'over\s*\([\s\S]{0,80}order\s+by', 'PONTUAVEL', 3, 'A ordem dentro da janela define o que e o pedido anterior.'),
('Dias entre Pedidos do Cliente (SQL)', 'Calcula a diferenca em dias', '-', 'PONTUAVEL', 2, 'A diferenca entre as duas datas devolve os dias decorridos.'),
('Dias entre Pedidos do Cliente (SQL)', 'Nao ordene sem particionar', 'over\s*\(\s*order\s+by', 'PROIBIDO', 1, 'Janela sem particao mistura os pedidos de todos os clientes numa fila so.'),

('Produtos sem Venda no Ano (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta parte de produtos, que e o lado a preservar.'),
('Produtos sem Venda no Ano (SQL)', 'Preserva os produtos sem venda no periodo', '(left\s+join|not\s+exists)', 'OBRIGATORIO', 1, 'JOIN comum descarta exatamente os produtos procurados.'),
('Produtos sem Venda no Ano (SQL)', 'Coloca o filtro do ano na juncao', '(on[\s\S]*2024|and[\s\S]*2024)', 'PONTUAVEL', 3, 'O filtro do ano precisa entrar na condicao de juncao, junto do ON.'),
('Produtos sem Venda no Ano (SQL)', 'Testa a ausencia depois da juncao', 'is\s+null', 'PONTUAVEL', 3, 'Depois do LEFT JOIN, a ausencia aparece como NULL.'),
('Produtos sem Venda no Ano (SQL)', 'Ordena por nome', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica.'),
('Produtos sem Venda no Ano (SQL)', 'Nao filtre o ano no WHERE', 'where[\s\S]*2024', 'PROIBIDO', 1, 'Filtrar o ano no WHERE elimina as linhas nulas do LEFT JOIN e o resultado vem vazio.'),

('Ticket Medio por Cliente e Geral (SQL)', 'Cruza clientes com pedidos', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e o valor na tabela de pedidos.'),
('Ticket Medio por Cliente e Geral (SQL)', 'Traz a media geral junto da media do cliente', '(over\s*\(\s*\)|\(\s*select|with)', 'OBRIGATORIO', 1, 'O ticket geral e outro nivel de agregacao: janela sem particao, CTE ou subconsulta.'),
('Ticket Medio por Cliente e Geral (SQL)', 'Calcula a media por cliente', 'avg\s*\(', 'PONTUAVEL', 3, 'AVG sobre valor produz o ticket do cliente.'),
('Ticket Medio por Cliente e Geral (SQL)', 'Agrupa por cliente', 'group\s+by', 'PONTUAVEL', 3, 'A media por cliente exige GROUP BY.'),
('Ticket Medio por Cliente e Geral (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 2, 'Valor monetario nao vai para a tela com dez casas decimais.'),
('Ticket Medio por Cliente e Geral (SQL)', 'Nao repita a media do cliente na coluna geral', 'avg\s*\([^)]*\)\s+as\s+ticket_geral', 'PROIBIDO', 1, 'O ticket geral e o mesmo em todas as linhas: ele nao depende do cliente.'),

('Clientes que Nunca Cancelaram (SQL)', 'Cruza clientes com pedidos', '(join|exists)', 'OBRIGATORIO', 1, 'E preciso olhar os pedidos para saber quem ja comprou.'),
('Clientes que Nunca Cancelaram (SQL)', 'Exclui quem tem algum cancelado', '(not\s+exists|not\s+in|having)', 'OBRIGATORIO', 1, 'A condicao e sobre o conjunto de pedidos do cliente, nao sobre um pedido.'),
('Clientes que Nunca Cancelaram (SQL)', 'Exige ao menos um pedido', '(join|exists|count)', 'PONTUAVEL', 3, 'Cliente sem pedido nenhum nao entra no resultado.'),
('Clientes que Nunca Cancelaram (SQL)', 'Cita o status cancelado', 'cancelado', 'PONTUAVEL', 3, 'O status excluido e cancelado.'),
('Clientes que Nunca Cancelaram (SQL)', 'Ordena por nome', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica.'),
('Clientes que Nunca Cancelaram (SQL)', 'Nao filtre status diferente de cancelado', '(status\s*<>\s*.cancelado|status\s*!=\s*.cancelado)', 'PROIBIDO', 1, 'Esse filtro traz o cliente que tem um cancelado e outros pedidos normais.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'SQL'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
