-- Progresso do candidato: apelido publico, pontos, sequencia de dias e a trava de repontuacao.
--
-- A pergunta que o produto passa a responder e "estou evoluindo?", e nao so "acertei esta
-- questao?". Para isso precisa de tres coisas no banco.
--
-- 1. Apelido. O ranking e publico, entao ele nao pode expor e-mail. O apelido nasce do primeiro
--    nome e vira a identidade da pessoa na tabela de classificacao.
--
-- 2. Pontos e sequencia gravados no usuario. Poderiam ser recalculados a partir de submissoes a
--    cada leitura, mas a home mostra ranking para visitante anonimo: recalcular 255 questoes por
--    usuario a cada visita e caro sem necessidade. O valor e derivado, e a fonte continua sendo
--    a tabela de conquistas abaixo, entao da para reconstruir se algum dia divergir.
--
-- 3. Conquista por questao. Sem ela, bastaria reenviar a mesma questao facil para inflar o
--    ranking. A chave unica (usuario, desafio) e o que garante que cada questao paga uma vez.

ALTER TABLE usuarios ADD COLUMN apelido VARCHAR(40);
ALTER TABLE usuarios ADD COLUMN pontos INTEGER NOT NULL DEFAULT 0;
ALTER TABLE usuarios ADD COLUMN sequencia_atual INTEGER NOT NULL DEFAULT 0;
ALTER TABLE usuarios ADD COLUMN sequencia_recorde INTEGER NOT NULL DEFAULT 0;
-- Ultimo dia em que a pessoa praticou. Data, e nao timestamp: a sequencia conta dias.
ALTER TABLE usuarios ADD COLUMN ultimo_dia_praticado DATE;

-- Apelido inicial: primeiro nome do cadastro. Sem sobrenome, porque o ranking e publico.
UPDATE usuarios
SET apelido = CASE
        WHEN position(' ' IN nome) > 0 THEN substring(nome FROM 1 FOR position(' ' IN nome) - 1)
        ELSE nome
    END
WHERE apelido IS NULL;

-- Desempate por id mantem o apelido do cadastro mais antigo e numera os seguintes.
UPDATE usuarios u
SET apelido = u.apelido || ' ' || (
        SELECT COUNT(*) FROM usuarios anterior
        WHERE anterior.apelido = u.apelido AND anterior.id < u.id
    )
WHERE EXISTS (
    SELECT 1 FROM usuarios outro
    WHERE outro.apelido = u.apelido AND outro.id < u.id
);

ALTER TABLE usuarios ALTER COLUMN apelido SET NOT NULL;
CREATE UNIQUE INDEX ux_usuarios_apelido ON usuarios (apelido);

CREATE TABLE conquistas (
    id            BIGSERIAL PRIMARY KEY,
    usuario_id    BIGINT    NOT NULL REFERENCES usuarios (id) ON DELETE CASCADE,
    desafio_id    BIGINT    NOT NULL REFERENCES desafios (id) ON DELETE CASCADE,
    -- Pontos ja creditados por esta questao. Guardado aqui, e nao recalculado, porque a regra de
    -- pontuacao pode mudar amanha e o historico precisa continuar explicando o placar de hoje.
    pontos        INTEGER   NOT NULL,
    precisao      INTEGER   NOT NULL,
    conquistado_em TIMESTAMP NOT NULL
);

-- A trava contra repontuar a mesma questao. E indice unico, e nao checagem na aplicacao, porque
-- dois envios simultaneos passariam por qualquer if antes de qualquer insert.
CREATE UNIQUE INDEX ux_conquistas_usuario_desafio ON conquistas (usuario_id, desafio_id);
CREATE INDEX idx_conquistas_usuario ON conquistas (usuario_id);

-- O ranking ordena por pontos e usa a sequencia como desempate.
CREATE INDEX idx_usuarios_ranking ON usuarios (pontos DESC, sequencia_atual DESC);
