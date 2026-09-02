-- Sobra de um criterio no Verificador de Palindromo.
--
-- A V9 removeu a regua antiga dos dois desafios herdados da V3 comparando a descricao contra uma
-- lista unica, montada com os criterios dos dois. O efeito colateral: "Devolve o resultado com
-- return" pertence a regua nova do Media de Notas, entao a comparacao o considerou legitimo
-- tambem no Palindromo, onde ele e resto da V3 e duplica o criterio "Devolve booleano".
--
-- A licao esta na forma deste DELETE: a comparacao precisa ser por par (desafio, descricao).
-- Descricao sozinha nao identifica criterio nenhum, porque o mesmo texto se repete de proposito
-- entre questoes diferentes.

DELETE FROM criterios_avaliacao
WHERE descricao = 'Devolve o resultado com return'
  AND desafio_id IN (
    SELECT d.id FROM desafios d
    JOIN tecnologias t ON t.id = d.tecnologia_id
    WHERE t.nome = 'Python'
      AND d.titulo = 'Verificador de Palindromo'
  );
