import { CircleCheck, Clock, Lightbulb, Ruler } from "lucide-react";
import type { FalaEntrevistador as Fala } from "../api/types";

/*
 * O retorno em forma de conversa. A lista de critérios ao lado diz o que falhou; este bloco diz
 * o que alguém falaria numa entrevista: o que gostou, onde a solução trava, que caminho seguir e
 * como a avaliação foi feita.
 *
 * A dica aponta a direção e para por aí — entregar o trecho pronto acabaria com o exercício.
 */
export function FalaEntrevistador({ fala }: { fala: Fala }) {
  return (
    <section
      aria-labelledby="titulo-entrevistador"
      className="flex flex-col gap-5 border border-borda bg-elevada p-6 rounded-padrao"
    >
      <header className="flex items-center gap-3">
        <span
          aria-hidden="true"
          className="flex h-10 w-10 shrink-0 items-center justify-center rounded-padrao border border-acento bg-acento-suave font-titulo text-sm font-semibold text-acento"
        >
          {iniciais(fala.entrevistador)}
        </span>
        <span className="flex flex-col">
          <h3 id="titulo-entrevistador" className="text-md text-tinta">
            {fala.entrevistador}
          </h3>
          <span className="text-sm text-tinta-fraca">
            {fala.cargo} · retorno da entrevista
          </span>
        </span>
      </header>

      <p className="max-w-[var(--medida-texto)] text-tinta-media">{fala.abertura}</p>

      {fala.elogios.length > 0 ? (
        <ul className="flex flex-col gap-2">
          {fala.elogios.map((elogio) => (
            <li key={elogio} className="flex items-start gap-2 text-tinta-media">
              <CircleCheck aria-hidden="true" size={18} className="mt-1 shrink-0 text-ok" />
              <span className="max-w-[var(--medida-texto)]">{elogio}</span>
            </li>
          ))}
        </ul>
      ) : null}

      {fala.ajustes.length > 0 ? (
        <div className="flex flex-col gap-3">
          <h4 className="text-sm font-medium text-tinta">O que eu pediria para ajustar</h4>

          <ul className="flex flex-col gap-3">
            {fala.ajustes.map((ajuste) => (
              <li
                key={ajuste.oQueFaltou}
                className="flex flex-col gap-2 border border-borda bg-afundada p-4 rounded-padrao"
              >
                <p className="text-tinta">{ajuste.oQueFaltou}</p>

                <p className="flex items-start gap-2 text-tinta-media">
                  <Lightbulb aria-hidden="true" size={18} className="mt-1 shrink-0 text-alerta" />
                  <span className="max-w-[var(--medida-texto)]">
                    <span className="sr-only">Dica: </span>
                    {ajuste.dica}
                  </span>
                </p>

                <p className="max-w-[var(--medida-texto)] text-sm text-tinta-fraca">
                  {ajuste.porQueImporta}
                </p>
              </li>
            ))}
          </ul>
        </div>
      ) : null}

      <p className="flex items-start gap-2 text-tinta-media">
        <Clock aria-hidden="true" size={18} className="mt-1 shrink-0 text-tinta-fraca" />
        <span className="max-w-[var(--medida-texto)]">{fala.comentarioTempo}</span>
      </p>

      <p className="flex items-start gap-2 border-t border-borda pt-4 text-sm text-tinta-media">
        <Ruler aria-hidden="true" size={18} className="mt-0.5 shrink-0 text-tinta-fraca" />
        <span className="max-w-[var(--medida-texto)]">{fala.comoAvaliei}</span>
      </p>

      <p className="max-w-[var(--medida-texto)] text-tinta">{fala.fechamento}</p>
    </section>
  );
}

function iniciais(nome: string): string {
  const partes = nome.trim().split(/\s+/);
  const primeira = partes[0]?.charAt(0) ?? "";
  const ultima = partes.length > 1 ? partes[partes.length - 1].charAt(0) : "";
  return (primeira + ultima).toUpperCase();
}
