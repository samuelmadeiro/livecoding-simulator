-- Reescreve o enunciado das dez questoes herdadas do seed original (V3).
--
-- Elas nasceram antes do enunciado estruturado e ficaram com um paragrafo curto onde as outras 245
-- tem contexto, formato de entrada, formato de saida, exemplo e restricoes. Isso as tornava as
-- unicas questoes do catalogo em que o candidato precisava adivinhar o formato e os casos de borda,
-- justamente as que ja tinham submissoes.
--
-- Nenhum id, titulo ou criterio e alterado aqui: as submissoes existentes continuam apontando para
-- as mesmas questoes, e a regua de correcao de cada uma permanece a que ja estava cadastrada. O que
-- muda e o texto que o candidato le.
--
-- O filtro por tecnologia em cada UPDATE evita acertar uma questao homonima de outra trilha.

UPDATE desafios SET
    descricao = 'Escreva o metodo contarVogais(String texto) que devolve quantas vogais o texto tem.',
    contexto = 'Validador de apelido e contador de caracteres passam por aqui. Em Java a questao ainda cobra o basico de String: percorrer com charAt ou toCharArray e normalizar a caixa antes de comparar, porque o A maiusculo da entrada escapa de quem compara direto.',
    formato_entrada = 'Uma String que pode estar vazia, ser nula ou misturar maiusculas e minusculas.',
    formato_saida = 'Um int com a quantidade de vogais. Texto vazio ou nulo devolve 0.',
    exemplo = 'Entrada: "Banana Azeda"
Saida: 6',
    restricoes = 'Considere apenas a, e, i, o, u. Texto nulo devolve 0 sem lancar excecao.'
WHERE titulo = 'Contar Vogais'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Java');

UPDATE desafios SET
    descricao = 'Implemente o endpoint GET /produtos, que devolve a lista de produtos cadastrados.',
    contexto = 'E a primeira rota de qualquer API de catalogo e a que sustenta a vitrine. Parece trivial, mas e onde se ve se a pessoa separa controller de acesso a dados ou se escreve a consulta dentro do controller, decisao que cobra caro quando a regra de negocio cresce.',
    formato_entrada = 'Nenhum parametro. A aplicacao ja tem um repositorio de produtos disponivel para injecao.',
    formato_saida = 'Status 200 com a lista de produtos em JSON. Catalogo vazio devolve 200 com lista vazia, e nao 404.',
    exemplo = 'GET /produtos
200 [{"id":1,"nome":"Teclado","preco":250.00}]',
    restricoes = 'Catalogo vazio nao e erro: devolva 200 com lista vazia. Busque os dados por um repositorio ou service, nao direto no controller.'
WHERE titulo = 'CRUD de Produtos'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Java');

UPDATE desafios SET
    descricao = 'Implemente o endpoint POST /clientes, que recebe o cliente no corpo da requisicao, valida os campos e responde 201 com o cliente salvo.',
    contexto = 'Cadastro e a porta de entrada de dado sujo no sistema. A questao mede duas coisas que costumam faltar juntas: validar antes de gravar e devolver o status certo. Responder 200 numa criacao confunde qualquer cliente da API que siga a convencao.',
    formato_entrada = 'Corpo JSON com nome e email. Ambos obrigatorios e nao podem vir em branco.',
    formato_saida = 'Status 201 com o cliente salvo, incluindo o id gerado. Corpo invalido devolve 400 com os erros de validacao.',
    exemplo = 'POST /clientes {"nome":"Ana","email":"ana@exemplo.com"}
201 {"id":10,"nome":"Ana","email":"ana@exemplo.com"}',
    restricoes = 'Criacao responde 201, nao 200. A validacao acontece antes de qualquer gravacao.'
WHERE titulo = 'Cadastro de Clientes'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Java');

UPDATE desafios SET
    descricao = 'Implemente o endpoint GET /pedidos com paginacao e ordenacao, devolvendo os itens da pagina e o total de registros.',
    contexto = 'Listagem sem paginacao funciona por seis meses e derruba a aplicacao no dia em que a tabela cresce, porque carrega tudo em memoria. A questao cobra o tamanho maximo de pagina: sem ele, basta alguem pedir cem mil registros para reproduzir o mesmo problema.',
    formato_entrada = 'Parametros de query opcionais: pagina, tamanho e ordenacao. A pagina 1 e a primeira.',
    formato_saida = 'Status 200 com os itens da pagina e o total de registros, para o cliente montar a navegacao.',
    exemplo = 'GET /pedidos?pagina=2&tamanho=20&ordenacao=data,desc
200 {"itens":[...],"total":183}',
    restricoes = 'Defina um tamanho de pagina padrao e um maximo. Nao carregue a tabela inteira em memoria para depois cortar.'
WHERE titulo = 'Paginacao de Pedidos'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Java');

UPDATE desafios SET
    descricao = 'Escreva o metodo agrupar(List<String> palavras) que agrupa as palavras que sao anagramas entre si.',
    contexto = 'Deduplicacao de cadastro com letras trocadas e indexacao de busca caem nesse problema. A sacada e perceber que duas palavras anagramas produzem a mesma chave depois de ordenadas, o que troca uma comparacao de todos contra todos por uma unica varredura com Map.',
    formato_entrada = 'Uma List<String> em minusculas, possivelmente vazia.',
    formato_saida = 'Uma List<List<String>> com os grupos. Palavra sem par forma um grupo de um elemento. Lista vazia devolve lista vazia.',
    exemplo = 'Entrada: [amor, roma, casa, ramo]
