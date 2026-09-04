import { useId, useMemo } from "react";
import CodeMirror from "@uiw/react-codemirror";
import { EditorView, keymap } from "@codemirror/view";
import { HighlightStyle, syntaxHighlighting } from "@codemirror/language";
import { tags } from "@lezer/highlight";
import { java } from "@codemirror/lang-java";
import { python } from "@codemirror/lang-python";
import { sql } from "@codemirror/lang-sql";

interface Props {
  valor: string;
  onMudar: (valor: string) => void;
  rotulo: string;
  desabilitado?: boolean;
  /** Nome da tecnologia do desafio. Decide a gramatica usada no realce. */
  linguagem?: string | null;
}

/*
 * Editor de codigo com CodeMirror 6.
 *
 * A versao anterior era um <textarea>, e o comentario dela dizia que o peso da lib nao se
 * justificava. Justifica: o candidato passa a prova inteira nesta tela, e escrever codigo sem
 * realce, sem numero de linha e sem fechamento automatico de bloco cansa e induz erro que nao tem
 * nada a ver com o problema proposto. O custo e carregar a gramatica de uma linguagem por vez.
 *
 * O tema nao e um pronto de editor escuro: ele usa os tokens do proprio design system, para o
 * editor nao virar uma ilha visual dentro da pagina. As cores de sintaxe moram em
 * design-tokens.css, com o contraste conferido, e nao aqui.
 *
 * Acessibilidade: Tab indenta em vez de mover o foco, senao o editor fica inutil para codigo. Isso
 * criaria armadilha de teclado (WCAG 2.1.2), entao Escape devolve o foco ao fluxo da pagina, e a
 * instrucao aparece na tela e nao so neste comentario.
 */

/*
 * As tags vem do lezer e valem para as tres gramaticas. Uma tag ausente na linguagem simplesmente
 * nao casa: por isso funcao aparece junto de definicao de variavel, que e como o parser de Python
 * marca o nome de uma funcao declarada.
 */
const REALCE = HighlightStyle.define([
  { tag: [tags.keyword, tags.controlKeyword, tags.moduleKeyword], color: "var(--sintaxe-palavra)", fontWeight: "500" },
  { tag: [tags.function(tags.variableName), tags.function(tags.propertyName)], color: "var(--sintaxe-funcao)" },
  /*
   * Nome de funcao na declaracao, que o Python marca com esta tag composta.
   *
   * Nao vale incluir definition(variableName) aqui para tentar pegar a declaracao de metodo do
   * Java: a gramatica usa a mesma tag para o nome do metodo, para o parametro, para a variavel
   * local e para o nome da classe, entao a regra pintaria tudo de cor de funcao. Em Java, a
   * chamada continua realcada por function(propertyName), que e o caso que aparece no codigo do
   * candidato o tempo todo.
   */
  { tag: [tags.definition(tags.function(tags.variableName))], color: "var(--sintaxe-funcao)", fontWeight: "500" },
  /* Declaracao ganha peso, e nao matiz: distingue sem competir com o realce de funcao. */
  { tag: [tags.definition(tags.variableName)], color: "var(--sintaxe-variavel)", fontWeight: "500" },
  { tag: [tags.typeName, tags.className, tags.namespace], color: "var(--sintaxe-tipo)" },
  { tag: [tags.string, tags.special(tags.string), tags.character], color: "var(--sintaxe-literal)" },
  { tag: [tags.number, tags.bool, tags.null, tags.atom], color: "var(--sintaxe-numero)" },
  { tag: [tags.comment, tags.lineComment, tags.blockComment], color: "var(--sintaxe-comentario)", fontStyle: "italic" },
  { tag: [tags.operator, tags.punctuation, tags.separator, tags.bracket], color: "var(--sintaxe-operador)" },
  { tag: [tags.variableName, tags.propertyName], color: "var(--sintaxe-variavel)" },
  { tag: [tags.invalid], color: "var(--erro)" },
]);

