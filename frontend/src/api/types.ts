/** Espelho dos DTOs e enums do backend (com.portfolio.livecoding.dto / .enums). */

export const NIVEIS = ["ESTAGIO", "JUNIOR", "PLENO"] as const;
export type NivelVaga = (typeof NIVEIS)[number];

export const TIPOS = ["API_REST", "ALGORITMO_EASY", "BANCO_DADOS"] as const;
export type TipoDesafio = (typeof TIPOS)[number];

export type StatusSubmissao =
  | "PENDENTE"
  | "APROVADO"
  | "ERRO_COMPILACAO"
  | "ERRO_TESTE";

export type Role = "CANDIDATO" | "ADMIN";

export interface Desafio {
  id: number;
  titulo: string;
  descricao: string;
  nivel: NivelVaga;
  tipo: TipoDesafio;
  tempoLimiteMinutos: number | null;
  templateCodigo: string | null;
  tecnologiaId: number | null;
  tecnologiaNome: string | null;
}

export interface Autenticacao {
  token: string;
  tipo: string;
  expiraEmMs: number;
  nome: string;
  email: string;
  role: Role;
}

/** Um item do feedback: o que era esperado e se a submissao atendeu. */
export interface CriterioResultado {
  descricao: string;
  atendido: boolean;
}

export interface Submissao {
  submissaoId: number;
  status: StatusSubmissao;
  mensagemFeedback: string;
  /** Nota de 0 a 100. Nula em submissoes antigas, gravadas antes da correcao por criterios. */
  pontuacao: number | null;
  criterios: CriterioResultado[];
}

export interface FiltroDesafios {
  nivel?: NivelVaga;
  tecnologiaId?: number;
  tipo?: TipoDesafio;
}

/** Rotulos em portugues para os enums; a UI nunca mostra a constante crua. */
export const ROTULO_NIVEL: Record<NivelVaga, string> = {
  ESTAGIO: "Estágio",
  JUNIOR: "Júnior",
  PLENO: "Pleno",
};

export const ROTULO_TIPO: Record<TipoDesafio, string> = {
  API_REST: "API REST",
  ALGORITMO_EASY: "Algoritmo",
  BANCO_DADOS: "Banco de dados",
};

export const ROTULO_STATUS: Record<StatusSubmissao, string> = {
  PENDENTE: "Em análise",
  APROVADO: "Aprovado",
  ERRO_COMPILACAO: "Erro de compilação",
  ERRO_TESTE: "Testes falharam",
};