Saida: [[amor, roma, ramo], [casa]]',
    restricoes = 'Nao compare todas as palavras contra todas. Use uma chave derivada da propria palavra.'
WHERE titulo = 'Agrupar Anagramas'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Java');

UPDATE desafios SET
    descricao = 'Escreva a funcao eh_palindromo(texto) que diz se o texto se le igual de tras para frente.',
    contexto = 'Aparece em entrevista para ver como a pessoa normaliza dados antes de comparar. O problema de verdade nao e inverter a string: e lembrar que "Ame a ema" e palindromo mesmo tendo espaco e maiuscula, e que comparar sem limpar reprova a entrada correta.',
    formato_entrada = 'Uma string que pode conter espacos, pontuacao e letras maiusculas.',
    formato_saida = 'True se for palindromo, False se nao for. Texto vazio devolve True.',
    exemplo = 'Entrada: "Ame a ema"
Saida: True

Entrada: "Python"
Saida: False',
    restricoes = 'Ignore espacos, pontuacao e diferenca entre maiuscula e minuscula. Devolva booleano, nao string.'
WHERE titulo = 'Verificador de Palindromo'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Python');

UPDATE desafios SET
    descricao = 'Escreva a funcao media(notas) que devolve a media aritmetica das notas recebidas.',
    contexto = 'Um sistema academico calcula a media do aluno a cada lancamento de nota. O detalhe que separa quem passa de quem nao passa nesta questao e a turma sem nota nenhuma: dividir por zero derruba a aplicacao inteira em producao.',
    formato_entrada = 'Uma lista de numeros (int ou float), possivelmente vazia.',
    formato_saida = 'Um numero com a media. Lista vazia devolve 0, sem lancar excecao.',
    exemplo = 'Entrada: [7.0, 8.5, 6.5]
Saida: 7.333333333333333

Entrada: []
Saida: 0',
    restricoes = 'Trate a lista vazia sem deixar estourar ZeroDivisionError. Nao use bibliotecas externas.'
WHERE titulo = 'Media de Notas'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Python');

UPDATE desafios SET
    descricao = 'Com FastAPI, exponha GET /relatorio recebendo data inicial e final como parametros de query e devolvendo o total do periodo.',
    contexto = 'Relatorio por periodo e o endpoint que a area de negocio mais pede e o que mais recebe entrada invalida: data trocada, formato errado, periodo de dois anos. A questao mede se a pessoa deixa o framework validar pelo tipo em vez de escrever a checagem na mao.',
    formato_entrada = 'Parametros de query data_inicial e data_final, ambos no formato de data. A data inicial nao pode ser posterior a final.',
    formato_saida = 'Status 200 com o total do periodo. Data invalida ou periodo invertido devolve 400 ou 422 com a mensagem do erro.',
    exemplo = 'GET /relatorio?data_inicial=2024-01-01&data_final=2024-01-31
200 {"total": 15320.00}',
    restricoes = 'Tipe os parametros para o FastAPI validar o formato. Periodo invertido precisa devolver erro HTTP, nao 200 com total zerado.'
WHERE titulo = 'Endpoint de Relatorio'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Python');

UPDATE desafios SET
    descricao = 'Escreva a consulta que devolve o total vendido por mes, do mes mais recente para o mais antigo.',
    contexto = 'E a serie que alimenta o grafico de vendas da diretoria. O erro que passa despercebido e agrupar pela data completa: isso produz um grupo por dia, o grafico ganha centenas de pontos e ninguem entende por que o relatorio mensal tem tantas linhas.',
    formato_entrada = 'Tabelas pedidos(id, cliente_id, valor, data) e clientes(id, nome). A coluna data e do tipo DATE.',
    formato_saida = 'Duas colunas: o mes e o total vendido, do mes mais recente para o mais antigo.',
    exemplo = 'mes        | total
2024-12-01 | 42800.00
2024-11-01 | 38150.00',
    restricoes = 'Agrupe por mes, nao pela data completa. Todo mes com venda precisa aparecer.'
WHERE titulo = 'Relatorio de Vendas por Mes'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'SQL');

UPDATE desafios SET
    descricao = 'Escreva a consulta que lista os clientes que nao fizeram nenhum pedido nos ultimos 12 meses.',
    contexto = 'Base de reativacao sai daqui, e o corte por recencia e o mesmo raciocinio de churn. A dificuldade e que a pergunta e sobre ausencia: um JOIN comum descarta justamente as linhas que voce procura, e filtrar a data no WHERE elimina os nulos que provam a ausencia.',
    formato_entrada = 'Tabelas clientes(id, nome) e pedidos(id, cliente_id, data).',
    formato_saida = 'Duas colunas, id e nome do cliente, em ordem alfabetica de nome. Cliente que nunca comprou tambem entra.',
    exemplo = 'id | nome
44 | Carla Dias',
    restricoes = 'Nao use subconsulta correlacionada. O filtro de data nao pode eliminar as linhas que indicam a ausencia.'
WHERE titulo = 'Clientes sem Pedido'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'SQL');
