import { createContext } from "react";

export interface Sessao {
  token: string;
  nome: string;
  email: string;
  expiraEm: number;
}

export interface ValorDoContexto {
  sessao: Sessao | null;
  autenticado: boolean;
  entrar: (email: string, senha: string) => Promise<void>;
  cadastrar: (nome: string, email: string, senha: string) => Promise<void>;
  sair: () => void;
}

/* Em arquivo proprio: um modulo que exporta contexto e componente junto quebra o fast refresh
 * do Vite, que so recarrega em isolamento arquivos que exportam apenas componentes. */
export const AuthContext = createContext<ValorDoContexto | null>(null);
