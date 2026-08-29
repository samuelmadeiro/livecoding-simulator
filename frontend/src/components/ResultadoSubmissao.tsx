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

      <p className="text-xs text-tinta-fraca">Submissão #{submissao.submissaoId}</p>
    </section>
  );
}
