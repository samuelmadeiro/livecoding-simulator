import type { ButtonHTMLAttributes, ReactNode } from "react";

type Variante = "primario" | "secundario" | "discreto";

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variante?: Variante;
  children: ReactNode;
}

/* Altura de 40px passa com folga do alvo minimo de 24x24 (WCAG 2.5.8). */
const BASE =
  "inline-flex items-center justify-center gap-2 rounded-padrao px-4 py-2 min-h-10 " +
  "font-corpo text-sm font-medium transition-colors " +
  "disabled:cursor-not-allowed disabled:bg-desabilitado disabled:text-desabilitado-tinta " +
  "disabled:border-borda";

const POR_VARIANTE: Record<Variante, string> = {
  primario:
    "border border-acento bg-acento text-tinta-invertida hover:bg-acento-escuro hover:border-acento-escuro",
  secundario:
    "border border-borda-forte bg-elevada text-tinta hover:bg-afundada",
  discreto:
    "border border-transparent bg-transparent text-tinta-media hover:bg-afundada hover:text-tinta",
};

export function Botao({ variante = "primario", children, ...resto }: Props) {
  return (
    <button className={`${BASE} ${POR_VARIANTE[variante]}`} {...resto}>
      {children}
    </button>
  );
}
