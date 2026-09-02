-- Catalogo Java, nivel estagio: 50 questoes de algoritmo.
--
-- Mesma regua dos catalogos anteriores: cada questao diz por que existe, o que entra, o que sai,
-- mostra um caso resolvido e lista o que nao vale. Os criterios so cobram o que o enunciado pediu.
--
-- Todo titulo leva o sufixo (Java) porque o catalogo tem questoes equivalentes em outras
-- linguagens: sem isso, o INSERT de criterios encontraria o desafio homonimo de Python e
-- penduraria a regua errada nele. O JOIN de criterios ainda filtra pela tecnologia, para o
-- vinculo nao depender so do texto do titulo.
--
-- Detalhe de escrita: nenhum template usa literal de caractere em Java, porque a aspa simples
-- precisaria ser escapada dentro do literal de string do SQL e o arquivo ficaria ilegivel.
-- Onde a solucao pediria um char, o enunciado aceita String.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'ESTAGIO', 'ALGORITMO_EASY', v.tempo, v.template, t.id
FROM (VALUES

('Somar os Elementos do Array (Java)',
 'Escreva o metodo somar(int[] numeros) que devolve a soma de todos os elementos do array.',
 'E o primeiro laco que todo backend escreve: totalizar uma coluna antes de mostrar num relatorio. Em Java o detalhe extra e o array nulo, que chega quando a camada de cima nao inicializou a lista e derruba tudo com NullPointerException.',
 'Um array de inteiros, que pode estar vazio ou ser nulo.',
 'Um int com a soma. Array vazio ou nulo devolve 0.',
 'Entrada: [1, 2, 3]
Saida: 6

Entrada: null
Saida: 0',
 'Array nulo nao pode lancar NullPointerException. Nao leia nada do teclado.',
 20,
 'public class Solucao {
    public int somar(int[] numeros) {
        // TODO: implementar
        return 0;
    }
}'),

('Media do Array (Java)',
 'Escreva o metodo media(int[] notas) que devolve a media aritmetica dos valores.',
 'Boletim, tempo medio de atendimento e ticket medio saem dessa conta. O que separa quem passa e o array vazio: dividir por zero com inteiros lanca ArithmeticException, e com double devolve NaN. Os dois quebram a tela.',
 'Um array de inteiros, que pode estar vazio.',
 'Um double com a media. Array vazio devolve 0.',
 'Entrada: [8, 6, 10]
Saida: 8.0

Entrada: []
Saida: 0.0',
 'Array vazio devolve 0 sem lancar excecao. Cuidado com a divisao inteira: 7/2 em int da 3, nao 3.5.',
 20,
 'public class Solucao {
    public double media(int[] notas) {
        // TODO: implementar
        return 0;
    }
}'),

('Contar Vogais da Frase (Java)',
 'Escreva o metodo contarVogais(String texto) que devolve quantas vogais o texto tem.',
 'Validador de apelido e contador de caracteres passam por aqui. Em Java a questao ainda cobra o basico de String: percorrer com charAt ou toCharArray, e normalizar a caixa antes de comparar.',
 'Uma String que pode estar vazia, ser nula ou misturar maiusculas e minusculas.',
 'Um int com a quantidade de vogais. Texto vazio ou nulo devolve 0.',
 'Entrada: "Banana Azeda"
Saida: 6',
 'Considere apenas a, e, i, o, u. Texto nulo devolve 0 sem lancar excecao.',
 20,
 'public class Solucao {
    public int contarVogais(String texto) {
        // TODO: implementar
        return 0;
    }
}'),

('Inverter a String (Java)',
 'Escreva o metodo inverter(String texto) que devolve o texto de tras para frente.',
 'Aparece em normalizacao de codigo de barras e em exercicio de manipulacao de String. Em Java a conversa util e sobre String ser imutavel: concatenar dentro de laco cria um objeto novo a cada volta, e por isso existe StringBuilder.',
 'Uma String que pode estar vazia ou ser nula.',
 'Uma String invertida. Texto nulo devolve string vazia.',
 'Entrada: "java"
Saida: "avaj"',
 'Texto nulo devolve string vazia. Nao use o metodo reverse de StringBuilder: percorra o texto.',
 20,
 'public class Solucao {
    public String inverter(String texto) {
        // TODO: implementar
        return "";
    }
}'),

('Verificar Palindromo (Java)',
 'Escreva o metodo ehPalindromo(String texto) que diz se o texto se le igual nos dois sentidos.',
 'Serve para conversar sobre normalizacao antes de comparar. O texto real vem com espaco, acento e maiuscula, e comparar sem limpar reprova frases que sao palindromo de verdade.',
 'Uma String que pode conter espacos, pontuacao e maiusculas.',
 'true se for palindromo, false caso contrario. Texto vazio ou nulo devolve true.',
 'Entrada: "Ame a ema"
Saida: true

Entrada: "java"
Saida: false',
 'Ignore espacos, pontuacao e diferenca de maiusculas. Devolva boolean, nao String.',
 25,
 'public class Solucao {
    public boolean ehPalindromo(String texto) {
        // TODO: implementar
        return false;
    }
}'),

('Maior Elemento do Array (Java)',
 'Escreva o metodo maior(int[] numeros) que devolve o maior valor do array.',
 'Pico de acesso, maior venda e limite de uso saem daqui. A armadilha e inicializar a variavel com 0: se todos os numeros forem negativos, o metodo devolve 0, que nem esta no array.',
 'Um array de inteiros com pelo menos um elemento.',
 'Um int com o maior valor.',
 'Entrada: [-5, -2, -9]
Saida: -2',
 'Nao inicialize com 0: use o primeiro elemento do array. Nao use Arrays.stream.',
 20,
 'public class Solucao {
    public int maior(int[] numeros) {
        // TODO: implementar
        return 0;
    }
}'),

('FizzBuzz em Java (Java)',
 'Escreva o metodo fizzBuzz(int n) que devolve uma lista de 1 ate n trocando multiplos de 3 por Fizz, de 5 por Buzz e de ambos por FizzBuzz.',
 'E o filtro mais aplicado do mercado, e o que ele revela e a ordem dos testes: quem checa 3 antes de checar 15 nunca produz FizzBuzz. O bug passa despercebido ate alguem olhar a linha do numero 15.',
 'Um int n maior ou igual a 1.',
 'Uma List<String> com n elementos, com os numeros convertidos para texto quando nao forem multiplos.',
 'Entrada: 5
Saida: ["1", "2", "Fizz", "4", "Buzz"]',
 'Teste o caso de multiplo de 3 e 5 antes dos casos separados. Devolva a lista, nao imprima.',
 25,
 'import java.util.*;

public class Solucao {
    public List<String> fizzBuzz(int n) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Fatorial com Laco (Java)',
 'Escreva o metodo fatorial(int n) que devolve o fatorial de n.',
 'Classico para falar de acumulador e de caso base. Em Java entra um detalhe a mais: o fatorial estoura o int rapido, e por isso o retorno e long. Perceber isso sozinho conta pontos na entrevista.',
 'Um int maior ou igual a 0.',
 'Um long com o fatorial. O fatorial de 0 e de 1 e 1.',
 'Entrada: 5
Saida: 120

Entrada: 0
Saida: 1',
 'Trate o caso de n igual a 0. Use laco, nao recursao.',
 20,
 'public class Solucao {
    public long fatorial(int n) {
        // TODO: implementar
        return 1;
    }
}'),

('Verificar Numero Primo (Java)',
 'Escreva o metodo ehPrimo(int numero) que diz se o numero e primo.',
 'Mede nocao de laco com condicao de parada. Testar todos os divisores funciona, e a pergunta seguinte do entrevistador e sempre por que parar na raiz quadrada resolve igual em muito menos passos.',
 'Um int que pode ser negativo, zero ou positivo.',
 'true se for primo, false caso contrario. Numeros menores que 2 nao sao primos.',
 'Entrada: 7
Saida: true

Entrada: 1
Saida: false',
 'Trate 0, 1 e negativos como nao primos. Nao use BigInteger.',
 25,
 'public class Solucao {
    public boolean ehPrimo(int numero) {
        // TODO: implementar
        return false;
    }
}'),

('Contar Palavras do Texto (Java)',
 'Escreva o metodo contarPalavras(String frase) que devolve quantas palavras a frase tem.',
 'Campo com limite de palavras existe em todo formulario. O usuario digita dois espacos entre as palavras, e o split ingenuo conta pedaco vazio como palavra, inflando o numero.',
 'Uma String que pode ter espacos extras no comeco, no fim e no meio. Pode estar vazia ou ser nula.',
 'Um int com a quantidade de palavras. Texto vazio, nulo ou so com espacos devolve 0.',
 'Entrada: "  ola   mundo bonito "
Saida: 3',
 'Espacos repetidos nao podem contar como palavra a mais. Texto nulo devolve 0.',
 20,
 'public class Solucao {
    public int contarPalavras(String frase) {
        // TODO: implementar
        return 0;
    }
}'),

('Somar Apenas os Pares (Java)',
 'Escreva o metodo somarPares(int[] numeros) que soma somente os numeros pares do array.',
 'Somar um subconjunto e o que todo relatorio faz: so os pedidos aprovados, so os boletos vencidos. A estrutura do codigo e sempre a mesma, percorrer, testar a condicao e acumular.',
 'Um array de inteiros, possivelmente vazio, podendo conter negativos.',
 'Um int com a soma dos pares. Sem pares, devolve 0.',
 'Entrada: [1, 2, 3, 4, 10]
Saida: 16',
 'Zero e par. Pares negativos tambem entram na soma.',
 20,
 'public class Solucao {
    public int somarPares(int[] numeros) {
        // TODO: implementar
        return 0;
    }
}'),

('Gerar a Tabuada (Java)',
 'Escreva o metodo tabuada(int numero) que devolve um array com a tabuada de 1 a 10 do numero.',
 'Gerar sequencia calculada e o que esta por tras de parcelamento e projecao. A questao troca a regra financeira por multiplicacao simples para focar no laco e no preenchimento do array por indice.',
 'Um int que pode ser negativo ou zero.',
 'Um int[] com 10 posicoes, do numero vezes 1 ate o numero vezes 10.',
 'Entrada: 3
Saida: [3, 6, 9, 12, 15, 18, 21, 24, 27, 30]',
 'O array tem exatamente 10 posicoes. Devolva o array, nao imprima na tela.',
 20,
 'public class Solucao {
    public int[] tabuada(int numero) {
        // TODO: implementar
        return new int[10];
    }
}'),

('Ano Bissexto (Java)',
 'Escreva o metodo ehBissexto(int ano) que diz se o ano e bissexto.',
 'Calculo de vencimento, ferias e juros esbarra nisso. A regra tem tres partes e quase todo mundo lembra so da primeira: divisivel por 4, mas nao por 100, a nao ser que tambem seja por 400.',
 'Um int com o ano, sempre positivo.',
 'true se for bissexto, false caso contrario.',
 'Entrada: 2024
Saida: true

Entrada: 1900
Saida: false',
 'A regra do 400 precisa estar contemplada: 2000 e bissexto e 1900 nao e. Nao use a API de datas.',
 20,
 'public class Solucao {
    public boolean ehBissexto(int ano) {
        // TODO: implementar
        return false;
    }
}'),

('Converter Temperatura (Java)',
 'Escreva o metodo paraFahrenheit(double celsius) que converte a temperatura para Fahrenheit.',
 'Conversao de unidade e a tarefa mais comum de integracao entre sistemas. O que se avalia e ler a formula com atencao: trocar a ordem das operacoes devolve um numero plausivel e errado, que passa por revisao sem ninguem notar.',
 'Um double que pode ser negativo.',
 'Um double com a temperatura em Fahrenheit.',
 'Entrada: 25.0
Saida: 77.0

Entrada: -40.0
Saida: -40.0',
 'A formula e celsius vezes 9/5 mais 32. Cuidado com a divisao inteira ao escrever 9/5.',
 20,
 'public class Solucao {
    public double paraFahrenheit(double celsius) {
        // TODO: implementar
        return 0;
    }
}'),

('Classificar o IMC (Java)',
 'Escreva o metodo classificarImc(double peso, double altura) que calcula o IMC e devolve a faixa.',
 'Aplicativo de saude mostra a faixa, nao o numero cru. A questao junta formula com cadeia de faixas, e o erro tipico e sobrepor os limites, classificando errado justamente quem esta na fronteira.',
 'peso em quilos e altura em metros, ambos maiores que 0.',
 'Uma String com a faixa: "abaixo" para IMC menor que 18.5, "normal" ate 24.9, "sobrepeso" ate 29.9 e "obesidade" de 30 em diante.',
 'Entrada: peso=70.0, altura=1.75
Saida: "normal"',
 'O IMC e peso dividido pela altura ao quadrado. As faixas nao podem se sobrepor.',
 25,
 'public class Solucao {
    public String classificarImc(double peso, double altura) {
        // TODO: implementar
        return "";
    }
}'),

('Frete por Faixa de Compra (Java)',
 'Escreva o metodo calcularFrete(double valorCompra) que devolve o frete conforme a faixa.',
 'Frete gratis acima de um valor existe em toda loja, e a fronteira e onde mora o bug. Quem escreve maior em vez de maior ou igual cobra frete de quem comprou exatamente o valor da promocao, e isso vira reclamacao no suporte.',
 'Um double maior ou igual a 0.',
 'Um double com o frete: 0 para compras de 200 ou mais, 15 para compras de 100 ate 199.99 e 25 abaixo de 100.',
 'Entrada: 200.0
Saida: 0.0

Entrada: 199.99
Saida: 15.0',
 'Compra de exatamente 200 tem frete gratis. As faixas nao podem se sobrepor.',
 20,
 'public class Solucao {
    public double calcularFrete(double valorCompra) {
        // TODO: implementar
        return 0;
    }
}'),

('Troco em Notas (Java)',
 'Escreva o metodo troco(int valor) que devolve quantas notas de 100, 50, 20 e 10 formam o valor.',
 'Caixa eletronico resolve isso o dia inteiro. E o primeiro contato com algoritmo guloso: pegar sempre a maior nota possivel antes de descer. Quem faz na ordem inversa entrega o troco em dezenas de notas de 10.',
 'Um int multiplo de 10, maior ou igual a 0.',
 'Um Map<Integer, Integer> com as chaves 100, 50, 20 e 10 e a quantidade de cada nota.',
 'Entrada: 180
Saida: {100=1, 50=1, 20=1, 10=1}',
 'Use sempre a maior nota possivel primeiro, para o total de notas ser o menor possivel.',
 25,
 'import java.util.*;

public class Solucao {
    public Map<Integer, Integer> troco(int valor) {
        // TODO: implementar
        return new LinkedHashMap<>();
    }
}'),

('Iniciais do Nome (Java)',
 'Escreva o metodo sigla(String nome) que devolve as iniciais do nome em maiuscula.',
 'Avatar sem foto mostra as iniciais, e sistema de protocolo gera codigo a partir do nome. Exercicio curto que revela se a pessoa sabe combinar split, indexacao de String e StringBuilder.',
 'Uma String com o nome completo, podendo ter espacos extras. Pode estar vazia ou ser nula.',
 'Uma String com a inicial de cada palavra, em maiuscula, sem separador. Nome vazio ou nulo devolve string vazia.',
 'Entrada: "maria clara souza"
Saida: "MCS"',
 'Espacos extras nao podem gerar inicial vazia. Nome nulo devolve string vazia.',
 20,
 'public class Solucao {
    public String sigla(String nome) {
        // TODO: implementar
        return "";
    }
}'),

('Capitalizar Cada Palavra (Java)',
 'Escreva o metodo capitalizar(String frase) que deixa a primeira letra de cada palavra em maiuscula e o resto em minuscula.',
 'Nome de cliente digitado em caixa alta vira nota fiscal feia e busca que nao encontra ninguem. Normalizar antes de gravar e regra basica de cadastro.',
 'Uma String com palavras separadas por espaco, podendo vir toda em maiuscula. Pode ser nula.',
 'Uma String com cada palavra capitalizada. Frase nula ou vazia devolve string vazia.',
 'Entrada: "maria DA silva"
Saida: "Maria Da Silva"',
 'O restante de cada palavra fica em minuscula. Frase nula devolve string vazia.',
 25,
 'public class Solucao {
    public String capitalizar(String frase) {
        // TODO: implementar
        return "";
    }
}'),

('Remover Espacos Extras (Java)',
 'Escreva o metodo limparEspacos(String texto) que remove espacos das pontas e reduz os do meio a um so.',
 'Dado digitado por usuario chega sujo, e espaco invisivel no fim do campo e a causa numero um de busca que nao encontra o registro. Limpar antes de gravar evita chamado de suporte.',
 'Uma String com espacos no comeco, no fim e repetidos no meio. Pode ser nula.',
 'Uma String limpa. Texto nulo ou so com espacos devolve string vazia.',
 'Entrada: "   ola    mundo   "
Saida: "ola mundo"',
 'Texto nulo devolve string vazia. Nao use String.join com stream.',
 20,
 'public class Solucao {
    public String limparEspacos(String texto) {
        // TODO: implementar
        return "";
    }
}'),

('Maior Palavra da Frase (Java)',
 'Escreva o metodo maiorPalavra(String frase) que devolve a palavra mais longa.',
 'Serve para dimensionar coluna de relatorio e truncar texto sem cortar palavra no meio. O caso de borda que o entrevistador testa e o empate entre duas palavras do mesmo tamanho.',
 'Uma String com palavras separadas por espaco. Pode estar vazia ou ser nula.',
 'A palavra mais longa. No empate, a primeira. Frase vazia ou nula devolve string vazia.',
 'Entrada: "o rato roeu a roupa"
Saida: "roupa"',
 'No empate vence a primeira palavra. Frase nula devolve string vazia.',
 20,
 'public class Solucao {
    public String maiorPalavra(String frase) {
        // TODO: implementar
        return "";
    }
}'),

('Segundo Maior do Array (Java)',
 'Escreva o metodo segundoMaior(int[] numeros) que devolve o segundo maior valor distinto.',
 'Ranking de vendedores precisa do segundo lugar, e ele nao e simplesmente o penultimo do array ordenado quando ha empate no topo. E ai que a maioria das solucoes falha.',
 'Um array de inteiros com pelo menos dois valores distintos.',
 'Um int com o segundo maior valor distinto.',
 'Entrada: [10, 8, 10, 7]
Saida: 8',
 'Valores repetidos no topo nao podem virar segundo lugar. Nao use Arrays.sort.',
 25,
 'public class Solucao {
    public int segundoMaior(int[] numeros) {
        // TODO: implementar
        return 0;
    }
}'),

('Remover Duplicados da Lista (Java)',
 'Escreva o metodo removerDuplicados(List<String> itens) que devolve uma nova lista sem repeticoes, mantendo a ordem.',
 'Lista de e-mails para disparo e historico de busca precisam ser desduplicados sem baguncar a ordem. Em Java a conversa e sobre qual Set escolher: HashSet perde a ordem, LinkedHashSet mantem.',
 'Uma List<String>, possivelmente vazia.',
 'Uma nova lista sem duplicatas, na ordem da primeira ocorrencia. A lista original nao pode ser alterada.',
 'Entrada: ["b", "a", "b", "c"]
Saida: ["b", "a", "c"]',
 'A ordem importa. Nao altere a lista recebida.',
 25,
 'import java.util.*;

public class Solucao {
    public List<String> removerDuplicados(List<String> itens) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Contar Ocorrencias com Map (Java)',
 'Escreva o metodo frequencia(List<String> itens) que devolve quantas vezes cada item aparece.',
 'Contar ocorrencia e a base de qualquer relatorio: pedidos por status, acessos por pagina. Em Java o padrao aparece o tempo todo, e conhecer getOrDefault ou merge economiza cinco linhas de if.',
 'Uma List<String>, possivelmente vazia.',
 'Um Map<String, Integer> com o item e a contagem. Lista vazia devolve mapa vazio.',
 'Entrada: ["a", "b", "a"]
Saida: {a=2, b=1}',
 'Somar direto numa chave inexistente nao pode lancar excecao. Nao use Collectors.groupingBy.',
 25,
 'import java.util.*;

public class Solucao {
    public Map<String, Integer> frequencia(List<String> itens) {
        // TODO: implementar
        return new HashMap<>();
    }
}'),

('Somar os Digitos do Numero (Java)',
 'Escreva o metodo somarDigitos(int numero) que soma os algarismos do numero.',
 'E o primeiro passo de qualquer validacao de documento, onde o digito verificador nasce de uma soma de algarismos. Mostra tambem se a pessoa sabe usar resto e divisao inteira em vez de converter tudo para texto.',
 'Um int positivo.',
 'Um int com a soma dos algarismos.',
 'Entrada: 1234
Saida: 10',
 'Resolva com operacoes numericas, sem converter o numero para String.',
 20,
 'public class Solucao {
    public int somarDigitos(int numero) {
        // TODO: implementar
        return 0;
    }
}'),

('Total do Carrinho (Java)',
 'Escreva o metodo total(List<int[]> itens) que soma preco vezes quantidade de cada item.',
 'Toda tela de e-commerce mostra um subtotal antes do pagamento. O erro que aparece em teste e somar so o preco unitario e ignorar a quantidade, o que passa despercebido enquanto todo mundo compra uma unidade de cada.',
 'Uma List<int[]> em que cada array tem duas posicoes: preco na posicao 0 e quantidade na posicao 1. Pode vir vazia.',
 'Um int com o total. Lista vazia devolve 0.',
 'Entrada: [[10, 2], [5, 4]]
Saida: 40',
 'A quantidade precisa entrar na conta. Nao leia nada do teclado.',
 20,
 'import java.util.*;

public class Solucao {
    public int total(List<int[]> itens) {
        // TODO: implementar
        return 0;
    }
}'),

('Filtrar Maiores de Idade (Java)',
 'Escreva o metodo maioresDeIdade(Map<String, Integer> pessoas) que devolve os nomes de quem tem 18 anos ou mais.',
 'Regra com corte por valor aparece em cadastro, credito e liberacao de conteudo. O detalhe que derruba candidato e o "ou mais": quem usa apenas maior que corta indevidamente quem tem exatamente 18.',
 'Um Map<String, Integer> com nome e idade. Pode vir vazio.',
 'Uma List<String> com os nomes. Ninguem elegivel devolve lista vazia.',
 'Entrada: {ana=17, bia=18}
Saida: ["bia"]',
 'Quem tem exatamente 18 entra no resultado. Devolva apenas os nomes.',
 20,
 'import java.util.*;

public class Solucao {
    public List<String> maioresDeIdade(Map<String, Integer> pessoas) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Aplicar Desconto (Java)',
 'Escreva o metodo aplicarDesconto(double preco, int percentual) que devolve o preco com o desconto aplicado.',
 'Cupom e promocao passam por essa conta em toda loja. O erro comum e dividir por 100 no lugar errado e devolver um preco maior que o original, o que so aparece quando o cliente reclama.',
 'preco: double positivo. percentual: int de 0 a 100.',
 'Um double com o preco final. Percentual fora da faixa de 0 a 100 devolve o preco original.',
 'Entrada: preco=200.0, percentual=25
Saida: 150.0',
 'Percentual fora de 0 a 100 devolve o preco original, sem calcular. Cuidado com a divisao inteira.',
 20,
 'public class Solucao {
    public double aplicarDesconto(double preco, int percentual) {
        // TODO: implementar
        return preco;
    }
}'),

('Contar Aprovados e Reprovados (Java)',
 'Escreva o metodo contarSituacao(double[] notas) que devolve um array com a quantidade de aprovados e de reprovados.',
 'Fechamento de turma sempre termina em duas contagens que precisam somar o total. Se o candidato usa um contador so e deduz o outro por subtracao, a solucao quebra quando surge uma terceira situacao.',
 'Um array de doubles de 0 a 10, possivelmente vazio.',
 'Um int[] de duas posicoes: aprovados na posicao 0 e reprovados na 1. Aprovado e nota maior ou igual a 6.',
 'Entrada: [10, 5.5, 6, 3]
Saida: [2, 2]',
 'Nota exatamente 6 conta como aprovado. Conte os dois grupos de verdade.',
 20,
 'public class Solucao {
    public int[] contarSituacao(double[] notas) {
        // TODO: implementar
        return new int[2];
    }
}'),

('Somar Numeros em Texto (Java)',
 'Escreva o metodo somarTexto(String[] valores) que soma numeros que chegaram como texto.',
 'Arquivo CSV e formulario web entregam tudo como String, e a soma direta concatena em vez de somar. Converter antes de calcular e o primeiro cuidado de qualquer rotina de importacao.',
 'Um array de Strings, cada uma representando um inteiro. Pode estar vazio.',
 'Um int com a soma. Array vazio devolve 0.',
 'Entrada: ["10", "5", "-3"]
Saida: 12',
 'A soma precisa ser numerica, nao concatenacao de texto.',
 20,
 'public class Solucao {
    public int somarTexto(String[] valores) {
        // TODO: implementar
        return 0;
    }
}'),

('Formatar Duracao (Java)',
 'Escreva o metodo formatarDuracao(int minutos) que devolve a duracao no formato XhYY.',
 'Toda tela que mostra tempo gasto faz essa conversao: chamado aberto ha 145 minutos vira 2h25. O que separa a solucao pronta da meia-pronta e o zero a esquerda: 2h5 esta errado, o certo e 2h05.',
 'Um int maior ou igual a 0.',
 'Uma String no formato XhYY, com os minutos sempre em duas casas.',
 'Entrada: 145
Saida: "2h25"

Entrada: 65
Saida: "1h05"',
 'Os minutos precisam ter duas casas, com zero a esquerda quando necessario.',
 25,
 'public class Solucao {
    public String formatarDuracao(int minutos) {
        // TODO: implementar
        return "";
    }
}'),

('Verificar Array Ordenado (Java)',
 'Escreva o metodo estaOrdenado(int[] numeros) que diz se o array esta em ordem crescente.',
 'Checar ordenacao antes de aplicar busca binaria, ou validar que um arquivo chegou na ordem combinada, e tarefa real de integracao. O caminho eficiente compara vizinhos, sem ordenar nada.',
 'Um array de inteiros, possivelmente vazio ou com um unico elemento.',
 'true se cada elemento for menor ou igual ao seguinte. Array vazio ou com um elemento devolve true.',
 'Entrada: [1, 2, 2, 5]
Saida: true

Entrada: [3, 1]
Saida: false',
 'Elementos iguais lado a lado continuam ordenados. Nao ordene o array para comparar.',
 25,
 'public class Solucao {
    public boolean estaOrdenado(int[] numeros) {
        // TODO: implementar
        return false;
    }
}'),

('Buscar a Posicao no Array (Java)',
 'Escreva o metodo posicao(int[] numeros, int alvo) que devolve o indice da primeira ocorrencia do alvo.',
 'Busca linear e a base de qualquer filtro antes de existir indice no banco. O que a questao cobra e o retorno quando nada e encontrado: devolver 0 confunde com a primeira posicao e gera bug silencioso.',
 'numeros: array de inteiros, possivelmente vazio. alvo: o inteiro procurado.',
 'O indice da primeira ocorrencia, comecando em 0. Devolve -1 quando o alvo nao existe.',
 'Entrada: [4, 7, 9], alvo=9
Saida: 2

Entrada: [4], alvo=1
Saida: -1',
 'Devolva -1 quando nao encontrar. Nao use Arrays.binarySearch.',
 20,
 'public class Solucao {
    public int posicao(int[] numeros, int alvo) {
        // TODO: implementar
        return -1;
    }
}'),

('Verificar Anagrama (Java)',
 'Escreva o metodo saoAnagramas(String primeira, String segunda) que diz se as palavras usam as mesmas letras.',
 'Detectar nome duplicado com letras trocadas e um caso real de deduplicacao de cadastro. A solucao direta ordena as letras das duas e compara, e a conversa seguinte e sobre o custo dessa ordenacao.',
 'Duas Strings que podem ter maiusculas e espacos.',
 'true se forem anagramas, false caso contrario.',
 'Entrada: "Amor", "Roma"
Saida: true

Entrada: "casa", "asas"
Saida: false',
 'Ignore espacos e diferenca de maiusculas. Palavras de tamanhos diferentes nunca sao anagramas.',
 25,
 'public class Solucao {
    public boolean saoAnagramas(String primeira, String segunda) {
        // TODO: implementar
        return false;
    }
}'),

('Percentual de Tarefas Concluidas (Java)',
 'Escreva o metodo percentualConcluido(boolean[] tarefas) que devolve o percentual de tarefas ja concluidas.',
 'Barra de progresso de projeto sai desse calculo. O caso que derruba e a lista sem tarefa nenhuma: dividir por zero para a tela inteira, quando o certo e mostrar 0 por cento.',
 'Um array de booleanos, possivelmente vazio.',
 'Um double de 0 a 100 com o percentual. Array vazio devolve 0.',
 'Entrada: [true, false, true]
Saida: 66.66666666666667',
 'Array vazio devolve 0 sem lancar excecao. Cuidado com a divisao inteira antes de multiplicar por 100.',
 25,
 'public class Solucao {
    public double percentualConcluido(boolean[] tarefas) {
        // TODO: implementar
        return 0;
    }
}'),

('Todos os Numeros Positivos (Java)',
 'Escreva o metodo todosPositivos(int[] numeros) que diz se todos os valores sao maiores que zero.',
 'Validacao de lote antes de gravar: nenhum item pode ter quantidade negativa. O ganho de quem sabe o que faz e sair do laco na primeira falha, sem varrer o resto a toa.',
 'Um array de inteiros, possivelmente vazio.',
 'true se todos forem maiores que zero. Array vazio devolve true.',
 'Entrada: [1, 5, 3]
Saida: true

Entrada: [1, 0]
Saida: false',
 'Zero nao e positivo. Array vazio devolve true.',
 20,
 'public class Solucao {
    public boolean todosPositivos(int[] numeros) {
        // TODO: implementar
        return false;
    }
}'),

('Somar os Valores do Mapa (Java)',
 'Escreva o metodo somarValores(Map<String, Integer> estoque) que soma todos os valores do mapa.',
 'Fechamento de estoque e total de horas por projeto caem nesse padrao. O ponto avaliado e saber que o Map tem tres formas de ser percorrido, e que aqui so os valores interessam.',
 'Um Map<String, Integer>, possivelmente vazio.',
 'Um int com a soma dos valores. Mapa vazio devolve 0.',
 'Entrada: {teclado=3, mouse=7}
Saida: 10',
 'Percorra os valores, nao as chaves. Nao use stream.',
 20,
 'import java.util.*;

public class Solucao {
    public int somarValores(Map<String, Integer> estoque) {
        // TODO: implementar
        return 0;
    }
}'),

('Itens Acima da Media (Java)',
 'Escreva o metodo acimaDaMedia(int[] numeros) que devolve os valores maiores que a media do array.',
 'Relatorio de desempenho destaca quem esta acima da media do time. A pegadinha e recalcular a media dentro do laco: ela precisa ser calculada uma unica vez, antes de comparar, senao o custo explode sem necessidade.',
 'Um array de inteiros, possivelmente vazio.',
 'Uma List<Integer> com os valores maiores que a media, na ordem original. Array vazio devolve lista vazia.',
 'Entrada: [2, 4, 6]
Saida: [6]',
 'Calcule a media uma unica vez, fora do laco. Array vazio nao pode dividir por zero.',
 25,
 'import java.util.*;

public class Solucao {
    public List<Integer> acimaDaMedia(int[] numeros) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Inverter a Ordem das Palavras (Java)',
 'Escreva o metodo inverterPalavras(String frase) que devolve a frase com as palavras na ordem inversa.',
 'Aparece em tratamento de nome completo e em normalizacao de endereco, onde a ordem dos pedacos muda conforme o pais. Avalia separar, reordenar e remontar sem deixar espaco sobrando.',
 'Uma String com palavras separadas por espaco, podendo ter espacos extras. Pode ser nula.',
 'Uma String com as palavras invertidas, separadas por um unico espaco. Frase nula devolve string vazia.',
 'Entrada: "o rato roeu a roupa"
Saida: "roupa a roeu rato o"',
 'A saida nao pode ter espaco duplicado nem nas pontas. Inverta a ordem das palavras, nao as letras.',
 25,
 'public class Solucao {
    public String inverterPalavras(String frase) {
        // TODO: implementar
        return "";
    }
}'),

('Interseccao de Duas Listas (Java)',
 'Escreva o metodo emComum(List<String> primeira, List<String> segunda) que devolve os elementos presentes nas duas.',
 'Comparar dois conjuntos e rotina de conciliacao: quais clientes estao nas duas campanhas, quais produtos vem dos dois fornecedores. O detalhe e nao deixar item repetido vazar para o resultado.',
 'Duas List<String>, ambas possivelmente vazias.',
 'Uma List<String> com os elementos comuns, sem repeticao, na ordem da primeira lista.',
 'Entrada: ["a", "b", "b", "c"], ["b", "c", "d"]
Saida: ["b", "c"]',
 'O resultado nao pode ter itens repetidos. A ordem segue a primeira lista.',
 25,
 'import java.util.*;

public class Solucao {
    public List<String> emComum(List<String> primeira, List<String> segunda) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Dividir a Lista em Blocos (Java)',
 'Escreva o metodo dividirEmBlocos(List<Integer> itens, int tamanho) que quebra a lista em pedacos.',
 'Envio em lote e o caso classico: a API aceita 100 registros por chamada e voce tem 250. O ultimo bloco quase sempre vem incompleto, e e ele que quebra a solucao de quem assume divisao exata.',
 'itens: uma List<Integer>, possivelmente vazia. tamanho: int maior que 0.',
 'Uma List<List<Integer>>. O ultimo bloco pode ter menos elementos. Lista vazia devolve lista vazia.',
 'Entrada: [1,2,3,4,5], tamanho=2
Saida: [[1, 2], [3, 4], [5]]',
 'Nenhum elemento pode ser perdido nem duplicado. O ultimo bloco nao pode estourar o fim da lista.',
 30,
 'import java.util.*;

public class Solucao {
    public List<List<Integer>> dividirEmBlocos(List<Integer> itens, int tamanho) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Fibonacci ate N Termos (Java)',
 'Escreva o metodo fibonacci(int n) que devolve os n primeiros termos da sequencia, comecando em 0 e 1.',
 'A sequencia aparece pouco em producao, mas o padrao dela aparece muito: cada resultado depende dos dois anteriores, igual a saldo acumulado. O erro comum e perder o valor antigo ao atualizar as variaveis na ordem errada.',
 'Um int n maior ou igual a 0.',
 'Uma List<Long> com n elementos. n igual a 0 devolve lista vazia.',
 'Entrada: 6
Saida: [0, 1, 1, 2, 3, 5]',
 'A sequencia comeca em 0 e 1. Use laco, nao recursao.',
 25,
 'import java.util.*;

public class Solucao {
    public List<Long> fibonacci(int n) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Validar Senha Forte (Java)',
 'Escreva o metodo senhaForte(String senha) que verifica se a senha atende as regras minimas.',
 'Toda tela de cadastro valida senha, e a validacao mal escrita aceita tudo ou rejeita tudo. A pessoa precisa combinar varias condicoes sem esquecer nenhuma, que e o mesmo raciocinio de qualquer regra de negocio composta.',
 'Uma String que pode estar vazia ou ser nula.',
 'true se tiver ao menos 8 caracteres, uma maiuscula, uma minuscula e um digito. Senha nula devolve false.',
 'Entrada: "Senha123"
Saida: true

Entrada: "senha123"
Saida: false',
 'As quatro regras precisam valer ao mesmo tempo. Senha nula devolve false.',
 25,
 'public class Solucao {
    public boolean senhaForte(String senha) {
        // TODO: implementar
        return false;
    }
}'),

('Contar Tipos de Caractere (Java)',
 'Escreva o metodo contarTipos(String texto) que conta letras, digitos e outros caracteres.',
 'Analisar o conteudo de um campo antes de validar aparece em importacao de dados e em regra de senha. Avalia conhecer os utilitarios de Character em vez de comparar codigo de caractere na mao.',
 'Uma String que pode conter letras, numeros, espacos e pontuacao. Pode ser nula.',
 'Um int[] de tres posicoes: letras, digitos e outros, nessa ordem. Texto nulo devolve tudo zerado.',
 'Entrada: "ab 12!"
Saida: [2, 2, 2]',
 'Espaco conta como outros. Cada caractere entra em exatamente uma categoria.',
 25,
 'public class Solucao {
    public int[] contarTipos(String texto) {
        // TODO: implementar
        return new int[3];
    }
}'),

('Repetir Texto com Separador (Java)',
 'Escreva o metodo repetir(String texto, int vezes) que repete o texto separado por virgula e espaco.',
 'Montar clausula IN de uma consulta, ou lista de destinatarios, precisa de separador entre os itens e nunca no fim. O separador sobrando no final e um dos erros mais comuns de montagem de String.',
 'texto: uma String. vezes: int maior ou igual a 0.',
 'Uma String com o texto repetido, separado por virgula e espaco, sem separador no fim. vezes igual a 0 devolve string vazia.',
 'Entrada: texto="ola", vezes=3
Saida: "ola, ola, ola"',
 'Nao pode sobrar virgula no final. vezes igual a 0 devolve string vazia.',
 20,
 'public class Solucao {
    public String repetir(String texto, int vezes) {
        // TODO: implementar
        return "";
    }
}'),

('Media por Materia (Java)',
 'Escreva o metodo mediaPorMateria(Map<String, List<Double>> boletim) que devolve a media de cada materia.',
 'Boletim, relatorio por filial e consumo por servidor tem a mesma forma: uma chave apontando para varias medicoes. Percorrer mapa de listas e passo obrigatorio antes de qualquer relatorio agregado.',
 'Um Map<String, List<Double>> com a materia e suas notas. Alguma lista pode vir vazia.',
 'Um Map<String, Double> com a materia e a media. Materia sem nota tem media 0.',
 'Entrada: {matematica=[8.0, 6.0], historia=[]}
Saida: {matematica=7.0, historia=0.0}',
 'Materia com lista vazia nao pode causar divisao por zero.',
 30,
 'import java.util.*;

public class Solucao {
    public Map<String, Double> mediaPorMateria(Map<String, List<Double>> boletim) {
        // TODO: implementar
        return new HashMap<>();
    }
}'),

('Item Mais Frequente (Java)',
 'Escreva o metodo maisFrequente(List<String> itens) que devolve o item que mais aparece.',
 'Produto mais vendido, erro mais comum no log, pagina mais acessada: todos saem dessa contagem seguida de um maximo. Junta Map e comparacao numa tarefa so.',
 'Uma List<String> com pelo menos um elemento.',
 'O item que mais aparece. No empate, o que apareceu primeiro na lista.',
 'Entrada: ["a", "b", "a", "b", "a"]
Saida: "a"',
 'No empate vence quem apareceu primeiro. Nao use Collectors.groupingBy.',
 30,
 'import java.util.*;

public class Solucao {
    public String maisFrequente(List<String> itens) {
        // TODO: implementar
        return "";
    }
}'),

('Ordenar Nomes Ignorando a Caixa (Java)',
 'Escreva o metodo ordenarNomes(List<String> nomes) que devolve os nomes em ordem alfabetica, ignorando maiusculas.',
 'Lista de participantes e catalogo de produtos precisam sair ordenados. O erro que aparece na entrevista e ordenar sem normalizar: em Java, maiuscula tem codigo menor, entao "bruno" viria depois de "Ana" por acaso e "ana" viria por ultimo.',
 'Uma List<String> que pode misturar maiusculas e minusculas. Pode vir vazia.',
 'Uma nova lista ordenada alfabeticamente ignorando a caixa. Os nomes saem como entraram e a lista original nao pode ser alterada.',
 'Entrada: ["bruno", "Ana", "carla"]
Saida: ["Ana", "bruno", "carla"]',
 'A comparacao ignora a caixa, mas o nome sai do jeito que entrou. Nao altere a lista recebida.',
 25,
 'import java.util.*;

public class Solucao {
    public List<String> ordenarNomes(List<String> nomes) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Achatar Lista de Listas (Java)',
 'Escreva o metodo achatar(List<List<Integer>> listas) que junta tudo numa lista so, preservando a ordem.',
 'Resposta de API paginada chega assim: uma lista de paginas, cada pagina com sua lista de registros. Antes de processar, tudo vira uma lista so. E o laco dentro do laco mais comum do dia a dia.',
 'Uma List<List<Integer>>. As listas internas podem estar vazias e a externa tambem.',
 'Uma List<Integer> com todos os elementos, na ordem em que aparecem.',
 'Entrada: [[1, 2], [], [3]]
Saida: [1, 2, 3]',
 'Considere apenas um nivel de aninhamento. Nao use flatMap.',
 25,
 'import java.util.*;

public class Solucao {
    public List<Integer> achatar(List<List<Integer>> listas) {
        // TODO: implementar
        return new ArrayList<>();
    }
}')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Somar os Elementos do Array (Java)', 'Declara o metodo somar', '\w+\s+somar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar somar e receber o array por parametro.'),
('Somar os Elementos do Array (Java)', 'Percorre o array', '(for\s*\(|while\s*\(|stream\s*\()', 'OBRIGATORIO', 1, 'Sem percorrer o array nao ha o que somar. Um for-each resolve.'),
('Somar os Elementos do Array (Java)', 'Acumula a soma', '(\+=|sum\s*\(|total|soma)', 'PONTUAVEL', 3, 'Falta acumular os valores numa variavel de total.'),
('Somar os Elementos do Array (Java)', 'Protege contra array nulo', '(==\s*null|!=\s*null|Objects\.)', 'PONTUAVEL', 3, 'Array nulo lanca NullPointerException no for. Cheque antes de percorrer.'),
('Somar os Elementos do Array (Java)', 'Devolve o total com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O total precisa voltar como retorno do metodo.'),
('Somar os Elementos do Array (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O array chega por parametro. Scanner travaria o teste esperando digitacao.'),

('Media do Array (Java)', 'Declara o metodo media', '\w+\s+media\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar media e receber o array por parametro.'),
('Media do Array (Java)', 'Soma os elementos', '(for\s*\(|while\s*\(|sum\s*\(|\+=)', 'OBRIGATORIO', 1, 'A media comeca pela soma dos elementos.'),
('Media do Array (Java)', 'Divide pela quantidade', '(\.length|/)', 'PONTUAVEL', 3, 'A soma precisa ser dividida por notas.length.'),
('Media do Array (Java)', 'Evita a divisao inteira', '(double|\(\s*double\s*\)|1\.0\s*\*|/\s*\(\s*double)', 'PONTUAVEL', 3, 'int dividido por int corta a parte decimal. Converta para double antes de dividir.'),
('Media do Array (Java)', 'Trata o array vazio', '(length\s*==\s*0|length\s*<|==\s*null)', 'PONTUAVEL', 2, 'Array vazio divide por zero. O enunciado manda devolver 0.'),
('Media do Array (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'As notas chegam por parametro.'),

('Contar Vogais da Frase (Java)', 'Declara o metodo contarVogais', '\w+\s+contarVogais\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar contarVogais e receber o texto.'),
('Contar Vogais da Frase (Java)', 'Percorre os caracteres do texto', '(charAt|toCharArray|for\s*\(|chars\s*\()', 'OBRIGATORIO', 1, 'Para contar caractere a caractere e preciso percorrer a String.'),
('Contar Vogais da Frase (Java)', 'Compara com o conjunto de vogais', '(aeiou|indexOf|contains)', 'PONTUAVEL', 3, 'Falta dizer o que e vogal. Um indexOf numa String de vogais resolve.'),
('Contar Vogais da Frase (Java)', 'Normaliza a caixa do texto', '(toLowerCase|toUpperCase|equalsIgnoreCase)', 'PONTUAVEL', 3, 'Sem normalizar, o A maiusculo da entrada escapa da contagem.'),
('Contar Vogais da Frase (Java)', 'Protege contra texto nulo', '(==\s*null|!=\s*null)', 'PONTUAVEL', 2, 'Texto nulo lanca NullPointerException. O enunciado manda devolver 0.'),
('Contar Vogais da Frase (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Inverter a String (Java)', 'Declara o metodo inverter', '\w+\s+inverter\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar inverter e receber o texto.'),
('Inverter a String (Java)', 'Percorre o texto de tras para frente', '(length\s*\(\s*\)\s*-\s*1|charAt|toCharArray)', 'OBRIGATORIO', 1, 'A inversao percorre do ultimo indice ate o primeiro.'),
('Inverter a String (Java)', 'Monta o resultado com StringBuilder', 'StringBuilder', 'PONTUAVEL', 3, 'Concatenar String dentro de laco cria um objeto novo a cada volta. StringBuilder evita isso.'),
('Inverter a String (Java)', 'Acumula os caracteres', '(append|\+=)', 'PONTUAVEL', 3, 'Cada caractere lido precisa entrar no resultado.'),
('Inverter a String (Java)', 'Protege contra texto nulo', '(==\s*null|!=\s*null)', 'PONTUAVEL', 2, 'Texto nulo devolve string vazia, sem lancar excecao.'),
('Inverter a String (Java)', 'Nao use o reverse pronto', '\.reverse\s*\(', 'PROIBIDO', 1, 'O enunciado pediu para percorrer o texto, sem StringBuilder.reverse().'),

('Verificar Palindromo (Java)', 'Declara o metodo ehPalindromo', '\w+\s+ehPalindromo\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar ehPalindromo e receber o texto.'),
('Verificar Palindromo (Java)', 'Compara os extremos ou o texto invertido', '(charAt|reverse|StringBuilder|equals)', 'OBRIGATORIO', 1, 'Compare o inicio com o fim, ou o texto limpo com ele invertido.'),
('Verificar Palindromo (Java)', 'Normaliza a caixa', '(toLowerCase|toUpperCase|equalsIgnoreCase)', 'PONTUAVEL', 3, 'Sem normalizar, "Ame a ema" reprova por causa do A maiusculo.'),
('Verificar Palindromo (Java)', 'Remove espacos e pontuacao', '(replaceAll|replace\s*\(|isLetterOrDigit)', 'PONTUAVEL', 3, 'Espaco e pontuacao atrapalham a comparacao. Limpe o texto antes.'),
('Verificar Palindromo (Java)', 'Devolve boolean', '(return\s+(true|false)|boolean)', 'PONTUAVEL', 2, 'O enunciado pede boolean, nao a String "sim".'),
('Verificar Palindromo (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O texto chega por parametro.'),

('Maior Elemento do Array (Java)', 'Declara o metodo maior', '\w+\s+maior\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar maior e receber o array.'),
('Maior Elemento do Array (Java)', 'Percorre o array', '(for\s*\(|while\s*\()', 'OBRIGATORIO', 1, 'A comparacao precisa passar por todos os elementos.'),
('Maior Elemento do Array (Java)', 'Inicializa com o primeiro elemento', '\[\s*0\s*\]', 'PONTUAVEL', 3, 'Comecar em 0 devolve 0 quando todos os numeros sao negativos. Use numeros[0].'),
('Maior Elemento do Array (Java)', 'Compara os elementos', '(>|Math\.max)', 'PONTUAVEL', 3, 'Sem comparacao nao ha como saber quem e o maior.'),
('Maior Elemento do Array (Java)', 'Devolve o maior com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O valor precisa voltar como retorno do metodo.'),
('Maior Elemento do Array (Java)', 'Nao use Arrays.stream', 'Arrays\.stream', 'PROIBIDO', 1, 'O enunciado pediu o laco escrito na mao.'),

('FizzBuzz em Java (Java)', 'Declara o metodo fizzBuzz', '\w+\s+fizzBuzz\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar fizzBuzz e receber n.'),
('FizzBuzz em Java (Java)', 'Percorre de 1 ate n', 'for\s*\(', 'OBRIGATORIO', 1, 'O laco vai de 1 ate n, inclusive.'),
('FizzBuzz em Java (Java)', 'Testa multiplo de 3 e 5 antes dos separados', '(15|%\s*3\s*==\s*0\s*&&)', 'PONTUAVEL', 3, 'Testar 3 e 5 separados primeiro faz FizzBuzz nunca aparecer.'),
('FizzBuzz em Java (Java)', 'Usa o resto da divisao', '%\s*(3|5)', 'PONTUAVEL', 3, 'O teste de multiplo sai do resto da divisao igual a zero.'),
('FizzBuzz em Java (Java)', 'Adiciona os itens na lista', '(add\s*\(|List)', 'PONTUAVEL', 2, 'O enunciado pede a lista de volta, montada com add.'),
('FizzBuzz em Java (Java)', 'Nao imprima no lugar de devolver', 'System\.out\.print', 'PROIBIDO', 1, 'Imprimir nao devolve nada para quem chamou o metodo.'),

('Fatorial com Laco (Java)', 'Declara o metodo fatorial', '\w+\s+fatorial\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar fatorial e receber n.'),
('Fatorial com Laco (Java)', 'Percorre de 1 ate n', '(for\s*\(|while\s*\()', 'OBRIGATORIO', 1, 'O fatorial e a multiplicacao acumulada de 1 ate n.'),
('Fatorial com Laco (Java)', 'Acumula o produto', '(\*=|=\s*\w+\s*\*)', 'PONTUAVEL', 3, 'O acumulador comeca em 1 e vai sendo multiplicado a cada volta.'),
('Fatorial com Laco (Java)', 'Usa long para o resultado', 'long', 'PONTUAVEL', 3, 'O fatorial estoura o int rapido: a partir de 13 o valor ja fica errado.'),
('Fatorial com Laco (Java)', 'Trata o fatorial de 0', '(==\s*0|<=\s*1|=\s*1)', 'PONTUAVEL', 2, 'O fatorial de 0 e 1: comecar o acumulador em 1 ja resolve.'),
('Fatorial com Laco (Java)', 'Nao use recursao', 'return\s+\w*\s*fatorial\s*\(', 'PROIBIDO', 1, 'O enunciado pediu a versao com laco.'),

('Verificar Numero Primo (Java)', 'Declara o metodo ehPrimo', '\w+\s+ehPrimo\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar ehPrimo e receber o numero.'),
('Verificar Numero Primo (Java)', 'Procura divisores num laco', '(for\s*\(|while\s*\()', 'OBRIGATORIO', 1, 'Para saber se e primo e preciso testar os possiveis divisores.'),
('Verificar Numero Primo (Java)', 'Testa o resto da divisao', '%\s*\w+\s*==\s*0', 'PONTUAVEL', 3, 'Um divisor e todo numero cujo resto da divisao da zero.'),
('Verificar Numero Primo (Java)', 'Trata os casos menores que 2', '(<\s*2|<=\s*1)', 'PONTUAVEL', 3, 'Zero, um e negativos nao sao primos e saem antes do laco.'),
('Verificar Numero Primo (Java)', 'Devolve boolean', 'return\s+(true|false)', 'PONTUAVEL', 2, 'A resposta e true ou false.'),
('Verificar Numero Primo (Java)', 'Nao use BigInteger', 'BigInteger', 'PROIBIDO', 1, 'O enunciado pediu a verificacao escrita na mao.'),

('Contar Palavras do Texto (Java)', 'Declara o metodo contarPalavras', '\w+\s+contarPalavras\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar contarPalavras e receber a frase.'),
('Contar Palavras do Texto (Java)', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'split quebra a frase; o segredo esta no separador escolhido.'),
('Contar Palavras do Texto (Java)', 'Trata espacos repetidos', '(\\\\s\+|trim\s*\(|isEmpty|isBlank)', 'PONTUAVEL', 3, 'split com um espaco so gera pedacos vazios. Um separador de um ou mais espacos resolve.'),
('Contar Palavras do Texto (Java)', 'Conta os pedacos resultantes', '\.length', 'PONTUAVEL', 3, 'Depois de separar, o tamanho do array e a quantidade de palavras.'),
('Contar Palavras do Texto (Java)', 'Protege contra texto nulo ou vazio', '(==\s*null|isEmpty|isBlank|trim\s*\()', 'PONTUAVEL', 2, 'Texto nulo ou so com espacos devolve 0, sem excecao.'),
('Contar Palavras do Texto (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'A frase chega por parametro.'),

('Somar Apenas os Pares (Java)', 'Declara o metodo somarPares', '\w+\s+somarPares\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar somarPares e receber o array.'),
('Somar Apenas os Pares (Java)', 'Percorre o array', '(for\s*\(|while\s*\()', 'OBRIGATORIO', 1, 'Sem percorrer o array nao ha o que somar.'),
('Somar Apenas os Pares (Java)', 'Testa a paridade com resto', '%\s*2', 'PONTUAVEL', 3, 'O resto da divisao por 2 igual a zero identifica o par.'),
('Somar Apenas os Pares (Java)', 'Acumula apenas os pares', '(\+=|soma|total)', 'PONTUAVEL', 3, 'Identificar o par nao basta: e preciso somar num acumulador.'),
('Somar Apenas os Pares (Java)', 'Devolve a soma com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O total precisa voltar como retorno.'),
('Somar Apenas os Pares (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Gerar a Tabuada (Java)', 'Declara o metodo tabuada', '\w+\s+tabuada\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar tabuada e receber o numero.'),
('Gerar a Tabuada (Java)', 'Percorre de 1 a 10', 'for\s*\(', 'OBRIGATORIO', 1, 'O laco gera os multiplicadores de 1 a 10.'),
('Gerar a Tabuada (Java)', 'Multiplica o numero pelo contador', '\*', 'PONTUAVEL', 3, 'Cada posicao e o numero multiplicado pelo valor da vez.'),
('Gerar a Tabuada (Java)', 'Preenche o array por indice', '\[\s*\w+\s*\]\s*=', 'PONTUAVEL', 3, 'O resultado vai para a posicao correspondente do array.'),
('Gerar a Tabuada (Java)', 'Devolve o array com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O array precisa voltar como retorno do metodo.'),
('Gerar a Tabuada (Java)', 'Nao imprima no lugar de devolver', 'System\.out\.print', 'PROIBIDO', 1, 'Imprimir nao devolve nada para quem chamou.'),

('Ano Bissexto (Java)', 'Declara o metodo ehBissexto', '\w+\s+ehBissexto\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar ehBissexto e receber o ano.'),
('Ano Bissexto (Java)', 'Testa a divisao por 4', '%\s*4', 'OBRIGATORIO', 1, 'A primeira parte da regra e ser divisivel por 4.'),
('Ano Bissexto (Java)', 'Contempla a excecao do 100', '%\s*100', 'PONTUAVEL', 3, 'Sem a regra do 100, 1900 seria classificado como bissexto por engano.'),
('Ano Bissexto (Java)', 'Contempla a excecao do 400', '%\s*400', 'PONTUAVEL', 3, 'Sem a regra do 400, o ano 2000 seria classificado como comum.'),
('Ano Bissexto (Java)', 'Devolve boolean', 'return\s+(true|false|\()', 'PONTUAVEL', 2, 'A resposta e true ou false.'),
('Ano Bissexto (Java)', 'Nao use a API de datas', '(java\.time|LocalDate|Year\.)', 'PROIBIDO', 1, 'O enunciado pediu a regra escrita na mao, sem Year.isLeap.'),

('Converter Temperatura (Java)', 'Declara o metodo paraFahrenheit', '\w+\s+paraFahrenheit\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar paraFahrenheit e receber celsius.'),
('Converter Temperatura (Java)', 'Aplica a proporcao 9/5', '(9\s*/\s*5|1\.8|9\.0|\*\s*9)', 'OBRIGATORIO', 1, 'A conversao multiplica por 9/5 antes de somar.'),
('Converter Temperatura (Java)', 'Soma o deslocamento de 32', '\+\s*32', 'PONTUAVEL', 3, 'Depois de multiplicar, some 32 para chegar na escala Fahrenheit.'),
('Converter Temperatura (Java)', 'Evita a divisao inteira em 9/5', '(9\.0|1\.8|\*\s*9\s*/\s*5\.0|\(\s*double)', 'PONTUAVEL', 3, '9/5 com inteiros da 1, e a conversao inteira sai errada. Force o double.'),
('Converter Temperatura (Java)', 'Devolve o resultado com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'A temperatura convertida precisa voltar como retorno.'),
('Converter Temperatura (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'A temperatura chega por parametro.'),

('Classificar o IMC (Java)', 'Declara o metodo classificarImc', '\w+\s+classificarImc\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar classificarImc e receber peso e altura.'),
('Classificar o IMC (Java)', 'Eleva a altura ao quadrado', '(altura\s*\*\s*altura|Math\.pow)', 'OBRIGATORIO', 1, 'O IMC divide o peso pela altura ao quadrado, nao pela altura.'),
('Classificar o IMC (Java)', 'Compara com os limites das faixas', '(18\.5|24\.9|29\.9|30)', 'PONTUAVEL', 3, 'Os limites 18.5, 24.9 e 29.9 precisam aparecer nas comparacoes.'),
('Classificar o IMC (Java)', 'Encadeia as faixas sem sobreposicao', '(else\s+if|else)', 'PONTUAVEL', 3, 'A cadeia if/else if/else garante que cada IMC caia em uma unica faixa.'),
('Classificar o IMC (Java)', 'Devolve o nome da faixa', '(abaixo|normal|sobrepeso|obesidade)', 'PONTUAVEL', 2, 'A saida e a faixa em texto, nao o numero do IMC.'),
('Classificar o IMC (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Frete por Faixa de Compra (Java)', 'Declara o metodo calcularFrete', '\w+\s+calcularFrete\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar calcularFrete e receber o valor da compra.'),
('Frete por Faixa de Compra (Java)', 'Compara com os limites das faixas', '(200|100)', 'OBRIGATORIO', 1, 'Os cortes em 200 e em 100 precisam aparecer nas comparacoes.'),
('Frete por Faixa de Compra (Java)', 'Inclui o limite no frete gratis', '>=\s*200', 'PONTUAVEL', 3, 'Compra de exatamente 200 tem frete gratis: a comparacao e >= e nao >.'),
('Frete por Faixa de Compra (Java)', 'Encadeia as faixas sem sobreposicao', '(else\s+if|else)', 'PONTUAVEL', 3, 'if/else if/else garante que cada valor caia em uma unica faixa.'),
('Frete por Faixa de Compra (Java)', 'Devolve o valor do frete', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O frete precisa voltar como retorno do metodo.'),
('Frete por Faixa de Compra (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O valor da compra chega por parametro.'),

('Troco em Notas (Java)', 'Declara o metodo troco', '\w+\s+troco\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar troco e receber o valor.'),
('Troco em Notas (Java)', 'Percorre as notas da maior para a menor', '(100[\s\S]{0,60}50[\s\S]{0,60}20|for\s*\()', 'OBRIGATORIO', 1, 'A ordem 100, 50, 20, 10 e o que garante o menor numero de notas.'),
('Troco em Notas (Java)', 'Calcula quantas notas cabem', '/', 'PONTUAVEL', 3, 'A divisao inteira diz quantas notas daquele valor cabem no que restou.'),
('Troco em Notas (Java)', 'Atualiza o valor restante', '(%|-=)', 'PONTUAVEL', 3, 'O que sobra continua para a proxima nota: use o resto da divisao.'),
('Troco em Notas (Java)', 'Preenche o mapa de saida', '(put\s*\(|Map)', 'PONTUAVEL', 2, 'O resultado e um mapa com a nota e a quantidade.'),
('Troco em Notas (Java)', 'Nao imprima no lugar de devolver', 'System\.out\.print', 'PROIBIDO', 1, 'Imprimir nao devolve nada para quem chamou.'),

('Iniciais do Nome (Java)', 'Declara o metodo sigla', '\w+\s+sigla\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar sigla e receber o nome.'),
('Iniciais do Nome (Java)', 'Separa o nome em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'A sigla sai da primeira letra de cada palavra, entao e preciso separar.'),
('Iniciais do Nome (Java)', 'Pega a primeira letra de cada palavra', '(charAt\s*\(\s*0|substring\s*\(\s*0\s*,\s*1)', 'PONTUAVEL', 3, 'A inicial e o caractere de indice 0 de cada palavra.'),
('Iniciais do Nome (Java)', 'Coloca as iniciais em maiuscula', 'toUpperCase', 'PONTUAVEL', 3, 'O enunciado pede as iniciais em maiuscula.'),
('Iniciais do Nome (Java)', 'Trata espacos extras e texto nulo', '(\\\\s\+|isEmpty|isBlank|==\s*null|trim\s*\()', 'PONTUAVEL', 2, 'Espaco duplo gera pedaco vazio, e charAt(0) nele lanca excecao.'),
('Iniciais do Nome (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O nome chega por parametro.'),

('Capitalizar Cada Palavra (Java)', 'Declara o metodo capitalizar', '\w+\s+capitalizar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar capitalizar e receber a frase.'),
('Capitalizar Cada Palavra (Java)', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Para tratar palavra a palavra e preciso separar a frase.'),
('Capitalizar Cada Palavra (Java)', 'Coloca a inicial em maiuscula', 'toUpperCase', 'PONTUAVEL', 3, 'A primeira letra de cada palavra sobe para maiuscula.'),
('Capitalizar Cada Palavra (Java)', 'Coloca o restante em minuscula', 'toLowerCase', 'PONTUAVEL', 3, 'Entrada em caixa alta continua feia se o resto nao descer para minuscula.'),
('Capitalizar Cada Palavra (Java)', 'Remonta a frase', '(StringBuilder|String\.join|\+=)', 'PONTUAVEL', 2, 'As palavras tratadas precisam voltar a formar uma frase.'),
('Capitalizar Cada Palavra (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Remover Espacos Extras (Java)', 'Declara o metodo limparEspacos', '\w+\s+limparEspacos\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar limparEspacos e receber o texto.'),
('Remover Espacos Extras (Java)', 'Remove os espacos das pontas', '(trim\s*\(|strip\s*\()', 'OBRIGATORIO', 1, 'O espaco invisivel nas pontas e o que quebra a busca depois.'),
('Remover Espacos Extras (Java)', 'Reduz os espacos do meio', '(replaceAll|split\s*\()', 'PONTUAVEL', 3, 'Espacos repetidos no meio precisam virar um so.'),
('Remover Espacos Extras (Java)', 'Usa o padrao de um ou mais espacos', '\\\\s\+', 'PONTUAVEL', 3, 'O padrao de um ou mais espacos e o que casa com a sequencia inteira.'),
('Remover Espacos Extras (Java)', 'Protege contra texto nulo', '(==\s*null|!=\s*null)', 'PONTUAVEL', 2, 'Texto nulo devolve string vazia, sem lancar excecao.'),
('Remover Espacos Extras (Java)', 'Nao use stream para juntar', '\.stream\s*\(', 'PROIBIDO', 1, 'O enunciado pediu com os metodos de String.'),

('Maior Palavra da Frase (Java)', 'Declara o metodo maiorPalavra', '\w+\s+maiorPalavra\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar maiorPalavra e receber a frase.'),
('Maior Palavra da Frase (Java)', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Sem separar nao ha palavras para comparar.'),
('Maior Palavra da Frase (Java)', 'Compara o tamanho das palavras', 'length\s*\(', 'PONTUAVEL', 3, 'O criterio de comparacao e o comprimento de cada palavra.'),
('Maior Palavra da Frase (Java)', 'Resolve o empate pela primeira', '>', 'PONTUAVEL', 3, 'Use > e nao >=: assim a primeira palavra do empate permanece.'),
('Maior Palavra da Frase (Java)', 'Trata frase vazia ou nula', '(==\s*null|isEmpty|isBlank|length\s*\(\s*\)\s*==\s*0)', 'PONTUAVEL', 2, 'Frase vazia ou nula devolve string vazia, sem excecao.'),
('Maior Palavra da Frase (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'A frase chega por parametro.'),

('Segundo Maior do Array (Java)', 'Declara o metodo segundoMaior', '\w+\s+segundoMaior\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar segundoMaior e receber o array.'),
('Segundo Maior do Array (Java)', 'Trata os valores repetidos no topo', '(!=|maior|primeiro)', 'OBRIGATORIO', 1, 'Com [10, 10, 8] o segundo maior e 8: o repetido nao pode ocupar o segundo lugar.'),
('Segundo Maior do Array (Java)', 'Mantem o maior e o segundo maior', '(segundo|maior)', 'PONTUAVEL', 3, 'Duas variaveis atualizadas no mesmo laco resolvem sem ordenar nada.'),
('Segundo Maior do Array (Java)', 'Percorre o array uma vez', 'for\s*\(', 'PONTUAVEL', 3, 'Uma varredura basta: nao e preciso ordenar o array inteiro.'),
('Segundo Maior do Array (Java)', 'Devolve o valor com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O valor precisa voltar como retorno do metodo.'),
('Segundo Maior do Array (Java)', 'Nao use Arrays.sort', 'Arrays\.sort', 'PROIBIDO', 1, 'Ordenar custa mais e o enunciado pediu a varredura.'),

('Remover Duplicados da Lista (Java)', 'Declara o metodo removerDuplicados', '\w+\s+removerDuplicados\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar removerDuplicados e receber a lista.'),
('Remover Duplicados da Lista (Java)', 'Percorre a lista original', '(for\s*\(|LinkedHashSet)', 'OBRIGATORIO', 1, 'A ordem so se preserva percorrendo a lista na sequencia recebida.'),
('Remover Duplicados da Lista (Java)', 'Guarda o que ja apareceu', '(Set|contains|add\s*\()', 'PONTUAVEL', 3, 'E preciso lembrar quais itens ja sairam para nao repetir.'),
('Remover Duplicados da Lista (Java)', 'Preserva a ordem de insercao', '(LinkedHashSet|ArrayList|contains)', 'PONTUAVEL', 3, 'HashSet perde a ordem. LinkedHashSet, ou um contains sobre a lista de saida, mantem.'),
('Remover Duplicados da Lista (Java)', 'Devolve uma lista nova', '(new\s+ArrayList|return\s+[^;]+;)', 'PONTUAVEL', 2, 'O resultado vai numa lista nova: a recebida nao pode ser alterada.'),
('Remover Duplicados da Lista (Java)', 'Nao altere a lista recebida', 'itens\s*\.\s*remove\s*\(', 'PROIBIDO', 1, 'Remover da lista recebida altera o objeto de quem chamou o metodo.'),

('Contar Ocorrencias com Map (Java)', 'Declara o metodo frequencia', '\w+\s+frequencia\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar frequencia e receber a lista.'),
('Contar Ocorrencias com Map (Java)', 'Percorre a lista', 'for\s*\(', 'OBRIGATORIO', 1, 'A contagem sai de um laco sobre os itens.'),
('Contar Ocorrencias com Map (Java)', 'Acumula a contagem no mapa', 'put\s*\(|merge\s*\(', 'PONTUAVEL', 3, 'O mapa guarda item e contagem.'),
('Contar Ocorrencias com Map (Java)', 'Trata a chave que ainda nao existe', '(getOrDefault|containsKey|merge\s*\(|computeIfAbsent)', 'PONTUAVEL', 3, 'Somar direto numa chave ausente da NullPointerException. getOrDefault evita isso.'),
('Contar Ocorrencias com Map (Java)', 'Devolve o mapa com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O mapa precisa voltar como retorno do metodo.'),
('Contar Ocorrencias com Map (Java)', 'Nao use Collectors.groupingBy', 'groupingBy', 'PROIBIDO', 1, 'O enunciado pediu a contagem montada na mao.'),

('Somar os Digitos do Numero (Java)', 'Declara o metodo somarDigitos', '\w+\s+somarDigitos\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar somarDigitos e receber o numero.'),
('Somar os Digitos do Numero (Java)', 'Percorre os algarismos', '(while\s*\(|for\s*\()', 'OBRIGATORIO', 1, 'O laco continua enquanto ainda houver algarismo a processar.'),
('Somar os Digitos do Numero (Java)', 'Extrai o ultimo algarismo com o resto', '%\s*10', 'PONTUAVEL', 3, 'O resto da divisao por 10 devolve o ultimo algarismo.'),
('Somar os Digitos do Numero (Java)', 'Descarta o algarismo processado', '/\s*10', 'PONTUAVEL', 3, 'A divisao inteira por 10 remove o algarismo ja somado e evita o laco infinito.'),
('Somar os Digitos do Numero (Java)', 'Acumula a soma', '(\+=|soma|total)', 'PONTUAVEL', 2, 'Os algarismos extraidos precisam ser somados num acumulador.'),
('Somar os Digitos do Numero (Java)', 'Nao converta o numero para texto', '(String\.valueOf|toString|charAt)', 'PROIBIDO', 1, 'O enunciado pediu a solucao com operacoes numericas.'),

('Total do Carrinho (Java)', 'Declara o metodo total', '\w+\s+total\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar total e receber a lista de itens.'),
('Total do Carrinho (Java)', 'Percorre os itens do carrinho', 'for\s*\(', 'OBRIGATORIO', 1, 'O subtotal sai de um laco sobre os itens.'),
('Total do Carrinho (Java)', 'Multiplica preco por quantidade', '\[\s*0\s*\][\s\S]{0,20}\*|\*[\s\S]{0,20}\[\s*1\s*\]', 'PONTUAVEL', 3, 'Somar so o preco ignora quem levou tres unidades. O total e preco vezes quantidade.'),
('Total do Carrinho (Java)', 'Le as duas posicoes do array', '\[\s*1\s*\]', 'PONTUAVEL', 3, 'A quantidade esta na posicao 1 e precisa entrar no calculo.'),
('Total do Carrinho (Java)', 'Acumula e devolve o total', '(\+=|return\s+[^;]+;)', 'PONTUAVEL', 2, 'O total precisa ser acumulado e devolvido.'),
('Total do Carrinho (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O carrinho chega por parametro.'),

('Filtrar Maiores de Idade (Java)', 'Declara o metodo maioresDeIdade', '\w+\s+maioresDeIdade\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar maioresDeIdade e receber o mapa.'),
('Filtrar Maiores de Idade (Java)', 'Percorre as entradas do mapa', '(entrySet|keySet|for\s*\()', 'OBRIGATORIO', 1, 'entrySet entrega nome e idade de uma vez.'),
('Filtrar Maiores de Idade (Java)', 'Aplica o corte de 18 anos ou mais', '>=\s*18', 'PONTUAVEL', 3, 'O enunciado diz 18 ou mais: com > 18 quem tem exatamente 18 fica de fora.'),
('Filtrar Maiores de Idade (Java)', 'Coleta apenas os nomes', '(getKey|add\s*\()', 'PONTUAVEL', 3, 'A saida e a lista de nomes, nao o mapa filtrado.'),
('Filtrar Maiores de Idade (Java)', 'Devolve a lista com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'A lista precisa voltar como retorno do metodo.'),
('Filtrar Maiores de Idade (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Aplicar Desconto (Java)', 'Declara o metodo aplicarDesconto', '\w+\s+aplicarDesconto\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar aplicarDesconto e receber preco e percentual.'),
('Aplicar Desconto (Java)', 'Usa o percentual no calculo', '(/\s*100|percentual)', 'OBRIGATORIO', 1, 'O percentual precisa entrar na conta, dividido por 100.'),
('Aplicar Desconto (Java)', 'Subtrai o desconto do preco', '(preco\s*-|\*\s*\(\s*1)', 'PONTUAVEL', 3, 'O preco final e o original menos o desconto.'),
('Aplicar Desconto (Java)', 'Valida o percentual fora da faixa', '(if\s*\(|>\s*100|<\s*0)', 'PONTUAVEL', 3, 'Percentual acima de 100 geraria preco negativo. Devolva o preco original.'),
('Aplicar Desconto (Java)', 'Evita a divisao inteira', '(100\.0|\(\s*double|1\.0)', 'PONTUAVEL', 2, 'percentual/100 com inteiros da 0, e o desconto some.'),
('Aplicar Desconto (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'Preco e percentual chegam por parametro.'),

('Contar Aprovados e Reprovados (Java)', 'Declara o metodo contarSituacao', '\w+\s+contarSituacao\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar contarSituacao e receber as notas.'),
('Contar Aprovados e Reprovados (Java)', 'Percorre as notas', 'for\s*\(', 'OBRIGATORIO', 1, 'E preciso varrer o array para classificar cada nota.'),
('Contar Aprovados e Reprovados (Java)', 'Aplica o corte em 6', '>=\s*6', 'PONTUAVEL', 3, 'Nota 6 aprova. Com > 6 quem tirou exatamente 6 seria reprovado.'),
('Contar Aprovados e Reprovados (Java)', 'Mantem os dois contadores', '(\+\+|\+=)', 'PONTUAVEL', 3, 'Conte os dois grupos, em vez de deduzir um por subtracao.'),
('Contar Aprovados e Reprovados (Java)', 'Devolve o array de duas posicoes', '(new\s+int\s*\[|return\s+[^;]+;)', 'PONTUAVEL', 2, 'A saida e um int[] com aprovados na posicao 0.'),
('Contar Aprovados e Reprovados (Java)', 'Nao imprima no lugar de devolver', 'System\.out\.print', 'PROIBIDO', 1, 'Imprimir nao devolve nada para quem chamou.'),

('Somar Numeros em Texto (Java)', 'Declara o metodo somarTexto', '\w+\s+somarTexto\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar somarTexto e receber o array de Strings.'),
('Somar Numeros em Texto (Java)', 'Converte o texto para numero', '(Integer\.parseInt|Integer\.valueOf)', 'OBRIGATORIO', 1, 'Sem parseInt, o Java concatena as Strings em vez de somar.'),
('Somar Numeros em Texto (Java)', 'Percorre o array', 'for\s*\(', 'PONTUAVEL', 3, 'A conversao precisa acontecer para cada item.'),
('Somar Numeros em Texto (Java)', 'Acumula o total', '(\+=|soma|total)', 'PONTUAVEL', 3, 'Os valores convertidos precisam ser somados num acumulador.'),
('Somar Numeros em Texto (Java)', 'Devolve a soma com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O total precisa voltar como retorno.'),
('Somar Numeros em Texto (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'Os valores chegam por parametro.'),

('Formatar Duracao (Java)', 'Declara o metodo formatarDuracao', '\w+\s+formatarDuracao\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar formatarDuracao e receber os minutos.'),
('Formatar Duracao (Java)', 'Separa as horas', '/\s*60', 'OBRIGATORIO', 1, 'A divisao inteira por 60 devolve as horas.'),
('Formatar Duracao (Java)', 'Calcula o resto dos minutos', '%\s*60', 'PONTUAVEL', 3, 'Sem o resto, 145 minutos viram 2h e os 25 minutos somem.'),
('Formatar Duracao (Java)', 'Coloca zero a esquerda nos minutos', '(%02d|String\.format|02)', 'PONTUAVEL', 3, 'O enunciado pede duas casas: 65 minutos vira 1h05, nao 1h5.'),
('Formatar Duracao (Java)', 'Monta a String no formato pedido', '(String\.format|\+)', 'PONTUAVEL', 2, 'O separador e a letra h entre horas e minutos.'),
('Formatar Duracao (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Verificar Array Ordenado (Java)', 'Declara o metodo estaOrdenado', '\w+\s+estaOrdenado\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar estaOrdenado e receber o array.'),
('Verificar Array Ordenado (Java)', 'Compara cada elemento com o seguinte', '(\+\s*1\s*\]|i\s*<\s*\w+\.length\s*-\s*1)', 'OBRIGATORIO', 1, 'A verificacao olha pares vizinhos: o laco para em length - 1.'),
('Verificar Array Ordenado (Java)', 'Usa menor ou igual na comparacao', '(<=|>)', 'PONTUAVEL', 3, 'Elementos iguais lado a lado continuam ordenados.'),
('Verificar Array Ordenado (Java)', 'Devolve false na primeira quebra', 'return\s+false', 'PONTUAVEL', 3, 'Achou um par fora de ordem, ja da para responder sem varrer o resto.'),
('Verificar Array Ordenado (Java)', 'Devolve true no fim', 'return\s+true', 'PONTUAVEL', 2, 'Sem quebra encontrada, o array esta ordenado.'),
('Verificar Array Ordenado (Java)', 'Nao ordene o array para comparar', 'Arrays\.sort', 'PROIBIDO', 1, 'Ordenar e mais caro e o enunciado pediu apenas para verificar.'),

('Buscar a Posicao no Array (Java)', 'Declara o metodo posicao', '\w+\s+posicao\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar posicao e receber numeros e alvo.'),
('Buscar a Posicao no Array (Java)', 'Percorre o array com indice', 'for\s*\(', 'OBRIGATORIO', 1, 'Para devolver a posicao e preciso acompanhar o indice.'),
('Buscar a Posicao no Array (Java)', 'Compara cada elemento com o alvo', '==\s*alvo|alvo\s*==', 'PONTUAVEL', 3, 'Falta a comparacao com o valor procurado.'),
('Buscar a Posicao no Array (Java)', 'Devolve -1 quando nao encontra', '-\s*1', 'PONTUAVEL', 3, 'Sem o -1 nao da para distinguir ausencia da posicao 0.'),
('Buscar a Posicao no Array (Java)', 'Para na primeira ocorrencia', 'return\s+\w+\s*;', 'PONTUAVEL', 2, 'O enunciado pede a primeira ocorrencia: devolva assim que encontrar.'),
('Buscar a Posicao no Array (Java)', 'Nao use Arrays.binarySearch', 'binarySearch', 'PROIBIDO', 1, 'binarySearch exige array ordenado e o enunciado nao garante isso.'),

('Verificar Anagrama (Java)', 'Declara o metodo saoAnagramas', '\w+\s+saoAnagramas\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar saoAnagramas e receber as duas palavras.'),
('Verificar Anagrama (Java)', 'Compara as letras das duas palavras', '(sort|equals|Arrays\.)', 'OBRIGATORIO', 1, 'Ordenar as letras das duas e compara-las e o caminho mais direto.'),
('Verificar Anagrama (Java)', 'Normaliza a caixa', '(toLowerCase|toUpperCase|equalsIgnoreCase)', 'PONTUAVEL', 3, 'Sem normalizar, "Amor" e "Roma" reprovam por causa da caixa.'),
('Verificar Anagrama (Java)', 'Descarta os espacos', '(replace\s*\(|replaceAll|trim\s*\()', 'PONTUAVEL', 3, 'Espaco conta como caractere e estraga a comparacao.'),
('Verificar Anagrama (Java)', 'Compara o tamanho antes de tudo', '(length\s*\(\s*\)\s*!=|length\s*\(\s*\)\s*==)', 'PONTUAVEL', 2, 'Tamanhos diferentes ja respondem false sem precisar ordenar nada.'),
('Verificar Anagrama (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'As palavras chegam por parametro.'),

('Percentual de Tarefas Concluidas (Java)', 'Declara o metodo percentualConcluido', '\w+\s+percentualConcluido\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar percentualConcluido e receber as tarefas.'),
('Percentual de Tarefas Concluidas (Java)', 'Conta as tarefas concluidas', '(for\s*\(|\+\+|\+=)', 'OBRIGATORIO', 1, 'E preciso contar quantas posicoes sao verdadeiras.'),
('Percentual de Tarefas Concluidas (Java)', 'Multiplica por 100', '(\*\s*100|100\.0)', 'PONTUAVEL', 3, 'A proporcao vira percentual multiplicando por 100.'),
('Percentual de Tarefas Concluidas (Java)', 'Protege o array vazio', '(length\s*==\s*0|length\s*<)', 'PONTUAVEL', 3, 'Sem tarefas a divisao por zero derruba a tela. Devolva 0.'),
('Percentual de Tarefas Concluidas (Java)', 'Evita a divisao inteira', '(100\.0|\(\s*double|1\.0)', 'PONTUAVEL', 2, 'int dividido por int corta o decimal e o percentual sai zerado.'),
('Percentual de Tarefas Concluidas (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Todos os Numeros Positivos (Java)', 'Declara o metodo todosPositivos', '\w+\s+todosPositivos\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar todosPositivos e receber o array.'),
('Todos os Numeros Positivos (Java)', 'Percorre o array', 'for\s*\(', 'OBRIGATORIO', 1, 'A verificacao passa por cada elemento.'),
('Todos os Numeros Positivos (Java)', 'Usa a comparacao maior que zero', '>\s*0|<=\s*0', 'PONTUAVEL', 3, 'Zero nao e positivo, entao a comparacao e estrita.'),
('Todos os Numeros Positivos (Java)', 'Devolve false na primeira falha', 'return\s+false', 'PONTUAVEL', 3, 'Achou um nao positivo, ja da para responder sem varrer o resto.'),
('Todos os Numeros Positivos (Java)', 'Devolve true no fim', 'return\s+true', 'PONTUAVEL', 2, 'Array vazio devolve true, porque nao ha nenhum valor invalido.'),
('Todos os Numeros Positivos (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O array chega por parametro.'),

('Somar os Valores do Mapa (Java)', 'Declara o metodo somarValores', '\w+\s+somarValores\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar somarValores e receber o mapa.'),
('Somar os Valores do Mapa (Java)', 'Percorre os valores do mapa', '(\.values\s*\(|entrySet|getValue)', 'OBRIGATORIO', 1, 'values() entrega so os numeros, que e o que interessa aqui.'),
('Somar os Valores do Mapa (Java)', 'Acumula a soma', '(\+=|soma|total)', 'PONTUAVEL', 3, 'Os valores precisam ser somados num acumulador.'),
('Somar os Valores do Mapa (Java)', 'Nao soma as chaves por engano', '(\.values\s*\(|getValue)', 'PONTUAVEL', 3, 'keySet entrega as chaves, nao os valores. Use values ou getValue.'),
('Somar os Valores do Mapa (Java)', 'Devolve o total com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O total precisa voltar como retorno do metodo.'),
('Somar os Valores do Mapa (Java)', 'Nao use stream', '\.stream\s*\(', 'PROIBIDO', 1, 'O enunciado pediu com laco.'),

('Itens Acima da Media (Java)', 'Declara o metodo acimaDaMedia', '\w+\s+acimaDaMedia\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar acimaDaMedia e receber o array.'),
('Itens Acima da Media (Java)', 'Calcula a media do array', '(\.length|/)', 'OBRIGATORIO', 1, 'A media e a soma dividida pela quantidade, calculada uma unica vez.'),
('Itens Acima da Media (Java)', 'Compara cada valor com a media', '>', 'PONTUAVEL', 3, 'Depois da media, compare cada valor com ela para montar o resultado.'),
('Itens Acima da Media (Java)', 'Trata o array vazio', '(length\s*==\s*0|length\s*<)', 'PONTUAVEL', 3, 'Array vazio divide por zero ao calcular a media. Devolva lista vazia antes.'),
('Itens Acima da Media (Java)', 'Evita a divisao inteira na media', '(double|1\.0|\(\s*double)', 'PONTUAVEL', 2, 'A media truncada muda quem entra no resultado.'),
('Itens Acima da Media (Java)', 'Nao recalcule a media dentro do laco', 'for\s*\([\s\S]{0,200}/\s*\w+\.length', 'PROIBIDO', 1, 'Recalcular a media a cada volta repete o trabalho sem necessidade.'),

('Inverter a Ordem das Palavras (Java)', 'Declara o metodo inverterPalavras', '\w+\s+inverterPalavras\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar inverterPalavras e receber a frase.'),
('Inverter a Ordem das Palavras (Java)', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Sem separar em palavras a inversao acaba virando inversao de letras.'),
('Inverter a Ordem das Palavras (Java)', 'Percorre as palavras de tras para frente', '(length\s*-\s*1|Collections\.reverse)', 'PONTUAVEL', 3, 'Percorrer do ultimo indice para o primeiro inverte a ordem.'),
('Inverter a Ordem das Palavras (Java)', 'Remonta a frase', '(StringBuilder|String\.join|\+=)', 'PONTUAVEL', 3, 'As palavras precisam voltar a formar uma frase, com um espaco entre elas.'),
('Inverter a Ordem das Palavras (Java)', 'Evita espaco sobrando nas pontas', '(trim\s*\(|String\.join|\\\\s\+)', 'PONTUAVEL', 2, 'Concatenar em laco costuma deixar espaco no fim.'),
('Inverter a Ordem das Palavras (Java)', 'Nao inverta as letras', '\.reverse\s*\(\s*\)\s*\.toString', 'PROIBIDO', 1, 'Inverter a String inteira embaralha as letras: o enunciado pede a ordem das palavras.'),

('Interseccao de Duas Listas (Java)', 'Declara o metodo emComum', '\w+\s+emComum\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar emComum e receber as duas listas.'),
('Interseccao de Duas Listas (Java)', 'Testa a presenca na segunda lista', 'contains\s*\(', 'OBRIGATORIO', 1, 'contains responde se o item da primeira lista existe na segunda.'),
('Interseccao de Duas Listas (Java)', 'Percorre a primeira lista', 'for\s*\(', 'PONTUAVEL', 3, 'A ordem do resultado segue a primeira lista.'),
('Interseccao de Duas Listas (Java)', 'Evita repetir item no resultado', '(Set|contains\s*\()', 'PONTUAVEL', 3, 'O item repetido na entrada nao pode sair duas vezes no resultado.'),
('Interseccao de Duas Listas (Java)', 'Devolve a lista com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'A lista de comuns precisa voltar como retorno.'),
('Interseccao de Duas Listas (Java)', 'Nao altere as listas recebidas', '\.retainAll\s*\(', 'PROIBIDO', 1, 'retainAll modifica a lista de quem chamou o metodo.'),

('Dividir a Lista em Blocos (Java)', 'Declara o metodo dividirEmBlocos', '\w+\s+dividirEmBlocos\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar dividirEmBlocos e receber itens e tamanho.'),
('Dividir a Lista em Blocos (Java)', 'Avanca de tamanho em tamanho', '(\+=\s*tamanho|i\s*\+\s*tamanho)', 'OBRIGATORIO', 1, 'O passo do laco e o tamanho do bloco.'),
('Dividir a Lista em Blocos (Java)', 'Recorta cada bloco', 'subList\s*\(', 'PONTUAVEL', 3, 'subList recorta o pedaco entre dois indices.'),
('Dividir a Lista em Blocos (Java)', 'Protege o ultimo bloco incompleto', 'Math\.min', 'PONTUAVEL', 3, 'O ultimo bloco estoura o fim da lista: Math.min com o tamanho da lista evita a excecao.'),
('Dividir a Lista em Blocos (Java)', 'Usa o tamanho recebido', 'tamanho', 'PONTUAVEL', 2, 'O tamanho do bloco vem por parametro e nao pode ser fixo no codigo.'),
('Dividir a Lista em Blocos (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Fibonacci ate N Termos (Java)', 'Declara o metodo fibonacci', '\w+\s+fibonacci\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar fibonacci e receber n.'),
('Fibonacci ate N Termos (Java)', 'Usa laco para gerar a sequencia', 'for\s*\(|while\s*\(', 'OBRIGATORIO', 1, 'O enunciado pede a versao iterativa.'),
('Fibonacci ate N Termos (Java)', 'Guarda os dois valores anteriores', '(anterior|atual|proximo|temp)', 'PONTUAVEL', 3, 'Cada termo depende dos dois anteriores: guarde os dois e atualize juntos.'),
('Fibonacci ate N Termos (Java)', 'Comeca a sequencia em 0 e 1', '(=\s*0|=\s*1)', 'PONTUAVEL', 3, 'A sequencia pedida comeca em 0 e 1; comecar em 1 e 1 desloca tudo.'),
('Fibonacci ate N Termos (Java)', 'Adiciona os termos na lista', 'add\s*\(', 'PONTUAVEL', 2, 'Os termos precisam ir para a lista de saida.'),
('Fibonacci ate N Termos (Java)', 'Nao use recursao', 'return\s+\w*\s*fibonacci\s*\(', 'PROIBIDO', 1, 'O enunciado pediu a versao com laco.'),

('Validar Senha Forte (Java)', 'Declara o metodo senhaForte', '\w+\s+senhaForte\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar senhaForte e receber a senha.'),
('Validar Senha Forte (Java)', 'Verifica o tamanho minimo', '(length\s*\(\s*\)\s*[<>]=?\s*8|8)', 'OBRIGATORIO', 1, 'A primeira regra e ter ao menos 8 caracteres.'),
('Validar Senha Forte (Java)', 'Verifica maiuscula e minuscula', '(isUpperCase|isLowerCase)', 'PONTUAVEL', 3, 'Character.isUpperCase e isLowerCase respondem as duas regras de caixa.'),
('Validar Senha Forte (Java)', 'Verifica a presenca de digito', 'isDigit', 'PONTUAVEL', 3, 'A regra do numero ficou de fora: Character.isDigit identifica o algarismo.'),
('Validar Senha Forte (Java)', 'Combina as regras e devolve boolean', '(&&|return\s+(true|false))', 'PONTUAVEL', 2, 'As quatro regras valem ao mesmo tempo: combine com && e devolva boolean.'),
('Validar Senha Forte (Java)', 'Protege contra senha nula', '(==\s*null|!=\s*null)', 'PROIBIDO', 1, 'Senha nula lanca NullPointerException em length(). O enunciado manda devolver false.'),

('Contar Tipos de Caractere (Java)', 'Declara o metodo contarTipos', '\w+\s+contarTipos\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar contarTipos e receber o texto.'),
('Contar Tipos de Caractere (Java)', 'Percorre os caracteres', '(charAt|toCharArray|for\s*\()', 'OBRIGATORIO', 1, 'A classificacao acontece caractere a caractere.'),
('Contar Tipos de Caractere (Java)', 'Identifica as letras', 'isLetter', 'PONTUAVEL', 3, 'Character.isLetter responde se o caractere e letra.'),
('Contar Tipos de Caractere (Java)', 'Identifica os digitos', 'isDigit', 'PONTUAVEL', 3, 'Character.isDigit responde se o caractere e algarismo.'),
('Contar Tipos de Caractere (Java)', 'Classifica o restante como outros', '(else|\[\s*2\s*\])', 'PONTUAVEL', 2, 'Espaco e pontuacao caem na terceira categoria.'),
('Contar Tipos de Caractere (Java)', 'Nao leia dados do teclado', '(Scanner|System\.in)', 'PROIBIDO', 1, 'O texto chega por parametro.'),

('Repetir Texto com Separador (Java)', 'Declara o metodo repetir', '\w+\s+repetir\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar repetir e receber texto e vezes.'),
('Repetir Texto com Separador (Java)', 'Repete conforme o parametro vezes', '(for\s*\(|vezes)', 'OBRIGATORIO', 1, 'A quantidade de repeticoes vem por parametro e nao pode ser fixa.'),
('Repetir Texto com Separador (Java)', 'Usa o separador entre os itens', '(String\.join|,\s)', 'PONTUAVEL', 3, 'O separador virgula e espaco entra entre os itens.'),
('Repetir Texto com Separador (Java)', 'Evita separador no fim', '(String\.join|i\s*<\s*vezes\s*-\s*1|StringJoiner)', 'PONTUAVEL', 3, 'Concatenar em laco deixa a virgula final: String.join ou StringJoiner resolvem.'),
('Repetir Texto com Separador (Java)', 'Trata vezes igual a zero', '(vezes\s*==\s*0|vezes\s*<=\s*0|for\s*\()', 'PONTUAVEL', 2, 'Com vezes igual a 0 a saida e string vazia, sem separador nenhum.'),
('Repetir Texto com Separador (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Media por Materia (Java)', 'Declara o metodo mediaPorMateria', '\w+\s+mediaPorMateria\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar mediaPorMateria e receber o boletim.'),
('Media por Materia (Java)', 'Percorre as entradas do mapa', '(entrySet|keySet)', 'OBRIGATORIO', 1, 'entrySet entrega a materia e a lista de notas de uma vez.'),
('Media por Materia (Java)', 'Calcula a media de cada lista', '(size\s*\(|/)', 'PONTUAVEL', 3, 'A media de cada materia e a soma das notas dividida pela quantidade.'),
('Media por Materia (Java)', 'Protege a materia sem nota', '(isEmpty|size\s*\(\s*\)\s*==\s*0)', 'PONTUAVEL', 3, 'Lista vazia divide por zero. O enunciado manda devolver 0.'),
('Media por Materia (Java)', 'Monta o mapa de saida', 'put\s*\(', 'PONTUAVEL', 2, 'O resultado e um mapa com a mesma chave e a media como valor.'),
('Media por Materia (Java)', 'Nao use stream', '\.stream\s*\(', 'PROIBIDO', 1, 'O enunciado pediu com laco sobre o mapa.'),

('Item Mais Frequente (Java)', 'Declara o metodo maisFrequente', '\w+\s+maisFrequente\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar maisFrequente e receber a lista.'),
('Item Mais Frequente (Java)', 'Conta as ocorrencias num mapa', '(Map|put\s*\(|getOrDefault)', 'OBRIGATORIO', 1, 'Antes de achar o maior e preciso contar quantas vezes cada item aparece.'),
('Item Mais Frequente (Java)', 'Compara as contagens', '>', 'PONTUAVEL', 3, 'Depois de contar, e preciso comparar para achar a maior contagem.'),
('Item Mais Frequente (Java)', 'Resolve o empate pela primeira aparicao', '(>|LinkedHashMap|for\s*\()', 'PONTUAVEL', 3, 'Use > e nao >=, e percorra na ordem da lista, para o primeiro permanecer.'),
('Item Mais Frequente (Java)', 'Devolve o item com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'O item, e nao a contagem, precisa voltar como retorno.'),
('Item Mais Frequente (Java)', 'Nao use Collectors.groupingBy', 'groupingBy', 'PROIBIDO', 1, 'O enunciado pediu a contagem montada na mao.'),

('Ordenar Nomes Ignorando a Caixa (Java)', 'Declara o metodo ordenarNomes', '\w+\s+ordenarNomes\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar ordenarNomes e receber a lista.'),
('Ordenar Nomes Ignorando a Caixa (Java)', 'Ordena a lista', '(sort\s*\(|Collections\.sort)', 'OBRIGATORIO', 1, 'A ordenacao e o coracao da questao.'),
('Ordenar Nomes Ignorando a Caixa (Java)', 'Ignora a caixa na comparacao', '(CASE_INSENSITIVE_ORDER|compareToIgnoreCase|toLowerCase)', 'PONTUAVEL', 3, 'Sem isso, todos os nomes com inicial maiuscula vem antes dos minusculos.'),
('Ordenar Nomes Ignorando a Caixa (Java)', 'Copia antes de ordenar', '(new\s+ArrayList|copyOf)', 'PONTUAVEL', 3, 'sort altera a lista recebida. Copie antes para preservar a original.'),
('Ordenar Nomes Ignorando a Caixa (Java)', 'Devolve a lista com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'A lista ordenada precisa voltar como retorno.'),
('Ordenar Nomes Ignorando a Caixa (Java)', 'Nao devolva os nomes em minuscula', 'add\s*\(\s*\w+\.toLowerCase', 'PROIBIDO', 1, 'A comparacao ignora a caixa, mas o nome sai como entrou.'),

('Achatar Lista de Listas (Java)', 'Declara o metodo achatar', '\w+\s+achatar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar achatar e receber a lista de listas.'),
('Achatar Lista de Listas (Java)', 'Percorre as listas internas', 'for\s*\(', 'OBRIGATORIO', 1, 'E preciso passar por cada lista interna.'),
('Achatar Lista de Listas (Java)', 'Junta os elementos de cada lista', '(addAll\s*\(|add\s*\()', 'PONTUAVEL', 3, 'addAll despeja a lista interna inteira de uma vez.'),
('Achatar Lista de Listas (Java)', 'Preserva a ordem original', 'for\s*\(', 'PONTUAVEL', 3, 'A ordem da saida segue a ordem das listas e dos elementos dentro delas.'),
('Achatar Lista de Listas (Java)', 'Devolve a lista com return', 'return\s+[^;]+;', 'PONTUAVEL', 2, 'A lista achatada precisa voltar como retorno.'),
('Achatar Lista de Listas (Java)', 'Nao use flatMap', 'flatMap', 'PROIBIDO', 1, 'O enunciado pediu com laco.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'Java'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
