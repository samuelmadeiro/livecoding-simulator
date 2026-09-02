-- Reparo do catalogo Python.
--
-- Duas coisas ficaram para tras quando os catalogos novos foram aplicados sobre o seed original:
--
--   1. Media de Notas e Verificador de Palindromo ja existiam desde a V3. Como as migrations de
--      catalogo nao duplicam titulo, o desafio antigo permaneceu e recebeu, alem da sua regua
--      original, os criterios escritos para a versao nova. Os dois acabaram com onze criterios,
--      cobrando a mesma coisa duas vezes com textos diferentes.
--
--   2. Alguns criterios do catalogo Python nao chegaram a existir, porque a descricao coincidia
--      com a de um criterio ja gravado em outro desafio de mesmo titulo.
--
-- Este script deixa os dois desafios com a regua nova, unica, e recoloca o que faltava. E
-- idempotente: num banco criado do zero as migrations anteriores ja deixam tudo no lugar e cada
-- comando aqui vira no-op.
--
-- Escrito so com subconsulta: DELETE ... USING e UPDATE ... FROM sao sintaxe de PostgreSQL, e
-- estas migrations tambem rodam no H2 em modo de compatibilidade.

-- 1. Nos dois desafios herdados da V3, mantem apenas os criterios da regua nova.
DELETE FROM criterios_avaliacao
WHERE desafio_id IN (
    SELECT d.id FROM desafios d
    JOIN tecnologias t ON t.id = d.tecnologia_id
    WHERE t.nome = 'Python'
      AND d.titulo IN ('Media de Notas', 'Verificador de Palindromo')
)
AND descricao NOT IN (
    'Compara o texto com ele invertido',
    'Declara a funcao eh_palindromo',
    'Declara a funcao media',
    'Descarta espacos e pontuacao',
    'Devolve booleano',
    'Devolve o resultado com return',
    'Divide pela quantidade de notas',
    'Nao leia dados do teclado',
    'Normaliza maiuscula e minuscula',
    'Protege a lista vazia antes de dividir',
    'Soma as notas'
);

-- 2. O Verificador de Palindromo nasceu como JUNIOR na V3, mas o enunciado reescrito e de estagio.
UPDATE desafios
SET nivel = 'ESTAGIO'
WHERE titulo = 'Verificador de Palindromo'
  AND tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Python');

