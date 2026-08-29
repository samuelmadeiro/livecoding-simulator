import { AlertTriangle, Inbox, Loader } from "lucide-react";
import type { ReactNode } from "react";

/* Conjunto de icones unico do projeto: lucide-react. Nenhum emoji em interface. */

export function Carregando({ rotulo }: { rotulo: string }) {
  return (
    <div
      role="status"
      className="flex items-center gap-3 px-4 py-8 text-tinta-media"
    >
      <Loader aria-hidden="true" size={20} className="shrink-0" />
      <span>{rotulo}</span>
    </div>
  );
}

export function Vazio({ titulo, children }: { titulo: string; children?: ReactNode }) {
  return (
    <div className="flex flex-col items-start gap-3 border border-borda bg-afundada px-6 py-8 rounded-padrao">
      <Inbox aria-hidden="true" size={24} className="text-tinta-fraca" />
      <h2 className="text-md text-tinta">{titulo}</h2>
      {children ? (
        <p className="max-w-[var(--medida-texto)] text-tinta-media">{children}</p>
      ) : null}
    </div>
  );
}

export function Falha({ mensagem, acao }: { mensagem: string; acao?: ReactNode }) {
  return (
    <div
      role="alert"
      className="flex flex-col items-start gap-3 border border-erro bg-erro-suave px-6 py-6 rounded-padrao"
    >
      <p className="flex items-start gap-3 text-erro">
        <AlertTriangle aria-hidden="true" size={20} className="mt-1 shrink-0" />
        <span className="max-w-[var(--medida-texto)]">{mensagem}</span>
      </p>
      {acao}
    </div>
  );
}
