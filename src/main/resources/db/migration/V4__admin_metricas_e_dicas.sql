-- Painel do admin, tempo por tentativa e dica por criterio.
--
-- Tres coisas entram aqui:
--   1. tentativas    -> ancora o cronometro no servidor. O tempo gasto nao pode vir do cliente:
--                       quem envia a submissao envia o que quiser no corpo.
--   2. resultados_criterio -> guarda o que cada submissao atendeu, criterio a criterio. Sem isso
--                       nao da para dizer qual criterio mais reprova num desafio, so a nota final.
--   3. dica          -> o texto que o entrevistador simulado fala quando o criterio falha.
--                       Igual ao padrao, mora no banco: ajustar a fala nao recompila nada.

CREATE TABLE tentativas (
    id            BIGSERIAL PRIMARY KEY,
    usuario_id    BIGINT    NOT NULL REFERENCES usuarios (id),
    desafio_id    BIGINT    NOT NULL REFERENCES desafios (id),
    iniciado_em   TIMESTAMP NOT NULL,
    finalizado_em TIMESTAMP
);

CREATE INDEX idx_tentativas_usuario_desafio ON tentativas (usuario_id, desafio_id);

-- Tempo gasto e precisao ficam na submissao: sao o que o painel do admin agrega.
ALTER TABLE submissoes ADD COLUMN duracao_segundos INTEGER;
ALTER TABLE submissoes ADD COLUMN precisao INTEGER;

CREATE INDEX idx_submissoes_usuario ON submissoes (usuario_id);
CREATE INDEX idx_submissoes_desafio ON submissoes (desafio_id);

CREATE TABLE resultados_criterio (
    id           BIGSERIAL    PRIMARY KEY,
    submissao_id BIGINT       NOT NULL REFERENCES submissoes (id) ON DELETE CASCADE,
    -- ON DELETE SET NULL: apagar um criterio nao pode apagar o historico de correcao.
    criterio_id  BIGINT       REFERENCES criterios_avaliacao (id) ON DELETE SET NULL,
    -- Copia do texto no momento da correcao. Se o criterio mudar depois, o historico continua
    -- dizendo o que foi cobrado naquele dia.
    descricao    VARCHAR(200) NOT NULL,
    tipo         VARCHAR(20)  NOT NULL,
    peso         INTEGER      NOT NULL DEFAULT 1,
    atendido     BOOLEAN      NOT NULL
);

CREATE INDEX idx_resultados_submissao ON resultados_criterio (submissao_id);
CREATE INDEX idx_resultados_criterio ON resultados_criterio (criterio_id);

-- Dica mostrada quando o criterio falha. Aponta o caminho sem entregar a solucao pronta.
ALTER TABLE criterios_avaliacao ADD COLUMN dica VARCHAR(300);

