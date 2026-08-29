import { useId, useRef, type KeyboardEvent } from "react";

interface Props {
  valor: string;
  onMudar: (valor: string) => void;
  rotulo: string;
  desabilitado?: boolean;
}

/*
 * Editor e um <textarea> com fonte monoespacada, nao CodeMirror nem Monaco: o peso dessas libs
 * (centenas de KB) nao se justifica para colar um trecho de codigo que o backend corrige por
 * heuristica estatica. Limitacao conhecida: sem realce de sintaxe e sem numero de linha.
 *
 * Tab indenta em vez de sair do campo, senao o editor fica inutil para codigo — mas isso quebraria
 * a navegacao por teclado (WCAG 2.1.2, sem armadilha de foco). A saida documentada e Escape, que
 * devolve o foco ao fluxo normal; a instrucao aparece na tela, nao so no codigo.
 */
export function EditorCodigo({ valor, onMudar, rotulo, desabilitado }: Props) {
  const id = useId();
  const idAjuda = `${id}-ajuda`;
  const referencia = useRef<HTMLTextAreaElement>(null);

  function aoTeclar(evento: KeyboardEvent<HTMLTextAreaElement>) {
    if (evento.key === "Escape") {
      referencia.current?.blur();
      return;
    }

    if (evento.key === "Tab") {
      evento.preventDefault();
      const campo = evento.currentTarget;
      const { selectionStart, selectionEnd } = campo;
      const novo = `${valor.slice(0, selectionStart)}  ${valor.slice(selectionEnd)}`;
      onMudar(novo);
      requestAnimationFrame(() => {
        campo.selectionStart = campo.selectionEnd = selectionStart + 2;
      });
    }
  }

  const linhas = valor ? valor.split("\n").length : 0;

  return (
    <div className="flex flex-col gap-2">
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <label htmlFor={id} className="text-sm font-medium text-tinta">
          {rotulo}
        </label>
        <span className="text-xs text-tinta-fraca">
          {linhas} {linhas === 1 ? "linha" : "linhas"}
        </span>
      </div>

      <p id={idAjuda} className="text-xs text-tinta-fraca">
        Tab indenta o código. Para sair do editor pelo teclado, pressione Escape e depois Tab.
      </p>

      <textarea
        id={id}
        ref={referencia}
        value={valor}
        onChange={(evento) => onMudar(evento.target.value)}
        onKeyDown={aoTeclar}
        disabled={desabilitado}
        spellCheck={false}
        rows={18}
        aria-describedby={idAjuda}
        className={
          "w-full resize-y rounded-padrao border border-borda-forte bg-elevada p-4 " +
          "font-codigo text-sm leading-relaxed text-tinta " +
          "disabled:bg-desabilitado disabled:text-desabilitado-tinta"
        }
      />
    </div>
  );
}
