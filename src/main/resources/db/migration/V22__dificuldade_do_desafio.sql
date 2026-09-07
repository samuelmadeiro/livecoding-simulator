-- Dificuldade do desafio: um eixo proprio, ao lado do nivel da vaga.
--
-- Ate aqui o catalogo so tinha nivel (ESTAGIO, JUNIOR, PLENO, SENIOR), que responde "para qual
-- vaga esta questao serve" — e nao "quanto ela cobra". Sao perguntas diferentes: quem esta se
-- preparando para uma vaga de junior quer comecar pelas questoes leves daquele nivel e so depois
-- encarar as pesadas. Com um eixo so, o filtro nao consegue expressar isso.
--
-- Backfill: nao ha registro historico de dificuldade, entao o valor inicial sai do tempo limite —
-- a unica estimativa de esforco que o catalogo ja carrega — comparado com as outras questoes do
-- mesmo nivel. A dificuldade e relativa ao nivel de proposito: as 150 questoes de estagio nao
-- viram todas FACIL so por serem de estagio, e cada trilha ganha suas leves, medias e pesadas.
--
--   ESTAGIO        ate 20 min FACIL   ate 25 MEDIO   acima DIFICIL
--   JUNIOR         ate 30 min FACIL   ate 35 MEDIO   acima DIFICIL
--   PLENO, SENIOR  ate 40 min FACIL   ate 45 MEDIO   acima DIFICIL
--
-- E um ponto de partida, nao um veredito: a dificuldade e coluna propria justamente para poder
-- ser corrigida questao a questao por UPDATE, sem depender do nivel nem do tempo.

ALTER TABLE desafios ADD COLUMN dificuldade VARCHAR(20);

UPDATE desafios
SET dificuldade = CASE
    WHEN nivel = 'ESTAGIO' THEN
        CASE WHEN tempo_limite_minutos <= 20 THEN 'FACIL'
             WHEN tempo_limite_minutos <= 25 THEN 'MEDIO'
             ELSE 'DIFICIL' END
    WHEN nivel = 'JUNIOR' THEN
        CASE WHEN tempo_limite_minutos <= 30 THEN 'FACIL'
             WHEN tempo_limite_minutos <= 35 THEN 'MEDIO'
             ELSE 'DIFICIL' END
    ELSE
        CASE WHEN tempo_limite_minutos <= 40 THEN 'FACIL'
             WHEN tempo_limite_minutos <= 45 THEN 'MEDIO'
             ELSE 'DIFICIL' END
END
WHERE dificuldade IS NULL;

-- NOT NULL so depois do backfill: a coluna nasce vazia e a tabela ja tem linhas.
ALTER TABLE desafios ALTER COLUMN dificuldade SET NOT NULL;
