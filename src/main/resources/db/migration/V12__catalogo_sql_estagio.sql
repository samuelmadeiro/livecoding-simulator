-- Catalogo SQL, nivel estagio: 50 questoes de consulta.
--
-- Todas as questoes usam o mesmo banco ficticio de e-commerce, descrito no formato_entrada de cada
-- uma. Repetir o mesmo esquema entre as questoes e proposital: o candidato aprende as tabelas uma
-- vez e passa a gastar o tempo pensando na consulta, como acontece num time de verdade.
--
--   clientes(id, nome, email, cidade, estado, criado_em)
--   produtos(id, nome, categoria, preco, estoque)
--   pedidos(id, cliente_id, data, status, valor)
--   itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario)
--
-- Como nas demais trilhas, o titulo leva o sufixo da tecnologia para nao colidir com questoes
-- homonimas de Python ou Java, e o INSERT de criterios filtra pela tecnologia.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'ESTAGIO', 'BANCO_DADOS', v.tempo, v.template, t.id
FROM (VALUES

('Clientes de um Estado (SQL)',
 'Escreva a consulta que lista o nome e o e-mail dos clientes do estado SP, em ordem alfabetica de nome.',
 'Filtrar por regiao e o recorte mais pedido por time comercial. A questao existe para ver se a pessoa escreve WHERE e ORDER BY na ordem certa e se seleciona apenas as colunas pedidas, em vez de despejar a tabela inteira na rede.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna estado guarda a sigla em maiusculas.',
 'Duas colunas, nome e email, ordenadas por nome em ordem crescente.',
 'nome        | email
Ana Souza   | ana@exemplo.com
Bruno Lima  | bruno@exemplo.com',
 'Selecione apenas as duas colunas pedidas, sem SELECT *.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos Acima de Um Preco (SQL)',
 'Escreva a consulta que lista nome e preco dos produtos com preco maior que 100, do mais caro para o mais barato.',
 'Toda vitrine tem filtro de faixa de preco e ordenacao. O detalhe avaliado e o DESC: sem ele, o cliente ve o produto mais barato primeiro, que e o contrario do que a area de negocio pediu.',
 'Tabela produtos(id, nome, categoria, preco, estoque). A coluna preco e numerica e nunca nula.',
 'Duas colunas, nome e preco, ordenadas por preco em ordem decrescente.',
 'nome     | preco
Monitor  | 899.00
Teclado  | 250.00',
 'Preco exatamente igual a 100 nao entra no resultado. Sem SELECT *.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Contar Clientes por Estado (SQL)',
 'Escreva a consulta que devolve quantos clientes existem em cada estado, do estado com mais clientes para o com menos.',
 'E o primeiro relatorio agregado que qualquer pessoa escreve, e o primeiro lugar onde se descobre o GROUP BY. O erro classico e colocar no SELECT uma coluna que nao esta no agrupamento e nao entender por que o banco reclama.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em).',
 'Duas colunas: estado e a quantidade de clientes, ordenadas pela quantidade em ordem decrescente.',
 'estado | total
SP     | 120
MG     | 45',
 'Todo estado presente na tabela precisa aparecer, mesmo com um unico cliente.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Total de Pedidos por Cliente (SQL)',
 'Escreva a consulta que mostra o nome do cliente e quanto ele ja gastou somando o valor dos pedidos.',
 'E a base da curva ABC de clientes. A questao junta JOIN com agregacao, que e onde a maioria trava: agrupar pelo nome do cliente e nao pelo id parece funcionar ate existirem dois clientes com o mesmo nome.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, data, status, valor).',
 'Duas colunas: nome do cliente e o total gasto, do maior total para o menor.',
 'nome       | total
Ana Souza  | 1520.00
Bruno Lima | 890.00',
 'Clientes sem pedido podem ficar de fora nesta versao. Agrupe pelo id do cliente, nao apenas pelo nome.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos de um Periodo (SQL)',
 'Escreva a consulta que lista id, data e valor dos pedidos feitos em 2024, do mais recente para o mais antigo.',
 'Fechamento mensal e anual sempre passa por um recorte de data. O que se avalia e escrever o intervalo sem cortar o ultimo dia do periodo, erro que faz o relatorio de dezembro perder as vendas do dia 31.',
 'Tabela pedidos(id, cliente_id, data, status, valor). A coluna data e do tipo DATE.',
 'Tres colunas: id, data e valor, ordenadas por data em ordem decrescente.',
 'id  | data       | valor
991 | 2024-12-31 | 350.00
812 | 2024-03-02 | 120.00',
 'O intervalo precisa incluir 1 de janeiro e 31 de dezembro de 2024.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos sem Estoque (SQL)',
 'Escreva a consulta que lista o nome dos produtos com estoque zerado ou nulo.',
 'Alerta de reposicao nasce dessa consulta. Ela existe para ensinar que nulo nao e zero: comparar estoque com zero deixa de fora justamente o produto cujo estoque nunca foi preenchido, que e o mais critico.',
 'Tabela produtos(id, nome, categoria, preco, estoque). A coluna estoque pode ser nula.',
 'Uma coluna com o nome do produto, em ordem alfabetica.',
 'nome
Cabo HDMI
Webcam',
 'Produto com estoque nulo tambem precisa aparecer. Lembre que estoque = NULL nunca e verdadeiro.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Buscar Cliente por Nome (SQL)',
 'Escreva a consulta que lista os clientes cujo nome contem a palavra silva, em qualquer posicao e sem diferenciar maiusculas.',
 'E a busca do campo de pesquisa de qualquer sistema. A questao mostra a diferenca entre igualdade e busca parcial, e por que a comparacao precisa ignorar a caixa para o usuario nao achar que o cadastro sumiu.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em).',
 'Duas colunas, id e nome, em ordem alfabetica de nome.',
 'id | nome
12 | Ana da Silva
30 | SILVA JUNIOR',
 'A busca precisa achar o termo no meio do nome e ignorar maiuscula e minuscula.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Dez Produtos Mais Caros (SQL)',
 'Escreva a consulta que devolve os dez produtos mais caros, com nome e preco.',
 'Vitrine de destaques e relatorio de top N vivem disso. E onde entra a conversa sobre limitar o resultado no banco em vez de trazer tudo e cortar na aplicacao, que e o que trava sistema quando a tabela cresce.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Duas colunas, nome e preco, ordenadas do maior preco para o menor, no maximo dez linhas.',
 'nome     | preco
Notebook | 4500.00
Monitor  | 899.00',
 'O corte precisa acontecer no banco, com LIMIT. Sem SELECT *.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Categorias Distintas (SQL)',
 'Escreva a consulta que lista as categorias de produto existentes, sem repetir nenhuma.',
 'Alimentar um filtro de tela costuma comecar assim. E a questao que apresenta o DISTINCT e a conversa seguinte: quando ele resolve o problema e quando ele so esconde uma consulta mal escrita.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Uma coluna com o nome da categoria, sem repeticoes, em ordem alfabetica.',
 'categoria
Informatica
Perifericos',
 'Nenhuma categoria pode aparecer duas vezes.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Preco Medio por Categoria (SQL)',
 'Escreva a consulta que mostra o preco medio dos produtos de cada categoria, com duas casas decimais.',
 'Comparar categorias e rotina de time de precificacao. A questao junta agregacao com arredondamento, e mostra por que a media crua, com dez casas decimais, nunca vai direto para a tela.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Duas colunas: categoria e o preco medio arredondado em duas casas, ordenadas da maior media para a menor.',
 'categoria    | media
Informatica  | 2100.50
Perifericos  | 180.75',
 'O resultado precisa vir arredondado em duas casas decimais.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos com o Nome do Cliente (SQL)',
 'Escreva a consulta que lista o id do pedido, a data e o nome do cliente que fez o pedido.',
 'E o JOIN mais basico e o mais usado: trazer a descricao junto do id para o relatorio ficar legivel. Sem ele, a tela mostra cliente 4712 em vez do nome, e ninguem consegue conferir nada.',
 'Tabelas pedidos(id, cliente_id, data, status, valor) e clientes(id, nome, ...).',
 'Tres colunas: id do pedido, data e nome do cliente, ordenadas por data em ordem decrescente.',
 'id  | data       | nome
991 | 2024-12-31 | Ana Souza
812 | 2024-03-02 | Bruno Lima',
 'Use JOIN entre as duas tabelas. Nao escreva o cruzamento com virgula no FROM.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos Cancelados (SQL)',
 'Escreva a consulta que conta quantos pedidos estao com status cancelado.',
 'Indicador de cancelamento aparece em todo painel. A questao e curta de proposito: o foco e escrever COUNT com filtro e entender que contar linhas e diferente de somar valores.',
 'Tabela pedidos(id, cliente_id, data, status, valor). A coluna status guarda textos como pago, pendente e cancelado.',
 'Uma unica linha com uma coluna: a quantidade de pedidos cancelados. Nenhum cancelado devolve 0.',
 'total
7',
 'A consulta devolve uma linha mesmo quando nao ha nenhum cancelado.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Faturamento do Mes (SQL)',
 'Escreva a consulta que soma o valor dos pedidos pagos de janeiro de 2024.',
 'E o numero que a diretoria pede toda segunda-feira. Junta filtro por status e por periodo numa consulta so, e mostra se a pessoa sabe que SUM ignora nulo mas devolve nulo quando nenhuma linha passa no filtro.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Uma unica linha com o total faturado no periodo, considerando apenas pedidos com status pago.',
 'faturamento
15320.00',
 'Somente pedidos pagos entram na soma. O intervalo cobre o mes inteiro de janeiro.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Ticket Medio dos Pedidos (SQL)',
 'Escreva a consulta que devolve o valor medio dos pedidos pagos, arredondado em duas casas.',
 'Ticket medio e um dos primeiros indicadores que qualquer loja acompanha. A questao mostra a diferenca entre AVG e somar dividindo na mao, e por que filtrar antes de agregar muda o numero que a diretoria le.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Uma unica linha com o valor medio dos pedidos pagos, com duas casas decimais.',
 'ticket_medio
238.47',
 'Somente pedidos com status pago entram na media. Arredonde em duas casas.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Maior e Menor Preco (SQL)',
 'Escreva a consulta que devolve, numa unica linha, o menor e o maior preco do catalogo.',
 'Alimentar o filtro de faixa de preco da vitrine pede exatamente esses dois numeros. A questao ensina que varias agregacoes cabem no mesmo SELECT, sem precisar de duas consultas e duas idas ao banco.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Uma unica linha com duas colunas: menor preco e maior preco.',
 'menor  | maior
19.90  | 4500.00',
 'Resolva com uma unica consulta, sem UNION.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos numa Faixa de Valor (SQL)',
 'Escreva a consulta que lista id e valor dos pedidos com valor entre 100 e 500, incluindo os limites.',
 'Faixa de valor aparece em regra de comissao e em analise de fraude. O ponto avaliado e o "incluindo os limites": trocar BETWEEN por comparacoes estritas deixa de fora justamente os pedidos que estao na fronteira da regra.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Duas colunas, id e valor, ordenadas por valor em ordem crescente. Pedido de exatamente 100 ou 500 entra no resultado.',
 'id  | valor
812 | 100.00
991 | 500.00',
 'Os dois limites entram no resultado. Sem SELECT *.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes sem E-mail (SQL)',
 'Escreva a consulta que lista o id e o nome dos clientes que nao tem e-mail cadastrado.',
 'Antes de disparar campanha alguem precisa saber quem nao vai receber nada. E o segundo encontro com NULL: campo vazio e campo nulo sao coisas diferentes no banco, e a consulta precisa cobrir as duas.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna email pode ser nula ou conter string vazia.',
 'Duas colunas, id e nome, em ordem alfabetica de nome.',
 'id | nome
44 | Carla Dias',
 'Considere tanto e-mail nulo quanto e-mail em branco. Lembre que email = NULL nunca e verdadeiro.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Total de Itens Vendidos (SQL)',
 'Escreva a consulta que devolve quantas unidades foram vendidas ao todo, somando a quantidade dos itens.',
 'Quantidade vendida e volume, valor vendido e receita: sao numeros diferentes e confundi-los ja causou muito relatorio errado. A questao existe para fixar que somar quantidade nao e contar linhas.',
 'Tabela itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario).',
 'Uma unica linha com o total de unidades vendidas.',
 'unidades
3820',
 'Some a quantidade, nao conte as linhas da tabela.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos por Status (SQL)',
 'Escreva a consulta que mostra quantos pedidos existem em cada status, do status mais frequente para o menos frequente.',
 'E o grafico de pizza de todo painel operacional. Repete o GROUP BY, agora sobre uma coluna de texto, e reforca a ordenacao por uma coluna calculada em vez de por uma coluna da tabela.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Duas colunas: status e a quantidade, da maior quantidade para a menor.',
 'status    | total
pago      | 340
pendente  | 55',
 'Todos os status presentes na tabela precisam aparecer.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos de Categorias Especificas (SQL)',
 'Escreva a consulta que lista nome e categoria dos produtos das categorias Informatica e Perifericos.',
 'Filtro de multipla escolha na tela vira uma lista de valores na consulta. A questao apresenta o IN e mostra por que ele e mais legivel do que encadear varios OR quando a lista cresce.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Duas colunas, nome e categoria, ordenadas por categoria e depois por nome.',
 'nome     | categoria
Notebook | Informatica
Teclado  | Perifericos',
 'Use uma lista de valores em vez de varios OR encadeados.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes Cadastrados no Ano (SQL)',
 'Escreva a consulta que conta quantos clientes foram cadastrados em 2024.',
 'Crescimento da base e o indicador que abre toda reuniao de resultado. A questao repete o recorte por data, agora sobre uma coluna de data e hora, onde comparar so a data deixa de fora os cadastros do ultimo dia.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna criado_em guarda data e hora.',
 'Uma unica linha com a quantidade de clientes cadastrados no ano.',
 'novos_clientes
187',
 'O intervalo precisa incluir os cadastros feitos ao longo de 31 de dezembro, nao so a meia-noite.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Renomear Colunas do Relatorio (SQL)',
 'Escreva a consulta que lista os produtos com as colunas renomeadas para produto e valor.',
 'Relatorio exportado para a area de negocio nao pode sair com nome tecnico de coluna. Alias e a forma mais barata de deixar o resultado legivel sem mexer no esquema do banco.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Duas colunas chamadas produto e valor, em ordem alfabetica de produto.',
 'produto  | valor
Monitor  | 899.00
Teclado  | 250.00',
 'Os nomes das colunas no resultado precisam ser produto e valor.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Nome e Cidade Juntos (SQL)',
 'Escreva a consulta que devolve uma unica coluna com o nome do cliente seguido da cidade entre parenteses.',
 'Etiqueta de envio e campo de busca costumam juntar informacao de varias colunas. A armadilha e a concatenacao com NULL: no SQL padrao, juntar texto com nulo devolve nulo e a linha inteira sai vazia.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna cidade pode ser nula.',
 'Uma unica coluna chamada identificacao, no formato Nome (Cidade). Cliente sem cidade nao pode virar linha vazia.',
 'identificacao
Ana Souza (Campinas)',
 'Cliente com cidade nula precisa continuar aparecendo com o nome.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Ultimos Pedidos Cadastrados (SQL)',
 'Escreva a consulta que mostra os cinco pedidos mais recentes, com id, data e valor.',
 'A tela inicial de qualquer sistema mostra os ultimos registros. Junta ordenacao com limite e e a base de qualquer feed de atividade recente.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Tres colunas, id, data e valor, do pedido mais recente para o mais antigo, no maximo cinco linhas.',
 'id  | data       | valor
991 | 2024-12-31 | 350.00',
 'Ordene antes de limitar: LIMIT sem ORDER BY devolve linhas quaisquer.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos com Estoque Baixo (SQL)',
 'Escreva a consulta que lista nome e estoque dos produtos com menos de 10 unidades, do menor estoque para o maior.',
 'Alerta de reposicao no painel do comprador sai daqui. Diferente da questao de estoque zerado, aqui o corte e por limite, e o produto de estoque nulo precisa ser tratado de proposito, nao por acidente.',
 'Tabela produtos(id, nome, categoria, preco, estoque). A coluna estoque pode ser nula.',
 'Duas colunas, nome e estoque, do menor estoque para o maior. Produto com estoque nulo nao entra no resultado.',
 'nome      | estoque
Webcam    | 2
Cabo HDMI | 7',
 'Estoque exatamente 10 nao entra. Produto com estoque nulo fica de fora nesta consulta.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Itens de um Pedido (SQL)',
 'Escreva a consulta que lista o nome do produto, a quantidade e o preco unitario dos itens do pedido de id 100.',
 'E a tela de detalhe do pedido, aberta toda vez que o suporte atende um cliente. Junta filtro por chave com JOIN, e mostra por que o item guarda o preco praticado na epoca em vez de ler o preco atual do produto.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, ...).',
 'Tres colunas: nome do produto, quantidade e preco unitario, em ordem alfabetica de produto.',
 'nome     | quantidade | preco_unitario
Monitor  | 1          | 899.00
Teclado  | 2          | 250.00',
 'Use o preco_unitario gravado no item, nao o preco atual do produto.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Valor Total de Cada Item (SQL)',
 'Escreva a consulta que mostra, para cada item de pedido, o produto e o total da linha, que e a quantidade vezes o preco unitario.',
 'Conferencia de nota fiscal comeca por esse calculo. A questao introduz coluna calculada no SELECT, que e como se produz informacao que nao esta gravada em nenhuma coluna.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, ...).',
 'Duas colunas: nome do produto e o total da linha, do maior total para o menor.',
 'nome     | total_linha
Monitor  | 899.00
Teclado  | 500.00',
 'O total precisa ser calculado na consulta, com alias.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes por Cidade (SQL)',
 'Escreva a consulta que conta quantos clientes existem em cada cidade do estado SP.',
 'Planejar rota de entrega ou abrir loja fisica pede esse recorte. Ela combina filtro com agrupamento, e e onde se aprende que o WHERE roda antes do GROUP BY, filtrando linhas e nao grupos.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em).',
 'Duas colunas: cidade e a quantidade de clientes, da maior quantidade para a menor.',
 'cidade    | total
Campinas  | 40
Santos    | 12',
 'Somente clientes de SP entram na contagem.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos Nunca Vendidos (SQL)',
 'Escreva a consulta que lista o nome dos produtos que nunca apareceram em nenhum item de pedido.',
 'Encalhe de estoque e uma pergunta de negocio cara. Aqui aparece o LEFT JOIN com teste de nulo, que e o jeito classico de perguntar o que NAO existe do outro lado da relacao.',
 'Tabelas produtos(id, nome, categoria, preco, estoque) e itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario).',
 'Uma coluna com o nome do produto, em ordem alfabetica. Nenhum produto encalhado devolve nenhuma linha.',
 'nome
Cabo HDMI',
 'JOIN comum descarta justamente as linhas que voce procura. Preserve os produtos sem correspondencia.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Media de Valor por Status (SQL)',
 'Escreva a consulta que mostra o valor medio dos pedidos agrupado por status.',
 'Comparar o ticket de quem paga com o de quem cancela costuma revelar padrao de fraude ou de carrinho abandonado. Repete AVG, agora dentro de um agrupamento.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Duas colunas: status e o valor medio arredondado em duas casas, da maior media para a menor.',
 'status    | media
pago      | 240.15
cancelado | 180.00',
 'O resultado precisa vir arredondado em duas casas.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Primeiro e Ultimo Cadastro (SQL)',
 'Escreva a consulta que devolve a data do primeiro e a do ultimo cadastro de cliente.',
 'Saber desde quando a base existe entra em todo relatorio de diretoria. Reforca que MIN e MAX tambem funcionam sobre datas, nao so sobre numeros.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em).',
 'Uma unica linha com duas colunas: a data mais antiga e a mais recente.',
 'primeiro             | ultimo
2021-02-10 09:12:00  | 2024-12-30 18:44:00',
 'Resolva com uma unica consulta, sem UNION.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos de Alto Valor por Cliente (SQL)',
 'Escreva a consulta que lista o nome do cliente e o valor dos pedidos acima de 1000, do maior valor para o menor.',
 'Time de atendimento premium trabalha com esse recorte. Junta JOIN com filtro numerico e reforca que o WHERE pode recair sobre qualquer uma das tabelas cruzadas.',
 'Tabelas pedidos(id, cliente_id, data, status, valor) e clientes(id, nome, ...).',
 'Duas colunas: nome do cliente e valor do pedido, do maior para o menor.',
 'nome       | valor
Ana Souza  | 4500.00
Bruno Lima | 1200.00',
 'Pedido de exatamente 1000 nao entra. Sem SELECT *.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Contar Produtos por Faixa de Preco (SQL)',
 'Escreva a consulta que classifica cada produto como barato, medio ou caro e conta quantos existem em cada faixa.',
 'Relatorio de mix de catalogo sai assim. E o primeiro contato com CASE, que e como se cria uma categoria que nao existe como coluna no banco.',
 'Tabela produtos(id, nome, categoria, preco, estoque). Barato e ate 100, medio vai de 100 exclusive ate 1000, e caro e acima de 1000.',
 'Duas colunas: a faixa e a quantidade de produtos.',
 'faixa  | total
barato | 40
medio  | 25
caro   | 8',
 'As faixas nao podem se sobrepor. Produto de exatamente 100 e barato.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes que Ja Compraram (SQL)',
 'Escreva a consulta que lista, sem repetir, o nome dos clientes que tem ao menos um pedido.',
 'Separar quem ja comprou de quem so se cadastrou muda toda a estrategia de campanha. A armadilha e o JOIN multiplicar o cliente uma vez por pedido, e o nome aparecer dez vezes na lista.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, ...).',
 'Uma coluna com o nome do cliente, sem repeticoes, em ordem alfabetica.',
 'nome
Ana Souza
Bruno Lima',
 'Nenhum cliente pode aparecer duas vezes, mesmo tendo varios pedidos.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Estoque Total por Categoria (SQL)',
 'Escreva a consulta que soma o estoque de cada categoria de produto.',
 'Inventario por categoria e o numero que o comprador olha antes de fechar pedido com fornecedor. Repete o agrupamento com SUM e traz de volta o cuidado com nulo, que nesse caso e ignorado pela agregacao.',
 'Tabela produtos(id, nome, categoria, preco, estoque). A coluna estoque pode ser nula.',
 'Duas colunas: categoria e o estoque total, da maior soma para a menor. Categoria em que todo estoque e nulo aparece com 0.',
 'categoria    | total
Perifericos  | 320
Informatica  | 85',
 'SUM ignora nulo, mas devolve nulo quando todos os valores do grupo sao nulos: o resultado precisa mostrar 0.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos sem Itens (SQL)',
 'Escreva a consulta que lista o id dos pedidos que nao tem nenhum item cadastrado.',
 'Pedido sem item e sintoma de gravacao interrompida na metade, e alguem precisa achar esses registros antes do fechamento contabil. Repete o LEFT JOIN com teste de nulo, agora no sentido inverso.',
 'Tabelas pedidos(id, cliente_id, data, status, valor) e itens_pedido(id, pedido_id, ...).',
 'Uma coluna com o id do pedido, em ordem crescente.',
 'id
455',
 'Preserve os pedidos sem correspondencia do outro lado da relacao.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Quantidade de Pedidos por Cliente (SQL)',
 'Escreva a consulta que mostra o nome do cliente e quantos pedidos ele fez, do que mais comprou para o que menos comprou.',
 'Frequencia de compra separa cliente fiel de cliente eventual. Diferente do total gasto, aqui se conta pedido, e a confusao entre COUNT e SUM e justamente o que o entrevistador quer ver se a pessoa evita.',
 'Tabelas clientes(id, nome, ...) e pedidos(id, cliente_id, ...).',
 'Duas colunas: nome do cliente e a quantidade de pedidos, da maior quantidade para a menor.',
 'nome       | pedidos
Ana Souza  | 12
Bruno Lima | 3',
 'Conte pedidos, nao some valores. Agrupe tambem pelo id do cliente.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos por Nome Parcial (SQL)',
 'Escreva a consulta que lista os produtos cujo nome comeca com a palavra cabo, sem diferenciar maiusculas.',
 'Autocomplete de campo de busca usa exatamente esse padrao. Diferente da busca em qualquer posicao, aqui o curinga fica so no fim, e a diferenca importa: com curinga dos dois lados o banco nao consegue usar indice.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Duas colunas, nome e preco, em ordem alfabetica de nome.',
 'nome           | preco
Cabo HDMI      | 39.90
cabo de rede   | 25.00',
 'O termo precisa estar no inicio do nome. A busca ignora maiuscula e minuscula.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Total Vendido por Produto (SQL)',
 'Escreva a consulta que mostra o nome do produto e quantas unidades dele ja foram vendidas.',
 'E o relatorio de giro de produto, base para decidir reposicao e desconto. Junta JOIN, agrupamento e SUM sobre a quantidade, que e a combinacao mais cobrada em entrevista de SQL.',
 'Tabelas itens_pedido(id, pedido_id, produto_id, quantidade, preco_unitario) e produtos(id, nome, ...).',
 'Duas colunas: nome do produto e o total de unidades, do mais vendido para o menos vendido.',
 'nome     | unidades
Teclado  | 420
Monitor  | 110',
 'Some a quantidade, nao conte as linhas. Agrupe tambem pelo id do produto.',
 25,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Clientes de Varios Estados (SQL)',
 'Escreva a consulta que lista nome e estado dos clientes de SP, RJ ou MG.',
 'Recorte por regiao comercial quase nunca e um estado so. Repete o IN, agora sobre texto, e reforca a ordenacao por duas colunas.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em).',
 'Duas colunas, nome e estado, ordenadas por estado e depois por nome.',
 'nome       | estado
Carla Dias | MG
Ana Souza  | SP',
 'Use uma lista de valores. Sem SELECT *.',
 15,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos do Cliente por Nome (SQL)',
 'Escreva a consulta que lista id, data e valor dos pedidos do cliente chamado Ana Souza.',
 'Suporte abre essa consulta a cada ligacao, e quase sempre com o nome, porque o cliente nao sabe o proprio id. Mostra o filtro recaindo sobre a tabela cruzada, e nao sobre a tabela principal.',
 'Tabelas pedidos(id, cliente_id, data, status, valor) e clientes(id, nome, ...).',
 'Tres colunas: id, data e valor, do pedido mais recente para o mais antigo.',
 'id  | data       | valor
991 | 2024-12-31 | 350.00',
 'O filtro pelo nome recai sobre a tabela de clientes. Sem SELECT *.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos Ordenados por Categoria e Preco (SQL)',
 'Escreva a consulta que lista os produtos ordenados por categoria em ordem alfabetica e, dentro de cada categoria, do mais caro para o mais barato.',
 'Catalogo agrupado visualmente sai dessa ordenacao. E a questao que mostra que ORDER BY aceita varias colunas, cada uma com seu proprio sentido de ordenacao.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Tres colunas: categoria, nome e preco, ordenadas por categoria crescente e preco decrescente.',
 'categoria    | nome     | preco
Informatica  | Notebook | 4500.00
Perifericos  | Teclado  | 250.00',
 'As duas colunas de ordenacao tem sentidos diferentes.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Quantidade de Produtos no Catalogo (SQL)',
 'Escreva a consulta que devolve quantos produtos existem e quantos deles tem estoque informado.',
 'Medir a completude do cadastro e passo obrigatorio antes de confiar num relatorio. Aqui aparece a diferenca entre COUNT de tudo e COUNT de uma coluna, que ignora nulo em silencio.',
 'Tabela produtos(id, nome, categoria, preco, estoque). A coluna estoque pode ser nula.',
 'Uma unica linha com duas colunas: o total de produtos e o total com estoque preenchido.',
 'total | com_estoque
120   | 98',
 'A diferenca entre as duas colunas precisa vir do tratamento de nulo, nao de um WHERE.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Pedidos Pendentes Antigos (SQL)',
 'Escreva a consulta que lista id, data e valor dos pedidos pendentes feitos antes de 2024, do mais antigo para o mais recente.',
 'Pedido pendente ha meses trava conciliacao e precisa ser resolvido a mao. A questao combina dois filtros com AND e reforca que ordem crescente e o padrao quando nada e informado.',
 'Tabela pedidos(id, cliente_id, data, status, valor).',
 'Tres colunas: id, data e valor, da data mais antiga para a mais recente.',
 'id  | data       | valor
120 | 2022-08-14 | 89.90',
 'Os dois filtros valem ao mesmo tempo. Pedido de 2024 nao entra.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Cidades Distintas dos Clientes (SQL)',
 'Escreva a consulta que devolve quantas cidades diferentes aparecem no cadastro de clientes.',
 'Medir capilaridade da base pede a contagem de valores distintos, e nao de linhas. Confundir os dois entrega um numero muito maior e uma conclusao errada para a area de expansao.',
 'Tabela clientes(id, nome, email, cidade, estado, criado_em). A coluna cidade pode ser nula.',
 'Uma unica linha com a quantidade de cidades diferentes. Cidade nula nao conta.',
 'cidades
37',
 'Conte valores distintos, nao linhas. Cidade nula fica de fora.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Valor Total dos Pedidos de Cada Dia (SQL)',
 'Escreva a consulta que soma o valor dos pedidos por dia, do dia mais recente para o mais antigo.',
 'E a serie que alimenta o grafico de vendas diarias. Repete o agrupamento sobre uma coluna de data, que e onde a pessoa percebe que agrupar por data e hora produz um grupo por segundo, e nao por dia.',
 'Tabela pedidos(id, cliente_id, data, status, valor). A coluna data e do tipo DATE.',
 'Duas colunas: a data e o total do dia, do dia mais recente para o mais antigo.',
 'data       | total
2024-12-31 | 1250.00
2024-12-30 | 890.00',
 'Todos os dias com pedido precisam aparecer.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Produtos com Desconto Simulado (SQL)',
 'Escreva a consulta que lista o nome, o preco atual e o preco com 10 por cento de desconto, arredondado em duas casas.',
 'Simular promocao antes de aplicar e rotina de time comercial. Reforca coluna calculada com alias e arredondamento, sem alterar nada no banco.',
 'Tabela produtos(id, nome, categoria, preco, estoque).',
 'Tres colunas: nome, preco e preco_promocional, do maior preco para o menor.',
 'nome     | preco  | preco_promocional
Monitor  | 899.00 | 809.10',
 'O calculo acontece na consulta: nenhum dado pode ser alterado na tabela.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;'),

('Cliente com Maior Pedido (SQL)',
 'Escreva a consulta que devolve o nome do cliente e o valor do maior pedido ja registrado.',
 'Reconhecer a maior venda do periodo abre reuniao comercial. Junta JOIN, ordenacao e limite, e mostra que nem toda pergunta de maximo precisa de MAX.',
 'Tabelas pedidos(id, cliente_id, data, status, valor) e clientes(id, nome, ...).',
 'Uma unica linha com duas colunas: nome do cliente e o valor do pedido.',
 'nome      | valor
Ana Souza | 4500.00',
 'Devolva uma unica linha. Ordene antes de limitar.',
 20,
 '-- TODO: escrever a consulta
SELECT 1;')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'SQL'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Clientes de um Estado (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Clientes de um Estado (SQL)', 'Filtra pelo estado', 'where[\s\S]*estado', 'OBRIGATORIO', 1, 'Sem WHERE sobre a coluna estado a consulta devolve o pais inteiro.'),
('Clientes de um Estado (SQL)', 'Seleciona nome e email', 'select[\s\S]*nome[\s\S]*email', 'PONTUAVEL', 3, 'O enunciado pede exatamente duas colunas: nome e email.'),
('Clientes de um Estado (SQL)', 'Ordena por nome', 'order\s+by[\s\S]*nome', 'PONTUAVEL', 3, 'Faltou o ORDER BY: sem ele a ordem das linhas nao e garantida.'),
('Clientes de um Estado (SQL)', 'Compara com a sigla SP', 'SP', 'PONTUAVEL', 2, 'O filtro precisa comparar a coluna estado com a sigla pedida.'),
('Clientes de um Estado (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'SELECT * traz colunas que ninguem pediu e quebra quando a tabela muda.'),

('Produtos Acima de Um Preco (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos Acima de Um Preco (SQL)', 'Filtra pelo preco', 'where[\s\S]*preco', 'OBRIGATORIO', 1, 'Sem WHERE sobre preco a consulta devolve o catalogo inteiro.'),
('Produtos Acima de Um Preco (SQL)', 'Usa maior que, sem incluir o limite', '>\s*100', 'PONTUAVEL', 3, 'O enunciado diz maior que 100: com >= o produto de 100 entra indevidamente.'),
('Produtos Acima de Um Preco (SQL)', 'Ordena do mais caro para o mais barato', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'Sem DESC o mais barato aparece primeiro, ao contrario do pedido.'),
('Produtos Acima de Um Preco (SQL)', 'Seleciona nome e preco', 'select[\s\S]*nome[\s\S]*preco', 'PONTUAVEL', 2, 'O enunciado pede duas colunas: nome e preco.'),
('Produtos Acima de Um Preco (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pediu colunas especificas.'),

('Contar Clientes por Estado (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Contar Clientes por Estado (SQL)', 'Agrupa por estado', 'group\s+by[\s\S]*estado', 'OBRIGATORIO', 1, 'A contagem por estado exige GROUP BY sobre a coluna estado.'),
('Contar Clientes por Estado (SQL)', 'Conta as linhas de cada grupo', 'count\s*\(', 'PONTUAVEL', 3, 'COUNT e o que transforma o grupo num numero.'),
('Contar Clientes por Estado (SQL)', 'Ordena pela quantidade em ordem decrescente', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'O enunciado pede do estado com mais clientes para o com menos.'),
('Contar Clientes por Estado (SQL)', 'Traz o estado junto da contagem', 'select[\s\S]*estado', 'PONTUAVEL', 2, 'Sem a coluna estado no SELECT, a contagem nao diz de quem e.'),
('Contar Clientes por Estado (SQL)', 'Nao filtre estado nenhum', 'where[\s\S]*estado\s*=', 'PROIBIDO', 1, 'O enunciado pede todos os estados, nao um so.'),

('Total de Pedidos por Cliente (SQL)', 'Cruza pedidos com clientes', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e o valor em pedidos: as duas tabelas precisam ser cruzadas.'),
('Total de Pedidos por Cliente (SQL)', 'Agrupa por cliente', 'group\s+by', 'OBRIGATORIO', 1, 'Somar por cliente exige GROUP BY.'),
('Total de Pedidos por Cliente (SQL)', 'Soma o valor dos pedidos', 'sum\s*\(', 'PONTUAVEL', 3, 'SUM sobre a coluna valor e o que produz o total gasto.'),
('Total de Pedidos por Cliente (SQL)', 'Agrupa tambem pelo id do cliente', 'group\s+by[\s\S]*id', 'PONTUAVEL', 3, 'Agrupar so pelo nome junta dois clientes homonimos num total unico.'),
('Total de Pedidos por Cliente (SQL)', 'Ordena do maior total para o menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do maior total para o menor.'),
('Total de Pedidos por Cliente (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Pedidos de um Periodo (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Pedidos de um Periodo (SQL)', 'Filtra pela data', 'where[\s\S]*data', 'OBRIGATORIO', 1, 'Sem filtro de data a consulta devolve todos os anos.'),
('Pedidos de um Periodo (SQL)', 'Delimita o intervalo do ano', '(between|>=|<=|2024)', 'PONTUAVEL', 3, 'BETWEEN, ou a dupla >= e <=, delimitam o ano inteiro.'),
('Pedidos de um Periodo (SQL)', 'Inclui o ultimo dia do periodo', '(12-31|<\s*.2025|between)', 'PONTUAVEL', 3, 'Parar em 30 de dezembro, ou usar < 2024-12-31, perde as vendas do ultimo dia.'),
('Pedidos de um Periodo (SQL)', 'Ordena da data mais recente para a mais antiga', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do mais recente para o mais antigo.'),
('Pedidos de um Periodo (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede tres colunas especificas.'),

('Produtos sem Estoque (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos sem Estoque (SQL)', 'Filtra pelo estoque', 'where[\s\S]*estoque', 'OBRIGATORIO', 1, 'O filtro recai sobre a coluna estoque.'),
('Produtos sem Estoque (SQL)', 'Trata o estoque nulo', 'is\s+null', 'PONTUAVEL', 3, 'estoque = NULL nunca e verdadeiro: o teste correto e IS NULL.'),
('Produtos sem Estoque (SQL)', 'Trata o estoque zerado', '=\s*0', 'PONTUAVEL', 3, 'Alem do nulo, o estoque igual a zero tambem precisa aparecer.'),
('Produtos sem Estoque (SQL)', 'Une as duas condicoes', '\bor\b', 'PONTUAVEL', 2, 'As duas situacoes valem: zerado OU nulo.'),
('Produtos sem Estoque (SQL)', 'Nao compare o nulo com igual', 'estoque\s*=\s*null', 'PROIBIDO', 1, 'Comparar com NULL usando = devolve desconhecido, e a linha nunca aparece.'),

('Buscar Cliente por Nome (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Buscar Cliente por Nome (SQL)', 'Usa busca parcial no nome', '(like|ilike)', 'OBRIGATORIO', 1, 'Igualdade so acha o nome exato: a busca parcial precisa de LIKE.'),
('Buscar Cliente por Nome (SQL)', 'Procura o termo em qualquer posicao', '%', 'PONTUAVEL', 3, 'Os curingas dos dois lados do termo acham a palavra no meio do nome.'),
('Buscar Cliente por Nome (SQL)', 'Ignora maiuscula e minuscula', '(ilike|lower|upper)', 'PONTUAVEL', 3, 'Sem normalizar a caixa, SILVA em maiusculas escapa da busca.'),
('Buscar Cliente por Nome (SQL)', 'Ordena por nome', 'order\s+by[\s\S]*nome', 'PONTUAVEL', 2, 'O enunciado pede o resultado em ordem alfabetica.'),
('Buscar Cliente por Nome (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede id e nome.'),

('Dez Produtos Mais Caros (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Dez Produtos Mais Caros (SQL)', 'Limita o resultado no banco', '(limit|fetch\s+first|top\s+10)', 'OBRIGATORIO', 1, 'O corte precisa acontecer no banco, nao na aplicacao.'),
('Dez Produtos Mais Caros (SQL)', 'Ordena do mais caro para o mais barato', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'Sem ORDER BY, o LIMIT devolve dez linhas quaisquer.'),
('Dez Produtos Mais Caros (SQL)', 'Corta em dez linhas', '10', 'PONTUAVEL', 3, 'O enunciado pede no maximo dez produtos.'),
('Dez Produtos Mais Caros (SQL)', 'Seleciona nome e preco', 'select[\s\S]*nome[\s\S]*preco', 'PONTUAVEL', 2, 'O enunciado pede duas colunas.'),
('Dez Produtos Mais Caros (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede colunas especificas.'),

('Categorias Distintas (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Categorias Distintas (SQL)', 'Elimina as repeticoes', '(distinct|group\s+by)', 'OBRIGATORIO', 1, 'DISTINCT, ou um GROUP BY pela categoria, removem as repeticoes.'),
('Categorias Distintas (SQL)', 'Seleciona a categoria', 'categoria', 'PONTUAVEL', 3, 'A coluna do resultado e a categoria.'),
('Categorias Distintas (SQL)', 'Ordena o resultado', 'order\s+by', 'PONTUAVEL', 3, 'O enunciado pede as categorias em ordem alfabetica.'),
('Categorias Distintas (SQL)', 'Devolve uma unica coluna', 'select\s+distinct\s+categoria|select\s+categoria', 'PONTUAVEL', 2, 'O enunciado pede apenas a categoria.'),
('Categorias Distintas (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'SELECT * com DISTINCT devolve linhas inteiras distintas, nao categorias.'),

('Preco Medio por Categoria (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Preco Medio por Categoria (SQL)', 'Agrupa por categoria', 'group\s+by[\s\S]*categoria', 'OBRIGATORIO', 1, 'A media por categoria exige GROUP BY.'),
('Preco Medio por Categoria (SQL)', 'Calcula a media do preco', 'avg\s*\(', 'PONTUAVEL', 3, 'AVG sobre a coluna preco produz a media do grupo.'),
('Preco Medio por Categoria (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 3, 'A media crua sai com muitas casas decimais e nao vai assim para a tela.'),
('Preco Medio por Categoria (SQL)', 'Ordena da maior media para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede da maior media para a menor.'),
('Preco Medio por Categoria (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Pedidos com o Nome do Cliente (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta parte de pedidos e busca o nome em clientes.'),
('Pedidos com o Nome do Cliente (SQL)', 'Cruza com a tabela de clientes', 'join\s+clientes', 'OBRIGATORIO', 1, 'O nome do cliente so aparece com o JOIN.'),
('Pedidos com o Nome do Cliente (SQL)', 'Liga as tabelas pela chave certa', 'cliente_id', 'PONTUAVEL', 3, 'A ligacao e entre pedidos.cliente_id e clientes.id.'),
('Pedidos com o Nome do Cliente (SQL)', 'Traz as tres colunas pedidas', 'select[\s\S]*data[\s\S]*nome', 'PONTUAVEL', 3, 'O enunciado pede id do pedido, data e nome do cliente.'),
('Pedidos com o Nome do Cliente (SQL)', 'Ordena por data em ordem decrescente', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do pedido mais recente para o mais antigo.'),
('Pedidos com o Nome do Cliente (SQL)', 'Nao cruze tabelas com virgula no FROM', 'from\s+pedidos\s*,', 'PROIBIDO', 1, 'A virgula no FROM esconde a condicao de ligacao e vira produto cartesiano se ela faltar.'),

('Pedidos Cancelados (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Pedidos Cancelados (SQL)', 'Conta as linhas', 'count\s*\(', 'OBRIGATORIO', 1, 'COUNT e o que devolve a quantidade de pedidos.'),
('Pedidos Cancelados (SQL)', 'Filtra pelo status', 'where[\s\S]*status', 'PONTUAVEL', 3, 'Sem o filtro de status, a consulta conta todos os pedidos.'),
('Pedidos Cancelados (SQL)', 'Compara com o status cancelado', 'cancelado', 'PONTUAVEL', 3, 'O status procurado e cancelado.'),
('Pedidos Cancelados (SQL)', 'Devolve uma unica linha', 'select\s+count', 'PONTUAVEL', 2, 'Sem GROUP BY, COUNT devolve exatamente uma linha.'),
('Pedidos Cancelados (SQL)', 'Nao agrupe o resultado', 'group\s+by', 'PROIBIDO', 1, 'O enunciado pede um numero so, nao uma contagem por grupo.'),

('Faturamento do Mes (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Faturamento do Mes (SQL)', 'Soma o valor', 'sum\s*\(', 'OBRIGATORIO', 1, 'SUM sobre a coluna valor produz o faturamento.'),
('Faturamento do Mes (SQL)', 'Filtra pelo status pago', 'pago', 'PONTUAVEL', 3, 'Pedido pendente ou cancelado nao entra no faturamento.'),
('Faturamento do Mes (SQL)', 'Delimita o mes de janeiro', '(01-01|between|>=)', 'PONTUAVEL', 3, 'O periodo precisa cobrir do dia 1 ao ultimo dia de janeiro.'),
('Faturamento do Mes (SQL)', 'Combina os dois filtros', '\band\b', 'PONTUAVEL', 2, 'Status e periodo valem ao mesmo tempo.'),
('Faturamento do Mes (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede um unico valor agregado.'),

('Ticket Medio dos Pedidos (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Ticket Medio dos Pedidos (SQL)', 'Calcula a media do valor', 'avg\s*\(', 'OBRIGATORIO', 1, 'AVG sobre a coluna valor produz o ticket medio.'),
('Ticket Medio dos Pedidos (SQL)', 'Filtra pelo status pago', 'pago', 'PONTUAVEL', 3, 'Pedido cancelado na media derruba o ticket e distorce o indicador.'),
('Ticket Medio dos Pedidos (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 3, 'A media crua sai com muitas casas decimais.'),
('Ticket Medio dos Pedidos (SQL)', 'Devolve uma unica linha', 'select', 'PONTUAVEL', 2, 'Sem GROUP BY, a agregacao devolve exatamente uma linha.'),
('Ticket Medio dos Pedidos (SQL)', 'Nao agrupe o resultado', 'group\s+by', 'PROIBIDO', 1, 'O enunciado pede um numero so, nao uma media por grupo.'),

('Maior e Menor Preco (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Maior e Menor Preco (SQL)', 'Calcula o menor preco', 'min\s*\(', 'OBRIGATORIO', 1, 'MIN devolve o menor preco do catalogo.'),
('Maior e Menor Preco (SQL)', 'Calcula o maior preco', 'max\s*\(', 'PONTUAVEL', 3, 'MAX devolve o maior preco do catalogo.'),
('Maior e Menor Preco (SQL)', 'Traz as duas agregacoes na mesma linha', 'select[\s\S]*min[\s\S]*max|select[\s\S]*max[\s\S]*min', 'PONTUAVEL', 3, 'As duas agregacoes cabem no mesmo SELECT, sem precisar de duas consultas.'),
('Maior e Menor Preco (SQL)', 'Nomeia as colunas do resultado', '\bas\b', 'PONTUAVEL', 2, 'Alias deixa claro qual coluna e o menor e qual e o maior.'),
('Maior e Menor Preco (SQL)', 'Nao use UNION', 'union', 'PROIBIDO', 1, 'UNION empilha duas consultas e devolve duas linhas: o enunciado pede uma.'),

('Pedidos numa Faixa de Valor (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Pedidos numa Faixa de Valor (SQL)', 'Filtra pelo valor', 'where[\s\S]*valor', 'OBRIGATORIO', 1, 'O filtro recai sobre a coluna valor.'),
('Pedidos numa Faixa de Valor (SQL)', 'Delimita a faixa', '(between|>=[\s\S]*<=)', 'PONTUAVEL', 3, 'BETWEEN, ou a dupla >= e <=, delimitam a faixa pedida.'),
('Pedidos numa Faixa de Valor (SQL)', 'Inclui os dois limites', '(between|>=|<=)', 'PONTUAVEL', 3, 'Comparacao estrita deixa de fora os pedidos de exatamente 100 e 500.'),
('Pedidos numa Faixa de Valor (SQL)', 'Ordena por valor em ordem crescente', 'order\s+by[\s\S]*valor', 'PONTUAVEL', 2, 'O enunciado pede o resultado do menor valor para o maior.'),
('Pedidos numa Faixa de Valor (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede id e valor.'),

('Clientes sem E-mail (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Clientes sem E-mail (SQL)', 'Trata o e-mail nulo', 'is\s+null', 'OBRIGATORIO', 1, 'email = NULL nunca e verdadeiro: o teste correto e IS NULL.'),
('Clientes sem E-mail (SQL)', 'Trata o e-mail em branco', '(trim|length|char_length)', 'PONTUAVEL', 3, 'Campo em branco tambem significa sem e-mail e precisa entrar.'),
('Clientes sem E-mail (SQL)', 'Une as duas condicoes', '\bor\b', 'PONTUAVEL', 3, 'As duas situacoes valem: nulo OU em branco.'),
('Clientes sem E-mail (SQL)', 'Ordena por nome', 'order\s+by[\s\S]*nome', 'PONTUAVEL', 2, 'O enunciado pede o resultado em ordem alfabetica.'),
('Clientes sem E-mail (SQL)', 'Nao compare o nulo com igual', 'email\s*=\s*null', 'PROIBIDO', 1, 'Comparar com NULL usando = devolve desconhecido e a linha nunca aparece.'),

('Total de Itens Vendidos (SQL)', 'Consulta a tabela de itens', 'from\s+itens_pedido', 'OBRIGATORIO', 1, 'A quantidade vendida esta em itens_pedido.'),
('Total de Itens Vendidos (SQL)', 'Soma a quantidade', 'sum\s*\(', 'OBRIGATORIO', 1, 'SUM sobre quantidade devolve o total de unidades.'),
('Total de Itens Vendidos (SQL)', 'Usa a coluna quantidade', 'quantidade', 'PONTUAVEL', 3, 'A coluna somada precisa ser quantidade, nao preco.'),
('Total de Itens Vendidos (SQL)', 'Devolve uma unica linha', 'select', 'PONTUAVEL', 3, 'Sem GROUP BY, a agregacao devolve exatamente uma linha.'),
('Total de Itens Vendidos (SQL)', 'Nomeia a coluna do resultado', '\bas\b', 'PONTUAVEL', 2, 'Alias deixa o resultado legivel para quem le o relatorio.'),
('Total de Itens Vendidos (SQL)', 'Nao conte linhas no lugar de somar', 'count\s*\(', 'PROIBIDO', 1, 'COUNT diz quantos itens diferentes foram vendidos, nao quantas unidades.'),

('Pedidos por Status (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Pedidos por Status (SQL)', 'Agrupa por status', 'group\s+by[\s\S]*status', 'OBRIGATORIO', 1, 'A contagem por status exige GROUP BY.'),
('Pedidos por Status (SQL)', 'Conta as linhas de cada grupo', 'count\s*\(', 'PONTUAVEL', 3, 'COUNT transforma cada grupo num numero.'),
('Pedidos por Status (SQL)', 'Ordena pela quantidade em ordem decrescente', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'O enunciado pede do status mais frequente para o menos frequente.'),
('Pedidos por Status (SQL)', 'Traz o status junto da contagem', 'select[\s\S]*status', 'PONTUAVEL', 2, 'Sem a coluna status, a contagem nao diz de que grupo e.'),
('Pedidos por Status (SQL)', 'Nao filtre um status especifico', 'where[\s\S]*status\s*=', 'PROIBIDO', 1, 'O enunciado pede todos os status, nao um so.'),

('Produtos de Categorias Especificas (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos de Categorias Especificas (SQL)', 'Filtra pela categoria', 'where[\s\S]*categoria', 'OBRIGATORIO', 1, 'O filtro recai sobre a coluna categoria.'),
('Produtos de Categorias Especificas (SQL)', 'Usa uma lista de valores', '\bin\s*\(', 'PONTUAVEL', 3, 'IN e mais legivel que encadear OR quando a lista de opcoes cresce.'),
('Produtos de Categorias Especificas (SQL)', 'Cita as duas categorias pedidas', 'Informatica[\s\S]*Perifericos|Perifericos[\s\S]*Informatica', 'PONTUAVEL', 3, 'As duas categorias do enunciado precisam aparecer no filtro.'),
('Produtos de Categorias Especificas (SQL)', 'Ordena por categoria e nome', 'order\s+by[\s\S]*categoria', 'PONTUAVEL', 2, 'O enunciado pede ordenacao por categoria e depois por nome.'),
('Produtos de Categorias Especificas (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede nome e categoria.'),

('Clientes Cadastrados no Ano (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Clientes Cadastrados no Ano (SQL)', 'Filtra pela data de cadastro', 'criado_em', 'OBRIGATORIO', 1, 'O recorte do ano recai sobre a coluna criado_em.'),
('Clientes Cadastrados no Ano (SQL)', 'Conta as linhas', 'count\s*\(', 'PONTUAVEL', 3, 'COUNT devolve a quantidade de clientes do periodo.'),
('Clientes Cadastrados no Ano (SQL)', 'Delimita o ano de 2024', '(2024|extract|date_trunc|year)', 'PONTUAVEL', 3, 'O ano precisa aparecer no filtro, por intervalo ou por extracao da parte do ano.'),
('Clientes Cadastrados no Ano (SQL)', 'Cobre o ultimo dia inteiro', '(<\s*.2025|extract|year|between)', 'PONTUAVEL', 2, 'Como criado_em tem hora, parar em 2024-12-31 perde os cadastros do dia.'),
('Clientes Cadastrados no Ano (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede apenas a contagem.'),

('Renomear Colunas do Relatorio (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Renomear Colunas do Relatorio (SQL)', 'Usa alias nas colunas', '\bas\b', 'OBRIGATORIO', 1, 'AS renomeia a coluna no resultado sem mexer no esquema.'),
('Renomear Colunas do Relatorio (SQL)', 'Renomeia nome para produto', 'produto', 'PONTUAVEL', 3, 'A coluna nome precisa sair como produto.'),
('Renomear Colunas do Relatorio (SQL)', 'Renomeia preco para valor', 'valor', 'PONTUAVEL', 3, 'A coluna preco precisa sair como valor.'),
('Renomear Colunas do Relatorio (SQL)', 'Ordena o resultado', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica de produto.'),
('Renomear Colunas do Relatorio (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'Com SELECT * nao ha como renomear coluna nenhuma.'),

('Nome e Cidade Juntos (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Nome e Cidade Juntos (SQL)', 'Concatena as colunas', '(\|\||concat)', 'OBRIGATORIO', 1, 'O operador de concatenacao junta nome e cidade num texto so.'),
('Nome e Cidade Juntos (SQL)', 'Inclui os parenteses no formato', '\(', 'PONTUAVEL', 3, 'A cidade sai entre parenteses, conforme o formato pedido.'),
('Nome e Cidade Juntos (SQL)', 'Protege a cidade nula', '(coalesce|case|concat_ws)', 'PONTUAVEL', 3, 'Concatenar com NULL devolve NULL: COALESCE evita a linha vazia.'),
('Nome e Cidade Juntos (SQL)', 'Nomeia a coluna como identificacao', 'identificacao', 'PONTUAVEL', 2, 'O enunciado define o nome da coluna do resultado.'),
('Nome e Cidade Juntos (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede uma unica coluna calculada.'),

('Ultimos Pedidos Cadastrados (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Ultimos Pedidos Cadastrados (SQL)', 'Ordena antes de limitar', 'order\s+by', 'OBRIGATORIO', 1, 'LIMIT sem ORDER BY devolve cinco linhas quaisquer, nao as mais recentes.'),
('Ultimos Pedidos Cadastrados (SQL)', 'Ordena da data mais recente para a mais antiga', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'Sem DESC a consulta traz os cinco pedidos mais antigos.'),
('Ultimos Pedidos Cadastrados (SQL)', 'Limita em cinco linhas', '(limit\s*5|fetch\s+first\s*5|top\s+5)', 'PONTUAVEL', 3, 'O enunciado pede no maximo cinco pedidos.'),
('Ultimos Pedidos Cadastrados (SQL)', 'Traz as tres colunas pedidas', 'select[\s\S]*data[\s\S]*valor', 'PONTUAVEL', 2, 'O enunciado pede id, data e valor.'),
('Ultimos Pedidos Cadastrados (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede colunas especificas.'),

('Produtos com Estoque Baixo (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos com Estoque Baixo (SQL)', 'Filtra pelo estoque', 'where[\s\S]*estoque', 'OBRIGATORIO', 1, 'O filtro recai sobre a coluna estoque.'),
('Produtos com Estoque Baixo (SQL)', 'Usa menor que, sem incluir o limite', '<\s*10', 'PONTUAVEL', 3, 'O enunciado diz menos de 10: com <= o produto de estoque 10 entra indevidamente.'),
('Produtos com Estoque Baixo (SQL)', 'Ordena do menor estoque para o maior', 'order\s+by[\s\S]*estoque', 'PONTUAVEL', 3, 'O comprador quer ver primeiro o que esta mais critico.'),
('Produtos com Estoque Baixo (SQL)', 'Seleciona nome e estoque', 'select[\s\S]*nome[\s\S]*estoque', 'PONTUAVEL', 2, 'O enunciado pede duas colunas.'),
('Produtos com Estoque Baixo (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede colunas especificas.'),

('Itens de um Pedido (SQL)', 'Consulta a tabela de itens', 'from\s+itens_pedido', 'OBRIGATORIO', 1, 'A consulta parte de itens_pedido e busca o nome em produtos.'),
('Itens de um Pedido (SQL)', 'Filtra pelo pedido', 'pedido_id', 'OBRIGATORIO', 1, 'Sem o filtro por pedido_id a consulta devolve os itens de todos os pedidos.'),
('Itens de um Pedido (SQL)', 'Cruza com a tabela de produtos', 'join\s+produtos', 'PONTUAVEL', 3, 'O nome do produto so aparece com o JOIN.'),
('Itens de um Pedido (SQL)', 'Usa o preco gravado no item', 'preco_unitario', 'PONTUAVEL', 3, 'O preco do produto muda com o tempo: a nota precisa do preco praticado na venda.'),
('Itens de um Pedido (SQL)', 'Ordena por nome do produto', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica de produto.'),
('Itens de um Pedido (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede tres colunas.'),

('Valor Total de Cada Item (SQL)', 'Consulta a tabela de itens', 'from\s+itens_pedido', 'OBRIGATORIO', 1, 'A consulta parte de itens_pedido.'),
('Valor Total de Cada Item (SQL)', 'Multiplica quantidade por preco', 'quantidade\s*\*|\*\s*preco_unitario', 'OBRIGATORIO', 1, 'O total da linha e quantidade vezes preco unitario.'),
('Valor Total de Cada Item (SQL)', 'Cruza com a tabela de produtos', 'join\s+produtos', 'PONTUAVEL', 3, 'O nome do produto vem da outra tabela.'),
('Valor Total de Cada Item (SQL)', 'Nomeia a coluna calculada', '\bas\b', 'PONTUAVEL', 3, 'Coluna calculada sem alias sai com nome ilegivel no relatorio.'),
('Valor Total de Cada Item (SQL)', 'Ordena do maior total para o menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do maior total para o menor.'),
('Valor Total de Cada Item (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede duas colunas.'),

('Clientes por Cidade (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Clientes por Cidade (SQL)', 'Agrupa por cidade', 'group\s+by[\s\S]*cidade', 'OBRIGATORIO', 1, 'A contagem por cidade exige GROUP BY.'),
('Clientes por Cidade (SQL)', 'Filtra pelo estado antes de agrupar', 'where[\s\S]*estado', 'PONTUAVEL', 3, 'O WHERE roda antes do GROUP BY e restringe as linhas que entram nos grupos.'),
('Clientes por Cidade (SQL)', 'Conta os clientes de cada grupo', 'count\s*\(', 'PONTUAVEL', 3, 'COUNT transforma o grupo num numero.'),
('Clientes por Cidade (SQL)', 'Ordena da maior quantidade para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede da cidade com mais clientes para a com menos.'),
('Clientes por Cidade (SQL)', 'Nao filtre a cidade', 'where[\s\S]*cidade\s*=', 'PROIBIDO', 1, 'O enunciado pede todas as cidades do estado, nao uma so.'),

('Produtos Nunca Vendidos (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta parte de produtos, que e o lado que precisa ser preservado.'),
('Produtos Nunca Vendidos (SQL)', 'Preserva os produtos sem correspondencia', '(left\s+join|not\s+exists|not\s+in)', 'OBRIGATORIO', 1, 'JOIN comum descarta exatamente as linhas procuradas.'),
('Produtos Nunca Vendidos (SQL)', 'Testa a ausencia do outro lado', '(is\s+null|not\s+exists|not\s+in)', 'PONTUAVEL', 3, 'Depois do LEFT JOIN, a ausencia aparece como NULL na coluna da outra tabela.'),
('Produtos Nunca Vendidos (SQL)', 'Liga pelo produto', 'produto_id', 'PONTUAVEL', 3, 'A ligacao e entre produtos.id e itens_pedido.produto_id.'),
('Produtos Nunca Vendidos (SQL)', 'Ordena por nome', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica.'),
('Produtos Nunca Vendidos (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Media de Valor por Status (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Media de Valor por Status (SQL)', 'Agrupa por status', 'group\s+by[\s\S]*status', 'OBRIGATORIO', 1, 'A media por status exige GROUP BY.'),
('Media de Valor por Status (SQL)', 'Calcula a media do valor', 'avg\s*\(', 'PONTUAVEL', 3, 'AVG sobre a coluna valor produz a media do grupo.'),
('Media de Valor por Status (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 3, 'A media crua nao vai direto para a tela.'),
('Media de Valor por Status (SQL)', 'Ordena da maior media para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede da maior media para a menor.'),
('Media de Valor por Status (SQL)', 'Nao filtre um status', 'where[\s\S]*status\s*=', 'PROIBIDO', 1, 'O enunciado pede todos os status.'),

('Primeiro e Ultimo Cadastro (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Primeiro e Ultimo Cadastro (SQL)', 'Busca a data mais antiga', 'min\s*\(', 'OBRIGATORIO', 1, 'MIN funciona sobre data, nao so sobre numero.'),
('Primeiro e Ultimo Cadastro (SQL)', 'Busca a data mais recente', 'max\s*\(', 'PONTUAVEL', 3, 'MAX devolve o cadastro mais recente.'),
('Primeiro e Ultimo Cadastro (SQL)', 'Usa a coluna de cadastro', 'criado_em', 'PONTUAVEL', 3, 'A coluna analisada e criado_em.'),
('Primeiro e Ultimo Cadastro (SQL)', 'Nomeia as colunas do resultado', '\bas\b', 'PONTUAVEL', 2, 'Alias deixa claro qual data e qual.'),
('Primeiro e Ultimo Cadastro (SQL)', 'Nao use UNION', 'union', 'PROIBIDO', 1, 'UNION devolveria duas linhas: o enunciado pede uma.'),

('Pedidos de Alto Valor por Cliente (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta parte de pedidos e busca o nome em clientes.'),
('Pedidos de Alto Valor por Cliente (SQL)', 'Cruza com a tabela de clientes', 'join\s+clientes', 'OBRIGATORIO', 1, 'O nome do cliente so aparece com o JOIN.'),
('Pedidos de Alto Valor por Cliente (SQL)', 'Filtra pelo valor do pedido', '>\s*1000', 'PONTUAVEL', 3, 'O enunciado diz acima de 1000: com >= o pedido de 1000 entra indevidamente.'),
('Pedidos de Alto Valor por Cliente (SQL)', 'Liga as tabelas pela chave certa', 'cliente_id', 'PONTUAVEL', 3, 'A ligacao e entre pedidos.cliente_id e clientes.id.'),
('Pedidos de Alto Valor por Cliente (SQL)', 'Ordena do maior valor para o menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do maior valor para o menor.'),
('Pedidos de Alto Valor por Cliente (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede duas colunas.'),

('Contar Produtos por Faixa de Preco (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Contar Produtos por Faixa de Preco (SQL)', 'Classifica o preco com CASE', 'case', 'OBRIGATORIO', 1, 'CASE cria a faixa, que nao existe como coluna no banco.'),
('Contar Produtos por Faixa de Preco (SQL)', 'Cita os limites das faixas', '(100|1000)', 'PONTUAVEL', 3, 'Os cortes em 100 e 1000 precisam aparecer na classificacao.'),
('Contar Produtos por Faixa de Preco (SQL)', 'Agrupa pela faixa', 'group\s+by', 'PONTUAVEL', 3, 'A contagem por faixa exige GROUP BY sobre a expressao classificada.'),
('Contar Produtos por Faixa de Preco (SQL)', 'Conta os produtos de cada faixa', 'count\s*\(', 'PONTUAVEL', 2, 'COUNT transforma cada faixa num numero.'),
('Contar Produtos por Faixa de Preco (SQL)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua na consulta.'),

('Clientes que Ja Compraram (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta parte de clientes.'),
('Clientes que Ja Compraram (SQL)', 'Relaciona com os pedidos', '(join|exists|\bin\s*\()', 'OBRIGATORIO', 1, 'E preciso olhar a tabela de pedidos para saber quem ja comprou.'),
('Clientes que Ja Compraram (SQL)', 'Elimina as repeticoes', '(distinct|group\s+by|exists)', 'PONTUAVEL', 3, 'O JOIN repete o cliente uma vez por pedido: DISTINCT ou EXISTS resolvem.'),
('Clientes que Ja Compraram (SQL)', 'Liga pela chave do cliente', 'cliente_id', 'PONTUAVEL', 3, 'A ligacao e entre clientes.id e pedidos.cliente_id.'),
('Clientes que Ja Compraram (SQL)', 'Ordena por nome', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica.'),
('Clientes que Ja Compraram (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede apenas o nome.'),

('Estoque Total por Categoria (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Estoque Total por Categoria (SQL)', 'Agrupa por categoria', 'group\s+by[\s\S]*categoria', 'OBRIGATORIO', 1, 'A soma por categoria exige GROUP BY.'),
('Estoque Total por Categoria (SQL)', 'Soma o estoque', 'sum\s*\(', 'PONTUAVEL', 3, 'SUM sobre a coluna estoque produz o inventario do grupo.'),
('Estoque Total por Categoria (SQL)', 'Troca o nulo por zero', 'coalesce', 'PONTUAVEL', 3, 'SUM devolve nulo quando todo o grupo e nulo: COALESCE mostra 0 no lugar.'),
('Estoque Total por Categoria (SQL)', 'Ordena da maior soma para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede da maior soma para a menor.'),
('Estoque Total por Categoria (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede duas colunas.'),

('Pedidos sem Itens (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta parte de pedidos, que e o lado a preservar.'),
('Pedidos sem Itens (SQL)', 'Preserva os pedidos sem correspondencia', '(left\s+join|not\s+exists|not\s+in)', 'OBRIGATORIO', 1, 'JOIN comum descarta exatamente os pedidos procurados.'),
('Pedidos sem Itens (SQL)', 'Testa a ausencia do item', '(is\s+null|not\s+exists|not\s+in)', 'PONTUAVEL', 3, 'Depois do LEFT JOIN, a ausencia aparece como NULL.'),
('Pedidos sem Itens (SQL)', 'Liga pelo pedido', 'pedido_id', 'PONTUAVEL', 3, 'A ligacao e entre pedidos.id e itens_pedido.pedido_id.'),
('Pedidos sem Itens (SQL)', 'Ordena por id', 'order\s+by', 'PONTUAVEL', 2, 'O enunciado pede o resultado em ordem crescente de id.'),
('Pedidos sem Itens (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede apenas o id.'),

('Quantidade de Pedidos por Cliente (SQL)', 'Cruza pedidos com clientes', 'join', 'OBRIGATORIO', 1, 'O nome esta em clientes e os pedidos na outra tabela.'),
('Quantidade de Pedidos por Cliente (SQL)', 'Agrupa por cliente', 'group\s+by', 'OBRIGATORIO', 1, 'Contar por cliente exige GROUP BY.'),
('Quantidade de Pedidos por Cliente (SQL)', 'Conta os pedidos', 'count\s*\(', 'PONTUAVEL', 3, 'A pergunta e quantos pedidos, entao a agregacao e COUNT e nao SUM.'),
('Quantidade de Pedidos por Cliente (SQL)', 'Agrupa tambem pelo id do cliente', 'group\s+by[\s\S]*id', 'PONTUAVEL', 3, 'Agrupar so pelo nome junta dois clientes homonimos.'),
('Quantidade de Pedidos por Cliente (SQL)', 'Ordena da maior quantidade para a menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede de quem mais comprou para quem menos comprou.'),
('Quantidade de Pedidos por Cliente (SQL)', 'Nao some valores no lugar de contar', 'sum\s*\(', 'PROIBIDO', 1, 'SUM responde quanto o cliente gastou, e a pergunta e quantos pedidos ele fez.'),

('Produtos por Nome Parcial (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos por Nome Parcial (SQL)', 'Usa busca parcial', '(like|ilike)', 'OBRIGATORIO', 1, 'Igualdade so acha o nome exato: prefixo precisa de LIKE.'),
('Produtos por Nome Parcial (SQL)', 'Coloca o curinga apenas no fim', 'cabo%', 'PONTUAVEL', 3, 'Curinga so no fim casa com o inicio do nome e ainda permite o banco usar indice.'),
('Produtos por Nome Parcial (SQL)', 'Ignora maiuscula e minuscula', '(ilike|lower|upper)', 'PONTUAVEL', 3, 'Sem normalizar a caixa, Cabo com maiuscula escapa da busca.'),
('Produtos por Nome Parcial (SQL)', 'Ordena por nome', 'order\s+by[\s\S]*nome', 'PONTUAVEL', 2, 'O enunciado pede ordem alfabetica.'),
('Produtos por Nome Parcial (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede nome e preco.'),

('Total Vendido por Produto (SQL)', 'Cruza itens com produtos', 'join', 'OBRIGATORIO', 1, 'A quantidade esta em itens_pedido e o nome em produtos.'),
('Total Vendido por Produto (SQL)', 'Agrupa por produto', 'group\s+by', 'OBRIGATORIO', 1, 'Somar por produto exige GROUP BY.'),
('Total Vendido por Produto (SQL)', 'Soma a quantidade vendida', 'sum\s*\(', 'PONTUAVEL', 3, 'A pergunta e quantas unidades, entao a agregacao e SUM sobre quantidade.'),
('Total Vendido por Produto (SQL)', 'Agrupa tambem pelo id do produto', 'group\s+by[\s\S]*id', 'PONTUAVEL', 3, 'Agrupar so pelo nome junta dois produtos homonimos.'),
('Total Vendido por Produto (SQL)', 'Ordena do mais vendido para o menos vendido', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do mais vendido para o menos vendido.'),
('Total Vendido por Produto (SQL)', 'Nao conte linhas no lugar de somar', 'count\s*\(', 'PROIBIDO', 1, 'COUNT diz em quantos pedidos o produto apareceu, nao quantas unidades sairam.'),

('Clientes de Varios Estados (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Clientes de Varios Estados (SQL)', 'Filtra pelo estado', 'where[\s\S]*estado', 'OBRIGATORIO', 1, 'O filtro recai sobre a coluna estado.'),
('Clientes de Varios Estados (SQL)', 'Usa uma lista de valores', '\bin\s*\(', 'PONTUAVEL', 3, 'IN e mais legivel que encadear OR para tres estados.'),
('Clientes de Varios Estados (SQL)', 'Cita os tres estados', 'SP[\s\S]*RJ[\s\S]*MG|MG[\s\S]*RJ[\s\S]*SP', 'PONTUAVEL', 3, 'Os tres estados do enunciado precisam aparecer no filtro.'),
('Clientes de Varios Estados (SQL)', 'Ordena por estado e nome', 'order\s+by[\s\S]*estado', 'PONTUAVEL', 2, 'O enunciado pede ordenacao por estado e depois por nome.'),
('Clientes de Varios Estados (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede nome e estado.'),

('Pedidos do Cliente por Nome (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta parte de pedidos.'),
('Pedidos do Cliente por Nome (SQL)', 'Cruza com a tabela de clientes', 'join\s+clientes', 'OBRIGATORIO', 1, 'O nome do cliente esta na outra tabela.'),
('Pedidos do Cliente por Nome (SQL)', 'Filtra pelo nome do cliente', 'where[\s\S]*nome', 'PONTUAVEL', 3, 'O filtro recai sobre a coluna nome da tabela cruzada.'),
('Pedidos do Cliente por Nome (SQL)', 'Liga as tabelas pela chave certa', 'cliente_id', 'PONTUAVEL', 3, 'A ligacao e entre pedidos.cliente_id e clientes.id.'),
('Pedidos do Cliente por Nome (SQL)', 'Ordena da data mais recente para a mais antiga', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do pedido mais recente para o mais antigo.'),
('Pedidos do Cliente por Nome (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede tres colunas.'),

('Produtos Ordenados por Categoria e Preco (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos Ordenados por Categoria e Preco (SQL)', 'Ordena por mais de uma coluna', 'order\s+by[\s\S]*,', 'OBRIGATORIO', 1, 'ORDER BY aceita varias colunas, separadas por virgula.'),
('Produtos Ordenados por Categoria e Preco (SQL)', 'Ordena a categoria em ordem crescente', 'order\s+by[\s\S]*categoria', 'PONTUAVEL', 3, 'A primeira coluna de ordenacao e a categoria.'),
('Produtos Ordenados por Categoria e Preco (SQL)', 'Ordena o preco em ordem decrescente', 'preco\s+desc', 'PONTUAVEL', 3, 'O DESC vale so para o preco: cada coluna tem seu proprio sentido.'),
('Produtos Ordenados por Categoria e Preco (SQL)', 'Traz as tres colunas pedidas', 'select[\s\S]*categoria[\s\S]*nome', 'PONTUAVEL', 2, 'O enunciado pede categoria, nome e preco.'),
('Produtos Ordenados por Categoria e Preco (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede colunas especificas.'),

('Quantidade de Produtos no Catalogo (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Quantidade de Produtos no Catalogo (SQL)', 'Conta o total de produtos', 'count\s*\(\s*\*', 'OBRIGATORIO', 1, 'COUNT(*) conta as linhas, inclusive as com estoque nulo.'),
('Quantidade de Produtos no Catalogo (SQL)', 'Conta apenas os que tem estoque', 'count\s*\(\s*estoque', 'PONTUAVEL', 3, 'COUNT sobre uma coluna ignora os nulos dela, que e o efeito desejado aqui.'),
('Quantidade de Produtos no Catalogo (SQL)', 'Traz as duas contagens na mesma linha', 'select[\s\S]*count[\s\S]*count', 'PONTUAVEL', 3, 'As duas agregacoes cabem no mesmo SELECT.'),
('Quantidade de Produtos no Catalogo (SQL)', 'Nomeia as colunas do resultado', '\bas\b', 'PONTUAVEL', 2, 'Alias distingue as duas contagens no resultado.'),
('Quantidade de Produtos no Catalogo (SQL)', 'Nao filtre com WHERE', 'where', 'PROIBIDO', 1, 'Com WHERE some a linha do total: a diferenca precisa sair do tratamento de nulo.'),

('Pedidos Pendentes Antigos (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Pedidos Pendentes Antigos (SQL)', 'Combina os dois filtros', '\band\b', 'OBRIGATORIO', 1, 'Status e data valem ao mesmo tempo.'),
('Pedidos Pendentes Antigos (SQL)', 'Filtra pelo status pendente', 'pendente', 'PONTUAVEL', 3, 'O status procurado e pendente.'),
('Pedidos Pendentes Antigos (SQL)', 'Corta as datas de 2024 em diante', '(<\s*.2024|2023)', 'PONTUAVEL', 3, 'Antes de 2024 significa ate 31 de dezembro de 2023.'),
('Pedidos Pendentes Antigos (SQL)', 'Ordena da data mais antiga para a mais recente', 'order\s+by[\s\S]*data', 'PONTUAVEL', 2, 'O enunciado pede do mais antigo para o mais recente.'),
('Pedidos Pendentes Antigos (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede tres colunas.'),

('Cidades Distintas dos Clientes (SQL)', 'Consulta a tabela de clientes', 'from\s+clientes', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela clientes.'),
('Cidades Distintas dos Clientes (SQL)', 'Conta valores distintos', 'count\s*\(\s*distinct', 'OBRIGATORIO', 1, 'COUNT(DISTINCT cidade) responde quantas cidades diferentes existem.'),
('Cidades Distintas dos Clientes (SQL)', 'Usa a coluna cidade', 'cidade', 'PONTUAVEL', 3, 'A coluna analisada e cidade.'),
('Cidades Distintas dos Clientes (SQL)', 'Devolve uma unica linha', 'select\s+count', 'PONTUAVEL', 3, 'Sem GROUP BY, a agregacao devolve uma linha.'),
('Cidades Distintas dos Clientes (SQL)', 'Nomeia a coluna do resultado', '\bas\b', 'PONTUAVEL', 2, 'Alias deixa o resultado legivel.'),
('Cidades Distintas dos Clientes (SQL)', 'Nao conte linhas no lugar de valores distintos', 'count\s*\(\s*\*', 'PROIBIDO', 1, 'COUNT(*) conta clientes, e a pergunta e quantas cidades diferentes existem.'),

('Valor Total dos Pedidos de Cada Dia (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela pedidos.'),
('Valor Total dos Pedidos de Cada Dia (SQL)', 'Agrupa pela data', 'group\s+by[\s\S]*data', 'OBRIGATORIO', 1, 'A soma por dia exige GROUP BY sobre a data.'),
('Valor Total dos Pedidos de Cada Dia (SQL)', 'Soma o valor de cada dia', 'sum\s*\(', 'PONTUAVEL', 3, 'SUM sobre a coluna valor produz o total do dia.'),
('Valor Total dos Pedidos de Cada Dia (SQL)', 'Ordena do dia mais recente para o mais antigo', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'O enunciado pede do dia mais recente para o mais antigo.'),
('Valor Total dos Pedidos de Cada Dia (SQL)', 'Traz a data junto do total', 'select[\s\S]*data', 'PONTUAVEL', 2, 'Sem a coluna data, o total nao diz de que dia e.'),
('Valor Total dos Pedidos de Cada Dia (SQL)', 'Nao filtre um dia especifico', 'where[\s\S]*data\s*=', 'PROIBIDO', 1, 'O enunciado pede a serie inteira, nao um dia so.'),

('Produtos com Desconto Simulado (SQL)', 'Consulta a tabela de produtos', 'from\s+produtos', 'OBRIGATORIO', 1, 'A consulta precisa partir da tabela produtos.'),
('Produtos com Desconto Simulado (SQL)', 'Calcula o preco com desconto', '(\*\s*0\.9|0\.9\s*\*|\*\s*0,9|-\s*\()', 'OBRIGATORIO', 1, 'Dez por cento de desconto e o preco multiplicado por 0.9.'),
('Produtos com Desconto Simulado (SQL)', 'Arredonda em duas casas', 'round\s*\(', 'PONTUAVEL', 3, 'Preco com muitas casas decimais nao vai para a tela.'),
('Produtos com Desconto Simulado (SQL)', 'Nomeia a coluna calculada', 'preco_promocional', 'PONTUAVEL', 3, 'O enunciado define o nome da terceira coluna.'),
('Produtos com Desconto Simulado (SQL)', 'Ordena do maior preco para o menor', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 2, 'O enunciado pede do maior preco para o menor.'),
('Produtos com Desconto Simulado (SQL)', 'Nao altere os dados da tabela', '\bupdate\b', 'PROIBIDO', 1, 'O enunciado pede uma simulacao: nenhum dado pode ser alterado.'),

('Cliente com Maior Pedido (SQL)', 'Consulta a tabela de pedidos', 'from\s+pedidos', 'OBRIGATORIO', 1, 'A consulta parte de pedidos e busca o nome em clientes.'),
('Cliente com Maior Pedido (SQL)', 'Cruza com a tabela de clientes', 'join\s+clientes', 'OBRIGATORIO', 1, 'O nome do cliente esta na outra tabela.'),
('Cliente com Maior Pedido (SQL)', 'Ordena pelo valor em ordem decrescente', 'order\s+by[\s\S]*desc', 'PONTUAVEL', 3, 'O maior pedido fica no topo depois da ordenacao decrescente.'),
('Cliente com Maior Pedido (SQL)', 'Devolve uma unica linha', '(limit\s*1|fetch\s+first|top\s+1)', 'PONTUAVEL', 3, 'O enunciado pede uma linha: LIMIT 1 depois de ordenar resolve.'),
('Cliente com Maior Pedido (SQL)', 'Liga as tabelas pela chave certa', 'cliente_id', 'PONTUAVEL', 2, 'A ligacao e entre pedidos.cliente_id e clientes.id.'),
('Cliente com Maior Pedido (SQL)', 'Nao use SELECT *', 'select\s+\*', 'PROIBIDO', 1, 'O enunciado pede nome e valor.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'SQL'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
