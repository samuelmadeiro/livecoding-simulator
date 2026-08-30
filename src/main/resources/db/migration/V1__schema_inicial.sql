-- Schema inicial do LiveCoding Simulator (PostgreSQL).
-- Espelha as entidades JPA: qualquer divergencia quebra o boot, porque o perfil prod roda
-- com spring.jpa.hibernate.ddl-auto=validate.

CREATE TABLE usuarios (
    id    BIGSERIAL     PRIMARY KEY,
    nome  VARCHAR(120)  NOT NULL,
    email VARCHAR(150)  NOT NULL UNIQUE,
    senha VARCHAR(255)  NOT NULL,
    role  VARCHAR(20)   NOT NULL
);

CREATE TABLE tecnologias (
    id   BIGSERIAL   PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE desafios (
    id                   BIGSERIAL    PRIMARY KEY,
    titulo               VARCHAR(150) NOT NULL,
    descricao            TEXT         NOT NULL,
    nivel                VARCHAR(20)  NOT NULL,
    tipo                 VARCHAR(30)  NOT NULL,
    tempo_limite_minutos INTEGER      NOT NULL,
    template_codigo      TEXT,
    tecnologia_id        BIGINT       NOT NULL REFERENCES tecnologias (id)
);

CREATE TABLE submissoes (
    id             BIGSERIAL   PRIMARY KEY,
    codigo_enviado TEXT        NOT NULL,
    status         VARCHAR(30) NOT NULL,
    data_hora      TIMESTAMP   NOT NULL,
    usuario_id     BIGINT      NOT NULL REFERENCES usuarios (id),
    desafio_id     BIGINT      NOT NULL REFERENCES desafios (id)
);
