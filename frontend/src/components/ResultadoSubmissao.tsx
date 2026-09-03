import { CircleCheck, CircleX, Flame, Hourglass, TriangleAlert, Trophy } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import {
  ROTULO_CRITERIO,
  ROTULO_STATUS,
  type CriterioResultado,
  type GanhoProgresso,
  type Submissao,
} from "../api/types";
import { formatarDuracao } from "../util/formato";
import { BarraPercentual } from "./BarraPercentual";
import { FalaEntrevistador } from "./FalaEntrevistador";

/*
 * Cada status carrega icone + rotulo + cor. A cor e o terceiro sinal, nunca o unico: quem nao
 * distingue vermelho de verde le "Aprovado" e ve o icone de confirmacao (WCAG 1.4.1).
 */
const APARENCIA: Record<
  Submissao["status"],
  { icone: LucideIcon; caixa: string; tinta: string }
> = {
  APROVADO: {
    icone: CircleCheck,
    caixa: "border-ok bg-ok-suave",
    tinta: "text-ok",
  },
  PENDENTE: {
    icone: Hourglass,
    caixa: "border-alerta bg-alerta-suave",
    tinta: "text-alerta",
  },
  ERRO_COMPILACAO: {
    icone: TriangleAlert,
    caixa: "border-erro bg-erro-suave",
    tinta: "text-erro",
  },
  ERRO_TESTE: {
    icone: CircleX,
    caixa: "border-erro bg-erro-suave",
    tinta: "text-erro",
  },
};

export function ResultadoSubmissao({ submissao }: { submissao: Submissao }) {
  const { icone: Icone, caixa, tinta } = APARENCIA[submissao.status];
  const criterios = submissao.criterios ?? [];

  return (
    <div className="flex flex-col gap-6">
      <section
        aria-labelledby="titulo-resultado"
        className={`flex flex-col gap-4 border p-6 rounded-padrao ${caixa}`}
      >
        <h3 id="titulo-resultado" className={`flex items-center gap-3 text-md ${tinta}`}>
          <Icone aria-hidden="true" size={22} className="shrink-0" />
          {ROTULO_STATUS[submissao.status]}
        </h3>

        <p className="max-w-[var(--medida-texto)] text-tinta-media">
          {submissao.mensagemFeedback}
        </p>

        <GanhoDoEnvio progresso={submissao.progresso} />

        {/*
         * Nota e precisao respondem coisas diferentes e por isso aparecem lado a lado: a nota so
         * conta o que valia ponto; a precisao conta a regua inteira, essenciais inclusos. Uma
         * solucao pode ter nota cheia nos pontuaveis e precisao baixa por faltar o essencial.
         */}
        <dl className="flex flex-wrap gap-x-8 gap-y-3">
          <div className="flex flex-col gap-1">
            <dt className="text-xs text-tinta-fraca">Nota (critérios que valem ponto)</dt>
            <dd className={`text-md ${tinta}`}>
              {submissao.pontuacao == null ? "—" : `${submissao.pontuacao} / 100`}
            </dd>
          </div>

          <div className="flex flex-col gap-1">
            <dt className="text-xs text-tinta-fraca">Precisão (régua inteira do exercício)</dt>
            <dd className="min-w-40">
              <BarraPercentual valor={submissao.precisao} />
            </dd>
          </div>

          <div className="flex flex-col gap-1">
            <dt className="text-xs text-tinta-fraca">Tempo até enviar</dt>
            <dd className="text-md text-tinta">{formatarDuracao(submissao.duracaoSegundos)}</dd>
          </div>
        </dl>

        {criterios.length > 0 ? (
          <div className="flex flex-col gap-2">
            <h4 className="text-sm text-tinta-media">O que foi avaliado</h4>
            {/*
             * Cada item repete o estado em icone e em texto alternativo, porque a lista mistura
             * verde e vermelho e a cor sozinha nao pode ser a informacao.
             */}
            <ul className="flex flex-col gap-2">
              {criterios.map((criterio) => (
                <ItemCriterio key={criterio.descricao} criterio={criterio} />
              ))}
            </ul>
          </div>
        ) : null}

        <p className="text-xs text-tinta-fraca">Submissão #{submissao.submissaoId}</p>
      </section>

      {submissao.entrevistador ? (
        <FalaEntrevistador fala={submissao.entrevistador} />
      ) : null}
    </div>
  );
}

/*
 * O que este envio rendeu de progresso.
 *
 * Três situações precisam ser distinguidas, senão a pessoa tira a conclusão errada:
 * questão nova conquistada, questão refeita (que não paga de novo, e isso não é bug) e
 * reprovação (que ainda assim registrou a prática do dia).
 *
 * Não é confete: o número aparece junto do motivo, porque um "+25" sozinho não ensina a regra.
 */
function GanhoDoEnvio({ progresso }: { progresso: GanhoProgresso | null }) {
  if (!progresso) {
    return null;
  }

  const { pontosGanhos, primeiraVez, sequenciaAtual, sequenciaCresceu } = progresso;

  const sequencia = sequenciaCresceu
    ? `Sequência em ${sequenciaAtual} ${sequenciaAtual === 1 ? "dia" : "dias"}.`
    : null;

  if (primeiraVez) {
    return (
      <p
        /* Anuncia sozinho no leitor de tela: o ganho aparece sem a pessoa procurar. */
        role="status"
        className="flex flex-wrap items-baseline gap-x-2 gap-y-1 border border-ok bg-ok-suave px-4 py-3 text-ok rounded-padrao"
      >
        <Trophy aria-hidden="true" size={18} className="self-center shrink-0" />
        <strong className="font-codigo">+{pontosGanhos} pontos</strong>
        <span className="text-tinta-media">Questão conquistada pela primeira vez.</span>
        {sequencia && <span className="text-tinta-media">{sequencia}</span>}
      </p>
    );
  }

  return (
    <p role="status" className="flex flex-wrap items-baseline gap-x-2 gap-y-1 text-sm text-tinta-media">
      <Flame aria-hidden="true" size={16} className="self-center shrink-0 text-acento" />
      <span>
        {pontosGanhos === 0 && sequenciaCresceu
          ? "Sem pontos neste envio, mas a prática de hoje ficou registrada."
          : "Você já tinha conquistado esta questão: refazer não soma pontos de novo."}
      </span>
      {sequencia && <span>{sequencia}</span>}
    </p>
  );
}

function ItemCriterio({ criterio }: { criterio: CriterioResultado }) {
  const Icone = criterio.atendido ? CircleCheck : CircleX;
  const tinta = criterio.atendido ? "text-ok" : "text-erro";

  return (
    <li className="flex items-start gap-2 text-tinta-media">
      <Icone aria-hidden="true" size={18} className={`mt-1 shrink-0 ${tinta}`} />
      <span className="flex flex-col gap-1">
        <span>
          <span className="sr-only">{criterio.atendido ? "Atendido: " : "Não atendido: "}</span>
          {criterio.descricao}
          <span className="text-sm text-tinta-fraca">
            {" "}
            · {ROTULO_CRITERIO[criterio.tipo]}
            {criterio.tipo === "PONTUAVEL" ? `, peso ${criterio.peso}` : ""}
          </span>
        </span>
      </span>
    </li>
  );
}
