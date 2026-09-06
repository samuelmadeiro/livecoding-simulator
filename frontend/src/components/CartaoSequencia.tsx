import { Flame } from "lucide-react";
import type { Progresso } from "../api/types";

/*
 * Sequência de dias praticados.
 *
 * A régua de sete dias é a semana: é o horizonte que a pessoa consegue enxergar enquanto se
 * prepara para uma entrevista, diferente de uma barra até 365 que nunca sai do lugar.
 *
 * O dia praticado é marcado por preenchimento E por texto no leitor de tela. Sem isso, a régua
 * seria um punhado de quadradinhos coloridos sem significado para quem não os enxerga.
 */
export function CartaoSequencia({ progresso }: { progresso: Progresso }) {
  const dias = ultimosSeteDias(progresso);

  return (
    <section
      aria-labelledby="titulo-sequencia"
      className="flex flex-col gap-4 border border-borda bg-elevada p-6 rounded-padrao"
    >
      <div className="flex items-start justify-between gap-4">
        <div className="flex flex-col gap-1">
          <h2 id="titulo-sequencia" className="text-sm text-tinta-media">
            Sequência
          </h2>
          <p className="flex items-baseline gap-2">
            <Flame aria-hidden="true" size={22} className="self-center text-acento" />
            <strong className="text-lg text-tinta">{progresso.sequenciaAtual}</strong>
            <span className="text-sm text-tinta-media">
              {progresso.sequenciaAtual === 1 ? "dia seguido" : "dias seguidos"}
            </span>
          </p>
        </div>

        <p className="text-right text-xs text-tinta-fraca">
          Recorde
          <br />
          <strong className="font-codigo text-sm text-tinta-media">
            {progresso.sequenciaRecorde}
          </strong>
        </p>
      </div>

      <ol className="flex gap-1.5" aria-label="Últimos sete dias">
        {dias.map((dia) => (
          <li
            key={dia.rotulo}
            className={`h-8 flex-1 rounded-padrao border ${
              dia.praticado ? "border-acento bg-acento" : "border-borda bg-afundada"
            }`}
          >
            <span className="sr-only">
              {dia.rotulo}: {dia.praticado ? "praticou" : "sem prática"}
            </span>
          </li>
        ))}
      </ol>

      <p className="text-sm text-tinta-media">
        {progresso.praticouHoje
          ? "Você já praticou hoje. A sequência está garantida."
          : progresso.sequenciaAtual > 0
            ? `Resolva uma questão hoje para não perder ${progresso.sequenciaAtual} ${
                progresso.sequenciaAtual === 1 ? "dia" : "dias"
              } de sequência.`
            : "Resolva uma questão hoje para começar sua sequência."}
      </p>
    </section>
  );
}

/*
 * A régua mostra os últimos sete dias. Só dá para afirmar com certeza o que aconteceu hoje e no
 * último dia praticado; para o meio, a sequência atual diz quantos dias seguidos vieram antes.
 * Isso basta para a régua, e evita pedir ao servidor um histórico dia a dia que ninguém mais usa.
 */
function ultimosSeteDias(progresso: Progresso) {
  const hoje = new Date();
  const nomes = ["dom", "seg", "ter", "qua", "qui", "sex", "sáb"];

  return Array.from({ length: 7 }, (_, indice) => {
    const data = new Date(hoje);
    data.setDate(hoje.getDate() - (6 - indice));

    const diasAtras = 6 - indice;
    const dentroDaSequencia = diasAtras < progresso.sequenciaAtual;
    const hojeSemPratica = diasAtras === 0 && !progresso.praticouHoje;

    return {
      rotulo: `${nomes[data.getDay()]} ${data.getDate()}`,
      praticado: dentroDaSequencia && !hojeSemPratica,
    };
  });
}
