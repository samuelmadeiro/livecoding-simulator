-- Correcao por criterios: cada desafio passa a ter varios sinais avaliados, com peso,
-- em vez de uma unica palavra-chave por tipo. As regras ficam no banco, nao no codigo.

CREATE TABLE criterios_avaliacao (
    id         BIGSERIAL    PRIMARY KEY,
    desafio_id BIGINT       NOT NULL REFERENCES desafios (id) ON DELETE CASCADE,
    -- Texto exibido ao candidato no feedback. Nunca expor a coluna padrao pela API:
    -- entregar a regex seria entregar a resposta.
    descricao  VARCHAR(200) NOT NULL,
    padrao     TEXT         NOT NULL,
    -- OBRIGATORIO reprova sozinho; PONTUAVEL soma para a nota; PROIBIDO reprova se casar.
    tipo       VARCHAR(20)  NOT NULL,
    peso       INTEGER      NOT NULL DEFAULT 1
);

CREATE INDEX idx_criterios_desafio ON criterios_avaliacao (desafio_id);

-- Nota de 0 a 100 da submissao. Nulo nas submissoes gravadas antes desta migration.
ALTER TABLE submissoes ADD COLUMN pontuacao INTEGER;
