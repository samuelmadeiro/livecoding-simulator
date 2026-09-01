import type { ReactNode } from "react";
import { Link, Navigate } from "react-router-dom";
import { useAuth } from "./useAuth";

/*
 * Guarda da área do admin. É conveniência de navegação, não segurança: o backend barra
 * /api/admin/** por role no SecurityConfig. Esconder a rota no front sem a regra no servidor
 * seria apenas tirar o link da vista.
 */
export function RotaAdmin({ children }: { children: ReactNode }) {
  const { autenticado, admin } = useAuth();

  if (!autenticado) {
    return <Navigate to="/entrar" state={{ de: "/admin" }} replace />;
  }

  if (!admin) {
    return (
      <main id="conteudo" className="flex flex-col gap-4 px-6 py-16 md:px-12">
        <h1 className="text-lg text-tinta">Área restrita</h1>
        <p className="max-w-[var(--medida-texto)] text-tinta-media">
          Esta página é do time que administra a plataforma. Sua conta entra como candidato.
        </p>
        <Link
          to="/"
          className="w-fit text-tinta underline decoration-borda-forte underline-offset-4 hover:decoration-acento"
        >
          Voltar para o catálogo
        </Link>
      </main>
    );
  }

  return children;
}
