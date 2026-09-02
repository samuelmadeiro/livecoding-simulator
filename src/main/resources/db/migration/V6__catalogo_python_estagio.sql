-- Catalogo Python, nivel estagio: 50 questoes de algoritmo.
--
-- Cada questao responde as mesmas cinco perguntas que um entrevistador responderia antes de
-- mandar alguem codar: por que o problema existe, o que entra, o que sai, um caso resolvido e o
-- que nao vale. Enunciado vago reprova por interpretacao, e nao por codigo.
--
-- Os criterios sao escritos contra o que o enunciado pediu, nunca contra um detalhe que so o autor
-- sabia. A dica e o que o entrevistador fala quando o criterio falha: aponta o caminho sem
-- entregar a resposta.
--
-- Idempotente e sem id explicito, como as demais migrations de catalogo.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'ESTAGIO', 'ALGORITMO_EASY', v.tempo, v.template, t.id
FROM (VALUES

('Total do Carrinho',
 'Escreva a funcao total_carrinho(itens) que devolve quanto o cliente vai pagar somando preco vezes quantidade de cada item.',
 'Toda tela de e-commerce mostra um subtotal antes do pagamento. Esse numero sai de um laco que percorre o carrinho e acumula preco vezes quantidade. E a primeira coisa que quebra quando alguem esquece a quantidade e soma so o preco unitario.',
 'Uma lista de dicionarios. Cada dicionario tem as chaves "preco" (float, sempre positivo) e "quantidade" (int, sempre positivo). A lista pode vir vazia.',
 'Um numero com o total. Carrinho vazio devolve 0.',
 'Entrada: [{"preco": 10.0, "quantidade": 2}, {"preco": 5.5, "quantidade": 4}]
Saida: 42.0',
 'Nao use bibliotecas externas. A funcao recebe a lista por parametro: nao leia nada do teclado.',
 20,
 'def total_carrinho(itens):
    # TODO: implementar
    return 0'),

('Media de Notas',
 'Escreva a funcao media(notas) que devolve a media aritmetica das notas recebidas.',
 'Um sistema academico calcula a media do aluno a cada lancamento de nota. O detalhe que separa quem passa de quem nao passa nesta questao e a turma sem nota nenhuma: dividir por zero derruba a aplicacao inteira em producao.',
 'Uma lista de numeros (int ou float), possivelmente vazia.',
 'Um numero com a media. Lista vazia devolve 0, sem lancar excecao.',
 'Entrada: [7.0, 8.5, 6.5]
Saida: 7.333333333333333

Entrada: []
Saida: 0',
 'Trate a lista vazia sem deixar estourar ZeroDivisionError. Nao use bibliotecas externas.',
 20,
 'def media(notas):
    # TODO: implementar
    return 0'),

('Contar Vogais do Texto',
 'Escreva a funcao contar_vogais(texto) que devolve quantas vogais existem no texto.',
 'Filtros de busca e validadores de apelido costumam contar tipos de caractere. E o exercicio classico para ver se a pessoa sabe percorrer uma string e comparar caractere a caractere sem se perder em maiuscula e minuscula.',
 'Uma string, que pode estar vazia e pode misturar maiusculas e minusculas.',
 'Um inteiro com a quantidade de vogais. Texto vazio devolve 0.',
 'Entrada: "Banana Azeda"
Saida: 6',
 'Considere apenas a, e, i, o, u. Maiuscula e minuscula contam igual. Nao use bibliotecas externas.',
 20,
 'def contar_vogais(texto):
    # TODO: implementar
    return 0'),

('Verificador de Palindromo',
 'Escreva a funcao eh_palindromo(texto) que diz se o texto se le igual de tras para frente.',
 'Aparece em entrevista para ver como a pessoa normaliza dados antes de comparar. O problema de verdade nao e inverter a string: e lembrar que "Ame a ema" e palindromo mesmo tendo espaco e maiuscula.',
 'Uma string que pode conter espacos, pontuacao e letras maiusculas.',
 'True se for palindromo, False se nao for. Texto vazio devolve True.',
 'Entrada: "Ame a ema"
Saida: True

Entrada: "Python"
Saida: False',
 'Ignore espacos, pontuacao e diferenca entre maiuscula e minuscula. Devolva booleano, nao string.',
 25,
 'def eh_palindromo(texto):
    # TODO: implementar
    return False'),

('Soma dos Numeros Pares',
 'Escreva a funcao soma_pares(numeros) que devolve a soma apenas dos numeros pares da lista.',
 'Relatorios financeiros vivem de somar um subconjunto: so as vendas aprovadas, so os boletos vencidos. O exercicio troca a regra de negocio por uma regra simples de paridade, mas a estrutura do codigo e a mesma: percorrer, testar a condicao, acumular.',
 'Uma lista de inteiros, que pode vir vazia e pode conter numeros negativos.',
 'Um inteiro com a soma dos pares. Lista sem pares devolve 0.',
 'Entrada: [1, 2, 3, 4, 10]
Saida: 16

Entrada: [1, 3, 5]
Saida: 0',
 'Zero e par. Numeros negativos pares tambem contam. Nao use bibliotecas externas.',
 20,
 'def soma_pares(numeros):
    # TODO: implementar
    return 0'),

('Maior e Menor da Lista',
 'Escreva a funcao maior_e_menor(numeros) que devolve uma tupla com o maior e o menor valor da lista, nessa ordem.',
 'Dashboards mostram pico e vale de um periodo: maior venda do mes, menor tempo de resposta. Aqui a armadilha e inicializar as variaveis com zero, o que quebra quando todos os numeros sao negativos.',
 'Uma lista de numeros com pelo menos um elemento.',
 'Uma tupla (maior, menor).',
 'Entrada: [3, -7, 12, 0]
Saida: (12, -7)',
 'Nao inicialize o maior e o menor com 0: use o primeiro elemento da lista. Nao use bibliotecas externas.',
 20,
 'def maior_e_menor(numeros):
    # TODO: implementar
    return (0, 0)'),

('Contar Palavras da Frase',
 'Escreva a funcao contar_palavras(frase) que devolve quantas palavras a frase tem.',
 'Campos de texto com limite de palavras aparecem em qualquer formulario: bio de perfil, descricao de produto, resumo de chamado. O contador precisa aguentar o usuario que digita dois espacos entre as palavras.',
 'Uma string que pode ter espacos extras no comeco, no fim e entre as palavras. Pode estar vazia.',
 'Um inteiro com a quantidade de palavras. String vazia ou so com espacos devolve 0.',
 'Entrada: "  ola   mundo bonito "
Saida: 3',
 'Espacos repetidos nao podem contar como palavra a mais. Nao use bibliotecas externas.',
 20,
 'def contar_palavras(frase):
    # TODO: implementar
    return 0'),

('Remover Duplicados Preservando Ordem',
 'Escreva a funcao remover_duplicados(itens) que devolve uma nova lista sem repeticoes, mantendo a ordem da primeira aparicao de cada item.',
 'Listas de e-mails para disparo, tags de produto e historico de busca precisam ser desduplicados sem baguncar a ordem. Converter para set resolve a repeticao mas perde a ordem, e e exatamente essa a conversa que o entrevistador quer ter.',
 'Uma lista de valores comparaveis (numeros ou strings), possivelmente vazia.',
 'Uma nova lista sem duplicatas, na ordem da primeira ocorrencia. A lista original nao pode ser alterada.',
 'Entrada: [3, 1, 3, 2, 1]
Saida: [3, 1, 2]',
 'A ordem importa: nao devolva um set nem ordene o resultado. Nao altere a lista recebida.',
 25,
 'def remover_duplicados(itens):
    # TODO: implementar
    return []'),

('FizzBuzz ate N',
 'Escreva a funcao fizzbuzz(n) que devolve a lista de 1 ate n, trocando multiplos de 3 por "Fizz", multiplos de 5 por "Buzz" e multiplos de ambos por "FizzBuzz".',
 'E o filtro mais usado do mercado, e nao por ser dificil: mostra se a pessoa cuida da ordem dos testes. Quem checa 3 antes de checar 15 nunca imprime FizzBuzz, e o bug passa despercebido ate alguem olhar o numero 15.',
 'Um inteiro n maior ou igual a 1.',
 'Uma lista com n elementos, misturando inteiros e strings.',
 'Entrada: 5
Saida: [1, 2, "Fizz", 4, "Buzz"]',
 'Teste o caso de multiplo de 3 e 5 antes dos casos separados. Nao use bibliotecas externas.',
 20,
 'def fizzbuzz(n):
    # TODO: implementar
    return []'),

('Frequencia de Cada Item',
 'Escreva a funcao frequencia(itens) que devolve um dicionario com quantas vezes cada item aparece na lista.',
 'Contar ocorrencia e a base de qualquer relatorio: pedidos por status, acessos por pagina, erro por codigo. O padrao de acumular num dicionario aparece em praticamente todo backend.',
 'Uma lista de strings ou numeros, possivelmente vazia.',
 'Um dicionario em que a chave e o item e o valor e a contagem. Lista vazia devolve dicionario vazio.',
 'Entrada: ["a", "b", "a", "c", "a"]
Saida: {"a": 3, "b": 1, "c": 1}',
 'Nao use collections.Counter: a ideia e montar o dicionario na mao.',
 25,
 'def frequencia(itens):
    # TODO: implementar
    return {}'),

('Inverter as Palavras da Frase',
 'Escreva a funcao inverter_palavras(frase) que devolve a frase com as palavras na ordem inversa.',
 'Aparece em tratamento de nome completo e em normalizacao de endereco, onde a ordem dos pedacos muda conforme o pais. O que se avalia e saber separar, reordenar e remontar sem deixar espaco sobrando.',
 'Uma string com palavras separadas por espaco, podendo ter espacos extras.',
 'Uma string com as palavras invertidas, separadas por um unico espaco.',
 'Entrada: "o rato roeu a roupa"
Saida: "roupa a roeu rato o"',
 'A saida nao pode ter espaco duplicado nem espaco nas pontas. Nao inverta as letras, so a ordem das palavras.',
 20,
 'def inverter_palavras(frase):
    # TODO: implementar
    return ""'),

('Filtrar Maiores de Idade',
 'Escreva a funcao maiores_de_idade(pessoas) que devolve a lista dos nomes de quem tem 18 anos ou mais.',
 'Regra de negocio com corte por valor aparece em cadastro, credito e liberacao de conteudo. O detalhe que derruba candidato aqui e o "ou mais": quem usa apenas maior que corta indevidamente quem tem exatamente 18.',
 'Uma lista de dicionarios com as chaves "nome" (string) e "idade" (int).',
 'Uma lista com os nomes, na mesma ordem da entrada. Nenhum maior de idade devolve lista vazia.',
 'Entrada: [{"nome": "Ana", "idade": 17}, {"nome": "Bia", "idade": 18}]
Saida: ["Bia"]',
 'Quem tem exatamente 18 entra no resultado. Devolva apenas os nomes, nao os dicionarios.',
 20,
 'def maiores_de_idade(pessoas):
    # TODO: implementar
    return []'),

('Aplicar Desconto Percentual',
 'Escreva a funcao aplicar_desconto(preco, percentual) que devolve o preco ja com o desconto aplicado.',
 'Cupom e promocao passam por essa conta em toda loja online. O erro comum e dividir por 100 no lugar errado e devolver um preco maior que o original, o que so aparece quando o cliente reclama.',
 'preco: numero positivo. percentual: numero de 0 a 100.',
 'Um numero com o preco final. Percentual 0 devolve o preco original.',
 'Entrada: preco=200.0, percentual=25
Saida: 150.0',
 'Percentual fora da faixa de 0 a 100 deve devolver o preco original, sem calcular. Nao use bibliotecas externas.',
 20,
 'def aplicar_desconto(preco, percentual):
    # TODO: implementar
    return preco'),

('Verificar Ano Bissexto',
 'Escreva a funcao eh_bissexto(ano) que diz se o ano informado e bissexto.',
 'Qualquer sistema que calcule vencimento, ferias ou juros esbarra nisso. A regra tem tres partes e quase todo mundo lembra so da primeira: divisivel por 4, mas nao por 100, a nao ser que tambem seja por 400.',
 'Um inteiro com o ano, sempre positivo.',
 'True se for bissexto, False se nao for.',
 'Entrada: 2024
Saida: True

Entrada: 1900
Saida: False',
 'A regra do 400 precisa estar contemplada: 2000 e bissexto e 1900 nao e. Nao use a biblioteca calendar.',
 20,
 'def eh_bissexto(ano):
    # TODO: implementar
    return False'),

('Soma dos Digitos',
 'Escreva a funcao soma_digitos(numero) que devolve a soma dos algarismos do numero.',
 'E o primeiro passo de qualquer validacao de documento ou cartao, onde o digito verificador nasce de uma soma dos algarismos. Tambem mostra se a pessoa sabe transitar entre numero e string sem se perder.',
 'Um inteiro positivo.',
 'Um inteiro com a soma dos algarismos.',
 'Entrada: 1234
Saida: 10',
 'A funcao recebe o numero por parametro: nao leia nada do teclado. Nao use bibliotecas externas.',
 20,
 'def soma_digitos(numero):
    # TODO: implementar
    return 0'),

('Numero Primo',
 'Escreva a funcao eh_primo(numero) que diz se o numero e primo.',
 'Serve para medir nocao de laco com condicao de parada. Quem testa todos os divisores ate o proprio numero acerta o resultado, mas a conversa seguinte do entrevistador e sempre sobre parar na raiz quadrada.',
 'Um inteiro que pode ser negativo, zero ou positivo.',
 'True se for primo, False caso contrario. Numeros menores que 2 nao sao primos.',
 'Entrada: 7
Saida: True

Entrada: 1
Saida: False',
 'Trate 0, 1 e negativos como nao primos. Nao use bibliotecas externas.',
 25,
 'def eh_primo(numero):
    # TODO: implementar
    return False'),

('Segunda Maior Nota',
 'Escreva a funcao segunda_maior(numeros) que devolve o segundo maior valor distinto da lista.',
 'Ranking de vendedores e podio de campanha precisam do segundo lugar, e o segundo lugar nao e simplesmente o penultimo da lista ordenada quando ha empate no topo. E ai que a maioria das solucoes falha.',
 'Uma lista de numeros com pelo menos dois valores distintos.',
 'Um numero com o segundo maior valor distinto.',
 'Entrada: [10, 8, 10, 7]
Saida: 8',
 'Valores repetidos no topo nao podem virar segundo lugar. Nao use bibliotecas externas.',
 25,
 'def segunda_maior(numeros):
    # TODO: implementar
    return 0'),

('Tabuada de um Numero',
 'Escreva a funcao tabuada(numero) que devolve a lista com os resultados da tabuada de 1 a 10 do numero informado.',
 'Gerar uma sequencia calculada e o que esta por tras de parcelamento, projecao de juros e grade de horarios. A questao troca a regra financeira por uma multiplicacao simples para focar no laco e na montagem da lista.',
 'Um inteiro, que pode ser negativo ou zero.',
 'Uma lista com 10 inteiros, do numero vezes 1 ate o numero vezes 10.',
 'Entrada: 3
Saida: [3, 6, 9, 12, 15, 18, 21, 24, 27, 30]',
 'A lista tem exatamente 10 posicoes, comecando em 1 vez o numero. Nao imprima na tela: devolva a lista.',
 20,
 'def tabuada(numero):
    # TODO: implementar
    return []'),

('Fatorial de um Numero',
 'Escreva a funcao fatorial(n) que devolve o fatorial de n.',
 'E o exercicio padrao para conversar sobre laco acumulador e sobre o caso base. Todo mundo lembra de multiplicar de 1 ate n; quase ninguem lembra que o fatorial de 0 e 1, e esse e justamente o teste que o entrevistador roda primeiro.',
 'Um inteiro maior ou igual a 0.',
 'Um inteiro com o fatorial. O fatorial de 0 e de 1 e igual a 1.',
 'Entrada: 5
Saida: 120

Entrada: 0
Saida: 1',
 'Trate o caso de n igual a 0. Nao use math.factorial: a ideia e escrever a repeticao.',
 20,
 'def fatorial(n):
    # TODO: implementar
    return 1'),

('Sequencia de Fibonacci',
 'Escreva a funcao fibonacci(n) que devolve a lista com os n primeiros numeros da sequencia de Fibonacci, comecando em 0 e 1.',
 'A sequencia aparece pouco em producao, mas o padrao dela aparece muito: cada resultado depende dos dois anteriores, igual a saldo acumulado e a media movel. O erro comum e perder o valor antigo ao atualizar as variaveis na ordem errada.',
 'Um inteiro n maior ou igual a 0.',
 'Uma lista com n elementos. n igual a 0 devolve lista vazia.',
 'Entrada: 6
Saida: [0, 1, 1, 2, 3, 5]

Entrada: 0
Saida: []',
 'A sequencia comeca em 0 e 1. Nao use recursao: o enunciado pede a versao com laco.',
 25,
 'def fibonacci(n):
    # TODO: implementar
    return []'),

('Converter Celsius para Fahrenheit',
 'Escreva a funcao para_fahrenheit(celsius) que converte a temperatura de Celsius para Fahrenheit.',
 'Conversao de unidade e a tarefa mais comum de integracao entre sistemas: peso em libra, distancia em milha, temperatura em Fahrenheit. O que se avalia e ler a formula com atencao, porque trocar a ordem das operacoes da um numero plausivel e errado.',
 'Um numero (int ou float), que pode ser negativo.',
 'Um numero com a temperatura em Fahrenheit.',
 'Entrada: 25
Saida: 77.0

Entrada: -40
Saida: -40.0',
 'A formula e celsius vezes 9/5 mais 32. Multiplique antes de somar. Nao use bibliotecas externas.',
 20,
 'def para_fahrenheit(celsius):
    # TODO: implementar
    return 0'),

('Validar Senha Forte',
 'Escreva a funcao senha_forte(senha) que diz se a senha atende as regras minimas de seguranca.',
 'Toda tela de cadastro valida senha, e a validacao mal escrita e a que aceita tudo ou rejeita tudo. Aqui a pessoa precisa combinar varias condicoes sem esquecer nenhuma, que e o mesmo raciocinio de qualquer regra de negocio composta.',
 'Uma string, que pode estar vazia.',
 'True se a senha tiver ao menos 8 caracteres, uma letra maiuscula, uma minuscula e um digito. False caso contrario.',
 'Entrada: "Senha123"
Saida: True

Entrada: "senha123"
Saida: False',
 'As quatro regras precisam valer ao mesmo tempo. Nao use bibliotecas externas.',
 25,
 'def senha_forte(senha):
    # TODO: implementar
    return False'),

('Primeira Letra Maiuscula',
 'Escreva a funcao capitalizar(frase) que devolve a frase com a primeira letra de cada palavra em maiuscula e o resto em minuscula.',
 'Nome de cliente digitado em caixa alta e nota fiscal com nome torto sao problema diario de sistema de cadastro. Normalizar o nome antes de gravar evita relatorio feio e busca que nao encontra ninguem.',
 'Uma string com palavras separadas por espaco. Pode vir toda em maiuscula ou toda em minuscula.',
 'Uma string com cada palavra capitalizada. String vazia devolve string vazia.',
 'Entrada: "maria DA silva"
Saida: "Maria Da Silva"',
 'O restante de cada palavra fica em minuscula. Nao use a funcao title() pronta: separe e monte a frase.',
 25,
 'def capitalizar(frase):
    # TODO: implementar
    return ""'),

('Contar Aprovados e Reprovados',
 'Escreva a funcao contar_situacao(notas) que devolve uma tupla com a quantidade de aprovados e de reprovados.',
 'Fechamento de turma, de campanha ou de lote de pedidos sempre termina em duas contagens que precisam somar o total. Se o candidato usar apenas um contador e calcular o outro por subtracao, o entrevistador pergunta o que acontece quando surge uma terceira situacao.',
 'Uma lista de numeros de 0 a 10, possivelmente vazia.',
 'Uma tupla (aprovados, reprovados). Aprovado e nota maior ou igual a 6. Lista vazia devolve (0, 0).',
 'Entrada: [10, 5.5, 6, 3]
Saida: (2, 2)',
 'Nota exatamente 6 conta como aprovado. Devolva a tupla, nao um dicionario.',
 20,
 'def contar_situacao(notas):
    # TODO: implementar
    return (0, 0)'),

('Achatar Lista de Listas',
 'Escreva a funcao achatar(listas) que junta varias listas numa unica lista, preservando a ordem.',
 'Resposta de API paginada chega assim: uma lista de paginas, cada pagina com sua lista de registros. Antes de processar, tudo vira uma lista so. E o laco dentro do laco mais comum do dia a dia.',
 'Uma lista de listas. As listas internas podem estar vazias e a externa tambem.',
 'Uma unica lista com todos os elementos, na ordem em que aparecem.',
 'Entrada: [[1, 2], [], [3]]
Saida: [1, 2, 3]',
 'Considere apenas um nivel de aninhamento. Nao use bibliotecas externas como itertools.',
 25,
 'def achatar(listas):
    # TODO: implementar
    return []'),

('Interseccao de Duas Listas',
 'Escreva a funcao em_comum(primeira, segunda) que devolve os elementos presentes nas duas listas, sem repeticao.',
 'Comparar dois conjuntos e rotina de conciliacao: quais clientes estao nas duas campanhas, quais produtos aparecem nos dois fornecedores. O detalhe da questao e nao deixar o item repetido vazar para o resultado.',
 'Duas listas de numeros ou strings, ambas possivelmente vazias.',
 'Uma lista com os elementos comuns, sem repeticao, na ordem em que aparecem na primeira lista.',
 'Entrada: [1, 2, 2, 3], [2, 3, 4]
Saida: [2, 3]',
 'O resultado nao pode ter itens repetidos. A ordem segue a primeira lista.',
 25,
 'def em_comum(primeira, segunda):
    # TODO: implementar
    return []'),

('Dividir Lista em Blocos',
 'Escreva a funcao dividir_em_blocos(itens, tamanho) que quebra a lista em pedacos de no maximo tamanho elementos.',
 'Envio em lote e o caso classico: a API aceita 100 registros por chamada e voce tem 250. O ultimo bloco quase sempre vem incompleto, e e ele que quebra a solucao de quem assume divisao exata.',
 'itens: uma lista, possivelmente vazia. tamanho: um inteiro maior que 0.',
 'Uma lista de listas. O ultimo bloco pode ter menos elementos que tamanho. Lista vazia devolve lista vazia.',
 'Entrada: [1, 2, 3, 4, 5], tamanho=2
Saida: [[1, 2], [3, 4], [5]]',
 'Nenhum elemento pode ser perdido nem duplicado. Nao use bibliotecas externas.',
 25,
 'def dividir_em_blocos(itens, tamanho):
    # TODO: implementar
    return []'),

('Troco em Notas',
 'Escreva a funcao troco(valor) que devolve quantas notas de 100, 50, 20 e 10 sao necessarias para formar o valor.',
 'Caixa eletronico e frente de loja resolvem isso o dia inteiro. E o primeiro contato com algoritmo guloso: pegar sempre a maior nota possivel antes de descer para a proxima. Quem tenta na ordem inversa entrega troco em 40 notas de 10.',
 'Um inteiro multiplo de 10, maior ou igual a 0.',
 'Um dicionario com as chaves 100, 50, 20 e 10 e a quantidade de cada nota. Valor 0 devolve todas as quantidades zeradas.',
 'Entrada: 180
Saida: {100: 1, 50: 1, 20: 1, 10: 1}',
 'Use sempre a maior nota possivel primeiro. O total de notas precisa ser o menor possivel.',
 25,
 'def troco(valor):
    # TODO: implementar
    return {}'),

('Ordenar Nomes em Ordem Alfabetica',
 'Escreva a funcao ordenar_nomes(nomes) que devolve os nomes em ordem alfabetica, ignorando maiusculas e minusculas.',
 'Lista de participantes, catalogo de produtos e ranking de qualquer tela precisam sair ordenados. O erro que aparece na entrevista e ordenar sem normalizar: em Python, "ana" vem depois de "Bruno" porque maiuscula tem codigo menor.',
 'Uma lista de strings, que pode misturar maiusculas e minusculas e pode vir vazia.',
 'Uma nova lista com os nomes ordenados alfabeticamente. A lista original nao pode ser alterada.',
 'Entrada: ["bruno", "Ana", "carla"]
Saida: ["Ana", "bruno", "carla"]',
 'A comparacao ignora a caixa, mas o nome sai do jeito que entrou. Nao altere a lista recebida.',
 25,
 'def ordenar_nomes(nomes):
    # TODO: implementar
    return []'),

('Posicao do Item na Lista',
 'Escreva a funcao posicao(itens, alvo) que devolve o indice da primeira ocorrencia do alvo na lista.',
 'Busca linear e a base de qualquer filtro antes de existir indice no banco. O que a questao cobra e o retorno quando nada e encontrado: devolver 0 confunde com a primeira posicao e gera bug silencioso.',
 'itens: uma lista de numeros ou strings, possivelmente vazia. alvo: o valor procurado.',
 'O indice da primeira ocorrencia, comecando em 0. Devolve -1 quando o alvo nao existe na lista.',
 'Entrada: ["a", "b", "c"], alvo="c"
Saida: 2

Entrada: ["a"], alvo="z"
Saida: -1',
 'Nao use o metodo index() pronto: ele lanca excecao quando nao encontra. Devolva -1 nesse caso.',
 25,
 'def posicao(itens, alvo):
    # TODO: implementar
    return -1'),

('Verificar Anagrama',
 'Escreva a funcao sao_anagramas(primeira, segunda) que diz se as duas palavras usam exatamente as mesmas letras.',
 'Detectar nome duplicado com letras trocadas e um caso real de deduplicacao de cadastro. A solucao elegante e ordenar as duas e comparar, e a conversa seguinte do entrevistador e sobre o custo dessa ordenacao.',
 'Duas strings, que podem ter maiusculas e espacos.',
 'True se forem anagramas, False caso contrario.',
 'Entrada: "Amor", "Roma"
Saida: True

Entrada: "casa", "asas"
Saida: False',
 'Ignore espacos e diferenca entre maiuscula e minuscula. Nao use collections.Counter.',
 25,
 'def sao_anagramas(primeira, segunda):
    # TODO: implementar
    return False'),

('Converter Minutos em Horas',
 'Escreva a funcao formatar_duracao(minutos) que devolve a duracao escrita como "XhYY".',
 'Toda tela que mostra tempo gasto faz essa conversao: chamado aberto ha 145 minutos vira 2h25. O detalhe que separa a solucao pronta da meia-pronta e o zero a esquerda nos minutos: 2h5 esta errado, o certo e 2h05.',
 'Um inteiro maior ou igual a 0 com a quantidade de minutos.',
 'Uma string no formato "XhYY", com os minutos sempre em duas casas.',
 'Entrada: 145
Saida: "2h25"

Entrada: 65
Saida: "1h05"',
 'Os minutos precisam ter duas casas, com zero a esquerda quando necessario.',
 25,
 'def formatar_duracao(minutos):
    # TODO: implementar
    return ""'),

('Somar os Valores do Dicionario',
 'Escreva a funcao somar_valores(estoque) que devolve a soma de todos os valores do dicionario.',
 'Fechamento de estoque, total de horas por projeto e soma de saldo por conta caem nesse mesmo padrao. O ponto avaliado e saber que o dicionario tem tres formas de ser percorrido, e que aqui so os valores interessam.',
 'Um dicionario em que a chave e uma string e o valor e um numero. Pode vir vazio.',
 'Um numero com a soma dos valores. Dicionario vazio devolve 0.',
 'Entrada: {"teclado": 3, "mouse": 7}
Saida: 10',
 'Percorra os valores, nao as chaves. Nao use bibliotecas externas.',
 20,
 'def somar_valores(estoque):
    # TODO: implementar
    return 0'),

('Mascarar E-mail',
 'Escreva a funcao mascarar_email(email) que esconde parte do endereco, mantendo a primeira letra e o dominio.',
 'Tela de recuperacao de senha mostra o e-mail mascarado para o usuario reconhecer a conta sem expor o endereco a quem esta olhando. E um requisito de privacidade que aparece em quase todo produto.',
 'Uma string com um e-mail valido, sempre contendo um arroba.',
 'Uma string com a primeira letra, tres asteriscos e o dominio a partir do arroba.',
 'Entrada: "maria@empresa.com"
Saida: "m***@empresa.com"',
 'O dominio precisa sair inteiro. Nao use bibliotecas externas.',
 25,
 'def mascarar_email(email):
    # TODO: implementar
    return ""'),

('Media por Materia',
 'Escreva a funcao media_por_materia(boletim) que devolve um dicionario com a media de cada materia.',
 'Boletim, relatorio por filial e consumo por servidor tem a mesma forma: uma chave apontando para varias medicoes. Percorrer dicionario de listas e um passo obrigatorio antes de qualquer relatorio agregado.',
 'Um dicionario em que a chave e o nome da materia e o valor e uma lista de notas. Alguma lista pode vir vazia.',
 'Um dicionario com a materia e a media. Materia sem nota tem media 0.',
 'Entrada: {"matematica": [8, 6], "historia": []}
Saida: {"matematica": 7.0, "historia": 0}',
 'Materia com lista vazia nao pode causar divisao por zero. Nao use bibliotecas externas.',
 25,
 'def media_por_materia(boletim):
    # TODO: implementar
    return {}'),

('Item Mais Frequente',
 'Escreva a funcao mais_frequente(itens) que devolve o item que mais aparece na lista.',
 'Produto mais vendido, erro mais comum no log, pagina mais acessada: todos saem dessa mesma contagem seguida de um maximo. E o exercicio que junta dicionario e comparacao numa coisa so.',
 'Uma lista de strings ou numeros com pelo menos um elemento.',
 'O item que mais aparece. Havendo empate, devolve o que apareceu primeiro na lista.',
 'Entrada: ["a", "b", "a", "b", "a"]
Saida: "a"',
 'No empate vence quem apareceu primeiro. Nao use collections.Counter.',
 25,
 'def mais_frequente(itens):
    # TODO: implementar
    return None'),

('Remover Espacos Extras',
 'Escreva a funcao limpar_espacos(texto) que devolve o texto sem espacos nas pontas e com apenas um espaco entre as palavras.',
 'Dado digitado por usuario chega sujo, e espaco invisivel no fim do campo e a causa numero um de busca que nao encontra o registro. Limpar antes de gravar e regra basica de cadastro.',
 'Uma string que pode ter espacos no comeco, no fim e repetidos no meio.',
 'Uma string limpa. Texto so com espacos devolve string vazia.',
 'Entrada: "   ola    mundo   "
Saida: "ola mundo"',
 'Nao use expressao regular: separe e remonte com os metodos de string.',
 20,
 'def limpar_espacos(texto):
    # TODO: implementar
    return ""'),

('Maior Palavra da Frase',
 'Escreva a funcao maior_palavra(frase) que devolve a palavra mais longa da frase.',
 'Serve para dimensionar coluna de relatorio e para truncar texto sem cortar palavra no meio. O caso de borda que o entrevistador testa e o empate: duas palavras do mesmo tamanho, e a regra precisa estar definida.',
 'Uma string com palavras separadas por espaco. Pode estar vazia.',
 'A palavra mais longa. Havendo empate, devolve a primeira. Frase vazia devolve string vazia.',
 'Entrada: "o rato roeu a roupa"
Saida: "roupa"',
 'No empate vence a primeira palavra. Trate a frase vazia sem lancar excecao.',
 20,
 'def maior_palavra(frase):
    # TODO: implementar
    return ""'),

('Todos os Numeros Positivos',
 'Escreva a funcao todos_positivos(numeros) que diz se todos os numeros da lista sao maiores que zero.',
 'Validacao de lote antes de gravar: nenhum item pode ter quantidade negativa, nenhum lancamento pode ter valor invalido. O ganho de quem sabe usar all e sair do laco na primeira falha, sem varrer o resto a toa.',
 'Uma lista de numeros, possivelmente vazia.',
 'True se todos forem maiores que zero. Lista vazia devolve True.',
 'Entrada: [1, 5, 3]
Saida: True

Entrada: [1, 0]
Saida: False',
 'Zero nao e positivo. Lista vazia devolve True. Nao use bibliotecas externas.',
 20,
 'def todos_positivos(numeros):
    # TODO: implementar
    return False'),

('Calcular e Classificar o IMC',
 'Escreva a funcao classificar_imc(peso, altura) que calcula o IMC e devolve a faixa correspondente.',
 'Aplicativo de saude faz esse calculo e mostra a faixa, nao o numero cru. A questao junta duas coisas que aparecem juntas o tempo todo: uma formula e uma cadeia de faixas, onde o erro comum e sobrepor os limites e classificar errado quem esta na fronteira.',
 'peso: numero em quilos, maior que 0. altura: numero em metros, maior que 0.',
 'Uma string com a faixa: "abaixo" para IMC menor que 18.5, "normal" ate 24.9, "sobrepeso" ate 29.9 e "obesidade" de 30 em diante.',
 'Entrada: peso=70, altura=1.75
Saida: "normal"',
 'O IMC e peso dividido pela altura ao quadrado. As faixas nao podem se sobrepor.',
 25,
 'def classificar_imc(peso, altura):
    # TODO: implementar
    return ""'),

('Total de Horas Trabalhadas',
 'Escreva a funcao total_horas(registros) que soma as horas trabalhadas na semana.',
 'Folha de ponto e faturamento por hora dependem dessa soma. O detalhe da questao e o registro em aberto: quem entrou e ainda nao saiu nao pode entrar na conta nem derrubar o calculo.',
 'Uma lista de dicionarios com as chaves "entrada" e "saida", ambas em horas inteiras (int). A chave "saida" pode vir como None quando o expediente ainda esta aberto.',
 'Um numero com o total de horas. Registros em aberto sao ignorados. Lista vazia devolve 0.',
 'Entrada: [{"entrada": 9, "saida": 18}, {"entrada": 9, "saida": None}]
Saida: 9',
 'Registro com saida None nao entra na soma e nao pode lancar excecao.',
 25,
 'def total_horas(registros):
    # TODO: implementar
    return 0'),

('Juntar Dois Dicionarios Somando',
 'Escreva a funcao juntar_estoques(primeiro, segundo) que soma as quantidades dos dois dicionarios.',
 'Consolidar estoque de duas lojas, ou somar metricas de dois servidores, cai exatamente nisso. Quem usa update() sobrescreve a quantidade da primeira loja em vez de somar, e o estoque final sai menor que o real.',
 'Dois dicionarios com chave string e valor inteiro. Podem ter chaves diferentes e podem vir vazios.',
 'Um novo dicionario com todas as chaves e a soma das quantidades. Os dicionarios recebidos nao podem ser alterados.',
 'Entrada: {"teclado": 2, "mouse": 1}, {"teclado": 3}
Saida: {"teclado": 5, "mouse": 1}',
 'Chave presente nos dois soma; chave presente num so entra com o valor dela. Nao altere os dicionarios recebidos.',
 25,
 'def juntar_estoques(primeiro, segundo):
    # TODO: implementar
    return {}'),

('Sigla do Nome',
 'Escreva a funcao sigla(nome) que devolve as iniciais do nome em maiuscula.',
 'Avatar de usuario sem foto mostra as iniciais, e sistema de protocolo gera codigo a partir do nome. E um exercicio curto que revela se a pessoa sabe combinar iteracao, indexacao de string e juncao.',
 'Uma string com o nome completo, palavras separadas por espaco. Pode ter espacos extras.',
 'Uma string com a inicial de cada palavra, em maiuscula, sem separador. Nome vazio devolve string vazia.',
 'Entrada: "maria clara souza"
Saida: "MCS"',
 'Espacos extras nao podem gerar inicial vazia. Nao use bibliotecas externas.',
 20,
 'def sigla(nome):
    # TODO: implementar
    return ""'),

('Itens Acima da Media',
 'Escreva a funcao acima_da_media(numeros) que devolve os valores maiores que a media da lista.',
 'Relatorio de desempenho destaca quem esta acima da media do time, e alerta de consumo aponta o servidor acima da media do cluster. A pegadinha e calcular a media dentro do laco: ela precisa ser calculada uma vez, antes de comparar.',
 'Uma lista de numeros, possivelmente vazia.',
 'Uma lista com os valores maiores que a media, na ordem original. Lista vazia devolve lista vazia.',
 'Entrada: [2, 4, 6]
Saida: [6]',
 'Calcule a media uma unica vez, fora do laco. Lista vazia nao pode dividir por zero.',
 25,
 'def acima_da_media(numeros):
    # TODO: implementar
    return []'),

('Lista Esta Ordenada',
 'Escreva a funcao esta_ordenada(numeros) que diz se a lista esta em ordem crescente.',
 'Checar ordenacao antes de aplicar busca binaria, ou validar que um arquivo chegou na ordem combinada, e tarefa real de integracao. O caminho eficiente compara cada elemento com o seguinte, sem ordenar nada.',
 'Uma lista de numeros, possivelmente vazia ou com um unico elemento.',
 'True se cada elemento for menor ou igual ao seguinte. Lista vazia ou com um elemento devolve True.',
 'Entrada: [1, 2, 2, 5]
Saida: True

Entrada: [3, 1]
Saida: False',
 'Elementos iguais lado a lado continuam ordenados. Nao ordene a lista para comparar.',
 25,
 'def esta_ordenada(numeros):
    # TODO: implementar
    return False'),

('Somar Numeros em Texto',
 'Escreva a funcao somar_texto(valores) que soma os numeros que chegaram como texto.',
 'Arquivo CSV e formulario web entregam tudo como string, e a soma direta concatena em vez de somar. Converter antes de calcular e o primeiro cuidado de qualquer rotina de importacao.',
 'Uma lista de strings, cada uma representando um numero inteiro. A lista pode vir vazia.',
 'Um inteiro com a soma. Lista vazia devolve 0.',
 'Entrada: ["10", "5", "-3"]
Saida: 12',
 'A soma precisa ser numerica, nao concatenacao de texto. Nao use bibliotecas externas.',
 20,
 'def somar_texto(valores):
    # TODO: implementar
    return 0'),

('Percentual de Tarefas Concluidas',
 'Escreva a funcao percentual_concluido(tarefas) que devolve o percentual de tarefas ja concluidas.',
 'Barra de progresso de projeto e de checklist sai desse calculo. O caso que derruba e a lista sem tarefa nenhuma: dividir por zero para a tela inteira, quando o certo e mostrar 0 por cento.',
 'Uma lista de dicionarios com a chave "concluida" (booleano). A lista pode vir vazia.',
 'Um numero de 0 a 100 com o percentual. Lista vazia devolve 0.',
 'Entrada: [{"concluida": True}, {"concluida": False}, {"concluida": True}]
Saida: 66.66666666666667',
 'Lista vazia devolve 0 sem lancar excecao. Nao arredonde o resultado.',
 25,
 'def percentual_concluido(tarefas):
    # TODO: implementar
    return 0'),

('Repetir Texto com Separador',
 'Escreva a funcao repetir(texto, vezes) que repete o texto separado por virgula e espaco.',
 'Montar clausula IN de uma consulta, ou lista de destinatarios, precisa de separador entre os itens e nunca no fim. O separador sobrando no final e um dos erros mais comuns de montagem de string.',
 'texto: uma string. vezes: um inteiro maior ou igual a 0.',
 'Uma string com o texto repetido, separado por ", ". Nao pode haver separador no fim. vezes igual a 0 devolve string vazia.',
 'Entrada: texto="ola", vezes=3
Saida: "ola, ola, ola"',
 'Nao pode sobrar virgula no final. vezes igual a 0 devolve string vazia.',
 20,
 'def repetir(texto, vezes):
    # TODO: implementar
    return ""'),

('Contar Tipos de Caractere',
 'Escreva a funcao contar_tipos(texto) que conta letras, digitos e outros caracteres.',
 'Analisar o conteudo de um campo antes de validar aparece em importacao de dados e em regra de senha. O que se avalia e conhecer os metodos de string que ja respondem essa pergunta em vez de comparar codigo de caractere na mao.',
 'Uma string que pode conter letras, numeros, espacos e pontuacao. Pode estar vazia.',
 'Um dicionario com as chaves "letras", "digitos" e "outros". Texto vazio devolve todas zeradas.',
 'Entrada: "ab 12!"
Saida: {"letras": 2, "digitos": 2, "outros": 2}',
 'Espaco conta como outros. Cada caractere entra em exatamente uma categoria.',
 25,
 'def contar_tipos(texto):
    # TODO: implementar
    return {}'),

('Frete por Faixa de Valor',
 'Escreva a funcao calcular_frete(valor_compra) que devolve o frete conforme a faixa da compra.',
 'Regra de frete gratis acima de um valor existe em toda loja, e a fronteira e onde mora o bug: quem escreve maior em vez de maior ou igual cobra frete de quem comprou exatamente o valor da promocao, e isso vira reclamacao.',
 'Um numero maior ou igual a 0 com o valor da compra.',
 'Um numero com o frete: 0 para compras de 200 ou mais, 15.0 para compras de 100 ate 199.99, e 25.0 para compras abaixo de 100.',
 'Entrada: 200.0
Saida: 0

Entrada: 199.99
Saida: 15.0',
 'Compra de exatamente 200 tem frete gratis. As faixas nao podem se sobrepor.',
 20,
 'def calcular_frete(valor_compra):
    # TODO: implementar
    return 0')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'Python'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Total do Carrinho', 'Declara a funcao total_carrinho', 'def\s+total_carrinho\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar total_carrinho e receber a lista de itens por parametro.'),
('Total do Carrinho', 'Percorre os itens do carrinho', '(for\s+\w+\s+in|sum\s*\()', 'OBRIGATORIO', 1, 'Sem percorrer a lista nao da para somar item a item. Um for ou um sum com generator resolve.'),
('Total do Carrinho', 'Multiplica preco por quantidade', '(preco[^\n]*\*|\*[^\n]*quantidade|\[.preco.\]\s*\*)', 'PONTUAVEL', 3, 'Somar so o preco ignora quem levou tres unidades. O total e preco vezes quantidade.'),
('Total do Carrinho', 'Le as duas chaves do dicionario', 'quantidade', 'PONTUAVEL', 2, 'A chave quantidade precisa aparecer no calculo, senao o carrinho com repeticao sai errado.'),
('Total do Carrinho', 'Devolve o total com return', 'return\s+\S+', 'PONTUAVEL', 2, 'Imprimir na tela nao serve: quem chama a funcao precisa do valor de volta.'),
('Total do Carrinho', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A lista chega por parametro. input travaria o servico esperando alguem digitar.'),

('Media de Notas', 'Declara a funcao media', 'def\s+media\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar media e receber a lista de notas por parametro.'),
('Media de Notas', 'Soma as notas', '(sum\s*\(|for\s+\w+\s+in|\+=)', 'OBRIGATORIO', 1, 'A media comeca pela soma: sum na lista ou um acumulador dentro do laco.'),
('Media de Notas', 'Divide pela quantidade de notas', '(len\s*\(|/)', 'PONTUAVEL', 3, 'Faltou dividir a soma pela quantidade de elementos, que len devolve.'),
('Media de Notas', 'Protege a lista vazia antes de dividir', '(if\s+not\s+\w+|len\s*\(\s*\w+\s*\)\s*==\s*0|if\s+\w+\s*:)', 'PONTUAVEL', 3, 'Lista vazia divide por zero e derruba a aplicacao. Cheque antes e devolva 0.'),
('Media de Notas', 'Devolve o resultado com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O valor precisa voltar para quem chamou, nao ser impresso.'),
('Media de Notas', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'As notas chegam por parametro; input nao tem lugar numa funcao de calculo.'),

('Contar Vogais do Texto', 'Declara a funcao contar_vogais', 'def\s+contar_vogais\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar contar_vogais e receber o texto por parametro.'),
('Contar Vogais do Texto', 'Percorre o texto', '(for\s+\w+\s+in|sum\s*\(|count\s*\()', 'OBRIGATORIO', 1, 'Para contar caractere a caractere e preciso percorrer a string.'),
('Contar Vogais do Texto', 'Compara com o conjunto de vogais', '(aeiou|in\s*\(|AEIOU)', 'PONTUAVEL', 3, 'Falta dizer o que e vogal. Uma string "aeiou" e o operador in resolvem a comparacao.'),
('Contar Vogais do Texto', 'Trata maiuscula e minuscula', '(lower\s*\(|upper\s*\(|casefold\s*\()', 'PONTUAVEL', 3, 'Sem normalizar o texto, o A maiusculo da entrada passa despercebido.'),
('Contar Vogais do Texto', 'Devolve a contagem com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A contagem precisa voltar como retorno da funcao.'),
('Contar Vogais do Texto', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template ficou no codigo: sinal de solucao entregue pela metade.'),

('Verificador de Palindromo', 'Declara a funcao eh_palindromo', 'def\s+eh_palindromo\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar eh_palindromo e receber o texto por parametro.'),
('Verificador de Palindromo', 'Compara o texto com ele invertido', '(\[\s*::\s*-\s*1\s*\]|reversed\s*\(|while)', 'OBRIGATORIO', 1, 'Falta a comparacao com a versao invertida. A fatia [::-1] faz isso numa linha.'),
('Verificador de Palindromo', 'Normaliza maiuscula e minuscula', '(lower\s*\(|upper\s*\(|casefold\s*\()', 'PONTUAVEL', 3, 'Sem normalizar, "Ame a ema" reprova por causa do A maiusculo.'),
('Verificador de Palindromo', 'Descarta espacos e pontuacao', '(isalnum|replace\s*\(|join\s*\(|sub\s*\()', 'PONTUAVEL', 3, 'Os espacos atrapalham a comparacao: limpe o texto antes de inverter.'),
('Verificador de Palindromo', 'Devolve booleano', '(True|False|return\s+\w+\s*==)', 'PONTUAVEL', 2, 'O enunciado pede True ou False, nao a string "sim".'),
('Verificador de Palindromo', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O texto vem por parametro. input aqui trava qualquer teste automatizado.'),

('Soma dos Numeros Pares', 'Declara a funcao soma_pares', 'def\s+soma_pares\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar soma_pares e receber a lista por parametro.'),
('Soma dos Numeros Pares', 'Percorre a lista', '(for\s+\w+\s+in|sum\s*\(|filter\s*\()', 'OBRIGATORIO', 1, 'Sem percorrer a lista nao ha o que somar.'),
('Soma dos Numeros Pares', 'Testa a paridade com resto de divisao', '%\s*2', 'PONTUAVEL', 3, 'Falta o teste de par. O resto da divisao por 2 igual a zero identifica o numero par.'),
('Soma dos Numeros Pares', 'Acumula apenas os pares', '(\+=|sum\s*\(|total|soma)', 'PONTUAVEL', 3, 'Identificar o par nao basta: e preciso acumular o valor num total.'),
('Soma dos Numeros Pares', 'Devolve a soma com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O total precisa voltar como retorno da funcao.'),
('Soma dos Numeros Pares', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A lista chega por parametro; input nao cabe numa funcao pura de calculo.'),

('Maior e Menor da Lista', 'Declara a funcao maior_e_menor', 'def\s+maior_e_menor\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar maior_e_menor e receber a lista por parametro.'),
('Maior e Menor da Lista', 'Percorre ou reduz a lista', '(for\s+\w+\s+in|max\s*\(|min\s*\()', 'OBRIGATORIO', 1, 'E preciso varrer a lista, seja com laco, seja com max e min.'),
('Maior e Menor da Lista', 'Devolve os dois valores juntos', 'return\s*\(?\s*\w+\s*,', 'PONTUAVEL', 3, 'O enunciado pede uma tupla com os dois valores, na ordem maior e menor.'),
('Maior e Menor da Lista', 'Inicializa a partir do primeiro elemento', '(\[\s*0\s*\]|numeros\[0\]|max\s*\(|min\s*\()', 'PONTUAVEL', 3, 'Comecar com 0 quebra quando todos os numeros sao negativos. Use o primeiro elemento.'),
('Maior e Menor da Lista', 'Compara os elementos', '(>|<|max\s*\(|min\s*\()', 'PONTUAVEL', 2, 'Sem comparacao nao ha como saber quem e o maior.'),
('Maior e Menor da Lista', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Contar Palavras da Frase', 'Declara a funcao contar_palavras', 'def\s+contar_palavras\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar contar_palavras e receber a frase por parametro.'),
('Contar Palavras da Frase', 'Separa a frase em palavras', '(split\s*\(|findall\s*\()', 'OBRIGATORIO', 1, 'Falta quebrar a frase. split sem argumento ja ignora espacos repetidos.'),
('Contar Palavras da Frase', 'Conta os pedacos resultantes', 'len\s*\(', 'PONTUAVEL', 3, 'Depois de separar, len na lista devolve a quantidade de palavras.'),
('Contar Palavras da Frase', 'Trata espacos extras', '(split\s*\(\s*\)|strip\s*\(|filter\s*\()', 'PONTUAVEL', 3, 'split(" ") gera pedacos vazios quando ha espaco duplo. Prefira split sem argumento.'),
('Contar Palavras da Frase', 'Devolve a contagem com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A contagem precisa voltar como retorno da funcao.'),
('Contar Palavras da Frase', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A frase chega por parametro.'),

('Remover Duplicados Preservando Ordem', 'Declara a funcao remover_duplicados', 'def\s+remover_duplicados\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar remover_duplicados e receber a lista por parametro.'),
('Remover Duplicados Preservando Ordem', 'Percorre a lista original', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'A ordem so se preserva percorrendo a lista na sequencia em que ela veio.'),
('Remover Duplicados Preservando Ordem', 'Guarda o que ja apareceu', '(set\s*\(|not\s+in|vistos|dict\.fromkeys)', 'PONTUAVEL', 3, 'E preciso lembrar quais itens ja sairam, com um set de vistos ou um teste not in.'),
('Remover Duplicados Preservando Ordem', 'Monta uma lista nova', '(append\s*\(|\[\s*\]|list\s*\()', 'PONTUAVEL', 3, 'O resultado vai numa lista nova: a original nao pode ser alterada.'),
('Remover Duplicados Preservando Ordem', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista sem duplicatas precisa voltar como retorno.'),
('Remover Duplicados Preservando Ordem', 'Nao devolva um set direto', 'return\s+set\s*\(', 'PROIBIDO', 1, 'Devolver set perde a ordem, que o enunciado pediu para manter.'),

('FizzBuzz ate N', 'Declara a funcao fizzbuzz', 'def\s+fizzbuzz\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar fizzbuzz e receber n por parametro.'),
('FizzBuzz ate N', 'Percorre de 1 ate n', 'range\s*\(', 'OBRIGATORIO', 1, 'range gera a sequencia. Lembre que range(n) para em n-1.'),
('FizzBuzz ate N', 'Testa multiplo de 3 e de 5 juntos primeiro', '(15|%\s*3\s*==\s*0\s+and|and\s+\w+\s*%\s*5)', 'PONTUAVEL', 3, 'Testar 3 e 5 separados antes do caso combinado faz FizzBuzz nunca aparecer.'),
('FizzBuzz ate N', 'Usa resto de divisao para os multiplos', '%\s*(3|5)', 'PONTUAVEL', 3, 'O teste de multiplo sai do resto da divisao igual a zero.'),
('FizzBuzz ate N', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O enunciado pede a lista de volta, nao um print de cada linha.'),
('FizzBuzz ate N', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O n chega por parametro.'),

('Frequencia de Cada Item', 'Declara a funcao frequencia', 'def\s+frequencia\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar frequencia e receber a lista por parametro.'),
('Frequencia de Cada Item', 'Percorre a lista', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'A contagem sai de um laco sobre os itens.'),
('Frequencia de Cada Item', 'Acumula a contagem num dicionario', '(\{\s*\}|dict\s*\(|\[\s*\w+\s*\]\s*=|get\s*\(|setdefault)', 'PONTUAVEL', 3, 'O dicionario e quem guarda item e contagem. Comece vazio e va somando.'),
('Frequencia de Cada Item', 'Trata o item que aparece pela primeira vez', '(get\s*\(|setdefault|not\s+in|in\s+\w+)', 'PONTUAVEL', 3, 'Somar direto numa chave inexistente lanca KeyError. get com padrao 0 evita isso.'),
('Frequencia de Cada Item', 'Devolve o dicionario com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O dicionario precisa voltar como retorno da funcao.'),
('Frequencia de Cada Item', 'Nao use collections.Counter', 'Counter', 'PROIBIDO', 1, 'O enunciado pediu para montar o dicionario na mao, sem Counter.'),

('Inverter as Palavras da Frase', 'Declara a funcao inverter_palavras', 'def\s+inverter_palavras\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar inverter_palavras e receber a frase por parametro.'),
('Inverter as Palavras da Frase', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Sem separar em palavras nao da para reordenar sem inverter as letras.'),
('Inverter as Palavras da Frase', 'Inverte a ordem das palavras', '(\[\s*::\s*-\s*1\s*\]|reversed\s*\(|reverse\s*\()', 'PONTUAVEL', 3, 'Falta inverter a lista de palavras: a fatia [::-1] resolve.'),
('Inverter as Palavras da Frase', 'Remonta a frase com join', 'join\s*\(', 'PONTUAVEL', 3, 'join com um espaco como separador remonta a frase sem espaco sobrando.'),
('Inverter as Palavras da Frase', 'Devolve a string com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A frase invertida precisa voltar como retorno.'),
('Inverter as Palavras da Frase', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Filtrar Maiores de Idade', 'Declara a funcao maiores_de_idade', 'def\s+maiores_de_idade\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar maiores_de_idade e receber a lista por parametro.'),
('Filtrar Maiores de Idade', 'Percorre as pessoas', '(for\s+\w+\s+in|filter\s*\()', 'OBRIGATORIO', 1, 'E preciso varrer a lista para testar cada pessoa.'),
('Filtrar Maiores de Idade', 'Aplica o corte de 18 anos ou mais', '>=\s*18', 'PONTUAVEL', 3, 'O enunciado diz 18 anos ou mais: com > 18 quem tem exatamente 18 fica de fora.'),
('Filtrar Maiores de Idade', 'Devolve apenas os nomes', 'nome', 'PONTUAVEL', 3, 'A saida e a lista de nomes, nao a lista de dicionarios inteiros.'),
('Filtrar Maiores de Idade', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista filtrada precisa voltar como retorno.'),
('Filtrar Maiores de Idade', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'As pessoas chegam por parametro.'),

('Aplicar Desconto Percentual', 'Declara a funcao aplicar_desconto', 'def\s+aplicar_desconto\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar aplicar_desconto e receber preco e percentual.'),
('Aplicar Desconto Percentual', 'Calcula sobre o percentual informado', '(/\s*100|\*\s*0\.|percentual)', 'OBRIGATORIO', 1, 'O percentual precisa entrar na conta, dividido por 100.'),
('Aplicar Desconto Percentual', 'Subtrai o desconto do preco', '(preco\s*-|-\s*\(|\*\s*\(\s*1)', 'PONTUAVEL', 3, 'O preco final e o original menos o desconto, ou o original vezes (1 - taxa).'),
('Aplicar Desconto Percentual', 'Valida o percentual fora da faixa', '(if\s|>\s*100|<\s*0)', 'PONTUAVEL', 3, 'Percentual acima de 100 geraria preco negativo. O enunciado manda devolver o preco original.'),
('Aplicar Desconto Percentual', 'Devolve o preco final com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O preco calculado precisa voltar como retorno.'),
('Aplicar Desconto Percentual', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Verificar Ano Bissexto', 'Declara a funcao eh_bissexto', 'def\s+eh_bissexto\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar eh_bissexto e receber o ano por parametro.'),
('Verificar Ano Bissexto', 'Testa a divisao por 4', '%\s*4', 'OBRIGATORIO', 1, 'A primeira parte da regra e ser divisivel por 4.'),
('Verificar Ano Bissexto', 'Contempla a excecao do 100', '%\s*100', 'PONTUAVEL', 3, 'Sem a regra do 100, o ano 1900 e classificado como bissexto por engano.'),
('Verificar Ano Bissexto', 'Contempla a excecao do 400', '%\s*400', 'PONTUAVEL', 3, 'Sem a regra do 400, o ano 2000 e classificado como comum por engano.'),
('Verificar Ano Bissexto', 'Devolve booleano com return', '(return\s+(True|False)|return\s+\()', 'PONTUAVEL', 2, 'A resposta e True ou False, devolvida pela funcao.'),
('Verificar Ano Bissexto', 'Nao use a biblioteca calendar', 'import\s+calendar', 'PROIBIDO', 1, 'O enunciado pediu a regra na mao, sem calendar.isleap.'),

('Soma dos Digitos', 'Declara a funcao soma_digitos', 'def\s+soma_digitos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar soma_digitos e receber o numero por parametro.'),
('Soma dos Digitos', 'Percorre os algarismos', '(for\s+\w+\s+in|while|sum\s*\()', 'OBRIGATORIO', 1, 'E preciso passar por cada algarismo, seja pela string, seja com divisao por 10.'),
('Soma dos Digitos', 'Separa os algarismos do numero', '(str\s*\(|%\s*10|//\s*10)', 'PONTUAVEL', 3, 'Duas saidas: converter para string, ou usar resto e divisao inteira por 10.'),
('Soma dos Digitos', 'Converte cada algarismo para inteiro', '(int\s*\(|%\s*10)', 'PONTUAVEL', 3, 'Somando caractere com caractere o Python concatena texto em vez de somar.'),
('Soma dos Digitos', 'Devolve a soma com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O total precisa voltar como retorno da funcao.'),
('Soma dos Digitos', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O numero chega por parametro.'),

('Numero Primo', 'Declara a funcao eh_primo', 'def\s+eh_primo\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar eh_primo e receber o numero por parametro.'),
('Numero Primo', 'Procura divisores num laco', '(for\s+\w+\s+in|while)', 'OBRIGATORIO', 1, 'Para saber se e primo e preciso testar possiveis divisores.'),
('Numero Primo', 'Testa o resto da divisao', '%\s*\w+\s*==\s*0', 'PONTUAVEL', 3, 'Um divisor e todo numero cujo resto da divisao da zero.'),
('Numero Primo', 'Trata os casos menores que 2', '(<\s*2|<=\s*1|==\s*1)', 'PONTUAVEL', 3, 'Zero, um e negativos nao sao primos e precisam sair antes do laco.'),
('Numero Primo', 'Devolve booleano com return', '(return\s+(True|False))', 'PONTUAVEL', 2, 'A resposta e True ou False.'),
('Numero Primo', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Segunda Maior Nota', 'Declara a funcao segunda_maior', 'def\s+segunda_maior\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar segunda_maior e receber a lista por parametro.'),
('Segunda Maior Nota', 'Trata os valores repetidos', '(set\s*\(|not\s+in|!=\s*maior|distinct)', 'OBRIGATORIO', 1, 'Com [10, 10, 8] o segundo maior e 8. Repetidos no topo precisam ser descartados.'),
('Segunda Maior Nota', 'Ordena ou compara os valores', '(sorted\s*\(|sort\s*\(|>|max\s*\()', 'PONTUAVEL', 3, 'Ordenar decrescente ou guardar maior e segundo maior num laco resolvem.'),
('Segunda Maior Nota', 'Seleciona a segunda posicao', '(\[\s*1\s*\]|\[\s*-\s*2\s*\]|segundo)', 'PONTUAVEL', 3, 'Depois de ordenar os valores distintos, o segundo maior e o indice 1.'),
('Segunda Maior Nota', 'Devolve o valor com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O valor precisa voltar como retorno da funcao.'),
('Segunda Maior Nota', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A lista chega por parametro.'),

('Tabuada de um Numero', 'Declara a funcao tabuada', 'def\s+tabuada\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar tabuada e receber o numero por parametro.'),
('Tabuada de um Numero', 'Gera a sequencia de 1 a 10', 'range\s*\(', 'OBRIGATORIO', 1, 'range gera os multiplicadores. Lembre que range(1, 11) vai de 1 ate 10.'),
('Tabuada de um Numero', 'Multiplica o numero pelo contador', '\*', 'PONTUAVEL', 3, 'Cada posicao da lista e o numero multiplicado pelo valor da vez.'),
('Tabuada de um Numero', 'Monta a lista de resultados', '(append\s*\(|\[\s*\w+\s*\*|for\s+\w+\s+in\s+range)', 'PONTUAVEL', 3, 'Os dez resultados precisam ir para uma lista, com append ou list comprehension.'),
('Tabuada de um Numero', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O enunciado pede a lista de volta, nao um print por linha.'),
('Tabuada de um Numero', 'Nao imprima no lugar de devolver', 'print\s*\(', 'PROIBIDO', 1, 'print mostra na tela mas devolve None. Quem chamou a funcao fica sem os resultados.'),

('Fatorial de um Numero', 'Declara a funcao fatorial', 'def\s+fatorial\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar fatorial e receber n por parametro.'),
('Fatorial de um Numero', 'Percorre os valores de 1 ate n', '(for\s+\w+\s+in|while)', 'OBRIGATORIO', 1, 'O fatorial e a multiplicacao acumulada de 1 ate n.'),
('Fatorial de um Numero', 'Acumula o produto', '(\*=|\w+\s*=\s*\w+\s*\*)', 'PONTUAVEL', 3, 'Falta acumular. O acumulador comeca em 1 e vai sendo multiplicado a cada volta.'),
('Fatorial de um Numero', 'Trata o fatorial de 0', '(==\s*0|<=\s*1|range\s*\(\s*1)', 'PONTUAVEL', 3, 'O fatorial de 0 e 1. Comecar o acumulador em 1 ja resolve, desde que o laco nao rode.'),
('Fatorial de um Numero', 'Devolve o resultado com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O valor precisa voltar como retorno da funcao.'),
('Fatorial de um Numero', 'Nao use math.factorial', 'factorial\s*\(', 'PROIBIDO', 1, 'O enunciado pediu a repeticao escrita na mao, sem math.factorial.'),

('Sequencia de Fibonacci', 'Declara a funcao fibonacci', 'def\s+fibonacci\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar fibonacci e receber n por parametro.'),
('Sequencia de Fibonacci', 'Usa um laco para gerar a sequencia', '(for\s+\w+\s+in|while)', 'OBRIGATORIO', 1, 'O enunciado pede a versao iterativa: um laco que roda n vezes.'),
('Sequencia de Fibonacci', 'Guarda os dois valores anteriores', '(\w+\s*,\s*\w+\s*=|anterior|atual|\[\s*-\s*1\s*\])', 'PONTUAVEL', 3, 'Cada termo depende dos dois anteriores. Atualize os dois juntos para nao perder o antigo.'),
('Sequencia de Fibonacci', 'Comeca a sequencia em 0 e 1', '(0\s*,\s*1|\[\s*0\s*,\s*1\s*\])', 'PONTUAVEL', 3, 'A sequencia pedida comeca em 0 e 1; comecar em 1 e 1 desloca todo o resultado.'),
('Sequencia de Fibonacci', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista precisa voltar como retorno da funcao.'),
('Sequencia de Fibonacci', 'Nao use recursao', 'return\s+fibonacci\s*\(', 'PROIBIDO', 1, 'O enunciado pediu a versao com laco, sem a funcao chamar a si mesma.'),

('Converter Celsius para Fahrenheit', 'Declara a funcao para_fahrenheit', 'def\s+para_fahrenheit\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar para_fahrenheit e receber celsius por parametro.'),
('Converter Celsius para Fahrenheit', 'Aplica a proporcao 9/5', '(9\s*/\s*5|1\.8|\*\s*9)', 'OBRIGATORIO', 1, 'A conversao multiplica por 9/5 antes de somar. Sem isso a escala fica errada.'),
('Converter Celsius para Fahrenheit', 'Soma o deslocamento de 32', '\+\s*32', 'PONTUAVEL', 3, 'Depois de multiplicar, some 32 para chegar na escala Fahrenheit.'),
('Converter Celsius para Fahrenheit', 'Respeita a ordem das operacoes', '(\*\s*9\s*/\s*5\s*\)?\s*\+|1\.8\s*\+|\*\s*1\.8)', 'PONTUAVEL', 3, 'Somar 32 antes de multiplicar da um numero plausivel e errado. Multiplique primeiro.'),
('Converter Celsius para Fahrenheit', 'Devolve o resultado com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A temperatura convertida precisa voltar como retorno.'),
('Converter Celsius para Fahrenheit', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A temperatura chega por parametro.'),

('Validar Senha Forte', 'Declara a funcao senha_forte', 'def\s+senha_forte\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar senha_forte e receber a senha por parametro.'),
('Validar Senha Forte', 'Verifica o tamanho minimo', '(len\s*\(|>=\s*8|<\s*8)', 'OBRIGATORIO', 1, 'A primeira regra e ter ao menos 8 caracteres, e len responde isso.'),
('Validar Senha Forte', 'Verifica maiuscula e minuscula', '(isupper|islower|any\s*\()', 'PONTUAVEL', 3, 'Faltou checar as duas caixas. isupper e islower dentro de um any resolvem.'),
('Validar Senha Forte', 'Verifica a presenca de digito', '(isdigit|isnumeric|0-9)', 'PONTUAVEL', 3, 'A regra do numero ficou de fora: isdigit identifica o algarismo.'),
('Validar Senha Forte', 'Combina as regras e devolve booleano', '(and|all\s*\(|return\s+(True|False))', 'PONTUAVEL', 2, 'As quatro regras valem ao mesmo tempo: combine com and e devolva True ou False.'),
('Validar Senha Forte', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Primeira Letra Maiuscula', 'Declara a funcao capitalizar', 'def\s+capitalizar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar capitalizar e receber a frase por parametro.'),
('Primeira Letra Maiuscula', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Para tratar palavra a palavra e preciso separar a frase antes.'),
('Primeira Letra Maiuscula', 'Coloca a inicial em maiuscula', '(upper\s*\(|capitalize\s*\()', 'PONTUAVEL', 3, 'A primeira letra de cada palavra precisa subir para maiuscula.'),
('Primeira Letra Maiuscula', 'Coloca o restante em minuscula', 'lower\s*\(', 'PONTUAVEL', 3, 'Entrada em caixa alta continua feia se o resto da palavra nao descer para minuscula.'),
('Primeira Letra Maiuscula', 'Remonta a frase com join', 'join\s*\(', 'PONTUAVEL', 2, 'Depois de tratar cada palavra, join remonta a frase com um espaco entre elas.'),
('Primeira Letra Maiuscula', 'Nao use title() pronto', '\.title\s*\(', 'PROIBIDO', 1, 'O enunciado pediu para separar e montar na mao, sem title().'),

('Contar Aprovados e Reprovados', 'Declara a funcao contar_situacao', 'def\s+contar_situacao\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar contar_situacao e receber as notas por parametro.'),
('Contar Aprovados e Reprovados', 'Percorre as notas', '(for\s+\w+\s+in|sum\s*\(|len\s*\()', 'OBRIGATORIO', 1, 'E preciso varrer a lista para classificar cada nota.'),
('Contar Aprovados e Reprovados', 'Aplica o corte em 6', '>=\s*6', 'PONTUAVEL', 3, 'Nota 6 aprova. Com > 6 quem tirou exatamente 6 seria reprovado por engano.'),
('Contar Aprovados e Reprovados', 'Mantem os dois contadores', '(\+=|aprovados|reprovados)', 'PONTUAVEL', 3, 'Conte os dois grupos de verdade, em vez de deduzir um por subtracao.'),
('Contar Aprovados e Reprovados', 'Devolve a tupla com os dois numeros', 'return\s*\(?\s*\w+\s*,', 'PONTUAVEL', 2, 'A saida e uma tupla (aprovados, reprovados), nessa ordem.'),
('Contar Aprovados e Reprovados', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'As notas chegam por parametro.'),

('Achatar Lista de Listas', 'Declara a funcao achatar', 'def\s+achatar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar achatar e receber a lista de listas por parametro.'),
('Achatar Lista de Listas', 'Percorre as listas internas', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'E preciso passar por cada lista interna para pegar seus elementos.'),
('Achatar Lista de Listas', 'Percorre os elementos de cada lista', '(for\s+\w+\s+in[\s\S]{0,80}for\s+\w+\s+in|extend\s*\(|\+=)', 'PONTUAVEL', 3, 'Falta o segundo nivel: ou um laco dentro do outro, ou extend para juntar de uma vez.'),
('Achatar Lista de Listas', 'Acumula numa lista de saida', '(append\s*\(|extend\s*\(|\[\s*\])', 'PONTUAVEL', 3, 'O resultado precisa ir para uma lista nova.'),
('Achatar Lista de Listas', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista achatada precisa voltar como retorno.'),
('Achatar Lista de Listas', 'Nao use itertools', 'itertools', 'PROIBIDO', 1, 'O enunciado pediu sem bibliotecas: monte o laco na mao.'),

('Interseccao de Duas Listas', 'Declara a funcao em_comum', 'def\s+em_comum\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar em_comum e receber as duas listas por parametro.'),
('Interseccao de Duas Listas', 'Testa a presenca na segunda lista', '(in\s+segunda|in\s+\w+|intersection)', 'OBRIGATORIO', 1, 'O operador in responde se o item da primeira lista existe na segunda.'),
('Interseccao de Duas Listas', 'Percorre a primeira lista', 'for\s+\w+\s+in', 'PONTUAVEL', 3, 'A ordem do resultado segue a primeira lista, entao e ela que deve ser percorrida.'),
('Interseccao de Duas Listas', 'Evita repetir item no resultado', '(not\s+in|set\s*\(|vistos)', 'PONTUAVEL', 3, 'O 2 aparece duas vezes na entrada e nao pode sair duas vezes no resultado.'),
('Interseccao de Duas Listas', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista de comuns precisa voltar como retorno.'),
('Interseccao de Duas Listas', 'Nao devolva um set direto', 'return\s+set\s*\(', 'PROIBIDO', 1, 'Set perde a ordem que o enunciado pediu para manter.'),

('Dividir Lista em Blocos', 'Declara a funcao dividir_em_blocos', 'def\s+dividir_em_blocos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar dividir_em_blocos e receber itens e tamanho.'),
('Dividir Lista em Blocos', 'Avanca de tamanho em tamanho', '(range\s*\([^)]*,[^)]*,|while)', 'OBRIGATORIO', 1, 'O passo do range e o tamanho do bloco: range(0, len(itens), tamanho).'),
('Dividir Lista em Blocos', 'Corta a lista em fatias', '\[\s*\w+\s*:', 'PONTUAVEL', 3, 'A fatia itens[i:i+tamanho] recorta cada bloco sem estourar o fim da lista.'),
('Dividir Lista em Blocos', 'Usa o tamanho recebido', 'tamanho', 'PONTUAVEL', 3, 'O tamanho do bloco vem por parametro e nao pode ser um numero fixo no codigo.'),
('Dividir Lista em Blocos', 'Devolve a lista de blocos com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista de listas precisa voltar como retorno.'),
('Dividir Lista em Blocos', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Troco em Notas', 'Declara a funcao troco', 'def\s+troco\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar troco e receber o valor por parametro.'),
('Troco em Notas', 'Percorre as notas da maior para a menor', '(100[\s\S]{0,40}50[\s\S]{0,40}20|for\s+\w+\s+in\s*[\(\[])', 'OBRIGATORIO', 1, 'A ordem 100, 50, 20, 10 e o que garante o menor numero de notas.'),
('Troco em Notas', 'Calcula quantas notas cabem no valor', '//', 'PONTUAVEL', 3, 'A divisao inteira diz quantas notas daquele valor cabem no que sobrou.'),
('Troco em Notas', 'Atualiza o valor restante', '(%|-=|resto|restante)', 'PONTUAVEL', 3, 'Depois de separar as notas, o que sobra continua para a proxima: use o resto.'),
('Troco em Notas', 'Devolve o dicionario com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A saida e um dicionario com a nota e a quantidade.'),
('Troco em Notas', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O valor chega por parametro.'),

('Ordenar Nomes em Ordem Alfabetica', 'Declara a funcao ordenar_nomes', 'def\s+ordenar_nomes\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar ordenar_nomes e receber a lista por parametro.'),
('Ordenar Nomes em Ordem Alfabetica', 'Ordena a lista', '(sorted\s*\(|\.sort\s*\()', 'OBRIGATORIO', 1, 'sorted devolve uma lista nova ordenada, que e o que o enunciado pede.'),
('Ordenar Nomes em Ordem Alfabetica', 'Ignora maiuscula na comparacao', '(key\s*=|lower|casefold)', 'PONTUAVEL', 3, 'Sem key=str.lower, "Ana" vem antes de "bruno" por acaso e "ana" viria depois.'),
('Ordenar Nomes em Ordem Alfabetica', 'Preserva a lista original', '(sorted\s*\(|\[\s*:\s*\]|copy\s*\()', 'PONTUAVEL', 3, 'sort() altera a lista recebida. Use sorted para devolver uma nova.'),
('Ordenar Nomes em Ordem Alfabetica', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista ordenada precisa voltar como retorno.'),
('Ordenar Nomes em Ordem Alfabetica', 'Nao devolva os nomes em minuscula', 'return\s+\[\s*\w+\.lower', 'PROIBIDO', 1, 'A comparacao ignora a caixa, mas o nome sai como entrou.'),

('Posicao do Item na Lista', 'Declara a funcao posicao', 'def\s+posicao\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar posicao e receber itens e alvo.'),
('Posicao do Item na Lista', 'Percorre a lista com o indice', '(enumerate\s*\(|range\s*\(\s*len)', 'OBRIGATORIO', 1, 'Para devolver a posicao e preciso acompanhar o indice, com enumerate ou range(len(...)).'),
('Posicao do Item na Lista', 'Compara cada item com o alvo', '==\s*alvo|alvo\s*==', 'PONTUAVEL', 3, 'Falta a comparacao com o valor procurado.'),
('Posicao do Item na Lista', 'Devolve -1 quando nao encontra', '-\s*1', 'PONTUAVEL', 3, 'Sem o -1, quem chamou nao consegue distinguir "nao achei" de "achei na posicao 0".'),
('Posicao do Item na Lista', 'Para na primeira ocorrencia', 'return\s+\w+', 'PONTUAVEL', 2, 'O enunciado pede a primeira ocorrencia: devolva assim que encontrar.'),
('Posicao do Item na Lista', 'Nao use o index() pronto', '\.index\s*\(', 'PROIBIDO', 1, 'index lanca ValueError quando nao encontra, e o enunciado pediu -1.'),

('Verificar Anagrama', 'Declara a funcao sao_anagramas', 'def\s+sao_anagramas\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar sao_anagramas e receber as duas palavras.'),
('Verificar Anagrama', 'Compara as letras das duas palavras', '(sorted\s*\(|==)', 'OBRIGATORIO', 1, 'Ordenar as letras das duas e compara-las e o caminho mais direto.'),
('Verificar Anagrama', 'Normaliza maiuscula e minuscula', '(lower\s*\(|upper\s*\(|casefold\s*\()', 'PONTUAVEL', 3, 'Sem normalizar, "Amor" e "Roma" reprovam por causa da caixa.'),
('Verificar Anagrama', 'Descarta os espacos', '(replace\s*\(|split\s*\(|join\s*\(|strip\s*\()', 'PONTUAVEL', 3, 'Espaco conta como caractere e estraga a comparacao.'),
('Verificar Anagrama', 'Devolve booleano', '(return\s+(True|False)|return\s+\w+.*==)', 'PONTUAVEL', 2, 'A resposta e True ou False.'),
('Verificar Anagrama', 'Nao use collections.Counter', 'Counter', 'PROIBIDO', 1, 'O enunciado pediu sem Counter.'),

('Converter Minutos em Horas', 'Declara a funcao formatar_duracao', 'def\s+formatar_duracao\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar formatar_duracao e receber os minutos.'),
('Converter Minutos em Horas', 'Separa horas e minutos', '(//\s*60|divmod)', 'OBRIGATORIO', 1, 'A divisao inteira por 60 da as horas; o resto da os minutos.'),
('Converter Minutos em Horas', 'Calcula o resto dos minutos', '(%\s*60|divmod)', 'PONTUAVEL', 3, 'Sem o resto, 145 minutos viram 2h e os 25 minutos somem.'),
('Converter Minutos em Horas', 'Coloca zero a esquerda nos minutos', '(zfill|02d|rjust|:02)', 'PONTUAVEL', 3, 'O enunciado pede duas casas: 65 minutos vira 1h05, nao 1h5.'),
('Converter Minutos em Horas', 'Monta a string no formato pedido', '(f.|format\s*\(|\+\s*.h.)', 'PONTUAVEL', 2, 'O separador e a letra h entre as horas e os minutos.'),
('Converter Minutos em Horas', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Somar os Valores do Dicionario', 'Declara a funcao somar_valores', 'def\s+somar_valores\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar somar_valores e receber o dicionario.'),
('Somar os Valores do Dicionario', 'Percorre os valores do dicionario', '(\.values\s*\(|for\s+\w+\s+in)', 'OBRIGATORIO', 1, 'values() entrega so os numeros, que e o que interessa aqui.'),
('Somar os Valores do Dicionario', 'Acumula a soma', '(sum\s*\(|\+=)', 'PONTUAVEL', 3, 'Falta somar os valores, com sum ou um acumulador.'),
('Somar os Valores do Dicionario', 'Nao soma as chaves por engano', '\.values\s*\(', 'PONTUAVEL', 3, 'Percorrer o dicionario direto entrega as chaves, nao os valores. Use values().'),
('Somar os Valores do Dicionario', 'Devolve o total com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O total precisa voltar como retorno.'),
('Somar os Valores do Dicionario', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O dicionario chega por parametro.'),

('Mascarar E-mail', 'Declara a funcao mascarar_email', 'def\s+mascarar_email\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar mascarar_email e receber o endereco.'),
('Mascarar E-mail', 'Localiza o arroba', '(split\s*\(|index\s*\(|find\s*\(|partition)', 'OBRIGATORIO', 1, 'O arroba separa a parte a esconder da parte a preservar.'),
('Mascarar E-mail', 'Preserva a primeira letra', '\[\s*0\s*\]', 'PONTUAVEL', 3, 'A primeira letra fica visivel para o usuario reconhecer a conta.'),
('Mascarar E-mail', 'Preserva o dominio inteiro', '(@|\[\s*1\s*\])', 'PONTUAVEL', 3, 'O dominio, do arroba em diante, sai sem alteracao.'),
('Mascarar E-mail', 'Insere os asteriscos', '\*', 'PONTUAVEL', 2, 'Os tres asteriscos entram no lugar do restante do nome.'),
('Mascarar E-mail', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O e-mail chega por parametro.'),

('Media por Materia', 'Declara a funcao media_por_materia', 'def\s+media_por_materia\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar media_por_materia e receber o boletim.'),
('Media por Materia', 'Percorre chave e valor do dicionario', '(\.items\s*\(|for\s+\w+\s+in)', 'OBRIGATORIO', 1, 'items() entrega a materia e a lista de notas de uma vez.'),
('Media por Materia', 'Calcula a media de cada lista', '(sum\s*\(|len\s*\(|/)', 'PONTUAVEL', 3, 'A media de cada materia e a soma das notas dividida pela quantidade.'),
('Media por Materia', 'Protege a materia sem nota', '(if\s|len\s*\(|not\s+\w+)', 'PONTUAVEL', 3, 'Lista vazia divide por zero. O enunciado manda devolver 0 nesse caso.'),
('Media por Materia', 'Monta o dicionario de saida', '(\{\s*\}|\[\s*\w+\s*\]\s*=|dict\s*\()', 'PONTUAVEL', 2, 'O resultado e um dicionario com a mesma chave e a media como valor.'),
('Media por Materia', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Item Mais Frequente', 'Declara a funcao mais_frequente', 'def\s+mais_frequente\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar mais_frequente e receber a lista.'),
('Item Mais Frequente', 'Conta as ocorrencias', '(\{\s*\}|get\s*\(|count\s*\(|setdefault)', 'OBRIGATORIO', 1, 'Antes de achar o maior e preciso contar quantas vezes cada item aparece.'),
('Item Mais Frequente', 'Compara as contagens', '(>|max\s*\()', 'PONTUAVEL', 3, 'Depois de contar, e preciso comparar para achar a maior contagem.'),
('Item Mais Frequente', 'Resolve o empate pela primeira aparicao', '(>|for\s+\w+\s+in)', 'PONTUAVEL', 3, 'Use > e nao >= ao comparar: assim o primeiro a atingir a contagem permanece.'),
('Item Mais Frequente', 'Devolve o item com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O item, e nao a contagem, precisa voltar como retorno.'),
('Item Mais Frequente', 'Nao use collections.Counter', 'Counter', 'PROIBIDO', 1, 'O enunciado pediu sem Counter.'),

('Remover Espacos Extras', 'Declara a funcao limpar_espacos', 'def\s+limpar_espacos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar limpar_espacos e receber o texto.'),
('Remover Espacos Extras', 'Separa o texto em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'split sem argumento ja descarta os espacos repetidos e das pontas.'),
('Remover Espacos Extras', 'Remonta com um unico espaco', 'join\s*\(', 'PONTUAVEL', 3, 'join com um espaco reconstroi o texto sem espaco duplicado.'),
('Remover Espacos Extras', 'Trata os espacos das pontas', '(split\s*\(\s*\)|strip\s*\()', 'PONTUAVEL', 3, 'O espaco invisivel no fim do campo e o que quebra a busca depois.'),
('Remover Espacos Extras', 'Devolve a string com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O texto limpo precisa voltar como retorno.'),
('Remover Espacos Extras', 'Nao use expressao regular', 'import\s+re', 'PROIBIDO', 1, 'O enunciado pediu com metodos de string, sem o modulo re.'),

('Maior Palavra da Frase', 'Declara a funcao maior_palavra', 'def\s+maior_palavra\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar maior_palavra e receber a frase.'),
('Maior Palavra da Frase', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Sem separar nao ha palavras para comparar.'),
('Maior Palavra da Frase', 'Compara o tamanho das palavras', '(len\s*\(|max\s*\()', 'PONTUAVEL', 3, 'O criterio e o comprimento: len de cada palavra.'),
('Maior Palavra da Frase', 'Resolve o empate pela primeira', '(>|max\s*\()', 'PONTUAVEL', 3, 'Use > e nao >=: assim a primeira palavra do empate permanece.'),
('Maior Palavra da Frase', 'Trata a frase vazia', '(if\s|not\s+\w+|len\s*\()', 'PONTUAVEL', 2, 'Frase vazia nao pode lancar excecao: devolva string vazia.'),
('Maior Palavra da Frase', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A frase chega por parametro.'),

('Todos os Numeros Positivos', 'Declara a funcao todos_positivos', 'def\s+todos_positivos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar todos_positivos e receber a lista.'),
('Todos os Numeros Positivos', 'Testa cada numero da lista', '(all\s*\(|for\s+\w+\s+in)', 'OBRIGATORIO', 1, 'all com um generator, ou um laco, testam item a item.'),
('Todos os Numeros Positivos', 'Usa a comparacao maior que zero', '>\s*0', 'PONTUAVEL', 3, 'Zero nao e positivo, entao a comparacao e > 0 e nao >= 0.'),
('Todos os Numeros Positivos', 'Devolve booleano', '(return\s+(True|False)|return\s+all)', 'PONTUAVEL', 3, 'A resposta e True ou False.'),
('Todos os Numeros Positivos', 'Interrompe na primeira falha', '(all\s*\(|return\s+False)', 'PONTUAVEL', 2, 'Achou um nao positivo, ja da para responder sem varrer o resto.'),
('Todos os Numeros Positivos', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Calcular e Classificar o IMC', 'Declara a funcao classificar_imc', 'def\s+classificar_imc\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar classificar_imc e receber peso e altura.'),
('Calcular e Classificar o IMC', 'Calcula o IMC com a altura ao quadrado', '(altura\s*\*\s*altura|altura\s*\*\*\s*2|\*\*\s*2)', 'OBRIGATORIO', 1, 'O IMC divide o peso pela altura ao quadrado, nao pela altura.'),
('Calcular e Classificar o IMC', 'Compara contra os limites das faixas', '(18\.5|24\.9|29\.9|30)', 'PONTUAVEL', 3, 'Os limites 18.5, 24.9 e 29.9 precisam aparecer na cadeia de comparacoes.'),
('Calcular e Classificar o IMC', 'Encadeia as faixas sem sobreposicao', '(elif|else)', 'PONTUAVEL', 3, 'Uma cadeia if/elif/else garante que cada IMC caia em exatamente uma faixa.'),
('Calcular e Classificar o IMC', 'Devolve o nome da faixa', '(abaixo|normal|sobrepeso|obesidade)', 'PONTUAVEL', 2, 'A saida e a faixa em texto, nao o numero do IMC.'),
('Calcular e Classificar o IMC', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'Peso e altura chegam por parametro.'),

('Total de Horas Trabalhadas', 'Declara a funcao total_horas', 'def\s+total_horas\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar total_horas e receber os registros.'),
('Total de Horas Trabalhadas', 'Percorre os registros', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'E preciso varrer a lista de registros de ponto.'),
('Total de Horas Trabalhadas', 'Calcula saida menos entrada', '(saida[^\n]*-|-[^\n]*entrada)', 'PONTUAVEL', 3, 'As horas de cada dia sao a diferenca entre saida e entrada.'),
('Total de Horas Trabalhadas', 'Ignora o registro em aberto', '(is\s+not\s+None|is\s+None|!=\s*None|if\s+\w+\s*\[)', 'PONTUAVEL', 3, 'Subtrair com saida None lanca TypeError. Cheque o None antes da conta.'),
('Total de Horas Trabalhadas', 'Acumula e devolve o total', '(\+=|sum\s*\()', 'PONTUAVEL', 2, 'As horas de cada dia precisam ser somadas num total.'),
('Total de Horas Trabalhadas', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Juntar Dois Dicionarios Somando', 'Declara a funcao juntar_estoques', 'def\s+juntar_estoques\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar juntar_estoques e receber os dois dicionarios.'),
('Juntar Dois Dicionarios Somando', 'Percorre os dois dicionarios', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'As chaves dos dois lados precisam ser visitadas para nada se perder.'),
('Juntar Dois Dicionarios Somando', 'Soma quando a chave existe nos dois', '(\+=|get\s*\(|\+\s*\w+\[)', 'PONTUAVEL', 3, 'Chave repetida soma. Atribuir direto sobrescreve e perde a quantidade da primeira loja.'),
('Juntar Dois Dicionarios Somando', 'Trata a chave que existe num so', '(get\s*\(|not\s+in|setdefault|in\s+\w+)', 'PONTUAVEL', 3, 'get com padrao 0 resolve a chave que so aparece de um lado.'),
('Juntar Dois Dicionarios Somando', 'Monta um dicionario novo', '(\{\s*\}|copy\s*\(|dict\s*\()', 'PONTUAVEL', 2, 'O resultado vai num dicionario novo: os recebidos nao podem ser alterados.'),
('Juntar Dois Dicionarios Somando', 'Nao use update, que sobrescreve', '\.update\s*\(', 'PROIBIDO', 1, 'update substitui o valor em vez de somar, e o estoque final sai menor que o real.'),

('Sigla do Nome', 'Declara a funcao sigla', 'def\s+sigla\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar sigla e receber o nome por parametro.'),
('Sigla do Nome', 'Separa o nome em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'split sem argumento separa as palavras e ja descarta os espacos extras.'),
('Sigla do Nome', 'Pega a primeira letra de cada palavra', '\[\s*0\s*\]', 'PONTUAVEL', 3, 'A inicial e o caractere de indice 0 de cada palavra.'),
('Sigla do Nome', 'Coloca as iniciais em maiuscula', 'upper\s*\(', 'PONTUAVEL', 3, 'O enunciado pede as iniciais em maiuscula.'),
('Sigla do Nome', 'Junta as iniciais numa string', '(join\s*\(|\+=)', 'PONTUAVEL', 2, 'join sem separador cola as iniciais numa string so.'),
('Sigla do Nome', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O nome chega por parametro.'),

('Itens Acima da Media', 'Declara a funcao acima_da_media', 'def\s+acima_da_media\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar acima_da_media e receber a lista.'),
('Itens Acima da Media', 'Calcula a media da lista', '(sum\s*\([\s\S]{0,40}len\s*\(|/\s*len\s*\()', 'OBRIGATORIO', 1, 'A media e a soma dividida pela quantidade, calculada uma unica vez.'),
('Itens Acima da Media', 'Filtra os valores maiores que a media', '>', 'PONTUAVEL', 3, 'Depois da media, compare cada valor com ela para montar o resultado.'),
('Itens Acima da Media', 'Trata a lista vazia', '(if\s+not\s+\w+|len\s*\(\s*\w+\s*\)\s*==\s*0|if\s+\w+\s*:)', 'PONTUAVEL', 3, 'Lista vazia divide por zero ao calcular a media. Devolva lista vazia antes disso.'),
('Itens Acima da Media', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista filtrada precisa voltar como retorno.'),
('Itens Acima da Media', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Lista Esta Ordenada', 'Declara a funcao esta_ordenada', 'def\s+esta_ordenada\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar esta_ordenada e receber a lista.'),
('Lista Esta Ordenada', 'Compara cada elemento com o seguinte', '(range\s*\(|zip\s*\(|all\s*\()', 'OBRIGATORIO', 1, 'A verificacao olha pares vizinhos, com range(len-1) ou zip da lista com ela deslocada.'),
('Lista Esta Ordenada', 'Usa menor ou igual na comparacao', '<=', 'PONTUAVEL', 3, 'Elementos iguais lado a lado continuam ordenados, entao a comparacao e <=.'),
('Lista Esta Ordenada', 'Devolve booleano', '(return\s+(True|False)|return\s+all)', 'PONTUAVEL', 3, 'A resposta e True ou False.'),
('Lista Esta Ordenada', 'Trata lista vazia ou de um elemento', '(len\s*\(|all\s*\(|range\s*\()', 'PONTUAVEL', 2, 'Com zero ou um elemento nao ha par para comparar, e a resposta e True.'),
('Lista Esta Ordenada', 'Nao ordene a lista para comparar', '(sorted\s*\(|\.sort\s*\()', 'PROIBIDO', 1, 'Ordenar e mais caro e o enunciado pediu para so verificar.'),

('Somar Numeros em Texto', 'Declara a funcao somar_texto', 'def\s+somar_texto\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar somar_texto e receber a lista de strings.'),
('Somar Numeros em Texto', 'Converte o texto para numero', 'int\s*\(', 'OBRIGATORIO', 1, 'Sem int(), o Python concatena as strings em vez de somar.'),
('Somar Numeros em Texto', 'Percorre ou reduz a lista', '(for\s+\w+\s+in|sum\s*\(|map\s*\()', 'PONTUAVEL', 3, 'A conversao precisa acontecer para cada item da lista.'),
('Somar Numeros em Texto', 'Acumula o total', '(sum\s*\(|\+=)', 'PONTUAVEL', 3, 'Os valores convertidos precisam ser somados num total.'),
('Somar Numeros em Texto', 'Devolve a soma com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O total precisa voltar como retorno.'),
('Somar Numeros em Texto', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A lista chega por parametro.'),

('Percentual de Tarefas Concluidas', 'Declara a funcao percentual_concluido', 'def\s+percentual_concluido\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar percentual_concluido e receber as tarefas.'),
('Percentual de Tarefas Concluidas', 'Conta as tarefas concluidas', '(concluida|sum\s*\(|for\s+\w+\s+in)', 'OBRIGATORIO', 1, 'E preciso contar quantas tarefas tem concluida verdadeira.'),
('Percentual de Tarefas Concluidas', 'Divide pelo total e multiplica por 100', '(\*\s*100|100\s*\*)', 'PONTUAVEL', 3, 'A proporcao vira percentual multiplicando por 100.'),
('Percentual de Tarefas Concluidas', 'Protege a lista vazia', '(if\s+not\s+\w+|len\s*\(\s*\w+\s*\)\s*==\s*0|if\s+\w+\s*:)', 'PONTUAVEL', 3, 'Sem tarefas a divisao por zero derruba a tela inteira. Devolva 0.'),
('Percentual de Tarefas Concluidas', 'Devolve o percentual com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O numero precisa voltar como retorno.'),
('Percentual de Tarefas Concluidas', 'Nao arredonde o resultado', 'round\s*\(', 'PROIBIDO', 1, 'O enunciado pediu o valor sem arredondar.'),

('Repetir Texto com Separador', 'Declara a funcao repetir', 'def\s+repetir\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar repetir e receber texto e vezes.'),
('Repetir Texto com Separador', 'Usa o separador entre os itens', '(,\s|join\s*\()', 'OBRIGATORIO', 1, 'O separador ", " entra entre os itens, nunca no fim.'),
('Repetir Texto com Separador', 'Junta os pedacos com join', 'join\s*\(', 'PONTUAVEL', 3, 'join coloca o separador so entre os itens, resolvendo a virgula sobrando.'),
('Repetir Texto com Separador', 'Repete conforme o parametro vezes', '(vezes|range\s*\(|\*\s*vezes)', 'PONTUAVEL', 3, 'A quantidade de repeticoes vem por parametro, nao pode ser fixa.'),
('Repetir Texto com Separador', 'Trata vezes igual a zero', '(if\s|range\s*\(|not\s+vezes)', 'PONTUAVEL', 2, 'Com vezes igual a 0 a saida e string vazia, sem separador nenhum.'),
('Repetir Texto com Separador', 'Nao deixe separador no fim', '\+\s*.,\s.\s*$', 'PROIBIDO', 1, 'Concatenar em laco costuma deixar a virgula final. join evita isso.'),

('Contar Tipos de Caractere', 'Declara a funcao contar_tipos', 'def\s+contar_tipos\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar contar_tipos e receber o texto.'),
('Contar Tipos de Caractere', 'Percorre o texto', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'A classificacao acontece caractere a caractere.'),
('Contar Tipos de Caractere', 'Identifica as letras', '(isalpha|isalnum)', 'PONTUAVEL', 3, 'isalpha responde se o caractere e letra.'),
('Contar Tipos de Caractere', 'Identifica os digitos', '(isdigit|isnumeric)', 'PONTUAVEL', 3, 'isdigit responde se o caractere e algarismo.'),
('Contar Tipos de Caractere', 'Devolve o dicionario com as tres chaves', '(letras[\s\S]{0,80}digitos|outros)', 'PONTUAVEL', 2, 'A saida tem exatamente as chaves letras, digitos e outros.'),
('Contar Tipos de Caractere', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O texto chega por parametro.'),

('Frete por Faixa de Valor', 'Declara a funcao calcular_frete', 'def\s+calcular_frete\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar calcular_frete e receber o valor da compra.'),
('Frete por Faixa de Valor', 'Compara contra os limites das faixas', '(200|100)', 'OBRIGATORIO', 1, 'Os cortes em 200 e em 100 precisam aparecer nas comparacoes.'),
('Frete por Faixa de Valor', 'Inclui o limite na faixa de frete gratis', '>=\s*200', 'PONTUAVEL', 3, 'Compra de exatamente 200 tem frete gratis: a comparacao e >= e nao >.'),
('Frete por Faixa de Valor', 'Encadeia as faixas sem sobreposicao', '(elif|else)', 'PONTUAVEL', 3, 'if/elif/else garante que cada valor caia em uma unica faixa.'),
('Frete por Faixa de Valor', 'Devolve o valor do frete', 'return\s+\S+', 'PONTUAVEL', 2, 'O frete calculado precisa voltar como retorno.'),
('Frete por Faixa de Valor', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