const TEMA = EditorView.theme({
  "&": {
    fontSize: "var(--texto-sm)",
    backgroundColor: "var(--superficie-elevada)",
    color: "var(--sintaxe-variavel)",
    border: "var(--borda-fina) solid var(--borda-forte)",
    borderRadius: "var(--raio)",
  },
  "&.cm-focused": { outline: "none", boxShadow: "var(--sombra-foco)" },
  ".cm-scroller": { fontFamily: "var(--fonte-codigo)", lineHeight: "1.6" },
  ".cm-content": { padding: "var(--espaco-3) 0", caretColor: "var(--tinta-forte)" },
  ".cm-gutters": {
    backgroundColor: "var(--editor-gutter)",
    color: "var(--tinta-fraca)",
    border: "none",
    borderRight: "var(--borda-fina) solid var(--borda)",
  },
  ".cm-activeLine": { backgroundColor: "var(--editor-linha-ativa)" },
  ".cm-activeLineGutter": { backgroundColor: "var(--editor-linha-ativa)", color: "var(--tinta-media)" },
  ".cm-selectionBackground, &.cm-focused .cm-selectionBackground, .cm-content ::selection": {
    backgroundColor: "var(--editor-selecao)",
  },
  /* O par casado ganha fundo, e nao so cor: cor sozinha nao chega a quem nao distingue matiz. */
  ".cm-matchingBracket, &.cm-focused .cm-matchingBracket": {
    backgroundColor: "var(--acento-suave)",
    outline: "var(--borda-fina) solid var(--acento)",
  },
  ".cm-nonmatchingBracket": { backgroundColor: "var(--erro-suave)", color: "var(--erro)" },
  ".cm-cursor": { borderLeftColor: "var(--tinta-forte)", borderLeftWidth: "2px" },
});

/*
 * Precisa ser uma constante de modulo, e nao um objeto literal na JSX: o @uiw/react-codemirror
 * compara a referencia para decidir se reconfigura o editor. Objeto novo a cada render remonta o
 * CodeMirror a cada tecla, e o efeito e o editor perder a quebra de linha e a posicao do cursor.
 */
const CONFIGURACAO = {
  lineNumbers: true,
  highlightActiveLine: true,
  highlightActiveLineGutter: true,
  bracketMatching: true,
  closeBrackets: true,
  autocompletion: false,
  foldGutter: false,
  /* Busca dentro do editor roubaria o Ctrl+F do navegador durante a prova. */
  searchKeymap: false,
  highlightSelectionMatches: true,
} as const;

/** Sem tecnologia conhecida o editor fica sem gramatica: melhor texto cru do que realce errado. */
function gramatica(linguagem?: string | null) {
  switch (linguagem?.toLowerCase()) {
    case "java":
      return [java()];
    case "python":
      return [python()];
    case "sql":
      return [sql()];
    default:
      return [];
  }
}

export function EditorCodigo({ valor, onMudar, rotulo, desabilitado, linguagem }: Props) {
  const id = useId();
  const idAjuda = `${id}-ajuda`;

  const extensoes = useMemo(
    () => [
      ...gramatica(linguagem),
      TEMA,
      syntaxHighlighting(REALCE),
      EditorView.lineWrapping,
      /* Escape tira o foco do editor: e a saida da armadilha de teclado que o Tab cria. */
      keymap.of([
        {
          key: "Escape",
          run: (view) => {
            view.contentDOM.blur();
            return true;
          },
        },
      ]),
      EditorView.editorAttributes.of({ "aria-describedby": idAjuda }),
    ],
    [linguagem, idAjuda],
  );

  const linhas = valor ? valor.split("\n").length : 0;

  return (
    <div className="flex flex-col gap-2">
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <label htmlFor={id} className="text-sm font-medium text-tinta">
          {rotulo}
        </label>
        <span className="text-xs text-tinta-fraca">
          {linguagem ? `${linguagem} · ` : ""}
          {linhas} {linhas === 1 ? "linha" : "linhas"}
        </span>
      </div>

      <p id={idAjuda} className="text-xs text-tinta-fraca">
        Tab indenta o código e fecha blocos automaticamente. Para sair do editor pelo teclado,
        pressione Escape e depois Tab.
      </p>

      <CodeMirror
        id={id}
        value={valor}
        onChange={onMudar}
        editable={!desabilitado}
        readOnly={desabilitado}
        height="28rem"
        indentWithTab
        extensions={extensoes}
        basicSetup={CONFIGURACAO}
        className={
          "overflow-hidden rounded-padrao " +
          (desabilitado ? "opacity-60" : "")
        }
      />
    </div>
  );
}
