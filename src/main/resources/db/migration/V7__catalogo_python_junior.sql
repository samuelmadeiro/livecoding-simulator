-- Catalogo Python, nivel junior: 50 questoes de algoritmo.
--
-- Um degrau acima do estagio: agrupamento, ordenacao com chave, duas estruturas combinadas,
-- tratamento de erro e conversa sobre custo. Continua sendo questao de entrevista de junior, e nao
-- de pleno: a resposta cabe numa funcao e nao exige estrutura de dados exotica.
--
-- Mesma regua do V6: cada questao diz por que existe, o que entra, o que sai, mostra um caso
-- resolvido e lista o que nao vale. Nenhum criterio cobra o que o enunciado nao pediu.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'JUNIOR', 'ALGORITMO_EASY', v.tempo, v.template, t.id
FROM (VALUES

('Agrupar Pedidos por Cliente',
 'Escreva a funcao agrupar_por_cliente(pedidos) que devolve um dicionario com o cliente e a lista de valores dos pedidos dele.',
 'Antes de qualquer relatorio vem o agrupamento, e ele quase sempre e feito na aplicacao quando os dados chegam de fontes diferentes. O erro que aparece em revisao de codigo e criar a lista de cada cliente fora do lugar certo e sobrescrever o pedido anterior.',
 'Uma lista de dicionarios com as chaves "cliente" (string) e "valor" (float). Pode vir vazia.',
 'Um dicionario com o nome do cliente e a lista dos valores dele, na ordem em que apareceram. Lista vazia devolve dicionario vazio.',
 'Entrada: [{"cliente": "ana", "valor": 10.0}, {"cliente": "bia", "valor": 5.0}, {"cliente": "ana", "valor": 7.0}]
Saida: {"ana": [10.0, 7.0], "bia": [5.0]}',
 'A ordem dos valores dentro de cada cliente segue a ordem da entrada. Nao use defaultdict.',
 30,
 'def agrupar_por_cliente(pedidos):
    # TODO: implementar
    return {}'),

('Top N Produtos Mais Vendidos',
 'Escreva a funcao top_produtos(vendas, n) que devolve os n produtos com maior quantidade vendida, do maior para o menor.',
 'Todo painel de vendas tem esse bloco. A parte tecnica interessante nao e ordenar, e ordenar por um criterio que nao e a chave: e ai que entra sorted com key, o assunto que separa quem so usa sort() de quem entende o parametro.',
 'vendas: dicionario com o nome do produto e a quantidade (int). n: inteiro maior que 0, podendo ser maior que a quantidade de produtos.',
 'Uma lista com ate n nomes de produto, ordenada pela quantidade em ordem decrescente. Empate desempata pelo nome em ordem alfabetica.',
 'Entrada: {"mouse": 5, "teclado": 9, "monitor": 5}, n=2
Saida: ["teclado", "monitor"]',
 'n maior que a quantidade de produtos devolve todos, sem erro. O desempate por nome e obrigatorio.',
 30,
 'def top_produtos(vendas, n):
    # TODO: implementar
    return []'),

('Media Movel de Tres Dias',
 'Escreva a funcao media_movel(valores) que devolve a media de cada janela de tres valores consecutivos.',
 'Grafico de metrica usa media movel para suavizar o ruido do dia a dia. O que se avalia aqui e o controle do indice: onde a janela comeca, onde ela termina e quantos resultados devem sair.',
 'Uma lista de numeros. Pode ter menos de tres elementos.',
 'Uma lista com as medias de cada janela de tres. Entrada com menos de tres elementos devolve lista vazia.',
 'Entrada: [1, 2, 3, 4]
Saida: [2.0, 3.0]',
 'A saida tem exatamente len(valores) - 2 elementos quando ha ao menos tres. Nao use bibliotecas externas.',
 30,
 'def media_movel(valores):
    # TODO: implementar
    return []'),

('Validar CPF pelo Digito Verificador',
 'Escreva a funcao cpf_valido(cpf) que valida o CPF pelos dois digitos verificadores.',
 'Validar documento no cliente evita ida ao servidor com dado invalido, e o algoritmo do CPF e o exemplo mais comum de regra oficial implementada em codigo. O ponto de atencao e a sequencia de digitos repetidos, que passa na conta mas e invalida por definicao.',
 'Uma string com 11 digitos, podendo conter pontos e traco.',
 'True se o CPF for valido, False caso contrario. Sequencias com todos os digitos iguais sao invalidas.',
 'Entrada: "529.982.247-25"
Saida: True

Entrada: "111.111.111-11"
Saida: False',
 'Remova a formatacao antes de calcular. Sequencia de digitos repetidos e invalida mesmo passando na conta.',
 35,
 'def cpf_valido(cpf):
    # TODO: implementar
    return False'),

('Contar Palavras Ignorando Stopwords',
 'Escreva a funcao contar_relevantes(texto, stopwords) que conta as palavras do texto, ignorando as da lista de stopwords.',
 'Busca e nuvem de tags descartam artigos e preposicoes antes de contar, senao o resultado e sempre "de", "a" e "o" no topo. E o primeiro passo de qualquer processamento de texto.',
 'texto: string com palavras separadas por espaco, podendo ter maiusculas. stopwords: lista de strings em minusculo.',
 'Um dicionario com a palavra em minusculo e a contagem, sem as stopwords. Texto vazio devolve dicionario vazio.',
 'Entrada: "O rato e o gato", stopwords=["o", "e"]
Saida: {"rato": 1, "gato": 1}',
 'A comparacao com a lista de stopwords ignora maiuscula. Nao use collections.Counter.',
 30,
 'def contar_relevantes(texto, stopwords):
    # TODO: implementar
    return {}'),

('Converter Lista de Dicionarios em CSV',
 'Escreva a funcao para_csv(registros) que transforma a lista de dicionarios numa string CSV com cabecalho.',
 'Exportar relatorio para planilha e pedido recorrente de area de negocio. A questao cobra a ordem estavel das colunas: sem ela, cada linha sai com os campos numa ordem diferente e o arquivo fica inutil.',
 'Uma lista de dicionarios com as mesmas chaves. Pode vir vazia.',
 'Uma string com a primeira linha de cabecalho e uma linha por registro, campos separados por virgula e linhas por quebra de linha. Lista vazia devolve string vazia.',
 'Entrada: [{"nome": "ana", "idade": 30}, {"nome": "bia", "idade": 25}]
Saida: "nome,idade\nana,30\nbia,25"',
 'A ordem das colunas segue as chaves do primeiro registro e vale para todas as linhas. Nao use o modulo csv.',
 35,
 'def para_csv(registros):
    # TODO: implementar
    return ""'),

('Buscar em Lista Ordenada',
 'Escreva a funcao busca_binaria(numeros, alvo) que encontra a posicao do alvo numa lista ja ordenada.',
 'E a pergunta de complexidade mais comum em entrevista de junior: por que percorrer 1 milhao de itens quando da para responder em 20 passos. O erro classico e o laco infinito por atualizar mal os limites.',
 'numeros: lista de inteiros em ordem crescente, sem repeticoes, possivelmente vazia. alvo: o inteiro procurado.',
 'O indice do alvo, comecando em 0. Devolve -1 quando o alvo nao existe.',
 'Entrada: [1, 3, 5, 7, 9], alvo=7
Saida: 3

Entrada: [1, 3], alvo=2
Saida: -1',
 'Nao percorra a lista inteira: use busca binaria. Nao use o operador in nem o metodo index.',
 30,
 'def busca_binaria(numeros, alvo):
    # TODO: implementar
    return -1'),

('Somar Valores Aninhados',
 'Escreva a funcao somar_tudo(dados) que soma todos os numeros de uma estrutura com listas dentro de listas, em qualquer profundidade.',
 'JSON de API vem aninhado e nem sempre com profundidade conhecida. Resolver isso e a porta de entrada para recursao, e a conversa seguinte do entrevistador e sobre o caso base e o limite de pilha.',
 'Uma lista que pode conter numeros e outras listas, em qualquer nivel de profundidade.',
 'Um numero com a soma de todos os valores encontrados. Lista vazia devolve 0.',
 'Entrada: [1, [2, [3, 4]], 5]
Saida: 15',
 'A profundidade e desconhecida. Nao use bibliotecas externas.',
 35,
 'def somar_tudo(dados):
    # TODO: implementar
    return 0'),

('Detectar Ciclo em Encadeamento',
 'Escreva a funcao tem_ciclo(proximo) que diz se o encadeamento de tarefas volta para uma tarefa ja visitada.',
 'Dependencia circular trava pipeline de build, importacao de planilha e workflow de aprovacao. Detectar o ciclo evita o laco infinito que so aparece em producao, quando o processo nunca termina.',
 'Um dicionario em que a chave e a tarefa e o valor e a proxima tarefa. A ultima tarefa aponta para None.',
 'True se existir ciclo a partir de qualquer tarefa, False caso contrario.',
 'Entrada: {"a": "b", "b": "c", "c": "a"}
Saida: True

Entrada: {"a": "b", "b": None}
Saida: False',
 'O ciclo pode nao comecar na primeira chave. Nao use bibliotecas externas.',
 35,
 'def tem_ciclo(proximo):
    # TODO: implementar
    return False'),

('Formatar Valor em Reais',
 'Escreva a funcao formatar_reais(valor) que devolve o valor no formato brasileiro de moeda.',
 'Numero mal formatado numa fatura vira chamado de suporte. O Brasil usa ponto para milhar e virgula para decimal, o inverso do padrao do Python, entao a troca precisa ser feita com cuidado para nao embaralhar os separadores.',
 'Um numero (int ou float), que pode ser negativo.',
 'Uma string no formato "R$ 1.234,56", sempre com duas casas decimais.',
 'Entrada: 1234.5
Saida: "R$ 1.234,56"

Entrada: -0.5
Saida: "R$ -0,50"',
 'Sempre duas casas decimais. Nao use a biblioteca locale.',
 30,
 'def formatar_reais(valor):
    # TODO: implementar
    return ""'),

('Intercalar Duas Listas',
 'Escreva a funcao intercalar(primeira, segunda) que alterna os elementos das duas listas.',
 'Aparece em montagem de feed que mistura duas fontes e em distribuicao de carga entre filas. O caso interessante e o tamanho diferente: a lista maior precisa despejar o que sobrou no fim, sem perder nada.',
 'Duas listas de qualquer tamanho, inclusive vazias e de tamanhos diferentes.',
 'Uma lista alternando um elemento de cada, comecando pela primeira. O excedente da lista maior vai para o fim, na ordem original.',
 'Entrada: [1, 2, 3], ["a"]
Saida: [1, "a", 2, 3]',
 'Nenhum elemento pode se perder. Nao use itertools.',
 30,
 'def intercalar(primeira, segunda):
    # TODO: implementar
    return []'),

('Resumo Estatistico da Lista',
 'Escreva a funcao resumo(numeros) que devolve minimo, maximo, media e mediana da lista.',
 'Antes de plotar qualquer grafico alguem calcula esse resumo. A mediana e a parte que revela atencao: com quantidade par de elementos ela e a media dos dois do meio, e e ai que a maioria erra.',
 'Uma lista de numeros com pelo menos um elemento.',
 'Um dicionario com as chaves "minimo", "maximo", "media" e "mediana".',
 'Entrada: [1, 3, 2, 4]
Saida: {"minimo": 1, "maximo": 4, "media": 2.5, "mediana": 2.5}',
 'Com quantidade par de elementos, a mediana e a media dos dois centrais. Nao use a biblioteca statistics.',
 35,
 'def resumo(numeros):
    # TODO: implementar
    return {}'),

('Unir Intervalos que se Sobrepoem',
 'Escreva a funcao unir_intervalos(intervalos) que junta os intervalos que se sobrepoem num unico intervalo.',
 'Agenda de sala, janela de manutencao e periodo de ferias precisam ser consolidados antes de mostrar na tela. A solucao passa por ordenar primeiro, e essa e a sacada que o entrevistador espera ouvir.',
 'Uma lista de tuplas (inicio, fim) com numeros inteiros, em qualquer ordem. Pode vir vazia.',
 'Uma lista de tuplas sem sobreposicao, ordenada pelo inicio. Lista vazia devolve lista vazia.',
 'Entrada: [(1, 3), (7, 9), (2, 5)]
Saida: [(1, 5), (7, 9)]',
 'Intervalos que apenas se encostam, como (1,3) e (3,5), devem ser unidos. Ordene antes de percorrer.',
 35,
 'def unir_intervalos(intervalos):
    # TODO: implementar
    return []'),

('Ordenar por Dois Criterios',
 'Escreva a funcao ranking(jogadores) que ordena por pontos em ordem decrescente e, no empate, por nome em ordem alfabetica.',
 'Toda tabela de classificacao tem criterio de desempate, e ele nao pode ser aleatorio: dois usuarios com a mesma pontuacao precisam aparecer sempre na mesma ordem. Ordenacao instavel com chave composta e o assunto da questao.',
 'Uma lista de dicionarios com as chaves "nome" (string) e "pontos" (int).',
 'Uma nova lista ordenada por pontos decrescente e nome crescente no empate.',
 'Entrada: [{"nome": "bia", "pontos": 10}, {"nome": "ana", "pontos": 10}, {"nome": "caio", "pontos": 20}]
Saida: [{"nome": "caio", "pontos": 20}, {"nome": "ana", "pontos": 10}, {"nome": "bia", "pontos": 10}]',
 'Os dois criterios precisam valer na mesma ordenacao, sem ordenar duas vezes. Nao altere a lista recebida.',
 30,
 'def ranking(jogadores):
    # TODO: implementar
    return []'),

('Paginar uma Lista',
 'Escreva a funcao paginar(itens, pagina, tamanho) que devolve os itens da pagina pedida.',
 'Paginacao existe em toda listagem, e o off-by-one dela e classico: a pagina 1 comeca no indice 0, nao no 1. Pagina alem do fim precisa devolver lista vazia em vez de estourar.',
 'itens: uma lista. pagina: inteiro maior ou igual a 1. tamanho: inteiro maior que 0.',
 'Uma lista com os itens daquela pagina. Pagina alem do fim devolve lista vazia.',
 'Entrada: [1,2,3,4,5], pagina=2, tamanho=2
Saida: [3, 4]

Entrada: [1,2], pagina=9, tamanho=2
Saida: []',
 'A pagina 1 e a primeira, nao a segunda. Pagina fora do intervalo nao pode lancar excecao.',
 30,
 'def paginar(itens, pagina, tamanho):
    # TODO: implementar
    return []'),

('Cache de Resultados',
 'Escreva a funcao calcular_com_cache(numeros, cache) que devolve o quadrado de cada numero, reaproveitando resultados ja calculados.',
 'Memoizacao aparece em qualquer rotina que consulta servico externo ou faz conta cara. Aqui o calculo e trivial de proposito: o que se avalia e a mecanica de consultar o cache antes, guardar depois e nao recalcular.',
 'numeros: lista de inteiros, podendo ter repeticoes. cache: dicionario que ja pode conter resultados anteriores e e atualizado pela funcao.',
 'Uma lista com o quadrado de cada numero, na ordem da entrada. O cache recebido fica atualizado com os novos resultados.',
 'Entrada: [2, 3, 2], cache={}
Saida: [4, 9, 4] e cache passa a valer {2: 4, 3: 9}',
 'O mesmo numero nao pode ser calculado duas vezes. O cache e alterado no lugar, nao substituido.',
 30,
 'def calcular_com_cache(numeros, cache):
    # TODO: implementar
    return []'),

('Validar Campos Obrigatorios',
 'Escreva a funcao validar_pedido(pedido, obrigatorios) que devolve a lista de campos obrigatorios ausentes ou vazios.',
 'Antes de gravar qualquer requisicao o backend valida o corpo, e a resposta util diz todos os campos com problema de uma vez, nao um por vez. Campo presente mas vazio conta como ausente, e essa e a parte que costuma escapar.',
 'pedido: dicionario com os dados recebidos. obrigatorios: lista de nomes de campo.',
 'Uma lista com os nomes dos campos ausentes ou vazios, na ordem da lista de obrigatorios. Nenhum problema devolve lista vazia.',
 'Entrada: {"cliente": "ana", "item": ""}, obrigatorios=["cliente", "item", "valor"]
Saida: ["item", "valor"]',
 'String vazia e None contam como ausente. O zero nao conta como ausente.',
 30,
 'def validar_pedido(pedido, obrigatorios):
    # TODO: implementar
    return []'),

('Par que Soma o Alvo',
 'Escreva a funcao par_com_soma(numeros, alvo) que encontra dois numeros cuja soma e igual ao alvo.',
 'E o exercicio mais usado para falar de troca de tempo por memoria. A versao com dois lacos funciona e reprova a entrevista; a versao com um dicionario de complementos passa numa varredura so.',
 'numeros: lista de inteiros, podendo ter repeticoes. alvo: inteiro.',
 'Uma tupla com os dois valores, na ordem em que aparecem. Devolve None quando nao existe par.',
 'Entrada: [2, 7, 11, 15], alvo=9
Saida: (2, 7)

Entrada: [1, 2], alvo=99
Saida: None',
 'Nao use dois lacos aninhados: resolva em uma unica varredura. O mesmo elemento nao pode ser usado duas vezes.',
 35,
 'def par_com_soma(numeros, alvo):
    # TODO: implementar
    return None'),

('Comprimir Texto Repetido',
 'Escreva a funcao comprimir(texto) que troca sequencias de caracteres iguais pelo caractere seguido da contagem.',
 'E a versao didatica de compressao usada em imagem simples e em protocolo de telemetria. A regra que fecha a questao e nao piorar: se a compressao ficar maior que o original, devolve o original.',
 'Uma string com letras, possivelmente vazia.',
 'A string comprimida, ou a original quando a compressao nao for menor. Texto vazio devolve string vazia.',
 'Entrada: "aaabbc"
Saida: "a3b2c1"

Entrada: "abc"
Saida: "abc"',
 'Se o resultado ficar do mesmo tamanho ou maior, devolva o texto original.',
 35,
 'def comprimir(texto):
    # TODO: implementar
    return ""'),

('Rotacionar a Lista',
 'Escreva a funcao rotacionar(itens, posicoes) que gira a lista para a direita a quantidade de posicoes pedida.',
 'Carrossel de banner e rodizio de plantao usam rotacao. O detalhe que quebra a solucao ingenua e o numero de posicoes maior que o tamanho da lista, que precisa dar a volta em vez de estourar.',
 'itens: uma lista, possivelmente vazia. posicoes: inteiro maior ou igual a 0, podendo ser maior que o tamanho da lista.',
 'Uma nova lista rotacionada para a direita. Lista vazia devolve lista vazia.',
 'Entrada: [1, 2, 3, 4], posicoes=1
Saida: [4, 1, 2, 3]

Entrada: [1, 2, 3], posicoes=5
Saida: [2, 3, 1]',
 'posicoes maior que o tamanho da lista precisa dar a volta. Nao altere a lista recebida.',
 30,
 'def rotacionar(itens, posicoes):
    # TODO: implementar
    return []'),

('Parenteses Balanceados',
 'Escreva a funcao balanceado(expressao) que verifica se parenteses, colchetes e chaves abrem e fecham na ordem certa.',
 'Todo parser, editor de codigo e validador de formula faz essa checagem. E o exercicio que apresenta a pilha, e a razao de usar pilha fica obvia: o ultimo que abriu e o primeiro que precisa fechar.',
 'Uma string contendo apenas os caracteres ( ) [ ] { }. Pode estar vazia.',
 'True se estiver balanceado, False caso contrario. String vazia devolve True.',
 'Entrada: "{[()]}"
Saida: True

Entrada: "([)]"
Saida: False',
 'A ordem importa: ([)] esta errado mesmo tendo a mesma quantidade de cada simbolo. Use uma pilha.',
 35,
 'def balanceado(expressao):
    # TODO: implementar
    return False'),

('Numero para Romano',
 'Escreva a funcao para_romano(numero) que converte um inteiro para algarismo romano.',
 'A questao existe para ver como a pessoa organiza uma tabela de conversao em vez de escrever dezenas de ifs. Os casos subtrativos, como 4 e 9, sao o que separa a solucao pensada da solucao remendada.',
 'Um inteiro de 1 a 3999.',
 'Uma string com o algarismo romano em maiusculas.',
 'Entrada: 1994
Saida: "MCMXCIV"

Entrada: 4
Saida: "IV"',
 'Os casos subtrativos (4, 9, 40, 90, 400, 900) precisam sair corretos. Nao use bibliotecas externas.',
 35,
 'def para_romano(numero):
    # TODO: implementar
    return ""'),

('Extrair Dominios dos E-mails',
 'Escreva a funcao dominios(emails) que devolve quantos e-mails existem por dominio.',
 'Analise de base de clientes comeca por essa quebra: quantos usuarios sao de dominio corporativo, quantos de provedor gratuito. Junta separacao de string, normalizacao e contagem numa tarefa so.',
 'Uma lista de strings com e-mails validos, podendo ter maiusculas. Pode vir vazia.',
 'Um dicionario com o dominio em minusculo e a quantidade. Lista vazia devolve dicionario vazio.',
 'Entrada: ["ana@Empresa.com", "bia@empresa.com", "caio@outro.com"]
Saida: {"empresa.com": 2, "outro.com": 1}',
 'O dominio sai em minusculo. Nao use collections.Counter.',
 30,
 'def dominios(emails):
    # TODO: implementar
    return {}'),

('Saldo a Partir dos Lancamentos',
 'Escreva a funcao saldo_final(lancamentos) que calcula o saldo somando creditos e subtraindo debitos.',
 'E o coracao de qualquer extrato. O erro que aparece em producao e tratar o tipo do lancamento com comparacao frouxa e somar um debito por engano, o que so e descoberto na conciliacao do mes.',
 'Uma lista de dicionarios com as chaves "tipo" ("credito" ou "debito") e "valor" (numero positivo). Pode vir vazia.',
 'Um numero com o saldo final. Lista vazia devolve 0.',
 'Entrada: [{"tipo": "credito", "valor": 100}, {"tipo": "debito", "valor": 30}]
Saida: 70',
 'Tipo diferente de credito e debito deve ser ignorado, sem lancar excecao.',
 30,
 'def saldo_final(lancamentos):
    # TODO: implementar
    return 0'),

('Horarios que se Chocam',
 'Escreva a funcao tem_conflito(reservas) que diz se existe alguma sobreposicao de horario.',
 'Reserva de sala, agenda medica e alocacao de recurso caem nesse teste antes de confirmar qualquer marcacao. A comparacao correta entre dois intervalos e curta, mas quase todo mundo escreve a condicao invertida na primeira tentativa.',
 'Uma lista de tuplas (inicio, fim) com horas inteiras, em qualquer ordem.',
 'True se dois horarios quaisquer se sobrepoem. Intervalos que so se encostam, como (8,10) e (10,12), nao sao conflito.',
 'Entrada: [(8, 10), (9, 11)]
Saida: True

Entrada: [(8, 10), (10, 12)]
Saida: False',
 'Fim igual ao inicio do proximo nao e conflito. Ordene antes de comparar.',
 35,
 'def tem_conflito(reservas):
    # TODO: implementar
    return False')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'Python'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Agrupar Pedidos por Cliente', 'Declara a funcao agrupar_por_cliente', 'def\s+agrupar_por_cliente\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar agrupar_por_cliente e receber os pedidos.'),
('Agrupar Pedidos por Cliente', 'Percorre os pedidos', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'O agrupamento sai de um laco sobre a lista de pedidos.'),
('Agrupar Pedidos por Cliente', 'Cria a lista na primeira ocorrencia do cliente', '(not\s+in|setdefault|get\s*\(|in\s+\w+)', 'PONTUAVEL', 3, 'Cliente novo precisa ganhar uma lista vazia antes do primeiro append.'),
('Agrupar Pedidos por Cliente', 'Acumula o valor na lista do cliente', 'append\s*\(', 'PONTUAVEL', 3, 'Atribuir direto substitui o pedido anterior. append mantem todos.'),
('Agrupar Pedidos por Cliente', 'Devolve o dicionario com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O dicionario agrupado precisa voltar como retorno.'),
('Agrupar Pedidos por Cliente', 'Nao use defaultdict', 'defaultdict', 'PROIBIDO', 1, 'O enunciado pediu para tratar a primeira ocorrencia na mao.'),

('Top N Produtos Mais Vendidos', 'Declara a funcao top_produtos', 'def\s+top_produtos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar top_produtos e receber vendas e n.'),
('Top N Produtos Mais Vendidos', 'Ordena os produtos', '(sorted\s*\(|\.sort\s*\()', 'OBRIGATORIO', 1, 'O ranking sai de uma ordenacao sobre os itens do dicionario.'),
('Top N Produtos Mais Vendidos', 'Ordena pela quantidade, nao pelo nome', 'key\s*=', 'PONTUAVEL', 3, 'Sem key, a ordenacao usa a chave do dicionario. O criterio aqui e a quantidade.'),
('Top N Produtos Mais Vendidos', 'Ordena em ordem decrescente', '(reverse\s*=\s*True|-\s*\w+\[1\]|-\s*\w+\s*\[)', 'PONTUAVEL', 3, 'O maior vem primeiro: reverse=True, ou quantidade negativa na chave.'),
('Top N Produtos Mais Vendidos', 'Corta o resultado em n itens', '\[\s*:\s*n\s*\]', 'PONTUAVEL', 2, 'A fatia [:n] ja devolve todos quando n e maior que a lista, sem erro.'),
('Top N Produtos Mais Vendidos', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Media Movel de Tres Dias', 'Declara a funcao media_movel', 'def\s+media_movel\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar media_movel e receber os valores.'),
('Media Movel de Tres Dias', 'Percorre as janelas', 'range\s*\(', 'OBRIGATORIO', 1, 'O laco vai de 0 ate len(valores) - 2 para nao estourar a ultima janela.'),
('Media Movel de Tres Dias', 'Recorta a janela de tres valores', '(\[\s*\w+\s*:\s*\w+\s*\+\s*3|\+\s*1\]|\+\s*2\])', 'PONTUAVEL', 3, 'Cada media usa tres valores consecutivos: a fatia [i:i+3] recorta a janela.'),
('Media Movel de Tres Dias', 'Divide por tres', '(/\s*3|len\s*\()', 'PONTUAVEL', 3, 'A media da janela e a soma dos tres dividida por 3.'),
('Media Movel de Tres Dias', 'Trata a lista curta demais', '(len\s*\(|if\s|range\s*\()', 'PONTUAVEL', 2, 'Com menos de tres elementos nao ha janela, e o resultado e lista vazia.'),
('Media Movel de Tres Dias', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'Os valores chegam por parametro.'),

('Validar CPF pelo Digito Verificador', 'Declara a funcao cpf_valido', 'def\s+cpf_valido\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar cpf_valido e receber o cpf.'),
('Validar CPF pelo Digito Verificador', 'Remove a formatacao antes de calcular', '(replace\s*\(|isdigit|filter\s*\(|join\s*\()', 'OBRIGATORIO', 1, 'Ponto e traco precisam sair antes de qualquer conta.'),
('Validar CPF pelo Digito Verificador', 'Calcula os digitos com peso decrescente', '(range\s*\(|\*\s*\(|10\s*-|11\s*-)', 'PONTUAVEL', 3, 'Cada digito e multiplicado por um peso que decresce; a soma entra na conta do modulo.'),
('Validar CPF pelo Digito Verificador', 'Aplica o modulo 11', '%\s*11', 'PONTUAVEL', 3, 'O digito verificador sai do resto da divisao por 11.'),
('Validar CPF pelo Digito Verificador', 'Rejeita digitos todos iguais', '(set\s*\(|\*\s*11|count\s*\()', 'PONTUAVEL', 2, '111.111.111-11 passa na conta do modulo mas e invalido. Trate esse caso.'),
('Validar CPF pelo Digito Verificador', 'Nao use biblioteca de validacao', 'import\s+(validate|validators)', 'PROIBIDO', 1, 'O enunciado pediu o algoritmo escrito na mao.'),

('Contar Palavras Ignorando Stopwords', 'Declara a funcao contar_relevantes', 'def\s+contar_relevantes\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar contar_relevantes e receber texto e stopwords.'),
('Contar Palavras Ignorando Stopwords', 'Separa o texto em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'A contagem comeca separando a frase em palavras.'),
('Contar Palavras Ignorando Stopwords', 'Descarta as stopwords', '(not\s+in|in\s+stopwords|continue)', 'PONTUAVEL', 3, 'A palavra que esta na lista de stopwords nao pode entrar na contagem.'),
('Contar Palavras Ignorando Stopwords', 'Normaliza a caixa antes de comparar', '(lower\s*\(|casefold\s*\()', 'PONTUAVEL', 3, 'A stopword vem em minusculo; sem normalizar, o "O" maiusculo do texto escapa do filtro.'),
('Contar Palavras Ignorando Stopwords', 'Acumula a contagem no dicionario', '(get\s*\(|setdefault|\[\s*\w+\s*\]\s*=)', 'PONTUAVEL', 2, 'O dicionario guarda palavra e contagem; get com padrao 0 evita KeyError.'),
('Contar Palavras Ignorando Stopwords', 'Nao use collections.Counter', 'Counter', 'PROIBIDO', 1, 'O enunciado pediu sem Counter.'),

('Converter Lista de Dicionarios em CSV', 'Declara a funcao para_csv', 'def\s+para_csv\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar para_csv e receber os registros.'),
('Converter Lista de Dicionarios em CSV', 'Monta a linha de cabecalho', '(keys\s*\(|\[\s*0\s*\])', 'OBRIGATORIO', 1, 'O cabecalho sai das chaves do primeiro registro.'),
('Converter Lista de Dicionarios em CSV', 'Mantem a ordem das colunas em todas as linhas', '(colunas|campos|for\s+\w+\s+in\s+\w+)', 'PONTUAVEL', 3, 'Guarde a ordem das colunas uma vez e use a mesma lista em cada linha.'),
('Converter Lista de Dicionarios em CSV', 'Junta os campos com virgula', 'join\s*\(', 'PONTUAVEL', 3, 'join com virgula evita a virgula sobrando no fim de cada linha.'),
('Converter Lista de Dicionarios em CSV', 'Separa as linhas com quebra de linha', '\\\\n', 'PONTUAVEL', 2, 'As linhas do CSV sao separadas por quebra de linha.'),
('Converter Lista de Dicionarios em CSV', 'Nao use o modulo csv', 'import\s+csv', 'PROIBIDO', 1, 'O enunciado pediu a montagem na mao.'),

('Buscar em Lista Ordenada', 'Declara a funcao busca_binaria', 'def\s+busca_binaria\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar busca_binaria e receber numeros e alvo.'),
('Buscar em Lista Ordenada', 'Mantem os limites da busca', '(inicio|fim|esquerda|direita|low|high)', 'OBRIGATORIO', 1, 'A busca binaria trabalha com dois limites que vao se aproximando.'),
('Buscar em Lista Ordenada', 'Calcula o meio da faixa', '(//\s*2|\/\/2)', 'PONTUAVEL', 3, 'O meio e a media dos limites com divisao inteira.'),
('Buscar em Lista Ordenada', 'Descarta metade a cada passo', '(=\s*meio\s*[-+]\s*1|meio\s*\+\s*1|meio\s*-\s*1)', 'PONTUAVEL', 3, 'Ajustar o limite para meio+1 ou meio-1 e o que evita o laco infinito.'),
('Buscar em Lista Ordenada', 'Devolve -1 quando nao encontra', '-\s*1', 'PONTUAVEL', 2, 'Sem o -1 nao da para distinguir ausencia da posicao 0.'),
('Buscar em Lista Ordenada', 'Nao use index nem o operador in', '(\.index\s*\(|in\s+numeros)', 'PROIBIDO', 1, 'Isso percorre a lista inteira e joga fora a vantagem da busca binaria.'),

('Somar Valores Aninhados', 'Declara a funcao somar_tudo', 'def\s+somar_tudo\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar somar_tudo e receber a estrutura.'),
('Somar Valores Aninhados', 'Distingue numero de lista', 'isinstance\s*\(', 'OBRIGATORIO', 1, 'isinstance responde se o item e uma lista para descer mais um nivel.'),
('Somar Valores Aninhados', 'Desce nos niveis internos', '(somar_tudo\s*\(|stack|pilha|while)', 'PONTUAVEL', 3, 'Chamar a propria funcao para a sublista resolve qualquer profundidade.'),
('Somar Valores Aninhados', 'Acumula a soma', '(\+=|sum\s*\()', 'PONTUAVEL', 3, 'Os valores encontrados precisam ser somados num total.'),
('Somar Valores Aninhados', 'Devolve o total com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O total precisa voltar como retorno.'),
('Somar Valores Aninhados', 'Nao use bibliotecas externas', 'itertools', 'PROIBIDO', 1, 'O enunciado pediu a solucao sem bibliotecas.'),

('Detectar Ciclo em Encadeamento', 'Declara a funcao tem_ciclo', 'def\s+tem_ciclo\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar tem_ciclo e receber o dicionario.'),
('Detectar Ciclo em Encadeamento', 'Guarda as tarefas ja visitadas', '(set\s*\(|visitad|vistos)', 'OBRIGATORIO', 1, 'Detectar ciclo e detectar repeticao: e preciso lembrar por onde ja passou.'),
('Detectar Ciclo em Encadeamento', 'Percorre a partir de cada tarefa', 'for\s+\w+\s+in', 'PONTUAVEL', 3, 'O ciclo pode nao envolver a primeira chave, entao todas precisam ser testadas.'),
('Detectar Ciclo em Encadeamento', 'Segue o encadeamento ate o fim', 'while', 'PONTUAVEL', 3, 'A partir de cada tarefa, siga o proximo ate encontrar None ou repetir alguem.'),
('Detectar Ciclo em Encadeamento', 'Para no fim da corrente', '(is\s+not\s+None|is\s+None|!=\s*None)', 'PONTUAVEL', 2, 'A ultima tarefa aponta para None, que e a condicao de parada.'),
('Detectar Ciclo em Encadeamento', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Formatar Valor em Reais', 'Declara a funcao formatar_reais', 'def\s+formatar_reais\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar formatar_reais e receber o valor.'),
('Formatar Valor em Reais', 'Fixa duas casas decimais', '(\.2f|02\.|round\s*\()', 'OBRIGATORIO', 1, 'O formato .2f garante as duas casas mesmo quando o valor e inteiro.'),
('Formatar Valor em Reais', 'Separa o milhar', '(,|\.)', 'PONTUAVEL', 3, 'O separador de milhar precisa aparecer: 1234 vira 1.234.'),
('Formatar Valor em Reais', 'Troca os separadores para o padrao brasileiro', 'replace\s*\(', 'PONTUAVEL', 3, 'O Python formata ao contrario. A troca de virgula por ponto precisa ser feita sem embaralhar.'),
('Formatar Valor em Reais', 'Prefixa com o simbolo da moeda', 'R\$', 'PONTUAVEL', 2, 'A saida comeca com R$ e um espaco.'),
('Formatar Valor em Reais', 'Nao use a biblioteca locale', 'import\s+locale', 'PROIBIDO', 1, 'locale depende da configuracao da maquina e o enunciado pediu sem ela.'),

('Intercalar Duas Listas', 'Declara a funcao intercalar', 'def\s+intercalar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar intercalar e receber as duas listas.'),
('Intercalar Duas Listas', 'Percorre as duas listas', '(range\s*\(|while|zip\s*\()', 'OBRIGATORIO', 1, 'A alternancia precisa avancar nas duas listas ao mesmo tempo.'),
('Intercalar Duas Listas', 'Alterna comecando pela primeira', 'append\s*\(', 'PONTUAVEL', 3, 'A ordem e um da primeira, um da segunda, e assim por diante.'),
('Intercalar Duas Listas', 'Anexa o excedente da lista maior', '(\[\s*\w+\s*:\s*\]|extend\s*\(|max\s*\(|len\s*\()', 'PONTUAVEL', 3, 'zip para na lista menor e descarta o resto. O que sobra precisa ir para o fim.'),
('Intercalar Duas Listas', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista intercalada precisa voltar como retorno.'),
('Intercalar Duas Listas', 'Nao use itertools', 'itertools', 'PROIBIDO', 1, 'O enunciado pediu sem itertools.'),

('Resumo Estatistico da Lista', 'Declara a funcao resumo', 'def\s+resumo\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar resumo e receber a lista de numeros.'),
('Resumo Estatistico da Lista', 'Calcula minimo e maximo', '(min\s*\(|max\s*\()', 'OBRIGATORIO', 1, 'min e max resolvem duas das quatro medidas pedidas.'),
('Resumo Estatistico da Lista', 'Calcula a media', '(sum\s*\([\s\S]{0,40}len\s*\(|/\s*len\s*\()', 'PONTUAVEL', 3, 'A media e a soma dividida pela quantidade.'),
('Resumo Estatistico da Lista', 'Ordena antes de achar a mediana', '(sorted\s*\(|\.sort\s*\()', 'PONTUAVEL', 3, 'A mediana exige a lista ordenada; sem ordenar o valor central nao significa nada.'),
('Resumo Estatistico da Lista', 'Trata a quantidade par na mediana', '(%\s*2|//\s*2)', 'PONTUAVEL', 2, 'Com quantidade par, a mediana e a media dos dois valores centrais.'),
('Resumo Estatistico da Lista', 'Nao use a biblioteca statistics', 'import\s+statistics', 'PROIBIDO', 1, 'O enunciado pediu os calculos na mao.'),

('Unir Intervalos que se Sobrepoem', 'Declara a funcao unir_intervalos', 'def\s+unir_intervalos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar unir_intervalos e receber a lista.'),
('Unir Intervalos que se Sobrepoem', 'Ordena os intervalos antes de percorrer', '(sorted\s*\(|\.sort\s*\()', 'OBRIGATORIO', 1, 'Sem ordenar pelo inicio, dois intervalos que se sobrepoem podem nunca ficar lado a lado.'),
('Unir Intervalos que se Sobrepoem', 'Compara o fim atual com o inicio seguinte', '(<=|>=|<|>)', 'PONTUAVEL', 3, 'Ha sobreposicao quando o inicio do proximo e menor ou igual ao fim do atual.'),
('Unir Intervalos que se Sobrepoem', 'Estende o intervalo com o maior fim', 'max\s*\(', 'PONTUAVEL', 3, 'Ao unir, o fim e o maior dos dois: (1,9) e (2,5) viram (1,9), nao (1,5).'),
('Unir Intervalos que se Sobrepoem', 'Monta a lista de saida', '(append\s*\(|\[\s*\])', 'PONTUAVEL', 2, 'Os intervalos ja consolidados vao para uma lista nova.'),
('Unir Intervalos que se Sobrepoem', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Ordenar por Dois Criterios', 'Declara a funcao ranking', 'def\s+ranking\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar ranking e receber a lista de jogadores.'),
('Ordenar por Dois Criterios', 'Ordena com chave', 'key\s*=', 'OBRIGATORIO', 1, 'A ordenacao por campo de dicionario exige o parametro key.'),
('Ordenar por Dois Criterios', 'Usa os dois criterios na mesma chave', '(\(\s*-|,\s*\w+\[.nome.\]|tuple|,)', 'PONTUAVEL', 3, 'Uma tupla como chave resolve os dois criterios de uma vez.'),
('Ordenar por Dois Criterios', 'Inverte apenas os pontos', '(-\s*\w+\[|reverse\s*=\s*True)', 'PONTUAVEL', 3, 'Pontos sao decrescentes e o nome crescente: negar os pontos na chave resolve sem inverter o nome.'),
('Ordenar por Dois Criterios', 'Devolve uma lista nova', '(sorted\s*\(|return\s+\S+)', 'PONTUAVEL', 2, 'sorted devolve lista nova e preserva a recebida.'),
('Ordenar por Dois Criterios', 'Nao ordene duas vezes seguidas', '\.sort\s*\([\s\S]{0,200}\.sort\s*\(', 'PROIBIDO', 1, 'Duas ordenacoes seguidas dependem da estabilidade e confundem quem le. Use uma chave composta.'),

('Paginar uma Lista', 'Declara a funcao paginar', 'def\s+paginar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar paginar e receber itens, pagina e tamanho.'),
('Paginar uma Lista', 'Calcula o inicio da pagina', '(pagina\s*-\s*1|\(\s*pagina\s*-)', 'OBRIGATORIO', 1, 'A pagina 1 comeca no indice 0, entao o calculo usa pagina - 1.'),
('Paginar uma Lista', 'Multiplica pelo tamanho da pagina', '\*\s*tamanho', 'PONTUAVEL', 3, 'O indice inicial e (pagina - 1) vezes o tamanho.'),
('Paginar uma Lista', 'Recorta com fatia', '\[\s*\w+\s*:', 'PONTUAVEL', 3, 'A fatia devolve lista vazia quando o inicio passa do fim, sem lancar excecao.'),
('Paginar uma Lista', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'Os itens da pagina precisam voltar como retorno.'),
('Paginar uma Lista', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'Todos os parametros chegam pela assinatura.'),

('Cache de Resultados', 'Declara a funcao calcular_com_cache', 'def\s+calcular_com_cache\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar calcular_com_cache e receber numeros e cache.'),
('Cache de Resultados', 'Consulta o cache antes de calcular', '(in\s+cache|cache\.get|not\s+in)', 'OBRIGATORIO', 1, 'O ganho do cache vem de checar antes: se ja tem, nao calcula de novo.'),
('Cache de Resultados', 'Guarda o resultado novo no cache', 'cache\s*\[', 'PONTUAVEL', 3, 'Depois de calcular, o valor precisa ser gravado para a proxima vez.'),
('Cache de Resultados', 'Calcula o quadrado', '(\*\*\s*2|\*\s*\w+)', 'PONTUAVEL', 3, 'O calculo pedido e o quadrado do numero.'),
('Cache de Resultados', 'Monta a lista de saida na ordem', '(append\s*\(|return\s+\S+)', 'PONTUAVEL', 2, 'A saida segue a ordem da entrada, inclusive nos repetidos.'),
('Cache de Resultados', 'Nao substitua o cache recebido', 'cache\s*=\s*\{\s*\}', 'PROIBIDO', 1, 'Reatribuir cache cria um dicionario local e o chamador nao ve nada.'),

('Validar Campos Obrigatorios', 'Declara a funcao validar_pedido', 'def\s+validar_pedido\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar validar_pedido e receber pedido e obrigatorios.'),
('Validar Campos Obrigatorios', 'Percorre a lista de obrigatorios', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'A ordem da saida segue a lista de campos obrigatorios.'),
('Validar Campos Obrigatorios', 'Detecta o campo ausente', '(not\s+in|get\s*\()', 'PONTUAVEL', 3, 'Campo que nem chegou no dicionario precisa entrar na lista de problemas.'),
('Validar Campos Obrigatorios', 'Detecta o campo presente e vazio', '(==\s*.{2}|not\s+\w+|is\s+None|strip\s*\()', 'PONTUAVEL', 3, 'Campo presente com string vazia conta como ausente, e essa e a parte que costuma escapar.'),
('Validar Campos Obrigatorios', 'Devolve a lista de problemas', 'return\s+\S+', 'PONTUAVEL', 2, 'A resposta util lista todos os campos com problema de uma vez.'),
('Validar Campos Obrigatorios', 'Nao pare no primeiro erro', 'return\s+\[\s*\w+\s*\]\s*$', 'PROIBIDO', 1, 'Devolver so o primeiro campo obriga o cliente a corrigir um por vez.'),

('Par que Soma o Alvo', 'Declara a funcao par_com_soma', 'def\s+par_com_soma\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar par_com_soma e receber numeros e alvo.'),
('Par que Soma o Alvo', 'Guarda os numeros ja vistos', '(set\s*\(|\{\s*\}|vistos|in\s+\w+)', 'OBRIGATORIO', 1, 'Guardar o que ja passou e o que permite responder numa varredura so.'),
('Par que Soma o Alvo', 'Calcula o complemento do alvo', '(alvo\s*-|-\s*\w+)', 'PONTUAVEL', 3, 'Para cada numero, o que falta e alvo menos ele. Basta procurar esse complemento.'),
('Par que Soma o Alvo', 'Devolve a tupla dos dois valores', 'return\s*\(?\s*\w+\s*,', 'PONTUAVEL', 3, 'A saida e uma tupla com os dois numeros, na ordem em que aparecem.'),
('Par que Soma o Alvo', 'Devolve None quando nao ha par', 'return\s+None', 'PONTUAVEL', 2, 'Sem par, o enunciado pede None e nao uma tupla vazia.'),
('Par que Soma o Alvo', 'Nao use dois lacos aninhados', 'for\s+\w+\s+in[\s\S]{0,120}for\s+\w+\s+in', 'PROIBIDO', 1, 'O laco dentro do laco resolve mas e quadratico, e o enunciado pediu uma varredura.'),

('Comprimir Texto Repetido', 'Declara a funcao comprimir', 'def\s+comprimir\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar comprimir e receber o texto.'),
('Comprimir Texto Repetido', 'Percorre o texto contando repeticoes', 'for\s+\w+\s+in|while', 'OBRIGATORIO', 1, 'A contagem da sequencia sai de um laco que compara com o caractere anterior.'),
('Comprimir Texto Repetido', 'Compara com o caractere anterior', '(==|!=|anterior|atual)', 'PONTUAVEL', 3, 'A sequencia termina quando o caractere muda.'),
('Comprimir Texto Repetido', 'Concatena caractere e contagem', '(str\s*\(|f.|join\s*\(|\+)', 'PONTUAVEL', 3, 'O formato e o caractere seguido do numero de repeticoes.'),
('Comprimir Texto Repetido', 'Devolve o original quando nao compensa', 'len\s*\(', 'PONTUAVEL', 2, 'Se o resultado nao ficou menor, o enunciado manda devolver o texto original.'),
('Comprimir Texto Repetido', 'Nao use itertools.groupby', 'groupby', 'PROIBIDO', 1, 'O enunciado pediu a contagem escrita na mao.'),

('Rotacionar a Lista', 'Declara a funcao rotacionar', 'def\s+rotacionar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar rotacionar e receber itens e posicoes.'),
('Rotacionar a Lista', 'Normaliza posicoes maiores que a lista', '%\s*len\s*\(', 'OBRIGATORIO', 1, 'O resto da divisao pelo tamanho faz a rotacao dar a volta em vez de estourar.'),
('Rotacionar a Lista', 'Recorta a cauda que vai para a frente', '\[\s*-', 'PONTUAVEL', 3, 'Os ultimos elementos passam para o comeco: a fatia [-n:] pega essa parte.'),
('Rotacionar a Lista', 'Junta as duas partes na ordem certa', '(\+|extend\s*\()', 'PONTUAVEL', 3, 'A lista rotacionada e a cauda seguida do restante.'),
('Rotacionar a Lista', 'Trata a lista vazia', '(if\s|not\s+\w+|len\s*\()', 'PONTUAVEL', 2, 'Lista vazia faz o resto da divisao por zero estourar. Trate antes.'),
('Rotacionar a Lista', 'Nao altere a lista recebida', '\.reverse\s*\(', 'PROIBIDO', 1, 'reverse altera a lista original, e o enunciado pede uma lista nova.'),

('Parenteses Balanceados', 'Declara a funcao balanceado', 'def\s+balanceado\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar balanceado e receber a expressao.'),
('Parenteses Balanceados', 'Usa uma pilha', '(append\s*\(|pop\s*\()', 'OBRIGATORIO', 1, 'O ultimo simbolo aberto e o primeiro que precisa fechar: isso e uma pilha.'),
('Parenteses Balanceados', 'Empilha os simbolos de abertura', 'append\s*\(', 'PONTUAVEL', 3, 'Todo simbolo que abre vai para a pilha esperando o par dele.'),
('Parenteses Balanceados', 'Confere se o fechamento casa com o topo', '(pop\s*\(|\[\s*-\s*1\s*\])', 'PONTUAVEL', 3, 'Ao fechar, o simbolo precisa casar com o que esta no topo da pilha.'),
('Parenteses Balanceados', 'Exige a pilha vazia no fim', '(not\s+\w+|len\s*\(\s*\w+\s*\)\s*==\s*0|return\s+not)', 'PONTUAVEL', 2, 'Sobrou simbolo aberto na pilha, a expressao nao esta balanceada.'),
('Parenteses Balanceados', 'Nao conte apenas a quantidade', 'count\s*\(', 'PROIBIDO', 1, 'Contar quantos abrem e fecham aprova ([)], que esta errado. A ordem importa.'),

('Numero para Romano', 'Declara a funcao para_romano', 'def\s+para_romano\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar para_romano e receber o numero.'),
('Numero para Romano', 'Percorre uma tabela de valores', '(for\s+\w+\s+in|while)', 'OBRIGATORIO', 1, 'A conversao percorre os valores do maior para o menor, subtraindo.'),
('Numero para Romano', 'Inclui os casos subtrativos na tabela', '(CM|XC|IV|IX|XL)', 'PONTUAVEL', 3, 'Sem CM, XC, XL, IX e IV na tabela, o 1994 sai errado.'),
('Numero para Romano', 'Subtrai o valor a cada simbolo emitido', '(-=|-\s*\w+)', 'PONTUAVEL', 3, 'A cada simbolo escrito, o valor correspondente sai do numero restante.'),
('Numero para Romano', 'Monta a string de saida', '(\+=|join\s*\()', 'PONTUAVEL', 2, 'Os simbolos vao sendo concatenados na ordem em que sao emitidos.'),
('Numero para Romano', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Extrair Dominios dos E-mails', 'Declara a funcao dominios', 'def\s+dominios\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar dominios e receber a lista de e-mails.'),
('Extrair Dominios dos E-mails', 'Separa o dominio pelo arroba', '(split\s*\(|partition|index\s*\()', 'OBRIGATORIO', 1, 'O dominio e a parte depois do arroba.'),
('Extrair Dominios dos E-mails', 'Normaliza o dominio para minusculo', 'lower\s*\(', 'PONTUAVEL', 3, 'Sem normalizar, Empresa.com e empresa.com viram duas chaves diferentes.'),
('Extrair Dominios dos E-mails', 'Acumula a contagem no dicionario', '(get\s*\(|setdefault|\[\s*\w+\s*\]\s*=)', 'PONTUAVEL', 3, 'O dicionario guarda dominio e quantidade.'),
('Extrair Dominios dos E-mails', 'Devolve o dicionario com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O dicionario precisa voltar como retorno.'),
('Extrair Dominios dos E-mails', 'Nao use collections.Counter', 'Counter', 'PROIBIDO', 1, 'O enunciado pediu sem Counter.'),

('Saldo a Partir dos Lancamentos', 'Declara a funcao saldo_final', 'def\s+saldo_final\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar saldo_final e receber os lancamentos.'),
('Saldo a Partir dos Lancamentos', 'Percorre os lancamentos', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'O saldo sai de um laco sobre a lista de lancamentos.'),
('Saldo a Partir dos Lancamentos', 'Soma os creditos', 'credito', 'PONTUAVEL', 3, 'O credito entra somando no saldo.'),
('Saldo a Partir dos Lancamentos', 'Subtrai os debitos', '(debito|-=|-\s*\w+)', 'PONTUAVEL', 3, 'O debito precisa sair do saldo, nao entrar.'),
('Saldo a Partir dos Lancamentos', 'Ignora tipo desconhecido', '(elif|else|==)', 'PONTUAVEL', 2, 'Tipo fora de credito e debito nao pode virar excecao nem entrar na conta.'),
('Saldo a Partir dos Lancamentos', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Horarios que se Chocam', 'Declara a funcao tem_conflito', 'def\s+tem_conflito\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar tem_conflito e receber as reservas.'),
('Horarios que se Chocam', 'Ordena as reservas antes de comparar', '(sorted\s*\(|\.sort\s*\()', 'OBRIGATORIO', 1, 'Ordenando pelo inicio, basta comparar cada reserva com a seguinte.'),
('Horarios que se Chocam', 'Compara o fim de uma com o inicio da outra', '(<|>|<=|>=)', 'PONTUAVEL', 3, 'Ha conflito quando o proximo comeca antes do atual terminar.'),
('Horarios que se Chocam', 'Trata o encosto como nao conflito', '(<\s|>\s)', 'PONTUAVEL', 3, 'Fim igual ao inicio seguinte nao e conflito: a comparacao precisa ser estrita.'),
('Horarios que se Chocam', 'Devolve booleano', '(return\s+(True|False))', 'PONTUAVEL', 2, 'A resposta e True ou False.'),
('Horarios que se Chocam', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'As reservas chegam por parametro.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
