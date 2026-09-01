/*
 * Barra de percentual das tabelas do admin. O numero vem escrito ao lado sempre: a barra e
 * reforco visual, nunca a unica forma de ler o valor (WCAG 1.4.1). Por isso a barra em si e
 * aria-hidden e quem le com leitor de tela ouve so o texto.
 */

type Tom = "acento" | "ok" | "erro" | "neutro";

const POR_TOM: Record<Tom, string> = {
  acento: "bg-acento",
  ok: "bg-ok",
  erro: "bg-erro",
  neutro: "bg-borda-forte",
};

/** Abaixo de 40% o assunto é problema, acima de 75% está resolvido. */
function tomAutomatico(valor: number): Tom {
  if (valor >= 75) return "ok";
  if (valor < 40) return "erro";
  return "acento";
}

export function BarraPercentual({
  valor,
  tom,
  rotulo,
}: {
  valor: number | null;
  tom?: Tom;
  rotulo?: string;
}) {
  if (valor == null) {
    return <span className="text-tinta-fraca">—</span>;
  }

  const largura = Math.min(Math.max(valor, 0), 100);
  const cor = POR_TOM[tom ?? tomAutomatico(largura)];

  return (
    <span className="flex items-center gap-2">
      <span className="min-w-10 text-sm text-tinta tabular-nums">{valor}%</span>
      <span
        aria-hidden="true"
        className="h-2 w-full min-w-16 max-w-40 overflow-hidden rounded-padrao bg-afundada"
      >
        <span className={`block h-full ${cor}`} style={{ width: `${largura}%` }} />
      </span>
      {rotulo ? <span className="sr-only">{rotulo}</span> : null}
    </span>
  );
}
