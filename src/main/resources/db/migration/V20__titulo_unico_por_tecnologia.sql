-- Tira o sufixo de tecnologia dos titulos e garante a unicidade no lugar certo.
--
-- O sufixo (Java), (Python) e (SQL) nasceu como remendo: as migrations de catalogo checam
-- NOT EXISTS por titulo antes de inserir, e questoes equivalentes em linguagens diferentes tem o
-- mesmo nome. Sem o sufixo, o desafio de Java nao entrava e, pior, seus criterios eram pendurados
-- no desafio homonimo de Python.
--
-- O sufixo resolvia o sintoma e sujava a tela, porque o card do desafio ja mostra a etiqueta da
-- tecnologia ao lado do titulo. A causa era outra: faltava dizer ao banco que titulo so precisa ser
-- unico dentro de uma tecnologia. E o que o indice abaixo passa a garantir, e ai o texto do titulo
-- volta a ser so texto.
--
-- A ordem importa: primeiro limpa os titulos, depois cria o indice. Se algum par
-- (titulo, tecnologia) colidir, a criacao do indice falha e a migration inteira e desfeita, o que e
-- exatamente o comportamento desejado.

UPDATE desafios
SET titulo = regexp_replace(titulo, ' \((Java|Python|SQL)\)$', '')
WHERE titulo ~ ' \((Java|Python|SQL)\)$';

CREATE UNIQUE INDEX ux_desafios_titulo_tecnologia ON desafios (titulo, tecnologia_id);
