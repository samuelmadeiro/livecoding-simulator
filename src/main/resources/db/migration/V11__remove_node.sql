-- Node sai do catalogo.
--
-- O simulador passa a cobrir tres trilhas: Python, Java e SQL. Node tinha quatro questoes e
-- nenhuma submissao, entao sair agora custa menos do que manter uma trilha pela metade ao lado de
-- trilhas com oitenta e cinco questoes cada.
--
-- A ordem dos comandos segue as chaves estrangeiras: tentativas apontam para desafios, e desafios
-- apontam para tecnologias. Criterios saem sozinhos, porque a FK deles e ON DELETE CASCADE.
--
-- Nao ha DELETE em submissoes aqui de proposito: se algum dia existir submissao para um desafio de
-- Node, esta migration falha em vez de apagar historico de candidato em silencio.

DELETE FROM tentativas
WHERE desafio_id IN (
    SELECT d.id FROM desafios d
    JOIN tecnologias t ON t.id = d.tecnologia_id
    WHERE t.nome = 'Node'
);

DELETE FROM desafios
WHERE tecnologia_id IN (SELECT id FROM tecnologias WHERE nome = 'Node');

DELETE FROM tecnologias WHERE nome = 'Node';
