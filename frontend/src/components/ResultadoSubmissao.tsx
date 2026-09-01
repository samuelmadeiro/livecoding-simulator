import { CircleCheck, CircleX, Hourglass, TriangleAlert } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { ROTULO_STATUS, type Submissao } from "../api/types";

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
    <section
      aria-labelledby="titulo-resultado"
      className={`flex flex-col gap-3 border p-6 rounded-padrao ${caixa}`}
    >
      <h3 id="titulo-resultado" className={`flex items-center gap-3 text-md ${tinta}`}>
        <Icone aria-hidden="true" size={22} className="shrink-0" />
        {ROTULO_STATUS[submissao.status]}
      </h3>

      <p className="max-w-[var(--medida-texto)] text-tinta-media">
        {submissao.mensagemFeedback}
      </p>

      {submissao.pontuacao !== null && (
        <p className="text-tinta-media">
          Pontuação: <strong className={tinta}>{submissao.pontuacao}</strong> de 100
        </p>
      )}

      {criterios.length > 0 && (
        <div className="flex flex-col gap-2">
          <h4 className="text-sm text-tinta-media">O que foi avaliado</h4>
          {/*
           * Cada item repete o estado em icone e em texto alternativo, porque a lista mistura
           * verde e vermelho e a cor sozinha nao pode ser a informacao.
           */}
          <ul className="flex flex-col gap-2">
            {criterios.map((criterio) => {
              const IconeItem = criterio.atendido ? CircleCheck : CircleX;
              const tintaItem = criterio.atendido ? "text-ok" : "text-erro";

              return (
                <li key={criterio.descricao} className="flex items-start gap-2 text-tinta-media">
                  <IconeItem
                    aria-hidden="true"
                    size={18}
                    className={`mt-1 shrink-0 ${tintaItem}`}
                  />
                  <span>
                    <span className="sr-only">
                      {criterio.atendido ? "Atendido: " : "Não atendido: "}
                    </span>
                    {criterio.descricao}
                  </span>
                </li>
              );
            })}
          </ul>
        </div>
      )}

      <p className="text-xs text-tinta-fraca">Submissão #{submissao.submissaoId}</p>
    </section>
  );
}