-- 3. Recoloca os criterios que ficaram faltando nos desafios de Python.
INSERT INTO criterios_avaliacao (desafio_id, descricao, padrao, tipo, peso, dica)
SELECT d.id, v.descricao, v.padrao, v.tipo, v.peso, v.dica
FROM (VALUES

('Total do Carrinho', 'Percorre os itens do carrinho', '(for\s+\w+\s+in|sum\s*\()', 'OBRIGATORIO', 1, 'Sem percorrer a lista nao da para somar item a item. Um for ou um sum com generator resolve.'),
('Total do Carrinho', 'Multiplica preco por quantidade', '(preco[^\n]*\*|\*[^\n]*quantidade|\[.preco.\]\s*\*)', 'PONTUAVEL', 3, 'Somar so o preco ignora quem levou tres unidades. O total e preco vezes quantidade.'),
('Total do Carrinho', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A lista chega por parametro. input travaria o servico esperando alguem digitar.'),
('Filtrar Maiores de Idade', 'Aplica o corte de 18 anos ou mais', '>=\s*18', 'PONTUAVEL', 3, 'O enunciado diz 18 anos ou mais: com > 18 quem tem exatamente 18 fica de fora.'),
('Filtrar Maiores de Idade', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista filtrada precisa voltar como retorno.'),
('Validar Senha Forte', 'Verifica o tamanho minimo', '(len\s*\(|>=\s*8|<\s*8)', 'OBRIGATORIO', 1, 'A primeira regra e ter ao menos 8 caracteres, e len responde isso.'),
('Validar Senha Forte', 'Verifica maiuscula e minuscula', '(isupper|islower|any\s*\()', 'PONTUAVEL', 3, 'Faltou checar as duas caixas. isupper e islower dentro de um any resolvem.'),
('Validar Senha Forte', 'Verifica a presenca de digito', '(isdigit|isnumeric|0-9)', 'PONTUAVEL', 3, 'A regra do numero ficou de fora: isdigit identifica o algarismo.'),
('Contar Aprovados e Reprovados', 'Percorre as notas', '(for\s+\w+\s+in|sum\s*\(|len\s*\()', 'OBRIGATORIO', 1, 'E preciso varrer a lista para classificar cada nota.'),
('Contar Aprovados e Reprovados', 'Aplica o corte em 6', '>=\s*6', 'PONTUAVEL', 3, 'Nota 6 aprova. Com > 6 quem tirou exatamente 6 seria reprovado por engano.'),
('Contar Aprovados e Reprovados', 'Mantem os dois contadores', '(\+=|aprovados|reprovados)', 'PONTUAVEL', 3, 'Conte os dois grupos de verdade, em vez de deduzir um por subtracao.'),
('Achatar Lista de Listas', 'Percorre as listas internas', 'for\s+\w+\s+in', 'OBRIGATORIO', 1, 'E preciso passar por cada lista interna para pegar seus elementos.'),
('Achatar Lista de Listas', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista achatada precisa voltar como retorno.'),
('Interseccao de Duas Listas', 'Testa a presenca na segunda lista', '(in\s+segunda|in\s+\w+|intersection)', 'OBRIGATORIO', 1, 'O operador in responde se o item da primeira lista existe na segunda.'),
('Interseccao de Duas Listas', 'Percorre a primeira lista', 'for\s+\w+\s+in', 'PONTUAVEL', 3, 'A ordem do resultado segue a primeira lista, entao e ela que deve ser percorrida.'),
('Interseccao de Duas Listas', 'Evita repetir item no resultado', '(not\s+in|set\s*\(|vistos)', 'PONTUAVEL', 3, 'O 2 aparece duas vezes na entrada e nao pode sair duas vezes no resultado.'),
('Interseccao de Duas Listas', 'Devolve a lista com return', 'return\s+\S+', 'PONTUAVEL', 2, 'A lista de comuns precisa voltar como retorno.'),
('Troco em Notas', 'Percorre as notas da maior para a menor', '(100[\s\S]{0,40}50[\s\S]{0,40}20|for\s+\w+\s+in\s*[\(\[])', 'OBRIGATORIO', 1, 'A ordem 100, 50, 20, 10 e o que garante o menor numero de notas.'),
('Troco em Notas', 'Atualiza o valor restante', '(%|-=|resto|restante)', 'PONTUAVEL', 3, 'Depois de separar as notas, o que sobra continua para a proxima: use o resto.'),
('Verificar Anagrama', 'Compara as letras das duas palavras', '(sorted\s*\(|==)', 'OBRIGATORIO', 1, 'Ordenar as letras das duas e compara-las e o caminho mais direto.'),
('Verificar Anagrama', 'Descarta os espacos', '(replace\s*\(|split\s*\(|join\s*\(|strip\s*\()', 'PONTUAVEL', 3, 'Espaco conta como caractere e estraga a comparacao.'),
('Media por Materia', 'Calcula a media de cada lista', '(sum\s*\(|len\s*\(|/)', 'PONTUAVEL', 3, 'A media de cada materia e a soma das notas dividida pela quantidade.'),
('Media por Materia', 'Protege a materia sem nota', '(if\s|len\s*\(|not\s+\w+)', 'PONTUAVEL', 3, 'Lista vazia divide por zero. O enunciado manda devolver 0 nesse caso.'),
('Item Mais Frequente', 'Compara as contagens', '(>|max\s*\()', 'PONTUAVEL', 3, 'Depois de contar, e preciso comparar para achar a maior contagem.'),
('Item Mais Frequente', 'Resolve o empate pela primeira aparicao', '(>|for\s+\w+\s+in)', 'PONTUAVEL', 3, 'Use > e nao >= ao comparar: assim o primeiro a atingir a contagem permanece.'),
('Item Mais Frequente', 'Devolve o item com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O item, e nao a contagem, precisa voltar como retorno.'),
('Maior Palavra da Frase', 'Separa a frase em palavras', 'split\s*\(', 'OBRIGATORIO', 1, 'Sem separar nao ha palavras para comparar.'),
('Maior Palavra da Frase', 'Compara o tamanho das palavras', '(len\s*\(|max\s*\()', 'PONTUAVEL', 3, 'O criterio e o comprimento: len de cada palavra.'),
('Maior Palavra da Frase', 'Resolve o empate pela primeira', '(>|max\s*\()', 'PONTUAVEL', 3, 'Use > e nao >=: assim a primeira palavra do empate permanece.'),
('Maior Palavra da Frase', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A frase chega por parametro.'),
('Todos os Numeros Positivos', 'Usa a comparacao maior que zero', '>\s*0', 'PONTUAVEL', 3, 'Zero nao e positivo, entao a comparacao e > 0 e nao >= 0.'),
('Somar Numeros em Texto', 'Converte o texto para numero', 'int\s*\(', 'OBRIGATORIO', 1, 'Sem int(), o Python concatena as strings em vez de somar.'),
('Somar Numeros em Texto', 'Acumula o total', '(sum\s*\(|\+=)', 'PONTUAVEL', 3, 'Os valores convertidos precisam ser somados num total.'),
('Somar Numeros em Texto', 'Devolve a soma com return', 'return\s+\S+', 'PONTUAVEL', 2, 'O total precisa voltar como retorno.'),
('Somar Numeros em Texto', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'A lista chega por parametro.'),
('Percentual de Tarefas Concluidas', 'Conta as tarefas concluidas', '(concluida|sum\s*\(|for\s+\w+\s+in)', 'OBRIGATORIO', 1, 'E preciso contar quantas tarefas tem concluida verdadeira.'),
('Repetir Texto com Separador', 'Usa o separador entre os itens', '(,\s|join\s*\()', 'OBRIGATORIO', 1, 'O separador ", " entra entre os itens, nunca no fim.'),
('Repetir Texto com Separador', 'Repete conforme o parametro vezes', '(vezes|range\s*\(|\*\s*vezes)', 'PONTUAVEL', 3, 'A quantidade de repeticoes vem por parametro, nao pode ser fixa.'),
('Repetir Texto com Separador', 'Trata vezes igual a zero', '(if\s|range\s*\(|not\s+vezes)', 'PONTUAVEL', 2, 'Com vezes igual a 0 a saida e string vazia, sem separador nenhum.'),
('Contar Tipos de Caractere', 'Identifica as letras', '(isalpha|isalnum)', 'PONTUAVEL', 3, 'isalpha responde se o caractere e letra.'),
('Contar Tipos de Caractere', 'Identifica os digitos', '(isdigit|isnumeric)', 'PONTUAVEL', 3, 'isdigit responde se o caractere e algarismo.'),
('Contar Tipos de Caractere', 'Nao leia dados do teclado', 'input\s*\(', 'PROIBIDO', 1, 'O texto chega por parametro.')

) AS v (desafio_titulo, descricao, padrao, tipo, peso, dica)
JOIN desafios d ON d.titulo = v.desafio_titulo
JOIN tecnologias t ON t.id = d.tecnologia_id AND t.nome = 'Python'
WHERE NOT EXISTS (
    SELECT 1 FROM criterios_avaliacao c
    WHERE c.desafio_id = d.id AND c.descricao = v.descricao
);
