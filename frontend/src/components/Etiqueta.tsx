import type { ReactNode } from "react";

type Tom = "neutro" | "acento" | "ok" | "alerta" | "erro";

const POR_TOM: Record<Tom, string> = {
  neutro: "border-borda-forte bg-afundada text-tinta-media",
  acento: "border-acento bg-acento-suave text-acento",
  ok: "border-ok bg-ok-suave text-ok",
  alerta: "border-alerta bg-alerta-suave text-alerta",
  erro: "border-erro bg-erro-suave text-erro",
};

/** Etiqueta de metadado. O tom reforca, nunca substitui, o texto que ela carrega. */
export function Etiqueta({
  tom = "neutro",
  children,
}: {
  tom?: Tom;
  children: ReactNode;
}) {
  return (
    <span
      className={`inline-flex items-center gap-1 rounded-padrao border px-2 py-1 text-xs font-medium ${POR_TOM[tom]}`}
    >
      {children}
    </span>
  );
}
