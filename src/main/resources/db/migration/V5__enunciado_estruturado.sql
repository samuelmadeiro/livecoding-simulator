-- Enunciado estruturado.
--
-- Ate aqui a questao inteira cabia num paragrafo de descricao, e o candidato tinha de adivinhar
-- o formato da entrada, o formato da saida e o que acontece nos casos de borda. Enunciado vago
-- reprova por interpretacao, nao por codigo, e a correcao por criterios fica injusta: cobra o que
-- nao foi pedido com clareza.
--
-- Cada parte vira uma coluna propria em vez de virar mais texto solto, por dois motivos: o front
-- renderiza cada secao com seu titulo, e da para auditar por SQL quais questoes ainda estao
-- incompletas (WHERE exemplo IS NULL).
--
-- Tudo nulo por enquanto: os desafios criados antes desta migration continuam validos e o front
-- simplesmente nao desenha a secao vazia.

-- Por que o problema existe no mundo real. E o que um recrutador explicaria antes do enunciado.
ALTER TABLE desafios ADD COLUMN contexto TEXT;

-- Formato exato do que entra: tipo, faixa de valores e o que pode vir vazio ou nulo.
ALTER TABLE desafios ADD COLUMN formato_entrada TEXT;

-- Formato exato do que sai, incluindo o que devolver quando nao ha resultado.
ALTER TABLE desafios ADD COLUMN formato_saida TEXT;

-- Pelo menos um caso resolvido, entrada e saida, para nao sobrar duvida de interpretacao.
ALTER TABLE desafios ADD COLUMN exemplo TEXT;

-- Limites e proibicoes: complexidade esperada, biblioteca vetada, caso de borda obrigatorio.
ALTER TABLE desafios ADD COLUMN restricoes TEXT;
