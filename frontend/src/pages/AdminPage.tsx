import { useEffect, useState } from "react";
import { ErroDeApi, api } from "../api/client";
import {
  ROTULO_CRITERIO,
  ROTULO_NIVEL,
  ROTULO_STATUS,
  ROTULO_TIPO,
  type MetricaDesafio,
  type MetricaUsuario,
  type PainelAdmin,
  type SubmissaoRecente,
} from "../api/types";
import { useAuth } from "../auth/useAuth";
import { BarraPercentual } from "../components/BarraPercentual";
import { Carregando, Falha, Vazio } from "../components/Estados";
import { Etiqueta } from "../components/Etiqueta";
import {
  formatarDataHora,
  formatarDuracao,
  formatarNota,
  formatarPercentual,
} from "../util/formato";

/*
 * Painel de quem administra: quanto tempo cada candidato levou, quanto acertou e onde cada
 * exercício derruba as pessoas.
 *
 * Tudo vem de uma requisição só (GET /api/admin/metricas), já agregado no banco. A tela não soma
 * nada: com o histórico crescendo, contar submissão no navegador seria baixar o banco inteiro.
 */
export function AdminPage() {
  const { sessao } = useAuth();
  const [painel, setPainel] = useState<PainelAdmin | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  const token = sessao?.token ?? null;

  useEffect(() => {
    if (!token) return;

    let cancelado = false;
    setPainel(null);
    setErro(null);

    api
      .buscarPainelAdmin(token)
      .then((dados) => {
        if (!cancelado) setPainel(dados);
      })
      .catch((causa: unknown) => {
        if (cancelado) return;
        setErro(causa instanceof ErroDeApi ? causa.message : "Falha ao carregar o painel.");
      });

    return () => {
      cancelado = true;
    };
  }, [token]);

  return (
    <main id="conteudo" className="flex flex-col gap-12 px-6 py-12 md:px-12">
      <div className="flex flex-col gap-4">
        <h1 className="text-xl text-tinta">Painel do admin</h1>
        <p className="max-w-[var(--medida-texto)] text-md text-tinta-media">
          Tempo gasto e percentual de acerto por candidato, e a precisão de cada exercício —
          incluindo qual critério mais reprova em cada um.
        </p>
      </div>

      {erro ? <Falha mensagem={erro} /> : null}

      {!erro && painel == null ? <Carregando rotulo="Carregando as métricas" /> : null}

      {painel ? (
        <>
          <Resumo painel={painel} />
          <TabelaCandidatos usuarios={painel.usuarios} />
          <ListaDesafios desafios={painel.desafios} />
          <TabelaSubmissoes submissoes={painel.ultimasSubmissoes} />
        </>
      ) : null}
    </main>
  );
}

function Resumo({ painel }: { painel: PainelAdmin }) {
  const { resumo } = painel;

  const cartoes = [
    { rotulo: "Candidatos cadastrados", valor: String(resumo.candidatos) },
    { rotulo: "Desafios no catálogo", valor: String(resumo.desafios) },
    { rotulo: "Submissões corrigidas", valor: String(resumo.submissoes) },
    {
      rotulo: "Aprovação geral",
      valor: `${resumo.taxaAprovacao}%`,
      apoio: `${resumo.aprovadas} de ${resumo.submissoes}`,
    },
    { rotulo: "Precisão média", valor: formatarPercentual(resumo.precisaoMedia) },
    { rotulo: "Nota média", valor: formatarNota(resumo.pontuacaoMedia) },
    {
      rotulo: "Tempo médio por questão",
      valor: formatarDuracao(resumo.tempoMedioSegundos),
      apoio: `total: ${formatarDuracao(resumo.tempoTotalSegundos)}`,
    },
  ];

  return (
    <section aria-labelledby="titulo-resumo" className="flex flex-col gap-6">
      <h2 id="titulo-resumo" className="text-lg text-tinta">
        Visão geral
      </h2>

      <dl className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {cartoes.map((cartao) => (
          <div
            key={cartao.rotulo}
            className="flex flex-col gap-1 border border-borda bg-elevada p-4 rounded-padrao"
          >
            <dt className="text-xs text-tinta-fraca">{cartao.rotulo}</dt>
            <dd className="font-titulo text-md text-tinta">{cartao.valor}</dd>
            {cartao.apoio ? (
              <dd className="text-xs text-tinta-fraca">{cartao.apoio}</dd>
            ) : null}
          </div>
        ))}
      </dl>
    </section>
  );
}

