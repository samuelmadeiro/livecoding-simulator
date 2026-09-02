-- Catalogo Java, nivel pleno: 8 questoes de algoritmo.
--
-- No pleno as questoes cobram escolha de estrutura, custo e as armadilhas de concorrencia e de
-- contrato que so aparecem em sistema grande: equals sem hashCode, HashMap compartilhado entre
-- threads, comparator que viola a transitividade, recursao que estoura a pilha.
--
-- Titulo com sufixo (Java) e INSERT de criterios filtrado pela tecnologia, como nas demais.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'PLENO', 'ALGORITMO_EASY', v.tempo, v.template, t.id
FROM (VALUES

('Cache LRU (Java)',
 'Implemente a classe CacheLRU com get(String chave) e put(String chave, int valor), descartando o item usado ha mais tempo quando a capacidade estoura.',
 'Todo servico com cache em memoria precisa de politica de descarte. Em Java a solucao curta usa LinkedHashMap com accessOrder ligado e removeEldestEntry sobrescrito, e saber disso vale tanto quanto saber implementar a lista duplamente ligada na mao.',
 'capacidade: int maior que 0, recebido no construtor.',
 'get devolve o valor ou -1 quando a chave nao existe. put insere ou atualiza, descartando o menos recentemente usado quando a capacidade estoura.',
 'CacheLRU c = new CacheLRU(2); c.put("a",1); c.put("b",2); c.get("a"); c.put("c",3);
Saida: a chave descartada e "b", porque "a" foi usada depois dela',
 'get e put precisam ser O(1). Nao percorra o cache atras do item mais antigo.',
 45,
 'import java.util.*;

public class CacheLRU {
    public CacheLRU(int capacidade) {
        // TODO: implementar
    }

    public int get(String chave) {
        // TODO: implementar
        return -1;
    }

    public void put(String chave, int valor) {
        // TODO: implementar
    }
}'),

('Chave de Map com equals e hashCode (Java)',
 'Implemente a classe Ponto com os campos x e y, de modo que dois pontos com as mesmas coordenadas sejam a mesma chave num HashMap.',
 'E o contrato mais violado do Java e o bug mais dificil de enxergar: sobrescrever equals e esquecer hashCode faz o objeto sumir do HashMap. O codigo compila, o teste com um elemento passa, e a busca falha em producao sem lancar excecao.',
 'Dois campos int, x e y, recebidos no construtor.',
 'Dois Ponto com as mesmas coordenadas precisam ser iguais por equals e produzir o mesmo hashCode, funcionando como a mesma chave num HashMap.',
 'Map<Ponto, String> m = new HashMap<>(); m.put(new Ponto(1,2), "a"); m.get(new Ponto(1,2));
Saida: "a"',
 'equals e hashCode precisam ser consistentes entre si. Comparar com == nao serve para objeto.',
 40,
 'import java.util.*;

public class Ponto {
    private final int x;
    private final int y;

    public Ponto(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // TODO: implementar
}'),

('Contador Seguro entre Threads (Java)',
 'Implemente a classe Contador com incrementar() e valor(), de modo que a contagem continue correta quando varias threads incrementam ao mesmo tempo.',
 'Contador de requisicoes e de erro parece trivial ate rodar sob carga: o incremento nao e atomico, sao tres operacoes, e duas threads podem ler o mesmo valor e gravar o mesmo resultado. O numero sai menor que o real e ninguem percebe, porque nao ha erro.',
 'Nenhum parametro no construtor. incrementar soma 1; valor devolve a contagem atual.',
 'Depois de N incrementos, distribuidos entre quantas threads forem, valor() devolve exatamente N.',
 'Duas threads chamando incrementar() mil vezes cada
Saida: valor() devolve 2000',
 'O incremento precisa ser atomico. Marcar o campo como volatile nao resolve, porque volatile garante visibilidade e nao atomicidade.',
 45,
 'public class Contador {
    // TODO: implementar

    public void incrementar() {
        // TODO: implementar
    }

    public long valor() {
        // TODO: implementar
        return 0;
    }
}'),

('Agrupar e Somar com Stream (Java)',
 'Escreva o metodo receitaPorCategoria(List<String[]> itens) que soma o valor por categoria usando a API de streams.',
 'Depois de escrever o agrupamento na mao no nivel junior, o pleno precisa saber a forma idiomatica. A questao cobra Collectors.groupingBy com um downstream de soma, que e o padrao que aparece em qualquer base Java moderna.',
 'Uma List<String[]> com a categoria na posicao 0 e o valor, como texto, na posicao 1.',
 'Um Map<String, Double> com a categoria e o total. Lista vazia devolve mapa vazio.',
 'Entrada: [["livros","10.5"],["livros","4.5"],["games","20"]]
Saida: {livros=15.0, games=20.0}',
 'Use stream com groupingBy e um downstream de soma. Nao monte o mapa com laco.',
 35,
 'import java.util.*;

public class Solucao {
    public Map<String, Double> receitaPorCategoria(List<String[]> itens) {
        // TODO: implementar
        return new HashMap<>();
    }
}'),

('Ordem de Execucao das Tarefas (Java)',
 'Escreva o metodo ordenar(Map<String, List<String>> dependencias) que devolve uma ordem valida de execucao, ou lista vazia quando houver ciclo.',
 'Pipeline de build e workflow de aprovacao resolvem isso toda vez que rodam. E ordenacao topologica, e o que separa a solucao correta da quase certa e detectar o ciclo em vez de entrar em recursao infinita ou devolver uma ordem incompleta em silencio.',
 'Um Map<String, List<String>> em que a chave e a tarefa e o valor sao as tarefas que precisam rodar antes dela.',
 'Uma List<String> com uma ordem valida de execucao. Havendo ciclo, devolve lista vazia.',
 'Entrada: {deploy=[build], build=[testes], testes=[]}
Saida: [testes, build, deploy]

Entrada: {a=[b], b=[a]}
Saida: []',
 'Ciclo devolve lista vazia, sem StackOverflowError. Toda tarefa precisa aparecer no resultado.',
 50,
 'import java.util.*;

public class Solucao {
    public List<String> ordenar(Map<String, List<String>> dependencias) {
        // TODO: implementar
        return new ArrayList<>();
    }
}'),

('Juntar K Listas Ordenadas (Java)',
 'Escreva o metodo juntar(List<int[]> listas) que combina varios arrays ja ordenados num unico array ordenado.',
 'Ler varios arquivos de log ordenados por data cai exatamente nisso. Concatenar tudo e ordenar funciona e desperdica a informacao mais valiosa do problema: cada entrada ja chega ordenada, e uma PriorityQueue aproveita isso.',
 'Uma List<int[]> em que cada array ja esta ordenado em ordem crescente. Algum pode estar vazio.',
 'Um int[] ordenado com todos os elementos. Entrada vazia devolve array vazio.',
 'Entrada: [[1,4,7],[2,5],[3]]
Saida: [1, 2, 3, 4, 5, 7]',
 'Nao concatene tudo e ordene no fim. Use uma fila de prioridade.',
 45,
 'import java.util.*;

public class Solucao {
    public int[] juntar(List<int[]> listas) {
        // TODO: implementar
        return new int[0];
    }
}'),

('Contar Ilhas no Mapa (Java)',
 'Escreva o metodo contarIlhas(int[][] mapa) que conta quantos grupos de posicoes ocupadas existem, considerando vizinhos na horizontal e na vertical.',
 'Aparece em processamento de imagem e agrupamento de sensores. E busca em grafo disfarcada de matriz, e em Java o cuidado extra e o tamanho da entrada: recursao profunda demais estoura a pilha, e uma fila resolve sem esse risco.',
 'Um int[][] com 1 para posicao ocupada e 0 para vazia. Pode vir vazio.',
 'Um int com a quantidade de grupos conectados. Mapa vazio devolve 0.',
 'Entrada: [[1,1,0],[0,1,0],[1,0,1]]
Saida: 3',
 'Vizinhanca apenas horizontal e vertical, sem diagonal. Nao altere o mapa recebido.',
 50,
 'import java.util.*;

public class Solucao {
    public int contarIlhas(int[][] mapa) {
        // TODO: implementar
        return 0;
    }
}'),

('Maior Sequencia sem Repetir (Java)',
 'Escreva o metodo maiorSequencia(String texto) que devolve o tamanho da maior sequencia de caracteres consecutivos sem repeticao.',
 'E o exercicio classico de janela deslizante, e aparece em analise de sessao e deteccao de padrao. A versao ingenua testa todas as sequencias possiveis e e quadratica; a versao com janela e uma varredura so, e essa e a conversa que o entrevistador quer ter.',
 'Uma String que pode estar vazia ou ser nula.',
 'Um int com o tamanho da maior sequencia sem caractere repetido. Texto vazio ou nulo devolve 0.',
 'Entrada: "abcabcbb"
Saida: 3

Entrada: "bbbb"
Saida: 1',
 'Resolva em uma unica varredura, sem testar todas as sequencias possiveis.',
 45,
 'import java.util.*;

public class Solucao {
    public int maiorSequencia(String texto) {
        // TODO: implementar
        return 0;
    }
}')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'Java'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Cache LRU (Java)', 'Declara os metodos get e put', 'get\s*\([\s\S]*put\s*\(', 'OBRIGATORIO', 1, 'A classe precisa expor os dois metodos pedidos.'),
('Cache LRU (Java)', 'Usa estrutura com ordem de acesso', '(LinkedHashMap|Deque|LinkedList)', 'OBRIGATORIO', 1, 'LinkedHashMap com accessOrder, ou lista ligada com mapa, mantem a ordem de uso.'),
('Cache LRU (Java)', 'Liga a ordem por acesso', '(accessOrder|true\s*\)|removeEldestEntry|moveTo)', 'PONTUAVEL', 3, 'Sem accessOrder, o LinkedHashMap ordena por insercao e o get nao renova a chave.'),
('Cache LRU (Java)', 'Descarta o menos recente ao estourar', '(removeEldestEntry|removeFirst|pollFirst|size\s*\(\s*\)\s*>)', 'PONTUAVEL', 3, 'Quando a capacidade estoura, sai o item usado ha mais tempo.'),
('Cache LRU (Java)', 'Devolve -1 para chave ausente', '-\s*1', 'PONTUAVEL', 2, 'Chave inexistente devolve -1, e nao null nem excecao.'),
('Cache LRU (Java)', 'Nao varra o cache atras do mais antigo', 'for\s*\([\s\S]{0,80}entrySet', 'PROIBIDO', 1, 'Percorrer o cache torna a operacao linear: o enunciado pede O(1).'),

('Chave de Map com equals e hashCode (Java)', 'Sobrescreve equals', 'boolean\s+equals\s*\(', 'OBRIGATORIO', 1, 'Sem equals, dois pontos com as mesmas coordenadas sao objetos diferentes.'),
('Chave de Map com equals e hashCode (Java)', 'Sobrescreve hashCode', 'int\s+hashCode\s*\(', 'OBRIGATORIO', 1, 'equals sem hashCode faz o objeto sumir do HashMap: e o contrato mais violado do Java.'),
('Chave de Map com equals e hashCode (Java)', 'Compara os dois campos no equals', 'x[\s\S]{0,60}y', 'PONTUAVEL', 3, 'A igualdade depende das duas coordenadas.'),
('Chave de Map com equals e hashCode (Java)', 'Usa os mesmos campos no hashCode', '(Objects\.hash|31\s*\*)', 'PONTUAVEL', 3, 'hashCode precisa usar os mesmos campos de equals, senao o contrato quebra.'),
('Chave de Map com equals e hashCode (Java)', 'Trata tipo diferente e nulo no equals', '(instanceof|getClass|==\s*null)', 'PONTUAVEL', 2, 'equals recebe Object: comparar sem checar o tipo lanca ClassCastException.'),
('Chave de Map com equals e hashCode (Java)', 'Nao compare os objetos com ==', 'this\s*==\s*\w+\s*\.\s*x', 'PROIBIDO', 1, 'Para objeto, == compara referencia e nao conteudo.'),

('Contador Seguro entre Threads (Java)', 'Declara incrementar e valor', 'incrementar\s*\([\s\S]*valor\s*\(', 'OBRIGATORIO', 1, 'A classe precisa expor os dois metodos pedidos.'),
('Contador Seguro entre Threads (Java)', 'Torna o incremento atomico', '(AtomicLong|AtomicInteger|synchronized|LongAdder|Lock)', 'OBRIGATORIO', 1, 'O incremento sao tres operacoes: sem atomicidade, duas threads gravam o mesmo resultado.'),
('Contador Seguro entre Threads (Java)', 'Incrementa sem ler e gravar em passos separados', '(incrementAndGet|getAndIncrement|increment\s*\(|\+\+)', 'PONTUAVEL', 3, 'A operacao precisa ser uma so, e nao ler, somar e gravar.'),
('Contador Seguro entre Threads (Java)', 'Le o valor de forma consistente', '(get\s*\(|sum\s*\(|synchronized)', 'PONTUAVEL', 3, 'A leitura tambem precisa enxergar o valor mais recente.'),
('Contador Seguro entre Threads (Java)', 'Usa long para nao estourar', 'long', 'PONTUAVEL', 2, 'Contador de requisicao passa de dois bilhoes com facilidade.'),
('Contador Seguro entre Threads (Java)', 'Nao confie apenas em volatile', 'volatile\s+(long|int)\s+\w+\s*;', 'PROIBIDO', 1, 'volatile garante visibilidade, nao atomicidade: o incremento continua perdendo contagem.'),

('Agrupar e Somar com Stream (Java)', 'Declara o metodo receitaPorCategoria', '\w+\s+receitaPorCategoria\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar receitaPorCategoria e receber os itens.'),
('Agrupar e Somar com Stream (Java)', 'Usa stream', '\.stream\s*\(', 'OBRIGATORIO', 1, 'O enunciado pede a forma idiomatica com a API de streams.'),
('Agrupar e Somar com Stream (Java)', 'Agrupa pela categoria', 'groupingBy', 'PONTUAVEL', 3, 'Collectors.groupingBy monta o mapa por categoria.'),
('Agrupar e Somar com Stream (Java)', 'Soma no downstream do agrupamento', '(summingDouble|reducing|summingInt)', 'PONTUAVEL', 3, 'O segundo argumento de groupingBy define o que fazer com cada grupo.'),
('Agrupar e Somar com Stream (Java)', 'Converte o valor de texto para numero', '(parseDouble|valueOf)', 'PONTUAVEL', 2, 'O valor chega como texto e precisa ser convertido antes de somar.'),
('Agrupar e Somar com Stream (Java)', 'Nao monte o mapa com laco', 'for\s*\(', 'PROIBIDO', 1, 'O enunciado pede a versao com stream: a versao com laco ja foi cobrada no nivel junior.'),

('Ordem de Execucao das Tarefas (Java)', 'Declara o metodo ordenar', '\w+\s+ordenar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar ordenar e receber as dependencias.'),
('Ordem de Execucao das Tarefas (Java)', 'Detecta a dependencia circular', '(visitando|Set|estado|ciclo|cinza)', 'OBRIGATORIO', 1, 'Sem marcar o que esta em visita, o ciclo vira StackOverflowError.'),
('Ordem de Execucao das Tarefas (Java)', 'Resolve as dependencias antes da tarefa', '(for\s*\(|Deque|Queue)', 'PONTUAVEL', 3, 'Cada tarefa so entra depois de suas dependencias.'),
('Ordem de Execucao das Tarefas (Java)', 'Marca as tarefas ja resolvidas', '(Set|contains|add\s*\()', 'PONTUAVEL', 3, 'Sem marcar o que ja saiu, a mesma tarefa entra duas vezes no resultado.'),
('Ordem de Execucao das Tarefas (Java)', 'Devolve lista vazia quando ha ciclo', '(new\s+ArrayList|List\.of\s*\(\s*\)|clear\s*\()', 'PONTUAVEL', 2, 'O enunciado pede lista vazia no ciclo, sem lancar excecao.'),
('Ordem de Execucao das Tarefas (Java)', 'Nao deixe o TODO do template', 'TODO', 'PROIBIDO', 1, 'O TODO do template continua no codigo.'),

('Juntar K Listas Ordenadas (Java)', 'Declara o metodo juntar', '\w+\s+juntar\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar juntar e receber a lista de arrays.'),
('Juntar K Listas Ordenadas (Java)', 'Usa fila de prioridade', 'PriorityQueue', 'OBRIGATORIO', 1, 'A fila de prioridade escolhe o proximo menor sem reordenar tudo.'),
('Juntar K Listas Ordenadas (Java)', 'Compara os candidatos pelo valor', '(Comparator|comparingInt)', 'PONTUAVEL', 3, 'A fila precisa saber comparar os candidatos de cada lista.'),
('Juntar K Listas Ordenadas (Java)', 'Avanca na lista de onde veio o menor', '(\+\s*1|indice|offer|add\s*\()', 'PONTUAVEL', 3, 'Depois de consumir um elemento, o proximo daquela lista entra na disputa.'),
('Juntar K Listas Ordenadas (Java)', 'Trata o array interno vazio', '(length\s*==\s*0|length\s*>\s*0)', 'PONTUAVEL', 2, 'Array vazio no meio da entrada nao pode quebrar a leitura do primeiro elemento.'),
('Juntar K Listas Ordenadas (Java)', 'Nao concatene tudo e ordene no fim', 'Arrays\.sort', 'PROIBIDO', 1, 'Ordenar o resultado concatenado joga fora a ordenacao que ja existia na entrada.'),

('Contar Ilhas no Mapa (Java)', 'Declara o metodo contarIlhas', '\w+\s+contarIlhas\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar contarIlhas e receber o mapa.'),
('Contar Ilhas no Mapa (Java)', 'Marca as posicoes ja visitadas', '(visitad|boolean\s*\[|Set)', 'OBRIGATORIO', 1, 'Sem marcar o visitado, a mesma ilha e contada varias vezes e a busca nao termina.'),
('Contar Ilhas no Mapa (Java)', 'Percorre a vizinhanca', '(\+\s*1|-\s*1|dx|dy|direc)', 'PONTUAVEL', 3, 'De cada posicao ocupada, a busca segue para os quatro vizinhos.'),
('Contar Ilhas no Mapa (Java)', 'Respeita os limites da matriz', '(length|>=\s*0|<\s*\w+\.length)', 'PONTUAVEL', 3, 'Indice fora da matriz lanca ArrayIndexOutOfBounds.'),
('Contar Ilhas no Mapa (Java)', 'Conta uma ilha por grupo iniciado', '\+\+', 'PONTUAVEL', 2, 'O contador sobe uma vez por grupo, e nao uma vez por posicao ocupada.'),
('Contar Ilhas no Mapa (Java)', 'Nao altere o mapa recebido', 'mapa\s*\[\s*\w+\s*\]\s*\[\s*\w+\s*\]\s*=', 'PROIBIDO', 1, 'Marcar o visitado no proprio mapa altera a estrutura de quem chamou o metodo.'),

('Maior Sequencia sem Repetir (Java)', 'Declara o metodo maiorSequencia', '\w+\s+maiorSequencia\s*\(', 'OBRIGATORIO', 1, 'O metodo precisa se chamar maiorSequencia e receber o texto.'),
('Maior Sequencia sem Repetir (Java)', 'Mantem uma janela sobre o texto', '(inicio|esquerda|left|start)', 'OBRIGATORIO', 1, 'A janela guarda onde a sequencia atual comeca.'),
('Maior Sequencia sem Repetir (Java)', 'Guarda a ultima posicao de cada caractere', '(Map|Set|int\s*\[\s*\])', 'PONTUAVEL', 3, 'Saber onde o caractere apareceu antes permite mover a janela de uma vez.'),
('Maior Sequencia sem Repetir (Java)', 'Move o inicio ao encontrar repeticao', 'Math\.max', 'PONTUAVEL', 3, 'Ao repetir, o inicio salta para depois da ocorrencia anterior, sem nunca retroceder.'),
('Maior Sequencia sem Repetir (Java)', 'Atualiza o maior tamanho', 'Math\.max', 'PONTUAVEL', 2, 'O resultado e o maior tamanho ja visto, e nao o tamanho da janela final.'),
('Maior Sequencia sem Repetir (Java)', 'Nao teste todas as sequencias possiveis', 'for\s*\([\s\S]{0,120}for\s*\(', 'PROIBIDO', 1, 'O laco duplo e quadratico: o enunciado pede uma unica varredura.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'Java'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
