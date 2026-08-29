import { useId, type InputHTMLAttributes } from "react";

interface Props extends Omit<InputHTMLAttributes<HTMLInputElement>, "id"> {
  rotulo: string;
  erro?: string;
  dica?: string;
}

/**
 * Campo com rotulo sempre visivel (placeholder nao substitui rotulo) e erro ligado ao input por
 * aria-describedby + aria-invalid, para o leitor de tela anunciar junto com o campo. O erro
 * tambem carrega icone e texto: cor sozinha nao informa nada (WCAG 1.4.1).
 */
export function CampoTexto({ rotulo, erro, dica, ...resto }: Props) {
  const id = useId();
  const idErro = `${id}-erro`;
  const idDica = `${id}-dica`;
  const descrito = [erro ? idErro : null, dica ? idDica : null]
    .filter(Boolean)
    .join(" ");

  return (
    <div className="flex flex-col gap-2">
      <label htmlFor={id} className="text-sm font-medium text-tinta">
        {rotulo}
      </label>

      {dica ? (
        <p id={idDica} className="text-xs text-tinta-fraca">
          {dica}
        </p>
      ) : null}

      <input
        id={id}
        aria-invalid={erro ? true : undefined}
        aria-describedby={descrito || undefined}
        className={
          "rounded-padrao border bg-elevada px-3 py-2 min-h-10 text-base text-tinta " +
          "placeholder:text-tinta-fraca " +
          (erro ? "border-erro" : "border-borda-forte")
        }
        {...resto}
      />

      {erro ? (
        <p id={idErro} className="flex items-start gap-2 text-sm text-erro">
          <span aria-hidden="true" className="font-bold leading-6">
            !
          </span>
          <span>{erro}</span>
        </p>
      ) : null}
    </div>
  );
}
