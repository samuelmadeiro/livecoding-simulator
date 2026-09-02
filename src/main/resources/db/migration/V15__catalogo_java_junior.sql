-- Catalogo Java, nivel junior: 23 questoes de algoritmo.
--
-- Um degrau acima do estagio: agrupamento, Comparator encadeado, duas estruturas combinadas,
-- recursao, janela deslizante e tratamento de ausencia. As armadilhas sao as do Java de verdade:
-- Integer comparado com ==, chave de Map sem equals, subList que aponta para a lista original,
-- ConcurrentModificationException ao remover dentro do laco.
--
-- Como no catalogo de estagio, o titulo leva o sufixo (Java) para nao colidir com a questao
-- equivalente de Python, e o INSERT de criterios filtra pela tecnologia.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'JUNIOR', 'ALGORITMO_EASY', v.tempo, v.template, t.id
FROM (VALUES

('Agrupar Pedidos por Cliente (Java)',
 'Escreva o metodo agrupar(List<String[]> pedidos) que devolve um mapa com o cliente e a lista de valores dos pedidos dele.',
 'Antes de qualquer relatorio vem o agrupamento, e ele quase sempre acontece na aplicacao quando os dados chegam de fontes diferentes. Em Java a armadilha e criar a lista do cliente no lugar errado e sobrescrever o pedido anterior a cada volta do laco.',
 'Uma List<String[]> em que cada array tem o nome do cliente na posicao 0 e o valor na posicao 1. Pode vir vazia.',
 'Um Map<String, List<String>> com o cliente e seus valores, na ordem em que apareceram. Lista vazia devolve mapa vazio.',
 'Entrada: [["ana","10"],["bia","5"],["ana","7"]]
Saida: {ana=[10, 7], bia=[5]}',
 'A ordem dos valores dentro de cada cliente segue a entrada. Cliente novo precisa ganhar uma lista antes do primeiro add.',
 30,
 'import java.util.*;

public class Solucao {
    public Map<String, List<String>> agrupar(List<String[]> pedidos) {
        // TODO: implementar
        return new LinkedHashMap<>();
    }
}'),

('Ordenar por Dois Criterios (Java)',
 'Escreva o metodo ranking(List<String[]> jogadores) que ordena por pontos em ordem decrescente e, no empate, por nome em ordem alfabetica.',
 'Toda tabela de classificacao tem desempate, e ele nao pode ser aleatorio: dois usuarios com a mesma pontuacao precisam aparecer sempre na mesma ordem. Em Java isso e Comparator encadeado, e a conversa seguinte e sobre reversed() aplicado no lugar errado.',
 'Uma List<String[]> com o nome na posicao 0 e os pontos, como texto, na posicao 1.',
 'Uma nova lista ordenada por pontos decrescente e nome crescente no empate. A lista recebida nao pode ser alterada.',
 'Entrada: [["bia","10"],["ana","10"],["caio","20"]]
Saida: [["caio","20"],["ana","10"],["bia","10"]]',
 'Os dois criterios valem na mesma ordenacao. Nao ordene duas vezes seguidas.',
 30,
 'import java.util.*;

public class Solucao {
    public List<String[]> ranking(List<String[]> jogadores) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Media Movel de Tres Dias (Java)',
 'Escreva o metodo mediaMovel(int[] valores) que devolve a media de cada janela de tres valores consecutivos.',
 'Grafico de metrica usa media movel para suavizar o ruido do dia a dia. O que se avalia e o controle do indice: onde a janela comeca, onde termina e quantos resultados devem sair, sem estourar o fim do array.',
 'Um array de inteiros. Pode ter menos de tres elementos.',
 'Um double[] com as medias de cada janela. Entrada com menos de tres elementos devolve array vazio.',
 'Entrada: [1, 2, 3, 4]
Saida: [2.0, 3.0]',
 'A saida tem exatamente length - 2 posicoes quando ha ao menos tres elementos. Cuidado com a divisao inteira.',
 30,
 'public class Solucao {
    public double[] mediaMovel(int[] valores) {
        // TODO: implementar
        return new double[0];
    }
}'),

('Validar CPF (Java)',
 'Escreva o metodo cpfValido(String cpf) que valida o CPF pelos dois digitos verificadores.',
 'Validar documento antes de ir ao servidor evita requisicao inutil, e o algoritmo do CPF e o exemplo mais comum de regra oficial implementada em codigo. O ponto de atencao e a sequencia de digitos repetidos, que passa na conta mas e invalida por definicao.',
 'Uma String com 11 digitos, podendo conter pontos e traco. Pode ser nula.',
 'true se o CPF for valido, false caso contrario. Sequencias com todos os digitos iguais sao invalidas. CPF nulo devolve false.',
 'Entrada: "529.982.247-25"
Saida: true

Entrada: "111.111.111-11"
Saida: false',
 'Remova a formatacao antes de calcular. Digitos todos iguais sao invalidos mesmo passando na conta.',
 40,
 'public class Solucao {
    public boolean cpfValido(String cpf) {
        // TODO: implementar
        return false;
    }
}'),

('Contar Palavras Ignorando Stopwords (Java)',
 'Escreva o metodo contarRelevantes(String texto, Set<String> stopwords) que conta as palavras do texto, ignorando as stopwords.',
 'Busca e nuvem de tags descartam artigos e preposicoes antes de contar, senao o topo do ranking e sempre de e a. E o primeiro passo de qualquer processamento de texto.',
 'texto: String com palavras separadas por espaco, podendo ter maiusculas. stopwords: Set<String> com as palavras em minusculo.',
 'Um Map<String, Integer> com a palavra em minusculo e a contagem, sem as stopwords. Texto vazio devolve mapa vazio.',
 'Entrada: "O rato e o gato", stopwords={o, e}
Saida: {rato=1, gato=1}',
 'A comparacao com as stopwords ignora maiuscula. Nao use Collectors.groupingBy.',
 30,
 'import java.util.*;

public class Solucao {
    public Map<String, Integer> contarRelevantes(String texto, Set<String> stopwords) {
        // TODO: implementar
        return new HashMap<>();
    }
}'),

('Busca Binaria (Java)',
 'Escreva o metodo buscaBinaria(int[] numeros, int alvo) que encontra a posicao do alvo num array ja ordenado.',
 'E a pergunta de complexidade mais comum em entrevista de junior: por que percorrer um milhao de itens quando da para responder em vinte passos. O erro classico e o laco infinito por atualizar mal os limites, e o segundo mais comum e o estouro ao calcular o meio.',
 'numeros: array de inteiros em ordem crescente, sem repeticoes, possivelmente vazio. alvo: o inteiro procurado.',
 'O indice do alvo, comecando em 0. Devolve -1 quando o alvo nao existe.',
 'Entrada: [1, 3, 5, 7, 9], alvo=7
Saida: 3

Entrada: [1, 3], alvo=2
Saida: -1',
 'Nao percorra o array inteiro. Nao use Arrays.binarySearch.',
 30,
 'public class Solucao {
    public int buscaBinaria(int[] numeros, int alvo) {
        // TODO: implementar
        return -1;
    }
}'),

('Parenteses Balanceados (Java)',
 'Escreva o metodo balanceado(String expressao) que verifica se parenteses, colchetes e chaves abrem e fecham na ordem certa.',
 'Todo parser, editor de codigo e validador de formula faz essa checagem. E o exercicio que apresenta a pilha, e a razao de usar pilha fica obvia: o ultimo que abriu e o primeiro que precisa fechar.',
 'Uma String contendo apenas os caracteres de abertura e fechamento. Pode estar vazia ou ser nula.',
 'true se estiver balanceado, false caso contrario. String vazia ou nula devolve true.',
 'Entrada: "{[()]}"
Saida: true

Entrada: "([)]"
Saida: false',
 'A ordem importa: contar quantos abrem e fecham nao resolve. Use uma pilha.',
 35,
 'import java.util.*;

public class Solucao {
    public boolean balanceado(String expressao) {
        // TODO: implementar
        return false;
    }
}'),

('Numero para Romano (Java)',
 'Escreva o metodo paraRomano(int numero) que converte um inteiro para algarismo romano.',
 'A questao existe para ver como a pessoa organiza uma tabela de conversao em vez de escrever dezenas de ifs. Os casos subtrativos, como 4 e 9, sao o que separa a solucao pensada da remendada.',
 'Um int de 1 a 3999.',
 'Uma String com o algarismo romano em maiusculas.',
 'Entrada: 1994
Saida: "MCMXCIV"

Entrada: 4
Saida: "IV"',
 'Os casos subtrativos (4, 9, 40, 90, 400, 900) precisam sair corretos.',
 35,
 'public class Solucao {
    public String paraRomano(int numero) {
        // TODO: implementar
        return "";
    }
}'),

('Par que Soma o Alvo (Java)',
 'Escreva o metodo parComSoma(int[] numeros, int alvo) que encontra dois numeros cuja soma e igual ao alvo.',
 'E o exercicio mais usado para falar de troca de tempo por memoria. A versao com dois lacos funciona e reprova a entrevista; a versao com um Set de complementos responde numa varredura so.',
 'numeros: array de inteiros, podendo ter repeticoes. alvo: inteiro.',
 'Um int[] com os dois valores, na ordem em que aparecem. Devolve array vazio quando nao existe par.',
 'Entrada: [2, 7, 11, 15], alvo=9
Saida: [2, 7]

Entrada: [1, 2], alvo=99
Saida: []',
 'Nao use dois lacos aninhados. O mesmo elemento nao pode ser usado duas vezes.',
 35,
 'import java.util.*;

public class Solucao {
    public int[] parComSoma(int[] numeros, int alvo) {
        // TODO: implementar
        return new int[0];
    }
}'),

('Comprimir Texto Repetido (Java)',
 'Escreva o metodo comprimir(String texto) que troca sequencias de caracteres iguais pelo caractere seguido da contagem.',
 'E a versao didatica de compressao usada em imagem simples e em telemetria. A regra que fecha a questao e nao piorar: se a compressao ficar maior que o original, devolve o original. Em Java, tambem e onde StringBuilder deixa de ser detalhe.',
 'Uma String com letras, possivelmente vazia ou nula.',
 'A String comprimida, ou a original quando a compressao nao for menor. Texto vazio ou nulo devolve string vazia.',
 'Entrada: "aaabbc"
Saida: "a3b2c1"

Entrada: "abc"
Saida: "abc"',
 'Se o resultado ficar do mesmo tamanho ou maior, devolva o texto original.',
 35,
 'public class Solucao {
    public String comprimir(String texto) {
        // TODO: implementar
        return "";
    }
}'),

('Rotacionar a Lista (Java)',
 'Escreva o metodo rotacionar(List<Integer> itens, int posicoes) que gira a lista para a direita.',
 'Carrossel de banner e rodizio de plantao usam rotacao. O detalhe que quebra a solucao ingenua e o numero de posicoes maior que o tamanho da lista, que precisa dar a volta em vez de estourar o indice.',
 'itens: uma List<Integer>, possivelmente vazia. posicoes: int maior ou igual a 0, podendo ser maior que o tamanho da lista.',
 'Uma nova lista rotacionada para a direita. Lista vazia devolve lista vazia. A lista recebida nao pode ser alterada.',
 'Entrada: [1, 2, 3, 4], posicoes=1
Saida: [4, 1, 2, 3]

Entrada: [1, 2, 3], posicoes=5
Saida: [2, 3, 1]',
 'posicoes maior que o tamanho precisa dar a volta. Nao altere a lista recebida.',
 30,
 'import java.util.*;

public class Solucao {
    public List<Integer> rotacionar(List<Integer> itens, int posicoes) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Formatar Valor em Reais (Java)',
 'Escreva o metodo formatarReais(double valor) que devolve o valor no formato brasileiro de moeda.',
 'Numero mal formatado numa fatura vira chamado de suporte. O Brasil usa ponto para milhar e virgula para decimal, o inverso do padrao do Java, entao a troca precisa ser feita sem embaralhar os separadores.',
 'Um double que pode ser negativo.',
 'Uma String no formato R$ 1.234,56, sempre com duas casas decimais.',
 'Entrada: 1234.5
Saida: "R$ 1.234,56"

Entrada: -0.5
Saida: "R$ -0,50"',
 'Sempre duas casas decimais. Nao use NumberFormat com Locale pronto: monte a formatacao.',
 30,
 'public class Solucao {
    public String formatarReais(double valor) {
        // TODO: implementar
        return "";
    }
}'),

('Unir Intervalos que se Sobrepoem (Java)',
 'Escreva o metodo unir(int[][] intervalos) que junta os intervalos que se sobrepoem num unico intervalo.',
 'Agenda de sala, janela de manutencao e periodo de ferias precisam ser consolidados antes de aparecer na tela. A solucao passa por ordenar primeiro, e essa e a sacada que o entrevistador espera ouvir antes de qualquer linha de codigo.',
 'Um int[][] em que cada linha tem inicio na posicao 0 e fim na posicao 1, em qualquer ordem. Pode vir vazio.',
 'Um int[][] sem sobreposicao, ordenado pelo inicio. Entrada vazia devolve array vazio.',
 'Entrada: [[1,3],[7,9],[2,5]]
Saida: [[1,5],[7,9]]',
 'Intervalos que apenas se encostam, como [1,3] e [3,5], devem ser unidos. Ordene antes de percorrer.',
 40,
 'import java.util.*;

public class Solucao {
    public int[][] unir(int[][] intervalos) {
        // TODO: implementar
        return new int[0][0];
    }
}'),

('Paginar uma Lista (Java)',
 'Escreva o metodo paginar(List<String> itens, int pagina, int tamanho) que devolve os itens da pagina pedida.',
 'Paginacao existe em toda listagem, e o off-by-one dela e classico: a pagina 1 comeca no indice 0. Em Java entra um agravante, porque subList com indice alem do fim lanca excecao em vez de devolver lista vazia.',
 'itens: uma List<String>. pagina: int maior ou igual a 1. tamanho: int maior que 0.',
 'Uma lista com os itens daquela pagina. Pagina alem do fim devolve lista vazia, sem lancar excecao.',
 'Entrada: [a,b,c,d,e], pagina=2, tamanho=2
Saida: [c, d]

Entrada: [a,b], pagina=9, tamanho=2
Saida: []',
 'A pagina 1 e a primeira. Pagina fora do intervalo nao pode lancar IndexOutOfBounds.',
 30,
 'import java.util.*;

public class Solucao {
    public List<String> paginar(List<String> itens, int pagina, int tamanho) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Cache de Resultados (Java)',
 'Escreva o metodo calcularComCache(int[] numeros, Map<Integer, Integer> cache) que devolve o quadrado de cada numero, reaproveitando o que ja foi calculado.',
 'Memoizacao aparece em toda rotina que consulta servico externo ou faz conta cara. O calculo aqui e trivial de proposito: o que se avalia e a mecanica de consultar o cache antes, gravar depois e nao recalcular o que ja se sabe.',
 'numeros: array de inteiros, podendo ter repeticoes. cache: mapa que ja pode conter resultados anteriores e e atualizado pelo metodo.',
 'Um int[] com o quadrado de cada numero, na ordem da entrada. O cache recebido fica atualizado.',
 'Entrada: [2, 3, 2], cache={}
Saida: [4, 9, 4] e o cache passa a valer {2=4, 3=9}',
 'O mesmo numero nao pode ser calculado duas vezes. O cache e alterado no lugar, nao substituido.',
 30,
 'import java.util.*;

public class Solucao {
    public int[] calcularComCache(int[] numeros, Map<Integer, Integer> cache) {
        // TODO: implementar
        return new int[0];
    }
}'),

('Validar Campos Obrigatorios (Java)',
 'Escreva o metodo validar(Map<String, String> dados, List<String> obrigatorios) que devolve os campos ausentes ou vazios.',
 'Antes de gravar qualquer requisicao o backend valida o corpo, e a resposta util aponta todos os campos com problema de uma vez, e nao um por vez. Campo presente mas em branco conta como ausente, e e isso que costuma escapar.',
 'dados: mapa com os valores recebidos, que podem ser nulos. obrigatorios: lista com os nomes dos campos.',
 'Uma List<String> com os campos ausentes ou vazios, na ordem da lista de obrigatorios. Nenhum problema devolve lista vazia.',
 'Entrada: {cliente=ana, item=}, obrigatorios=[cliente, item, valor]
Saida: [item, valor]',
 'String vazia e valor nulo contam como ausente. Nao pare no primeiro erro.',
 30,
 'import java.util.*;

public class Solucao {
    public List<String> validar(Map<String, String> dados, List<String> obrigatorios) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Saldo a Partir dos Lancamentos (Java)',
 'Escreva o metodo saldoFinal(List<String[]> lancamentos) que soma creditos e subtrai debitos.',
 'E o coracao de qualquer extrato. O erro que aparece em producao e comparar o tipo do lancamento com == em vez de equals: com String isso compara referencia, funciona no teste com literal e falha com dado vindo do banco.',
 'Uma List<String[]> com o tipo na posicao 0 (credito ou debito) e o valor, como texto, na posicao 1.',
 'Um double com o saldo final. Lista vazia devolve 0. Tipo desconhecido e ignorado.',
 'Entrada: [["credito","100"],["debito","30"]]
Saida: 70.0',
 'Tipo fora de credito e debito e ignorado, sem lancar excecao. Compare texto com equals.',
 30,
 'import java.util.*;

public class Solucao {
    public double saldoFinal(List<String[]> lancamentos) {
        // TODO: implementar
        return 0;
    }
}'),

('Horarios que se Chocam (Java)',
 'Escreva o metodo temConflito(int[][] reservas) que diz se existe sobreposicao de horario.',
 'Reserva de sala e agenda medica passam por esse teste antes de confirmar qualquer marcacao. A comparacao entre dois intervalos e curta, mas quase todo mundo escreve a condicao invertida na primeira tentativa.',
 'Um int[][] com inicio na posicao 0 e fim na posicao 1, em qualquer ordem.',
 'true se dois horarios quaisquer se sobrepoem. Intervalos que so se encostam, como [8,10] e [10,12], nao sao conflito.',
 'Entrada: [[8,10],[9,11]]
Saida: true

Entrada: [[8,10],[10,12]]
Saida: false',
 'Fim igual ao inicio do proximo nao e conflito. Ordene antes de comparar.',
 35,
 'import java.util.*;

public class Solucao {
    public boolean temConflito(int[][] reservas) {
        // TODO: implementar
        return false;
    }
}'),

('Somar Valores Aninhados (Java)',
 'Escreva o metodo somarTudo(List<Object> dados) que soma todos os numeros de uma estrutura com listas dentro de listas, em qualquer profundidade.',
 'JSON de API chega aninhado e nem sempre com profundidade conhecida. Resolver isso e a porta de entrada para recursao, e em Java ainda cobra o teste de tipo com instanceof antes de descer mais um nivel.',
 'Uma List<Object> que pode conter Integer e outras List<Object>, em qualquer profundidade.',
 'Um int com a soma de todos os valores encontrados. Lista vazia devolve 0.',
 'Entrada: [1, [2, [3, 4]], 5]
Saida: 15',
 'A profundidade e desconhecida. Trate o elemento que nao e numero nem lista sem quebrar.',
 35,
 'import java.util.*;

public class Solucao {
    public int somarTudo(List<Object> dados) {
        // TODO: implementar
        return 0;
    }
}'),

('Intercalar Duas Listas (Java)',
 'Escreva o metodo intercalar(List<String> primeira, List<String> segunda) que alterna os elementos das duas listas.',
 'Aparece em feed que mistura duas fontes e em distribuicao entre filas. O caso interessante e o tamanho diferente: a lista maior precisa despejar o que sobrou no fim, sem perder nada e sem estourar indice.',
 'Duas List<String> de qualquer tamanho, inclusive vazias e de tamanhos diferentes.',
 'Uma lista alternando um elemento de cada, comecando pela primeira. O excedente vai para o fim, na ordem original.',
 'Entrada: [1, 2, 3], [a]
Saida: [1, a, 2, 3]',
 'Nenhum elemento pode se perder. Cuidado com o indice ao passar do fim da lista menor.',
 30,
 'import java.util.*;

public class Solucao {
    public List<String> intercalar(List<String> primeira, List<String> segunda) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Remover Itens Durante o Laco (Java)',
 'Escreva o metodo removerCancelados(List<String> status) que remove da lista todos os itens iguais a cancelado.',
 'Filtrar uma colecao no lugar e tarefa diaria, e e onde nasce a ConcurrentModificationException mais famosa do Java: remover de dentro do for-each quebra em tempo de execucao, mesmo compilando sem aviso.',
 'Uma List<String> que pode conter o valor cancelado varias vezes. Pode ser nula ou vazia.',
 'A mesma lista recebida, sem os itens cancelados, devolvida pelo metodo. Lista nula devolve lista vazia.',
 'Entrada: [pago, cancelado, pendente, cancelado]
Saida: [pago, pendente]',
 'A remocao acontece na propria lista. Remover dentro do for-each lanca ConcurrentModificationException.',
 30,
 'import java.util.*;

public class Solucao {
    public List<String> removerCancelados(List<String> status) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Comparar Inteiros com Seguranca (Java)',
 'Escreva o metodo saoIguais(Integer a, Integer b) que diz se os dois valores representam o mesmo numero.',
 'E a pegadinha mais conhecida do Java e a que mais gera bug silencioso: Integer comparado com == compara referencia, funciona por acaso para valores pequenos por causa do cache de autoboxing e falha a partir de 128. O codigo passa em teste e quebra em producao.',
 'Dois Integer que podem ser nulos e podem ter qualquer valor.',
 'true se representarem o mesmo numero, incluindo os dois nulos. false se apenas um for nulo.',
 'Entrada: 1000, 1000
Saida: true

Entrada: null, 5
Saida: false',
 'Os dois nulos contam como iguais. A comparacao nao pode depender do cache de autoboxing.',
 25,
 'public class Solucao {
    public boolean saoIguais(Integer a, Integer b) {
        // TODO: implementar
        return false;
    }
}'),

('Resumo Estatistico do Array (Java)',
 'Escreva o metodo resumo(int[] numeros) que devolve minimo, maximo, media e mediana.',
 'Antes de plotar qualquer grafico alguem calcula esse resumo. A mediana e a parte que revela atencao: com quantidade par de elementos ela e a media dos dois centrais, e e ai que a maioria erra.',
 'Um array de inteiros com pelo menos um elemento.',
 'Um double[] com quatro posicoes, nesta ordem: minimo, maximo, media e mediana.',
 'Entrada: [1, 3, 2, 4]
Saida: [1.0, 4.0, 2.5, 2.5]',
 'Com quantidade par, a mediana e a media dos dois centrais. Ordene uma copia, nao o array recebido.',
 35,
 'import java.util.*;

public class Solucao {
    public double[] resumo(int[] numeros) {
        // TODO: implementar
        return new double[4];
    }
}')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Agrupar Pedidos por Cliente (Java)', 'Declara o metodo agrupar', '\w+\s+agrupar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar agrupar e receber a lista de pedidos.'),
('Agrupar Pedidos por Cliente (Java)', 'Percorre os pedidos', 'for\s*\(', 'OBRIGATORIO', 1, 'O agrupamento sai de um laco sobre a lista.'),
('Agrupar Pedidos por Cliente (Java)', 'Cria a lista na primeira ocorrencia do cliente', '(computeIfAbsent|containsKey|getOrDefault|putIfAbsent)', 'PONTUAVEL', 3, 'Cliente novo precisa ganhar uma lista vazia antes do primeiro add.'),
('Agrupar Pedidos por Cliente (Java)', 'Acumula o valor na lista do cliente', 'add\s*\(', 'PONTUAVEL', 3, 'Atribuir uma lista nova a cada volta descarta o pedido anterior.'),
('Agrupar Pedidos por Cliente (Java)', 'Preserva a ordem de chegada', '(LinkedHashMap|add\s*\()', 'PONTUAVEL', 2, 'A ordem dos valores dentro do cliente segue a entrada.'),
('Agrupar Pedidos por Cliente (Java)', 'Nao use Collectors.groupingBy', 'groupingBy', 'PROIBIDO', 1, 'O enunciado pede o agrupamento montado na mao.'),

('Ordenar por Dois Criterios (Java)', 'Declara o metodo ranking', '\w+\s+ranking\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar ranking e receber a lista.'),
('Ordenar por Dois Criterios (Java)', 'Ordena com Comparator', '(Comparator|sort\s*\()', 'OBRIGATORIO', 1, 'A ordenacao por campo exige um Comparator.'),
('Ordenar por Dois Criterios (Java)', 'Encadeia o segundo criterio', 'thenComparing', 'PONTUAVEL', 3, 'thenComparing resolve o desempate na mesma ordenacao.'),
('Ordenar por Dois Criterios (Java)', 'Inverte apenas os pontos', '(reversed|-\s*Integer\.compare|Comparator\.comparingInt)', 'PONTUAVEL', 3, 'Pontos sao decrescentes e o nome crescente: reversed no lugar errado inverte os dois.'),
('Ordenar por Dois Criterios (Java)', 'Copia antes de ordenar', '(new\s+ArrayList|copyOf)', 'PONTUAVEL', 2, 'sort altera a lista recebida: copie antes para preservar a original.'),
('Ordenar por Dois Criterios (Java)', 'Nao ordene duas vezes seguidas', 'sort\s*\([\s\S]{0,200}sort\s*\(', 'PROIBIDO', 1, 'Duas ordenacoes seguidas dependem da estabilidade e confundem quem le.'),

('Media Movel de Tres Dias (Java)', 'Declara o metodo mediaMovel', '\w+\s+mediaMovel\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar mediaMovel e receber os valores.'),
('Media Movel de Tres Dias (Java)', 'Percorre as janelas', 'for\s*\(', 'OBRIGATORIO', 1, 'O laco vai ate length - 2 para nao estourar a ultima janela.'),
('Media Movel de Tres Dias (Java)', 'Soma os tres valores da janela', '(\+\s*\w+\s*\[|\+=)', 'PONTUAVEL', 3, 'Cada media usa tres valores consecutivos.'),
('Media Movel de Tres Dias (Java)', 'Divide por tres sem truncar', '(3\.0|\(\s*double|/\s*3\.0)', 'PONTUAVEL', 3, 'Dividir int por int corta o decimal e a media sai errada.'),
('Media Movel de Tres Dias (Java)', 'Dimensiona o array de saida', '(length\s*-\s*2|new\s+double)', 'PONTUAVEL', 2, 'A saida tem exatamente length - 2 posicoes.'),
('Media Movel de Tres Dias (Java)', 'Nao estoure o fim do array', 'i\s*<\s*\w+\.length\s*;', 'PROIBIDO', 1, 'Ir ate length com janela de tres lanca ArrayIndexOutOfBounds.'),

('Validar CPF (Java)', 'Declara o metodo cpfValido', '\w+\s+cpfValido\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar cpfValido e receber o cpf.'),
('Validar CPF (Java)', 'Remove a formatacao antes de calcular', '(replaceAll|replace\s*\(|isDigit)', 'OBRIGATORIO', 1, 'Ponto e traco precisam sair antes de qualquer conta.'),
('Validar CPF (Java)', 'Calcula os digitos com peso decrescente', '(for\s*\(|\*\s*\(|10\s*-|11\s*-)', 'PONTUAVEL', 3, 'Cada digito e multiplicado por um peso que decresce.'),
('Validar CPF (Java)', 'Aplica o modulo 11', '%\s*11', 'PONTUAVEL', 3, 'O digito verificador sai do resto da divisao por 11.'),
('Validar CPF (Java)', 'Rejeita digitos todos iguais', '(matches|distinct|chars\s*\(|repeat)', 'PONTUAVEL', 2, 'Uma sequencia como 111.111.111-11 passa na conta mas e invalida.'),
('Validar CPF (Java)', 'Protege contra CPF nulo', '(==\s*null|!=\s*null)', 'PROIBIDO', 1, 'CPF nulo lanca NullPointerException: o enunciado manda devolver false.'),

('Contar Palavras Ignorando Stopwords (Java)', 'Declara o metodo contarRelevantes', '\w+\s+contarRelevantes\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar contarRelevantes e receber texto e stopwords.'),
('Contar Palavras Ignorando Stopwords (Java)', 'Separa o texto em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'A contagem comeca separando a frase em palavras.'),
('Contar Palavras Ignorando Stopwords (Java)', 'Descarta as stopwords', 'contains\s*\(', 'PONTUAVEL', 3, 'A palavra que esta no conjunto de stopwords nao entra na contagem.'),
('Contar Palavras Ignorando Stopwords (Java)', 'Normaliza a caixa antes de comparar', 'toLowerCase', 'PONTUAVEL', 3, 'A stopword vem em minusculo: sem normalizar, o O maiusculo escapa do filtro.'),
('Contar Palavras Ignorando Stopwords (Java)', 'Acumula a contagem no mapa', '(getOrDefault|merge\s*\(|put\s*\()', 'PONTUAVEL', 2, 'getOrDefault evita NullPointerException na primeira ocorrencia.'),
('Contar Palavras Ignorando Stopwords (Java)', 'Nao use Collectors.groupingBy', 'groupingBy', 'PROIBIDO', 1, 'O enunciado pede a contagem montada na mao.'),

('Busca Binaria (Java)', 'Declara o metodo buscaBinaria', '\w+\s+buscaBinaria\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar buscaBinaria e receber numeros e alvo.'),
('Busca Binaria (Java)', 'Mantem os limites da busca', '(inicio|fim|esquerda|direita|low|high)', 'OBRIGATORIO', 1, 'A busca binaria trabalha com dois limites que se aproximam.'),
('Busca Binaria (Java)', 'Calcula o meio da faixa', '(/\s*2|>>>\s*1)', 'PONTUAVEL', 3, 'O meio e a media dos limites; inicio + (fim - inicio) / 2 evita estouro.'),
('Busca Binaria (Java)', 'Descarta metade a cada passo', '(meio\s*\+\s*1|meio\s*-\s*1)', 'PONTUAVEL', 3, 'Ajustar o limite para meio+1 ou meio-1 e o que evita o laco infinito.'),
('Busca Binaria (Java)', 'Devolve -1 quando nao encontra', '-\s*1', 'PONTUAVEL', 2, 'Sem o -1 nao da para distinguir ausencia da posicao 0.'),
('Busca Binaria (Java)', 'Nao use Arrays.binarySearch', 'binarySearch', 'PROIBIDO', 1, 'O enunciado pede o algoritmo escrito na mao.'),

('Parenteses Balanceados (Java)', 'Declara o metodo balanceado', '\w+\s+balanceado\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar balanceado e receber a expressao.'),
('Parenteses Balanceados (Java)', 'Usa uma pilha', '(Deque|Stack|push|pop)', 'OBRIGATORIO', 1, 'O ultimo simbolo aberto e o primeiro que precisa fechar: isso e uma pilha.'),
('Parenteses Balanceados (Java)', 'Empilha os simbolos de abertura', '(push|addLast|add\s*\()', 'PONTUAVEL', 3, 'Todo simbolo que abre vai para a pilha esperando o par dele.'),
('Parenteses Balanceados (Java)', 'Confere se o fechamento casa com o topo', '(pop|peek)', 'PONTUAVEL', 3, 'Ao fechar, o simbolo precisa casar com o topo da pilha.'),
('Parenteses Balanceados (Java)', 'Exige a pilha vazia no fim', 'isEmpty', 'PONTUAVEL', 2, 'Sobrou simbolo aberto, a expressao nao esta balanceada.'),
('Parenteses Balanceados (Java)', 'Nao conte apenas a quantidade', '(count\s*\(|length\s*\(\s*\)\s*%)', 'PROIBIDO', 1, 'Contar quantos abrem e fecham aprova a expressao errada, porque ignora a ordem.'),

('Numero para Romano (Java)', 'Declara o metodo paraRomano', '\w+\s+paraRomano\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar paraRomano e receber o numero.'),
('Numero para Romano (Java)', 'Percorre uma tabela de valores', 'for\s*\(|while\s*\(', 'OBRIGATORIO', 1, 'A conversao percorre os valores do maior para o menor, subtraindo.'),
('Numero para Romano (Java)', 'Inclui os casos subtrativos', '(CM|XC|IV|IX|XL)', 'PONTUAVEL', 3, 'Sem CM, XC, XL, IX e IV na tabela, o 1994 sai errado.'),
('Numero para Romano (Java)', 'Subtrai o valor a cada simbolo emitido', '(-=|-\s*\w+\s*\[)', 'PONTUAVEL', 3, 'A cada simbolo escrito, o valor sai do numero restante.'),
('Numero para Romano (Java)', 'Monta a saida com StringBuilder', 'StringBuilder', 'PONTUAVEL', 2, 'Concatenar String em laco cria um objeto novo a cada volta.'),
('Numero para Romano (Java)', 'Nao encadeie dezenas de ifs', 'else\s+if[\s\S]{0,400}else\s+if[\s\S]{0,400}else\s+if[\s\S]{0,400}else\s+if', 'PROIBIDO', 1, 'Uma tabela de valores substitui a cadeia de ifs e fica muito mais legivel.'),

('Par que Soma o Alvo (Java)', 'Declara o metodo parComSoma', '\w+\s+parComSoma\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar parComSoma e receber numeros e alvo.'),
('Par que Soma o Alvo (Java)', 'Guarda os numeros ja vistos', '(Set|HashSet|Map|contains)', 'OBRIGATORIO', 1, 'Guardar o que ja passou e o que permite responder numa varredura so.'),
('Par que Soma o Alvo (Java)', 'Calcula o complemento do alvo', '(alvo\s*-|-\s*\w+\s*\[)', 'PONTUAVEL', 3, 'Para cada numero, o que falta e alvo menos ele.'),
('Par que Soma o Alvo (Java)', 'Devolve os dois valores', 'new\s+int\s*\[\s*\]', 'PONTUAVEL', 3, 'A saida e um array com os dois numeros, na ordem em que aparecem.'),
('Par que Soma o Alvo (Java)', 'Devolve array vazio quando nao ha par', 'new\s+int\s*\[\s*0\s*\]', 'PONTUAVEL', 2, 'Sem par, o enunciado pede array vazio e nao null.'),
('Par que Soma o Alvo (Java)', 'Nao use dois lacos aninhados', 'for\s*\([\s\S]{0,120}for\s*\(', 'PROIBIDO', 1, 'O laco dentro do laco resolve mas e quadratico, e o enunciado pediu uma varredura.'),

('Comprimir Texto Repetido (Java)', 'Declara o metodo comprimir', '\w+\s+comprimir\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar comprimir e receber o texto.'),
('Comprimir Texto Repetido (Java)', 'Percorre o texto contando repeticoes', '(for\s*\(|while\s*\()', 'OBRIGATORIO', 1, 'A contagem da sequencia sai de um laco que compara com o caractere anterior.'),
('Comprimir Texto Repetido (Java)', 'Compara com o caractere anterior', '(charAt|==|!=)', 'PONTUAVEL', 3, 'A sequencia termina quando o caractere muda.'),
('Comprimir Texto Repetido (Java)', 'Monta o resultado com StringBuilder', 'StringBuilder', 'PONTUAVEL', 3, 'Concatenar String em laco cria um objeto novo a cada volta.'),
('Comprimir Texto Repetido (Java)', 'Devolve o original quando nao compensa', 'length\s*\(', 'PONTUAVEL', 2, 'Se o resultado nao ficou menor, o enunciado manda devolver o texto original.'),
('Comprimir Texto Repetido (Java)', 'Protege contra texto nulo', '(==\s*null|!=\s*null)', 'PROIBIDO', 1, 'Texto nulo lanca NullPointerException: o enunciado manda devolver string vazia.'),

('Rotacionar a Lista (Java)', 'Declara o metodo rotacionar', '\w+\s+rotacionar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar rotacionar e receber itens e posicoes.'),
('Rotacionar a Lista (Java)', 'Normaliza posicoes maiores que a lista', '%\s*\w+\.size\s*\(', 'OBRIGATORIO', 1, 'O resto da divisao pelo tamanho faz a rotacao dar a volta.'),
('Rotacionar a Lista (Java)', 'Recorta as duas partes da lista', 'subList', 'PONTUAVEL', 3, 'A cauda passa para o comeco e o resto vem depois.'),
('Rotacionar a Lista (Java)', 'Monta uma lista nova', '(new\s+ArrayList|addAll)', 'PONTUAVEL', 3, 'subList devolve uma visao da lista original: copie para uma lista nova.'),
('Rotacionar a Lista (Java)', 'Trata a lista vazia', '(isEmpty|size\s*\(\s*\)\s*==\s*0)', 'PONTUAVEL', 2, 'Lista vazia faz o resto da divisao por zero estourar.'),
('Rotacionar a Lista (Java)', 'Nao altere a lista recebida', 'Collections\.(rotate|reverse)\s*\(\s*itens', 'PROIBIDO', 1, 'Esses metodos alteram a lista de quem chamou; o enunciado pede uma lista nova.'),

('Formatar Valor em Reais (Java)', 'Declara o metodo formatarReais', '\w+\s+formatarReais\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar formatarReais e receber o valor.'),
('Formatar Valor em Reais (Java)', 'Fixa duas casas decimais', '(%\s*,?\.2f|\.2f|#\.##)', 'OBRIGATORIO', 1, 'O formato com duas casas garante o centavo mesmo em valor inteiro.'),
('Formatar Valor em Reais (Java)', 'Separa o milhar', '(,|#,##)', 'PONTUAVEL', 3, 'O separador de milhar precisa aparecer: 1234 vira 1.234.'),
('Formatar Valor em Reais (Java)', 'Troca os separadores para o padrao brasileiro', 'replace', 'PONTUAVEL', 3, 'O Java formata ao contrario: a troca precisa ser feita sem embaralhar.'),
('Formatar Valor em Reais (Java)', 'Prefixa com o simbolo da moeda', 'R\$', 'PONTUAVEL', 2, 'A saida comeca com R$ e um espaco.'),
('Formatar Valor em Reais (Java)', 'Nao use NumberFormat com Locale pronto', '(NumberFormat|Locale)', 'PROIBIDO', 1, 'O enunciado pediu a formatacao montada na mao.'),

('Unir Intervalos que se Sobrepoem (Java)', 'Declara o metodo unir', '\w+\s+unir\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar unir e receber os intervalos.'),
('Unir Intervalos que se Sobrepoem (Java)', 'Ordena antes de percorrer', '(Arrays\.sort|Comparator)', 'OBRIGATORIO', 1, 'Sem ordenar pelo inicio, dois intervalos que se sobrepoem podem nunca ficar lado a lado.'),
('Unir Intervalos que se Sobrepoem (Java)', 'Compara o fim atual com o inicio seguinte', '(<=|>=|<|>)', 'PONTUAVEL', 3, 'Ha sobreposicao quando o inicio do proximo e menor ou igual ao fim do atual.'),
('Unir Intervalos que se Sobrepoem (Java)', 'Estende o intervalo com o maior fim', 'Math\.max', 'PONTUAVEL', 3, 'Ao unir, o fim e o maior dos dois: [1,9] com [2,5] vira [1,9], nao [1,5].'),
('Unir Intervalos que se Sobrepoem (Java)', 'Monta a saida numa lista antes de converter', '(List|ArrayList|toArray)', 'PONTUAVEL', 2, 'A quantidade final de intervalos so se sabe no fim: monte numa lista e converta depois.'),
('Unir Intervalos que se Sobrepoem (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Paginar uma Lista (Java)', 'Declara o metodo paginar', '\w+\s+paginar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar paginar e receber itens, pagina e tamanho.'),
('Paginar uma Lista (Java)', 'Calcula o inicio da pagina', '(pagina\s*-\s*1|\(\s*pagina\s*-)', 'OBRIGATORIO', 1, 'A pagina 1 comeca no indice 0, entao o calculo usa pagina - 1.'),
('Paginar uma Lista (Java)', 'Multiplica pelo tamanho da pagina', '\*\s*tamanho', 'PONTUAVEL', 3, 'O indice inicial e (pagina - 1) vezes o tamanho.'),
('Paginar uma Lista (Java)', 'Protege o fim da fatia', 'Math\.min', 'PONTUAVEL', 3, 'subList com fim alem do tamanho lanca excecao: Math.min limita o corte.'),
('Paginar uma Lista (Java)', 'Trata a pagina alem do fim', '(>=|>|isEmpty|size\s*\()', 'PONTUAVEL', 2, 'Pagina fora do intervalo devolve lista vazia, sem excecao.'),
('Paginar uma Lista (Java)', 'Nao ignore o indice inicial', 'subList\s*\(\s*0\s*,', 'PROIBIDO', 1, 'Comecar sempre no zero devolve a primeira pagina, qualquer que seja a pagina pedida.'),

('Cache de Resultados (Java)', 'Declara o metodo calcularComCache', '\w+\s+calcularComCache\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar calcularComCache e receber numeros e cache.'),
('Cache de Resultados (Java)', 'Consulta o cache antes de calcular', '(containsKey|get\s*\(|computeIfAbsent)', 'OBRIGATORIO', 1, 'O ganho do cache vem de checar antes: se ja tem, nao calcula de novo.'),
('Cache de Resultados (Java)', 'Grava o resultado novo no cache', '(put\s*\(|computeIfAbsent)', 'PONTUAVEL', 3, 'Depois de calcular, o valor precisa ser gravado para a proxima vez.'),
('Cache de Resultados (Java)', 'Calcula o quadrado', '\*', 'PONTUAVEL', 3, 'O calculo pedido e o numero multiplicado por ele mesmo.'),
('Cache de Resultados (Java)', 'Preenche a saida na ordem da entrada', '\[\s*\w+\s*\]\s*=', 'PONTUAVEL', 2, 'A saida segue a ordem da entrada, inclusive nos repetidos.'),
('Cache de Resultados (Java)', 'Nao substitua o cache recebido', 'cache\s*=\s*new', 'PROIBIDO', 1, 'Reatribuir cache cria um mapa local e quem chamou o metodo nao ve nada.'),

('Validar Campos Obrigatorios (Java)', 'Declara o metodo validar', '\w+\s+validar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar validar e receber dados e obrigatorios.'),
('Validar Campos Obrigatorios (Java)', 'Percorre a lista de obrigatorios', 'for\s*\(', 'OBRIGATORIO', 1, 'A ordem da saida segue a lista de campos obrigatorios.'),
('Validar Campos Obrigatorios (Java)', 'Detecta o campo ausente ou nulo', '(containsKey|==\s*null|get\s*\()', 'PONTUAVEL', 3, 'Campo que nem chegou no mapa precisa entrar na lista de problemas.'),
('Validar Campos Obrigatorios (Java)', 'Detecta o campo presente e vazio', '(isEmpty|isBlank|trim\s*\()', 'PONTUAVEL', 3, 'Campo com string vazia conta como ausente, e e isso que costuma escapar.'),
('Validar Campos Obrigatorios (Java)', 'Acumula todos os problemas', 'add\s*\(', 'PONTUAVEL', 2, 'A resposta util lista todos os campos com problema de uma vez.'),
('Validar Campos Obrigatorios (Java)', 'Nao pare no primeiro erro', 'return\s+List\.of\s*\(\s*\w+\s*\)', 'PROIBIDO', 1, 'Devolver so o primeiro campo obriga o cliente a corrigir um por vez.'),

('Saldo a Partir dos Lancamentos (Java)', 'Declara o metodo saldoFinal', '\w+\s+saldoFinal\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar saldoFinal e receber os lancamentos.'),
('Saldo a Partir dos Lancamentos (Java)', 'Compara o tipo com equals', 'equals\s*\(', 'OBRIGATORIO', 1, 'String comparada com == compara referencia e falha com dado vindo do banco.'),
('Saldo a Partir dos Lancamentos (Java)', 'Soma os creditos', 'credito', 'PONTUAVEL', 3, 'O credito entra somando no saldo.'),
('Saldo a Partir dos Lancamentos (Java)', 'Subtrai os debitos', '(debito|-=)', 'PONTUAVEL', 3, 'O debito precisa sair do saldo, nao entrar.'),
('Saldo a Partir dos Lancamentos (Java)', 'Converte o valor de texto para numero', '(parseDouble|valueOf)', 'PONTUAVEL', 2, 'O valor chega como texto e precisa ser convertido antes da conta.'),
('Saldo a Partir dos Lancamentos (Java)', 'Nao compare texto com ==', '\w+\s*\[\s*0\s*\]\s*==\s*.', 'PROIBIDO', 1, 'Comparar String com == compara referencia, nao conteudo.'),

('Horarios que se Chocam (Java)', 'Declara o metodo temConflito', '\w+\s+temConflito\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar temConflito e receber as reservas.'),
('Horarios que se Chocam (Java)', 'Ordena antes de comparar', '(Arrays\.sort|Comparator)', 'OBRIGATORIO', 1, 'Ordenando pelo inicio, basta comparar cada reserva com a seguinte.'),
('Horarios que se Chocam (Java)', 'Compara o fim de uma com o inicio da outra', '(<|>|<=|>=)', 'PONTUAVEL', 3, 'Ha conflito quando a proxima comeca antes de a atual terminar.'),
('Horarios que se Chocam (Java)', 'Trata o encosto como nao conflito', '(<\s|>\s)', 'PONTUAVEL', 3, 'Fim igual ao inicio seguinte nao e conflito: a comparacao precisa ser estrita.'),
('Horarios que se Chocam (Java)', 'Devolve boolean', 'return\s+(true|false)', 'PONTUAVEL', 2, 'A resposta e true ou false.'),
('Horarios que se Chocam (Java)', 'Nao compare todos contra todos', 'for\s*\([\s\S]{0,120}for\s*\(', 'PROIBIDO', 1, 'Depois de ordenar, basta comparar vizinhos: o laco duplo e desnecessario.'),

('Somar Valores Aninhados (Java)', 'Declara o metodo somarTudo', '\w+\s+somarTudo\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar somarTudo e receber a estrutura.'),
('Somar Valores Aninhados (Java)', 'Distingue numero de lista', 'instanceof', 'OBRIGATORIO', 1, 'instanceof responde se o elemento e lista, para descer mais um nivel.'),
('Somar Valores Aninhados (Java)', 'Desce nos niveis internos', '(somarTudo\s*\(|Deque|Stack)', 'PONTUAVEL', 3, 'Chamar o proprio metodo para a sublista resolve qualquer profundidade.'),
('Somar Valores Aninhados (Java)', 'Acumula a soma', '(\+=|total|soma)', 'PONTUAVEL', 3, 'Os valores encontrados precisam ser somados num acumulador.'),
('Somar Valores Aninhados (Java)', 'Converte o elemento para numero', '(Integer|Number|intValue)', 'PONTUAVEL', 2, 'O elemento chega como Object e precisa ser convertido antes de somar.'),
('Somar Valores Aninhados (Java)', 'Nao assuma profundidade fixa', 'get\s*\(\s*0\s*\)\s*\.\s*get\s*\(\s*0', 'PROIBIDO', 1, 'A profundidade e desconhecida: acessar nivel por nivel na mao nao resolve o caso geral.'),

('Intercalar Duas Listas (Java)', 'Declara o metodo intercalar', '\w+\s+intercalar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar intercalar e receber as duas listas.'),
('Intercalar Duas Listas (Java)', 'Percorre ate a lista maior', '(Math\.max|while|size\s*\()', 'OBRIGATORIO', 1, 'Parar na lista menor descarta o excedente da maior.'),
('Intercalar Duas Listas (Java)', 'Alterna comecando pela primeira', 'add\s*\(', 'PONTUAVEL', 3, 'A ordem e um da primeira, um da segunda, e assim por diante.'),
('Intercalar Duas Listas (Java)', 'Verifica o indice antes de acessar', '(<\s*\w+\.size|size\s*\(\s*\)\s*>)', 'PONTUAVEL', 3, 'Acessar indice alem do fim lanca IndexOutOfBounds.'),
('Intercalar Duas Listas (Java)', 'Anexa o excedente da lista maior', '(add\s*\(|addAll)', 'PONTUAVEL', 2, 'O que sobra da lista maior vai para o fim, na ordem original.'),
('Intercalar Duas Listas (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Remover Itens Durante o Laco (Java)', 'Declara o metodo removerCancelados', '\w+\s+removerCancelados\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar removerCancelados e receber a lista.'),
('Remover Itens Durante o Laco (Java)', 'Remove sem quebrar a iteracao', '(removeIf|Iterator|for\s*\(\s*int)', 'OBRIGATORIO', 1, 'removeIf, um Iterator explicito ou um for com indice de tras para frente resolvem.'),
('Remover Itens Durante o Laco (Java)', 'Identifica o valor cancelado', 'cancelado', 'PONTUAVEL', 3, 'O item removido e o de valor cancelado.'),
('Remover Itens Durante o Laco (Java)', 'Compara texto com equals', 'equals\s*\(', 'PONTUAVEL', 3, 'String comparada com == compara referencia, nao conteudo.'),
('Remover Itens Durante o Laco (Java)', 'Protege contra lista nula', '(==\s*null|!=\s*null)', 'PONTUAVEL', 2, 'Lista nula lanca NullPointerException: o enunciado manda devolver lista vazia.'),
('Remover Itens Durante o Laco (Java)', 'Nao remova dentro do for-each', 'for\s*\(\s*String[\s\S]{0,120}remove\s*\(', 'PROIBIDO', 1, 'Remover dentro do for-each lanca ConcurrentModificationException em tempo de execucao.'),

('Comparar Inteiros com Seguranca (Java)', 'Declara o metodo saoIguais', '\w+\s+saoIguais\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar saoIguais e receber os dois Integer.'),
('Comparar Inteiros com Seguranca (Java)', 'Compara o conteudo, nao a referencia', '(equals\s*\(|intValue|Objects\.equals)', 'OBRIGATORIO', 1, 'Integer comparado com == compara referencia e falha a partir de 128.'),
('Comparar Inteiros com Seguranca (Java)', 'Trata os dois nulos como iguais', '(Objects\.equals|==\s*null[\s\S]{0,40}==\s*null)', 'PONTUAVEL', 3, 'Objects.equals ja resolve os dois nulos numa chamada.'),
('Comparar Inteiros com Seguranca (Java)', 'Trata apenas um nulo', '(null)', 'PONTUAVEL', 3, 'Com um lado nulo a resposta e false, e equals direto lancaria excecao.'),
('Comparar Inteiros com Seguranca (Java)', 'Devolve boolean', 'return\s+', 'PONTUAVEL', 2, 'A resposta e true ou false.'),
('Comparar Inteiros com Seguranca (Java)', 'Nao compare os Integer com ==', 'a\s*==\s*b', 'PROIBIDO', 1, 'Esse e exatamente o bug da questao: funciona ate 127 por causa do cache e falha depois.'),

('Resumo Estatistico do Array (Java)', 'Declara o metodo resumo', '\w+\s+resumo\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar resumo e receber o array.'),
('Resumo Estatistico do Array (Java)', 'Ordena antes de achar a mediana', '(Arrays\.sort|sort\s*\()', 'OBRIGATORIO', 1, 'A mediana exige o array ordenado; sem ordenar o valor central nao significa nada.'),
('Resumo Estatistico do Array (Java)', 'Calcula minimo e maximo', '(Math\.min|Math\.max|\[\s*0\s*\])', 'PONTUAVEL', 3, 'Depois de ordenar, o minimo e o primeiro e o maximo e o ultimo.'),
('Resumo Estatistico do Array (Java)', 'Calcula a media sem truncar', '(double|1\.0|\(\s*double)', 'PONTUAVEL', 3, 'int dividido por int corta o decimal e a media sai errada.'),
('Resumo Estatistico do Array (Java)', 'Trata a quantidade par na mediana', '%\s*2', 'PONTUAVEL', 2, 'Com quantidade par, a mediana e a media dos dois valores centrais.'),
('Resumo Estatistico do Array (Java)', 'Nao ordene o array recebido', 'Arrays\.sort\s*\(\s*numeros\s*\)', 'PROIBIDO', 1, 'Ordenar o array do chamador altera o objeto dele: ordene uma copia.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'Java'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