UPDATE criterios_avaliacao SET dica = 'Apague o TODO do template. Codigo entregue com TODO diz para o entrevistador que a solucao parou no meio.' WHERE descricao = 'Nao deixe o TODO do template no codigo';
UPDATE criterios_avaliacao SET dica = 'A funcao precisa entregar o resultado a quem chamou: feche com return em vez de so imprimir ou guardar numa variavel.' WHERE descricao = 'Devolve o resultado com return';
UPDATE criterios_avaliacao SET dica = 'Declare a rota de leitura no roteador (router.get / app.get) apontando para o handler.' WHERE descricao = 'Registra a rota de leitura';
UPDATE criterios_avaliacao SET dica = 'Marque o metodo que responde a consulta com o verbo GET (@GetMapping ou equivalente). Sem isso a rota nao existe.' WHERE descricao = 'Expoe um endpoint de leitura (GET)';
UPDATE criterios_avaliacao SET dica = 'Ler o token nao basta: valide a assinatura com a chave secreta antes de confiar no conteudo dele.' WHERE descricao = 'Verifica a assinatura do token';
UPDATE criterios_avaliacao SET dica = 'Cheque os campos antes de salvar. Anotacoes de validacao ou um if explicito no comeco do metodo ja resolvem.' WHERE descricao = 'Valida os dados recebidos';
UPDATE criterios_avaliacao SET dica = 'Titulo vazio ou nulo nao pode virar registro: valide antes de chamar o banco.' WHERE descricao = 'Valida o titulo antes de salvar';
UPDATE criterios_avaliacao SET dica = 'Um mapa de chave para lista evita varrer tudo de novo a cada palavra. Pense em qual chave junta os anagramas.' WHERE descricao = 'Usa um Map para indexar os grupos';
UPDATE criterios_avaliacao SET dica = 'Troque x, y e aux por nomes que digam o que a variavel guarda. Quem le seu codigo na entrevista e uma pessoa.' WHERE descricao = 'Usa nomes de variavel descritivos';
UPDATE criterios_avaliacao SET dica = 'Data final antes da inicial e erro do cliente: responda 400, nao 500 nem uma lista vazia silenciosa.' WHERE descricao = 'Trata periodo invalido com erro HTTP';
UPDATE criterios_avaliacao SET dica = 'Decida o que devolver quando o array chega vazio antes de acessar a primeira posicao.' WHERE descricao = 'Trata o array vazio sem quebrar';
UPDATE criterios_avaliacao SET dica = 'Normalize o texto antes de comparar (toLowerCase e afins), senao A e a viram casos diferentes.' WHERE descricao = 'Trata maiusculas e minusculas';
UPDATE criterios_avaliacao SET dica = 'Use trim e cuide de espacos repetidos. Entrada suja e a regra, nao a excecao.' WHERE descricao = 'Trata espacos extras na entrada';
UPDATE criterios_avaliacao SET dica = 'Media de lista vazia e divisao por zero: trate esse caso antes da conta.' WHERE descricao = 'Trata a lista vazia antes de dividir';
UPDATE criterios_avaliacao SET dica = 'Anote os parametros com o tipo esperado: o FastAPI valida e documenta a rota a partir dessa anotacao.' WHERE descricao = 'Tipa os parametros para o FastAPI validar';
UPDATE criterios_avaliacao SET dica = 'Paridade sai do resto da divisao por 2 (n % 2 == 0).' WHERE descricao = 'Testa a paridade do numero';
UPDATE criterios_avaliacao SET dica = 'Agregue com SUM na propria consulta em vez de trazer as linhas e somar na aplicacao.' WHERE descricao = 'Soma o valor dos pedidos';
UPDATE criterios_avaliacao SET dica = 'Acumule as notas num total antes de dividir pela quantidade.' WHERE descricao = 'Soma as notas da lista';
UPDATE criterios_avaliacao SET dica = 'Quebre a frase por espaco (split) antes de mexer na ordem.' WHERE descricao = 'Separa a frase em palavras';
UPDATE criterios_avaliacao SET dica = 'Middleware que aprova precisa chamar next(), senao a requisicao morre nele e o cliente fica esperando.' WHERE descricao = 'Segue a cadeia de middlewares com next()';
UPDATE criterios_avaliacao SET dica = 'Sem token valido, responda 401 e interrompa a cadeia. Deixar passar e falha de seguranca, nao detalhe.' WHERE descricao = 'Responde 401 quando o token falta ou nao vale';
UPDATE criterios_avaliacao SET dica = 'Criou, 201. Corpo invalido, 400. O status faz parte do contrato da API tanto quanto o corpo.' WHERE descricao = 'Responde 201 ao criar e 400 quando o corpo e invalido';
UPDATE criterios_avaliacao SET dica = 'Criacao devolve 201 com o recurso criado; 200 e resposta de leitura.' WHERE descricao = 'Responde 201 Created em vez do 200 padrao';
UPDATE criterios_avaliacao SET dica = 'Depois de inverter, junte as palavras de volta numa string com join e um espaco.' WHERE descricao = 'Remonta a frase numa string';
UPDATE criterios_avaliacao SET dica = 'Ligue as tabelas pela chave estrangeira no JOIN (cliente.id = pedido.cliente_id).' WHERE descricao = 'Relaciona clientes com pedidos';
UPDATE criterios_avaliacao SET dica = 'Declare a rota de escrita no roteador (router.post) apontando para o handler.' WHERE descricao = 'Registra a rota de escrita';
UPDATE criterios_avaliacao SET dica = 'Filtre a data no WHERE pelos ultimos 12 meses em vez de trazer o historico inteiro.' WHERE descricao = 'Recorta a janela de 12 meses';
UPDATE criterios_avaliacao SET dica = 'Aceite pagina e tamanho vindos da requisicao (Pageable ou dois @RequestParam).' WHERE descricao = 'Recebe os parametros de paginacao';
UPDATE criterios_avaliacao SET dica = 'O intervalo e do cliente: receba inicio e fim como parametro em vez de fixar no codigo.' WHERE descricao = 'Recebe o periodo como parametro';
UPDATE criterios_avaliacao SET dica = 'LEFT JOIN mantem o cliente sem pedido; INNER JOIN some com ele e a resposta fica errada.' WHERE descricao = 'Preserva os clientes sem correspondencia';
UPDATE criterios_avaliacao SET dica = 'Salve pela camada de dados (repository.save ou um service). Controller nao conversa direto com o banco.' WHERE descricao = 'Persiste o cliente por um repositorio ou service';
UPDATE criterios_avaliacao SET dica = 'Aceite o criterio de ordenacao (sort) e repasse para a consulta.' WHERE descricao = 'Permite ordenar o resultado';
UPDATE criterios_avaliacao SET dica = 'Voce precisa visitar cada caractere: um for, um while ou um stream sobre chars().' WHERE descricao = 'Percorre o texto com laco ou stream';
UPDATE criterios_avaliacao SET dica = 'Um laco sobre o array e o minimo: sem ele nao ha o que somar nem comparar.' WHERE descricao = 'Percorre o array';
UPDATE criterios_avaliacao SET dica = 'Depois do split, itere sobre as palavras para montar o resultado.' WHERE descricao = 'Percorre a lista de palavras';
UPDATE criterios_avaliacao SET dica = 'ORDER BY na coluna do mes com DESC deixa o periodo mais recente no topo.' WHERE descricao = 'Ordena do mes mais recente para o mais antigo';
UPDATE criterios_avaliacao SET dica = 'Leve tudo para o mesmo caso antes de comparar ou agrupar.' WHERE descricao = 'Normaliza maiusculas e minusculas';
UPDATE criterios_avaliacao SET dica = 'A chave precisa ser igual para Amor e Roma: ordene as letras da palavra ja normalizada.' WHERE descricao = 'Normaliza a palavra para gerar a chave do grupo';
UPDATE criterios_avaliacao SET dica = 'Deixe filtro e agregacao no banco. SELECT * e filtrar na aplicacao funciona no teste e cai em producao.' WHERE descricao = 'Nao carregue a tabela inteira em memoria';
UPDATE criterios_avaliacao SET dica = 'Percorra os valores do mapa para montar a lista de saida.' WHERE descricao = 'Monta a lista de saida a partir dos grupos';
UPDATE criterios_avaliacao SET dica = 'O caminho /produtos precisa aparecer no mapeamento da classe ou do metodo.' WHERE descricao = 'Mapeia a rota /produtos';
UPDATE criterios_avaliacao SET dica = 'O token chega no header Authorization: leia esse header antes de qualquer validacao.' WHERE descricao = 'Le o header Authorization';
UPDATE criterios_avaliacao SET dica = 'O corpo do POST precisa ser lido (req.body ou equivalente) antes de validar qualquer campo.' WHERE descricao = 'Le o corpo da requisicao no POST';
UPDATE criterios_avaliacao SET dica = 'Marque o parametro que recebe o JSON do cliente (@RequestBody) para o corpo chegar no metodo.' WHERE descricao = 'Le o corpo da requisicao';
UPDATE criterios_avaliacao SET dica = 'Inverta a colecao de palavras, nao os caracteres da frase.' WHERE descricao = 'Inverte a ordem das palavras';
UPDATE criterios_avaliacao SET dica = 'Depois do LEFT JOIN, sobre so quem nao comprou: filtre por IS NULL ou pelo HAVING da contagem.' WHERE descricao = 'Filtra quem nao tem pedido';
UPDATE criterios_avaliacao SET dica = 'A tabela de pedidos precisa entrar na consulta: e de la que vem o valor.' WHERE descricao = 'Faz uma consulta na tabela de pedidos';
UPDATE criterios_avaliacao SET dica = 'Comece pela tabela de clientes: e ela que define quem aparece no resultado.' WHERE descricao = 'Faz uma consulta na tabela de clientes';
UPDATE criterios_avaliacao SET dica = 'Marque o metodo de criacao com POST (@PostMapping). GET nao cria recurso.' WHERE descricao = 'Expoe um endpoint de escrita (POST)';
UPDATE criterios_avaliacao SET dica = 'Media e soma dividida pelo tamanho da lista. Cuidado com divisao inteira comendo as casas decimais.' WHERE descricao = 'Divide pela quantidade de elementos';
UPDATE criterios_avaliacao SET dica = 'Devolva Page ou Slice, com total e pagina. Uma List crua joga fora a informacao de paginacao.' WHERE descricao = 'Devolve um resultado paginado, nao uma List crua';
UPDATE criterios_avaliacao SET dica = 'Feche a funcao devolvendo a colecao de grupos que voce montou.' WHERE descricao = 'Devolve os grupos com return';
UPDATE criterios_avaliacao SET dica = 'A pergunta e sim ou nao: devolva boolean, nao a palavra sim ou true como texto.' WHERE descricao = 'Devolve booleano em vez de string';
UPDATE criterios_avaliacao SET dica = 'O header vem como Bearer <token>: corte o prefixo antes de validar a assinatura.' WHERE descricao = 'Descarta o prefixo Bearer antes de validar';
UPDATE criterios_avaliacao SET dica = 'Antes de comparar, limpe o que nao e letra: palindromo ignora espaco e pontuacao.' WHERE descricao = 'Descarta espacos e pontuacao';
UPDATE criterios_avaliacao SET dica = 'Sem limite, o cliente pede size=1000000. Defina um tamanho padrao e um teto.' WHERE descricao = 'Define um tamanho de pagina padrao ou maximo';
UPDATE criterios_avaliacao SET dica = 'A rota precisa apontar para uma funcao existente: declare o handler que responde.' WHERE descricao = 'Declara a funcao que atende a rota';
UPDATE criterios_avaliacao SET dica = 'Marque a classe com @RestController, senao o Spring nao registra rota nenhuma dela.' WHERE descricao = 'Declara a classe como controller REST';
UPDATE criterios_avaliacao SET dica = 'Tenha o conjunto de vogais em algum lugar (uma string aeiou, um Set, um indexOf) e teste cada caractere contra ele.' WHERE descricao = 'Compara os caracteres contra o conjunto de vogais';
UPDATE criterios_avaliacao SET dica = 'Compare o texto limpo com ele mesmo invertido, ou percorra das duas pontas para o meio.' WHERE descricao = 'Compara o texto com a versao invertida';
UPDATE criterios_avaliacao SET dica = 'Chame o repositorio ou o service. Controller nao conversa direto com o banco.' WHERE descricao = 'Busca os dados por um repositorio ou service';
UPDATE criterios_avaliacao SET dica = 'GROUP BY na data cheia gera um grupo por dia: trunque para mes antes de agrupar.' WHERE descricao = 'Agrupa por mes, nao pela data cheia';
UPDATE criterios_avaliacao SET dica = 'Use GROUP BY na coluna que define o grupo antes de aplicar a agregacao.' WHERE descricao = 'Agrupa o resultado';
UPDATE criterios_avaliacao SET dica = 'Guarde o total numa variavel e some a cada iteracao.' WHERE descricao = 'Acumula a soma';
UPDATE criterios_avaliacao SET dica = 'Mantenha um contador e incremente quando o caractere for vogal.' WHERE descricao = 'Acumula a contagem numa variavel';
