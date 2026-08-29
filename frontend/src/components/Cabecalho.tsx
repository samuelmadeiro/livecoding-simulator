import { LogOut } from "lucide-react";
import { Link, NavLink } from "react-router-dom";
import { useAuth } from "../auth/useAuth";
import { Botao } from "./Botao";

export function Cabecalho() {
  const { sessao, autenticado, sair } = useAuth();

  return (
    <header className="border-b border-borda bg-elevada">
      <div className="flex flex-wrap items-center justify-between gap-4 px-6 py-4 md:px-12">
        <Link
          to="/"
          className="font-titulo text-md font-semibold text-tinta hover:text-acento"
        >
          LiveCoding Simulator
        </Link>

        <nav aria-label="Navegação principal" className="flex items-center gap-2">
          <NavLink
            to="/"
            end
            className={({ isActive }) =>
              "rounded-padrao px-3 py-2 text-sm " +
              (isActive
                ? "font-medium text-acento underline decoration-2 underline-offset-8"
                : "text-tinta-media hover:text-tinta")
            }
          >
            Desafios
          </NavLink>

          {autenticado ? (
            <div className="flex items-center gap-3">
              <span className="text-sm text-tinta-fraca">{sessao?.nome}</span>
              <Botao variante="secundario" onClick={sair}>
                <LogOut aria-hidden="true" size={16} />
                Sair
              </Botao>
            </div>
          ) : (
            <>
              <NavLink
                to="/entrar"
                className="rounded-padrao px-3 py-2 text-sm text-tinta-media hover:text-tinta"
              >
                Entrar
              </NavLink>
              <Link
                to="/cadastrar"
                className="inline-flex min-h-10 items-center rounded-padrao border border-acento bg-acento px-4 py-2 text-sm font-medium text-tinta-invertida hover:bg-acento-escuro"
              >
                Criar conta
              </Link>
            </>
          )}
        </nav>
      </div>
    </header>
  );
}
