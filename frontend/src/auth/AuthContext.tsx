import { useCallback, useEffect, useMemo, useState, type ReactNode } from "react";
import { api } from "../api/client";
import type { Autenticacao } from "../api/types";
import { AuthContext, type Sessao, type ValorDoContexto } from "./contexto";

/*
 * O token fica em sessionStorage: sobrevive ao refresh da pagina e morre quando a aba fecha.
 * Limitacao conhecida: qualquer XSS na aplicacao consegue ler o token. A alternativa correta e
 * cookie HttpOnly, que exige o backend passar a emitir e validar cookie em vez do header
 * Authorization — hoje a API e stateless por header (SecurityConfig + JwtAuthenticationFilter).
 */
const CHAVE = "livecoding.sessao";

function ler(): Sessao | null {
  try {
    const cru = sessionStorage.getItem(CHAVE);
    if (!cru) return null;
    const sessao = JSON.parse(cru) as Sessao;
    if (sessao.expiraEm <= Date.now()) return null;
    // Sessao gravada antes de a role existir: trata como candidato ate o proximo login.
    return { ...sessao, role: sessao.role ?? "CANDIDATO" };
  } catch {
    return null;
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [sessao, setSessao] = useState<Sessao | null>(ler);

  const guardar = useCallback((resposta: Autenticacao) => {
    const nova: Sessao = {
      token: resposta.token,
      nome: resposta.nome,
      email: resposta.email,
      role: resposta.role,
      expiraEm: Date.now() + resposta.expiraEmMs,
    };
    setSessao(nova);
    try {
      sessionStorage.setItem(CHAVE, JSON.stringify(nova));
    } catch {
      // Navegador em modo restrito: a sessao segue valendo em memoria ate o refresh.
    }
  }, []);

  const sair = useCallback(() => {
    setSessao(null);
    try {
      sessionStorage.removeItem(CHAVE);
    } catch {
      // sem storage: limpar a memoria ja basta
    }
  }, []);

  // Derruba a sessao no exato momento da expiracao, sem esperar a proxima requisicao falhar.
  useEffect(() => {
    if (!sessao) return;
    const restante = sessao.expiraEm - Date.now();
    if (restante <= 0) {
      sair();
      return;
    }
    const id = window.setTimeout(sair, restante);
    return () => window.clearTimeout(id);
  }, [sessao, sair]);

  const valor = useMemo<ValorDoContexto>(
    () => ({
      sessao,
      autenticado: sessao != null,
      admin: sessao?.role === "ADMIN",
      entrar: async (email, senha) => guardar(await api.entrar(email, senha)),
      cadastrar: async (nome, email, senha) =>
        guardar(await api.cadastrar(nome, email, senha)),
      sair,
    }),
    [sessao, guardar, sair],
  );

  return <AuthContext.Provider value={valor}>{children}</AuthContext.Provider>;
}
