-- Catalogo Python, nivel pleno: 9 questoes de algoritmo.
--
-- Aqui a pergunta deixa de ser "voce sabe escrever o laco" e passa a ser "voce escolhe a estrutura
-- certa e sabe dizer o custo dela". Cada questao tem uma solucao ingenua que funciona e reprova, e
-- o enunciado diz isso na cara: a restricao de complexidade faz parte do problema.
--
-- Como nas demais trilhas, o titulo leva o sufixo da tecnologia e o INSERT de criterios filtra pela
-- tecnologia, para nao colidir com questao homonima de Java ou SQL.

INSERT INTO desafios (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo,
                      restricoes, nivel, tipo, tempo_limite_minutos, template_codigo, tecnologia_id)
SELECT v.titulo, v.descricao, v.contexto, v.formato_entrada, v.formato_saida, v.exemplo,
       v.restricoes, 'PLENO', 'ALGORITMO_EASY', v.tempo, v.template, t.id
FROM (VALUES

('Cache LRU (Python)',
 'Implemente a classe CacheLRU com os metodos get(chave) e put(chave, valor), descartando o item usado ha mais tempo quando a capacidade estoura.',
 'Todo servico com cache em memoria precisa de politica de descarte, e LRU e a mais usada. A questao mede se a pessoa entende que get tambem e uma operacao de escrita, porque ele muda a ordem de uso, e se ela escolhe uma estrutura que faz isso em tempo constante em vez de varrer o cache atras do mais antigo.',
 'capacidade: inteiro maior que 0, passado no construtor. As chaves sao strings e os valores, inteiros.',
 'get devolve o valor ou -1 quando a chave nao existe. put insere ou atualiza, descartando o menos recentemente usado quando a capacidade estoura.',
 'c = CacheLRU(2); c.put("a", 1); c.put("b", 2); c.get("a"); c.put("c", 3)
Saida: a chave descartada e "b", porque "a" foi usada depois dela',
 'get e put precisam ser O(1). Nao percorra o cache inteiro para achar o mais antigo.',
 45,
 'class CacheLRU:
    def __init__(self, capacidade):
        self.capacidade = capacidade
        # TODO: implementar

    def get(self, chave):
        # TODO: implementar
        return -1

    def put(self, chave, valor):
        # TODO: implementar
        pass'),

('Ordem de Execucao das Tarefas (Python)',
 'Escreva a funcao ordenar_tarefas(dependencias) que devolve uma ordem valida de execucao, ou uma lista vazia quando houver dependencia circular.',
 'Pipeline de build, migracao de banco e workflow de aprovacao resolvem esse problema toda vez que rodam. E ordenacao topologica, e o que separa a solucao correta da quase certa e detectar o ciclo em vez de entrar em laco infinito ou devolver uma ordem incompleta sem avisar.',
 'Um dicionario em que a chave e a tarefa e o valor e a lista de tarefas que precisam rodar antes dela.',
 'Uma lista com as tarefas numa ordem valida de execucao. Havendo ciclo, devolve lista vazia.',
 'Entrada: {"deploy": ["build"], "build": ["testes"], "testes": []}
Saida: ["testes", "build", "deploy"]

Entrada: {"a": ["b"], "b": ["a"]}
Saida: []',
 'Ciclo devolve lista vazia, sem lancar excecao e sem laco infinito. Toda tarefa precisa aparecer no resultado.',
 50,
 'def ordenar_tarefas(dependencias):
    # TODO: implementar
    return []'),

('Juntar K Listas Ordenadas (Python)',
 'Escreva a funcao juntar(listas) que combina varias listas ja ordenadas numa unica lista ordenada.',
 'Ler varios arquivos de log ordenados por data, ou paginas de fontes diferentes, cai exatamente nisso. Concatenar tudo e ordenar funciona e desperdica a informacao mais valiosa do problema: as listas ja chegam ordenadas.',
 'Uma lista de listas de inteiros, cada uma ja ordenada em ordem crescente. Alguma pode estar vazia.',
 'Uma unica lista ordenada com todos os elementos. Entrada vazia devolve lista vazia.',
 'Entrada: [[1, 4, 7], [2, 5], [3]]
Saida: [1, 2, 3, 4, 5, 7]',
 'Nao concatene tudo e ordene no fim. Aproveite que cada lista ja esta ordenada, usando uma fila de prioridade.',
 45,
 'def juntar(listas):
    # TODO: implementar
    return []'),

('Limitador de Requisicoes (Python)',
 'Escreva a funcao permitir(historico, agora, limite, janela) que diz se uma nova requisicao pode passar, considerando quantas ja ocorreram na janela de tempo.',
 'Rate limiting protege API de abuso e de pico acidental. A questao mede se a pessoa entende janela deslizante: contar requisicoes por minuto cheio deixa passar o dobro do limite na virada do minuto, e esse bug so aparece em producao sob carga.',
 'historico: lista ordenada com os instantes das requisicoes anteriores, em segundos. agora: instante atual. limite: quantas requisicoes cabem na janela. janela: tamanho da janela em segundos.',
 'True se a requisicao pode passar, False caso contrario. Requisicoes fora da janela nao contam.',
 'Entrada: historico=[1, 2, 3], agora=4, limite=3, janela=10
Saida: False

Entrada: historico=[1, 2, 3], agora=15, limite=3, janela=10
Saida: True',
 'A janela e deslizante, e nao por minuto cheio. Requisicao exatamente no limite da janela ja saiu dela.',
 45,
 'def permitir(historico, agora, limite, janela):
    # TODO: implementar
    return False'),

('Diferenca entre Dois Dicionarios (Python)',
 'Escreva a funcao diferenca(antes, depois) que devolve o que mudou entre dois dicionarios aninhados.',
 'Auditoria de alteracao e log de mudanca precisam registrar o que mudou, e nao o registro inteiro. A questao exige recursao com tres casos que costumam ser esquecidos: chave que surgiu, chave que sumiu e chave cujo valor mudou de tipo.',
 'Dois dicionarios que podem conter outros dicionarios como valor, em qualquer profundidade.',
 'Um dicionario com as chaves que mudaram, cada uma apontando para uma tupla (valor_antes, valor_depois). Chave ausente de um lado aparece com None no lugar.',
 'Entrada: {"a": 1, "b": {"c": 2}}, {"a": 1, "b": {"c": 3}, "d": 4}
Saida: {"b": {"c": (2, 3)}, "d": (None, 4)}',
 'Chave que sumiu, chave que surgiu e mudanca de tipo precisam ser tratadas. Nao compare os dicionarios como texto.',
 50,
 'def diferenca(antes, depois):
    # TODO: implementar
    return {}'),

('Reexecucao com Espera Progressiva (Python)',
 'Escreva a funcao calcular_esperas(tentativas, base, teto) que devolve o tempo de espera antes de cada nova tentativa, dobrando a cada falha ate um teto.',
 'Chamada a servico externo falha, e reexecutar imediatamente so aumenta a fila do servico que ja esta sofrendo. Backoff exponencial com teto e o padrao de qualquer cliente HTTP serio, e o teto e o que impede a espera de virar meia hora.',
 'tentativas: quantas reexecucoes serao feitas, inteiro maior ou igual a 0. base: espera inicial em segundos. teto: espera maxima em segundos.',
 'Uma lista com o tempo de espera antes de cada tentativa. Nenhum valor pode passar do teto. tentativas igual a 0 devolve lista vazia.',
 'Entrada: tentativas=5, base=1, teto=8
Saida: [1, 2, 4, 8, 8]',
 'A espera dobra a cada tentativa e para de crescer no teto. Nao use sleep: a funcao apenas calcula.',
 35,
 'def calcular_esperas(tentativas, base, teto):
    # TODO: implementar
    return []'),

('Contar Ilhas no Mapa (Python)',
 'Escreva a funcao contar_ilhas(mapa) que conta quantos grupos de posicoes ocupadas existem, considerando vizinhos na horizontal e na vertical.',
 'Aparece em processamento de imagem, deteccao de regiao em mapa de calor e agrupamento de sensores. E busca em grafo disfarcada de matriz, e o cuidado esta em marcar o que ja foi visitado para nao contar a mesma ilha varias vezes nem entrar em recursao infinita.',
 'Uma lista de listas de inteiros, com 1 para posicao ocupada e 0 para vazia. Pode vir vazia.',
 'Um inteiro com a quantidade de grupos conectados. Mapa vazio devolve 0.',
 'Entrada: [[1,1,0],[0,1,0],[1,0,1]]
Saida: 3',
 'Vizinhanca e apenas horizontal e vertical, sem diagonal. Nao altere o mapa recebido.',
 50,
 'def contar_ilhas(mapa):
    # TODO: implementar
    return 0'),

('Agrupar com Chave Composta (Python)',
 'Escreva a funcao consolidar(vendas) que devolve o total vendido por combinacao de regiao e produto.',
 'Relatorio gerencial quase nunca agrupa por uma coluna so. A questao mede se a pessoa monta a chave composta corretamente e se sabe que tupla serve de chave em dicionario justamente porque e imutavel, ao contrario de lista.',
 'Uma lista de dicionarios com as chaves regiao, produto e valor.',
 'Um dicionario cuja chave e a tupla (regiao, produto) e o valor e o total vendido, ordenado do maior total para o menor quando convertido em lista.',
 'Entrada: [{"regiao": "sul", "produto": "x", "valor": 10}, {"regiao": "sul", "produto": "x", "valor": 5}]
Saida: {("sul", "x"): 15}',
 'A chave precisa ser imutavel: lista nao serve como chave de dicionario. Nao use pandas.',
 40,
 'def consolidar(vendas):
    # TODO: implementar
    return {}'),

('Maior Sequencia sem Repetir (Python)',
 'Escreva a funcao maior_sequencia(texto) que devolve o tamanho da maior sequencia de caracteres consecutivos sem repeticao.',
 'E o exercicio classico de janela deslizante, e aparece em analise de sessao e deteccao de padrao em fluxo. A versao ingenua testa todas as sequencias possiveis e e quadratica; a versao com janela e uma varredura so, e essa e a conversa que o entrevistador quer ter.',
 'Uma string que pode estar vazia e pode ter qualquer caractere.',
 'Um inteiro com o tamanho da maior sequencia sem caractere repetido. Texto vazio devolve 0.',
 'Entrada: "abcabcbb"
Saida: 3

Entrada: "bbbb"
Saida: 1',
 'Resolva em uma unica varredura, sem testar todas as sequencias possiveis.',
 45,
 'def maior_sequencia(texto):
    # TODO: implementar
    return 0')

) AS v (titulo, descricao, contexto, formato_entrada, formato_saida, exemplo, restricoes, tempo, template)
CROSS JOIN tecnologias t
WHERE t.nome = 'Python'
  AND NOT EXISTS (SELECT 1 FROM desafios d WHERE d.titulo = v.titulo);


INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Cache LRU (Python)', 'Declara a classe CacheLRU com get e put', 'def\s+get\s*\([\s\S]*def\s+put\s*\(', 'OBRIGATORIO', 1, 'A classe precisa expor os dois metodos pedidos, get e put.'),
('Cache LRU (Python)', 'Usa estrutura que preserva ordem de uso', '(OrderedDict|dict\s*\(|\{\s*\})', 'OBRIGATORIO', 1, 'Desde o Python 3.7 o dict comum ja mantem a ordem de insercao, e OrderedDict expoe o move_to_end.'),
('Cache LRU (Python)', 'Marca a chave como recem-usada no get', '(move_to_end|pop\s*\(|del\s+)', 'PONTUAVEL', 3, 'get tambem e escrita nesta estrutura: ler uma chave a torna a mais recente.'),
('Cache LRU (Python)', 'Descarta o item menos recente ao estourar', '(popitem|next\s*\(\s*iter|del\s+)', 'PONTUAVEL', 3, 'Quando a capacidade estoura, sai o item usado ha mais tempo.'),
('Cache LRU (Python)', 'Devolve -1 para chave ausente', '-\s*1', 'PONTUAVEL', 2, 'Chave inexistente devolve -1, e nao None nem excecao.'),
('Cache LRU (Python)', 'Nao varra o cache atras do mais antigo', 'for\s+\w+\s+in\s+self\.', 'PROIBIDO', 1, 'Percorrer o cache torna a operacao linear: o enunciado pede O(1).'),

('Ordem de Execucao das Tarefas (Python)', 'Declara a funcao ordenar_tarefas', 'def\s+ordenar_tarefas\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar ordenar_tarefas e receber as dependencias.'),
('Ordem de Execucao das Tarefas (Python)', 'Detecta a dependencia circular', '(visitando|temporari|ciclo|cinza|in_stack|estado)', 'OBRIGATORIO', 1, 'Sem marcar o que esta sendo visitado, o ciclo vira recursao infinita.'),
('Ordem de Execucao das Tarefas (Python)', 'Percorre as dependencias de cada tarefa', 'for\s+\w+\s+in', 'PONTUAVEL', 3, 'Cada tarefa precisa ter suas dependencias resolvidas antes dela.'),
('Ordem de Execucao das Tarefas (Python)', 'Marca as tarefas ja resolvidas', '(set\s*\(|visitad|resolvid)', 'PONTUAVEL', 3, 'Sem marcar o que ja saiu, a mesma tarefa entra duas vezes no resultado.'),
('Ordem de Execucao das Tarefas (Python)', 'Devolve lista vazia quando ha ciclo', 'return\s+\[\s*\]', 'PONTUAVEL', 2, 'O enunciado pede lista vazia no ciclo, sem lancar excecao.'),
('Ordem de Execucao das Tarefas (Python)', 'Nao use graphlib pronto', 'graphlib', 'PROIBIDO', 1, 'O enunciado pede a ordenacao topologica escrita na mao.'),

('Juntar K Listas Ordenadas (Python)', 'Declara a funcao juntar', 'def\s+juntar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar juntar e receber a lista de listas.'),
('Juntar K Listas Ordenadas (Python)', 'Usa fila de prioridade', '(heapq|heappush|heappop|merge)', 'OBRIGATORIO', 1, 'A fila de prioridade escolhe o proximo menor entre as listas sem reordenar tudo.'),
('Juntar K Listas Ordenadas (Python)', 'Aproveita que cada lista ja esta ordenada', '(\[\s*0\s*\]|heappop|indice|pos)', 'PONTUAVEL', 3, 'O proximo candidato de cada lista e sempre o primeiro elemento ainda nao consumido.'),
('Juntar K Listas Ordenadas (Python)', 'Avanca na lista de onde veio o menor', '(heappush|\+\s*1|indice)', 'PONTUAVEL', 3, 'Depois de consumir um elemento, o proximo daquela lista entra na disputa.'),
('Juntar K Listas Ordenadas (Python)', 'Trata a lista interna vazia', '(if\s+|len\s*\(|not\s+)', 'PONTUAVEL', 2, 'Lista vazia no meio da entrada nao pode quebrar a leitura do primeiro elemento.'),
('Juntar K Listas Ordenadas (Python)', 'Nao concatene tudo e ordene no fim', '(sorted\s*\(\s*\[?\s*\w+\s*\)|\.sort\s*\(\s*\))', 'PROIBIDO', 1, 'Ordenar o resultado concatenado joga fora a ordenacao que ja existia na entrada.'),

('Limitador de Requisicoes (Python)', 'Declara a funcao permitir', 'def\s+permitir\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar permitir e receber historico, agora, limite e janela.'),
('Limitador de Requisicoes (Python)', 'Descarta o que saiu da janela', '(agora\s*-\s*janela|>\s*agora\s*-|>=)', 'OBRIGATORIO', 1, 'So conta quem esta dentro da janela que termina agora.'),
('Limitador de Requisicoes (Python)', 'Conta as requisicoes que restaram', '(len\s*\(|sum\s*\(|count)', 'PONTUAVEL', 3, 'Depois de descartar as antigas, o que sobra e comparado com o limite.'),
('Limitador de Requisicoes (Python)', 'Compara com o limite', '(<\s*limite|>=\s*limite|<=)', 'PONTUAVEL', 3, 'Atingido o limite, a proxima requisicao e recusada.'),
('Limitador de Requisicoes (Python)', 'Devolve booleano', '(return\s+(True|False)|return\s+\w+\s*<)', 'PONTUAVEL', 2, 'A resposta e True ou False.'),
('Limitador de Requisicoes (Python)', 'Nao conte por minuto cheio', '(%\s*60|//\s*60)', 'PROIBIDO', 1, 'Janela por minuto cheio deixa passar o dobro do limite na virada do minuto.'),

('Diferenca entre Dois Dicionarios (Python)', 'Declara a funcao diferenca', 'def\s+diferenca\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar diferenca e receber os dois dicionarios.'),
('Diferenca entre Dois Dicionarios (Python)', 'Desce nos dicionarios aninhados', '(diferenca\s*\(|isinstance)', 'OBRIGATORIO', 1, 'Valor que tambem e dicionario precisa ser comparado nivel a nivel.'),
('Diferenca entre Dois Dicionarios (Python)', 'Cobre as chaves dos dois lados', '(\||union|set\s*\(|keys\s*\(\s*\))', 'PONTUAVEL', 3, 'Percorrer so um dos lados perde a chave que surgiu ou que sumiu.'),
('Diferenca entre Dois Dicionarios (Python)', 'Usa None para a chave ausente', 'None', 'PONTUAVEL', 3, 'Chave presente de um lado so aparece com None no outro.'),
('Diferenca entre Dois Dicionarios (Python)', 'Registra o par antes e depois', '(\(\s*\w+\s*,|tuple)', 'PONTUAVEL', 2, 'Cada mudanca vira uma tupla com o valor antigo e o novo.'),
('Diferenca entre Dois Dicionarios (Python)', 'Nao compare os dicionarios como texto', '(str\s*\(\s*antes|json\.dumps)', 'PROIBIDO', 1, 'Comparar a representacao em texto diz que mudou, mas nao diz o que mudou.'),

('Reexecucao com Espera Progressiva (Python)', 'Declara a funcao calcular_esperas', 'def\s+calcular_esperas\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar calcular_esperas e receber tentativas, base e teto.'),
('Reexecucao com Espera Progressiva (Python)', 'Dobra a espera a cada tentativa', '(\*\s*2|\*\*|<<)', 'OBRIGATORIO', 1, 'O crescimento e exponencial: cada espera e o dobro da anterior.'),
('Reexecucao com Espera Progressiva (Python)', 'Aplica o teto', 'min\s*\(', 'PONTUAVEL', 3, 'Sem o teto, a espera cresce sem limite e a tentativa nunca acontece.'),
('Reexecucao com Espera Progressiva (Python)', 'Comeca pela espera base', 'base', 'PONTUAVEL', 3, 'A primeira espera e a base informada, nao o dobro dela.'),
('Reexecucao com Espera Progressiva (Python)', 'Devolve uma espera por tentativa', '(range\s*\(|append\s*\()', 'PONTUAVEL', 2, 'A lista tem exatamente uma espera para cada tentativa pedida.'),
('Reexecucao com Espera Progressiva (Python)', 'Nao durma dentro da funcao', '(sleep|time\.sleep)', 'PROIBIDO', 1, 'A funcao apenas calcula: dormir aqui travaria qualquer teste.'),

('Contar Ilhas no Mapa (Python)', 'Declara a funcao contar_ilhas', 'def\s+contar_ilhas\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar contar_ilhas e receber o mapa.'),
('Contar Ilhas no Mapa (Python)', 'Marca as posicoes ja visitadas', '(visitad|set\s*\(|seen)', 'OBRIGATORIO', 1, 'Sem marcar o visitado, a mesma ilha e contada varias vezes e a busca nao termina.'),
('Contar Ilhas no Mapa (Python)', 'Percorre a vizinhanca', '(\+\s*1|-\s*1|dx|dy|direc)', 'PONTUAVEL', 3, 'De cada posicao ocupada, a busca segue para os quatro vizinhos.'),
('Contar Ilhas no Mapa (Python)', 'Respeita os limites do mapa', '(len\s*\(|0\s*<=|<\s*len)', 'PONTUAVEL', 3, 'Indice negativo em Python nao estoura: ele acessa o outro extremo e junta ilhas separadas.'),
('Contar Ilhas no Mapa (Python)', 'Conta uma ilha por grupo iniciado', '\+=\s*1', 'PONTUAVEL', 2, 'O contador sobe uma vez por grupo, e nao uma vez por posicao ocupada.'),
('Contar Ilhas no Mapa (Python)', 'Nao altere o mapa recebido', 'mapa\s*\[\s*\w+\s*\]\s*\[\s*\w+\s*\]\s*=', 'PROIBIDO', 1, 'Marcar o visitado no proprio mapa altera a estrutura de quem chamou a funcao.'),

('Agrupar com Chave Composta (Python)', 'Declara a funcao consolidar', 'def\s+consolidar\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar consolidar e receber as vendas.'),
('Agrupar com Chave Composta (Python)', 'Monta a chave composta', '\(\s*\w+\s*\[[^\]]+\]\s*,', 'OBRIGATORIO', 1, 'A chave junta regiao e produto numa tupla.'),
('Agrupar com Chave Composta (Python)', 'Acumula o total por chave', '(get\s*\(|setdefault|\+=)', 'PONTUAVEL', 3, 'Chave nova comeca em zero e vai somando; get com padrao evita KeyError.'),
('Agrupar com Chave Composta (Python)', 'Usa as duas colunas de agrupamento', 'regiao[\s\S]{0,80}produto', 'PONTUAVEL', 3, 'As duas colunas precisam entrar na chave, senao o agrupamento fica errado.'),
('Agrupar com Chave Composta (Python)', 'Soma a coluna de valor', 'valor', 'PONTUAVEL', 2, 'O total acumulado vem da coluna valor.'),
('Agrupar com Chave Composta (Python)', 'Nao use lista como chave', '\[\s*\w+\[.regiao.\]\s*,', 'PROIBIDO', 1, 'Lista e mutavel e nao pode ser chave de dicionario: use tupla.'),

('Maior Sequencia sem Repetir (Python)', 'Declara a funcao maior_sequencia', 'def\s+maior_sequencia\s*\(', 'OBRIGATORIO', 1, 'A funcao precisa se chamar maior_sequencia e receber o texto.'),
('Maior Sequencia sem Repetir (Python)', 'Mantem uma janela sobre o texto', '(inicio|esquerda|left|start)', 'OBRIGATORIO', 1, 'A janela guarda onde a sequencia atual comeca.'),
('Maior Sequencia sem Repetir (Python)', 'Guarda a ultima posicao de cada caractere', '(\{\s*\}|dict\s*\(|set\s*\()', 'PONTUAVEL', 3, 'Saber onde o caractere apareceu antes permite mover a janela de uma vez.'),
('Maior Sequencia sem Repetir (Python)', 'Move o inicio ao encontrar repeticao', '(max\s*\(|=\s*\w+\s*\+\s*1)', 'PONTUAVEL', 3, 'Ao repetir, o inicio salta para depois da ocorrencia anterior.'),
('Maior Sequencia sem Repetir (Python)', 'Atualiza o maior tamanho', 'max\s*\(', 'PONTUAVEL', 2, 'O resultado e o maior tamanho ja visto, e nao o tamanho da janela final.'),
('Maior Sequencia sem Repetir (Python)', 'Nao teste todas as sequencias possiveis', 'for\s+\w+\s+in\s+range[\s\S]{0,120}for\s+\w+\s+in\s+range', 'PROIBIDO', 1, 'O laco duplo e quadratico: o enunciado pede uma unica varredura.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'Python'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