function TabelaCandidatos({ usuarios }: { usuarios: MetricaUsuario[] }) {
  return (
    <section aria-labelledby="titulo-candidatos" className="flex flex-col gap-6">
      <h2 id="titulo-candidatos" className="text-lg text-tinta">
        Candidatos
      </h2>

      {usuarios.length === 0 ? (
        <Vazio titulo="Nenhuma conta cadastrada ainda" />
      ) : (
        /* A tabela rola dentro do próprio contêiner: a página nunca rola na horizontal. */
        <div className="overflow-x-auto border border-borda bg-elevada rounded-padrao">
          <table className="w-full min-w-max border-collapse text-left text-sm">
            <caption className="sr-only">
              Tempo gasto e percentual de acerto por candidato
            </caption>
            <thead className="border-b border-borda text-xs text-tinta-fraca">
              <tr>
                <th scope="col" className="px-4 py-3 font-medium">Candidato</th>
                <th scope="col" className="px-4 py-3 font-medium">Envios</th>
                <th scope="col" className="px-4 py-3 font-medium">% de acerto</th>
                <th scope="col" className="px-4 py-3 font-medium">Precisão média</th>
                <th scope="col" className="px-4 py-3 font-medium">Nota média</th>
                <th scope="col" className="px-4 py-3 font-medium">Tempo médio</th>
                <th scope="col" className="px-4 py-3 font-medium">Tempo total</th>
                <th scope="col" className="px-4 py-3 font-medium">Último envio</th>
              </tr>
            </thead>
            <tbody>
              {usuarios.map((usuario) => (
                <tr key={usuario.usuarioId} className="border-b border-borda last:border-b-0">
                  <th scope="row" className="px-4 py-3 font-normal">
                    <span className="flex flex-col gap-1">
                      <span className="flex items-center gap-2 text-tinta">
                        {usuario.nome}
                        {usuario.role === "ADMIN" ? <Etiqueta>admin</Etiqueta> : null}
                      </span>
                      <span className="text-xs text-tinta-fraca">{usuario.email}</span>
                    </span>
                  </th>
                  <td className="px-4 py-3 text-tinta-media tabular-nums">
                    {usuario.submissoes}
                    <span className="text-tinta-fraca"> ({usuario.aprovadas} ok)</span>
                  </td>
                  <td className="px-4 py-3">
                    <BarraPercentual
                      valor={usuario.submissoes === 0 ? null : usuario.taxaAcerto}
                      rotulo={`${usuario.nome}: ${usuario.taxaAcerto}% de acerto`}
                    />
                  </td>
                  <td className="px-4 py-3">
                    <BarraPercentual valor={usuario.precisaoMedia} />
                  </td>
                  <td className="px-4 py-3 text-tinta-media tabular-nums">
                    {formatarNota(usuario.pontuacaoMedia)}
                  </td>
                  <td className="px-4 py-3 text-tinta-media">
                    {formatarDuracao(usuario.tempoMedioSegundos)}
                  </td>
                  <td className="px-4 py-3 text-tinta-media">
                    {formatarDuracao(usuario.tempoTotalSegundos)}
                  </td>
                  <td className="px-4 py-3 text-tinta-fraca">
                    {formatarDataHora(usuario.ultimaSubmissao)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}

function ListaDesafios({ desafios }: { desafios: MetricaDesafio[] }) {
  return (
    <section aria-labelledby="titulo-desafios" className="flex flex-col gap-6">
      <div className="flex flex-col gap-2">
        <h2 id="titulo-desafios" className="text-lg text-tinta">
          Precisão por exercício
        </h2>
        <p className="max-w-[var(--medida-texto)] text-tinta-media">
          A precisão é a média do quanto cada solução cobriu da régua do exercício — critérios
          essenciais contam dobrado. Abaixo dela, a taxa de acerto critério a critério: é essa
          lista que diz onde as pessoas travam, e não a nota final.
        </p>
      </div>

      <ul className="flex flex-col gap-6">
        {desafios.map((desafio) => (
          <li key={desafio.desafioId}>
            <CartaoDesafio desafio={desafio} />
          </li>
        ))}
      </ul>
    </section>
  );
}

function CartaoDesafio({ desafio }: { desafio: MetricaDesafio }) {
  const semDados = desafio.submissoes === 0;

  return (
    <article className="flex flex-col gap-4 border border-borda bg-elevada p-6 rounded-padrao">
      <div className="flex flex-wrap items-center gap-2">
        <Etiqueta tom="acento">{ROTULO_NIVEL[desafio.nivel]}</Etiqueta>
        <Etiqueta>{ROTULO_TIPO[desafio.tipo]}</Etiqueta>
        {desafio.tecnologiaNome ? <Etiqueta>{desafio.tecnologiaNome}</Etiqueta> : null}
      </div>

      <h3 className="text-md text-tinta">{desafio.titulo}</h3>

      <dl className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <div className="flex flex-col gap-1">
          <dt className="text-xs text-tinta-fraca">Precisão média</dt>
          <dd>
            <BarraPercentual valor={desafio.precisaoMedia} />
          </dd>
        </div>
        <div className="flex flex-col gap-1">
          <dt className="text-xs text-tinta-fraca">Aprovação</dt>
          <dd>
            <BarraPercentual valor={semDados ? null : desafio.taxaAprovacao} />
          </dd>
        </div>
        <div className="flex flex-col gap-1">
          <dt className="text-xs text-tinta-fraca">Envios / candidatos</dt>
          <dd className="text-tinta-media tabular-nums">
            {desafio.submissoes} / {desafio.candidatos}
          </dd>
        </div>
        <div className="flex flex-col gap-1">
          <dt className="text-xs text-tinta-fraca">Tempo médio</dt>
          <dd className="text-tinta-media">
            {formatarDuracao(desafio.tempoMedioSegundos)}
            {desafio.tempoLimiteMinutos != null ? (
              <span className="text-tinta-fraca"> de {desafio.tempoLimiteMinutos} min</span>
            ) : null}
          </dd>
        </div>
      </dl>

      {semDados ? (
        <p className="text-sm text-tinta-fraca">Ninguém tentou este desafio ainda.</p>
      ) : (
        <>
          {desafio.criterioCritico ? (
            <p className="text-sm text-tinta-media">
              Critério que mais reprova aqui:{" "}
              <strong className="text-tinta">{desafio.criterioCritico}</strong>
            </p>
          ) : null}

          <div className="overflow-x-auto">
            <table className="w-full min-w-max border-collapse text-left text-sm">
              <caption className="sr-only">
                Taxa de acerto por critério em {desafio.titulo}
              </caption>
              <thead className="border-b border-borda text-xs text-tinta-fraca">
                <tr>
                  <th scope="col" className="py-2 pr-4 font-medium">Critério</th>
                  <th scope="col" className="py-2 pr-4 font-medium">Tipo</th>
                  <th scope="col" className="py-2 pr-4 font-medium">Atendido em</th>
                  <th scope="col" className="py-2 font-medium">% de acerto</th>
                </tr>
              </thead>
              <tbody>
                {desafio.criterios.map((criterio) => (
                  <tr key={criterio.descricao} className="border-b border-borda last:border-b-0">
                    <th scope="row" className="py-2 pr-4 font-normal text-tinta-media">
                      {criterio.descricao}
                    </th>
                    <td className="py-2 pr-4 text-tinta-fraca">
                      {ROTULO_CRITERIO[criterio.tipo]}
                      {criterio.tipo === "PONTUAVEL" ? ` · peso ${criterio.peso}` : ""}
                    </td>
                    <td className="py-2 pr-4 text-tinta-media tabular-nums">
                      {criterio.atendidas} de {criterio.avaliacoes}
                    </td>
                    <td className="py-2">
                      <BarraPercentual valor={criterio.taxaAcerto} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </article>
  );
}

/** PENDENTE nao e falha: e revisao manual. Pintar de vermelho contaria outra historia. */
function tomDoStatus(status: SubmissaoRecente["status"]) {
  if (status === "APROVADO") return "ok" as const;
  if (status === "PENDENTE") return "alerta" as const;
  return "erro" as const;
}

function TabelaSubmissoes({ submissoes }: { submissoes: SubmissaoRecente[] }) {
  return (
    <section aria-labelledby="titulo-submissoes" className="flex flex-col gap-6">
      <h2 id="titulo-submissoes" className="text-lg text-tinta">
        Últimas submissões
      </h2>

      {submissoes.length === 0 ? (
        <Vazio titulo="Nenhuma submissão registrada ainda" />
      ) : (
        <div className="overflow-x-auto border border-borda bg-elevada rounded-padrao">
          <table className="w-full min-w-max border-collapse text-left text-sm">
            <caption className="sr-only">Histórico recente de submissões</caption>
            <thead className="border-b border-borda text-xs text-tinta-fraca">
              <tr>
                <th scope="col" className="px-4 py-3 font-medium">Quando</th>
                <th scope="col" className="px-4 py-3 font-medium">Candidato</th>
                <th scope="col" className="px-4 py-3 font-medium">Desafio</th>
                <th scope="col" className="px-4 py-3 font-medium">Resultado</th>
                <th scope="col" className="px-4 py-3 font-medium">Nota</th>
                <th scope="col" className="px-4 py-3 font-medium">Precisão</th>
                <th scope="col" className="px-4 py-3 font-medium">Tempo</th>
              </tr>
            </thead>
            <tbody>
              {submissoes.map((submissao) => (
                <tr key={submissao.submissaoId} className="border-b border-borda last:border-b-0">
                  <td className="px-4 py-3 text-tinta-fraca">
                    {formatarDataHora(submissao.dataHora)}
                  </td>
                  <th scope="row" className="px-4 py-3 font-normal text-tinta">
                    {submissao.candidato}
                  </th>
                  <td className="px-4 py-3 text-tinta-media">{submissao.desafio}</td>
                  <td className="px-4 py-3">
                    <Etiqueta tom={tomDoStatus(submissao.status)}>
                      {ROTULO_STATUS[submissao.status]}
                    </Etiqueta>
                  </td>
                  <td className="px-4 py-3 text-tinta-media tabular-nums">
                    {formatarNota(submissao.pontuacao)}
                  </td>
                  <td className="px-4 py-3 text-tinta-media tabular-nums">
                    {formatarPercentual(submissao.precisao)}
                  </td>
                  <td className="px-4 py-3 text-tinta-media">
                    {formatarDuracao(submissao.duracaoSegundos)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
