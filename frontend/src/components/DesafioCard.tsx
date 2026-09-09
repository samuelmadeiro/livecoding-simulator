import { CircleCheck, Clock } from "lucide-react";
import { Link } from "react-router-dom";
import { ROTULO_NIVEL, ROTULO_TIPO, type Desafio } from "../api/types";
import { Etiqueta } from "./Etiqueta";
import { EtiquetaDificuldade } from "./EtiquetaDificuldade";

/*
 * O card inteiro nao e clicavel: so o titulo e link. Card-link engole o texto para quem navega
 * por teclado e por leitor de tela, que passa a ouvir a descricao inteira como rotulo do link.
 */
export function DesafioCard({ desafio }: { desafio: Desafio }) {
  return (
    <article className="flex flex-col gap-4 border border-borda bg-elevada p-6 rounded-padrao">
      <div className="flex flex-wrap items-center gap-2">
        <Etiqueta tom="acento">{ROTULO_NIVEL[desafio.nivel]}</Etiqueta>
        <EtiquetaDificuldade dificuldade={desafio.dificuldade} />
        <Etiqueta>{ROTULO_TIPO[desafio.tipo]}</Etiqueta>
        {desafio.tecnologiaNome ? <Etiqueta>{desafio.tecnologiaNome}</Etiqueta> : null}
      </div>

      <h3 className="flex flex-wrap items-center gap-3 text-md">
        <Link
          to={`/desafios/${desafio.id}`}
          className="text-tinta underline decoration-borda-forte underline-offset-4 hover:decoration-acento"
        >
          {desafio.titulo}
        </Link>

        {/*
         * Selo de conquista. Ícone e texto juntos: cor sozinha não informa, e aqui ela seria o
         * único sinal. Só aparece quando o servidor sabe de quem se trata — para visitante o campo
         * vem nulo, e "não resolvida" seria uma afirmação que ninguém fez.
         */}
        {desafio.resolvido === true ? (
          <span className="inline-flex items-center gap-1 border border-ok bg-ok-suave px-2 py-0.5 text-xs text-ok rounded-padrao">
            <CircleCheck aria-hidden="true" size={12} />
            resolvida
          </span>
        ) : null}
      </h3>

      <p className="max-w-[var(--medida-texto)] text-tinta-media">{desafio.descricao}</p>

      {desafio.tempoLimiteMinutos != null ? (
        <p className="flex items-center gap-2 text-sm text-tinta-fraca">
          <Clock aria-hidden="true" size={16} />
          <span>Tempo sugerido: {desafio.tempoLimiteMinutos} minutos</span>
        </p>
      ) : null}
    </article>
  );
}
