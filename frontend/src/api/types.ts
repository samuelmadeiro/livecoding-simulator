/** Espelho dos DTOs e enums do backend (com.portfolio.livecoding.dto / .enums). */

export const NIVEIS = ["ESTAGIO", "JUNIOR", "PLENO", "SENIOR"] as const;
export type NivelVaga = (typeof NIVEIS)[number];

export const TIPOS = ["API_REST", "ALGORITMO_EASY", "BANCO_DADOS"] as const;
export type TipoDesafio = (typeof TIPOS)[number];

/* Quanto a questao cobra. Eixo separado do nivel da vaga: nivel diz para qual vaga ela serve. */
export const DIFICULDADES = ["FACIL", "MEDIO", "DIFICIL"] as const;
export type Dificuldade = (typeof DIFICULDADES)[number];

/** Ordenacoes que o catalogo aceita. Espelho de OrdemDesafios no backend. */
export const ORDENS = [
  "PADRAO",
  "DIFICULDADE_CRESCENTE",
  "DIFICULDADE_DECRESCENTE",
  "TITULO",
  "TEMPO_CRESCENTE",
  "TEMPO_DECRESCENTE",
] as const;
export type OrdemDesafios = (typeof ORDENS)[number];

export type StatusSubmissao =
  | "PENDENTE"
  | "APROVADO"
  | "ERRO_COMPILACAO"
  | "ERRO_TESTE";

export type Role = "CANDIDATO" | "ADMIN";

export type TipoCriterio = "OBRIGATORIO" | "PONTUAVEL" | "PROIBIDO";

export interface Desafio {
  id: number;
  titulo: string;
  descricao: string;
  nivel: NivelVaga;
  dificuldade: Dificuldade;
  tipo: TipoDesafio;
  tempoLimiteMinutos: number | null;
  templateCodigo: string | null;
  /* Partes do enunciado. Nulas nos desafios criados antes do enunciado estruturado. */
  contexto: string | null;
  formatoEntrada: string | null;
  formatoSaida: string | null;
  exemplo: string | null;
  restricoes: string | null;
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

/** Cronômetro aberto no servidor quando o candidato começa o desafio. */
export interface Tentativa {
  tentativaId: number;
  desafioId: number;
  iniciadoEm: string;
  tempoLimiteMinutos: number | null;
  decorridoSegundos: number;
}

/** Um item do feedback: o que era esperado, quanto vale e se a submissão atendeu. */
export interface CriterioResultado {
  descricao: string;
  atendido: boolean;
  tipo: TipoCriterio;
  peso: number;
  dica: string | null;
}

/** Um ponto a corrigir, na voz de quem entrevista. */
export interface AjusteEntrevistador {
  oQueFaltou: string;
  dica: string;
  porQueImporta: string;
}

/** O retorno que um entrevistador daria depois de ler o código. */
export interface FalaEntrevistador {
  entrevistador: string;
  cargo: string;
  abertura: string;
  elogios: string[];
  ajustes: AjusteEntrevistador[];
  comentarioTempo: string;
  comoAvaliei: string;
  fechamento: string;
}

export interface Submissao {
  submissaoId: number;
  status: StatusSubmissao;
  mensagemFeedback: string;
  /** Nota de 0 a 100 sobre os critérios que valem ponto. */
  pontuacao: number | null;
  /** 0 a 100 sobre a régua inteira do desafio, obrigatórios inclusos. */
  precisao: number | null;
  /** Tempo entre abrir o desafio e enviar. Nulo em submissão sem cronômetro. */
  duracaoSegundos: number | null;
  criterios: CriterioResultado[];
  entrevistador: FalaEntrevistador | null;
  /** Pontos e sequência que esta submissão mexeu. Nulo em submissões anteriores à gamificação. */
  progresso: GanhoProgresso | null;
}

export interface FiltroDesafios {
  nivel?: NivelVaga;
  tecnologiaId?: number;
  tipo?: TipoDesafio;
  dificuldade?: Dificuldade;
}

/** O que a tela do catalogo pede de uma vez: os filtros, a ordem e qual fatia. */
export interface ConsultaDesafios extends FiltroDesafios {
  ordenar?: OrdemDesafios;
  pagina?: number;
  tamanho?: number;
}

/** Uma fatia de resultado. Espelho de PaginaDTO: o total conta o filtro inteiro, nao a fatia. */
export interface Pagina<T> {
  conteudo: T[];
  pagina: number;
  tamanho: number;
  totalItens: number;
  totalPaginas: number;
  primeira: boolean;
  ultima: boolean;
}

/** Uma tecnologia do catalogo, como GET /api/tecnologias devolve. */
export interface Tecnologia {
  id: number;
  nome: string;
}

/* ---------- Painel do admin (GET /api/admin/metricas) ---------- */

export interface ResumoAdmin {
  candidatos: number;
  desafios: number;
  submissoes: number;
  aprovadas: number;
  taxaAprovacao: number;
  pontuacaoMedia: number | null;
  precisaoMedia: number | null;
  tempoMedioSegundos: number | null;
  tempoTotalSegundos: number | null;
}

export interface MetricaUsuario {
  usuarioId: number;
  nome: string;
  email: string;
  role: Role;
  submissoes: number;
  aprovadas: number;
  taxaAcerto: number;
  pontuacaoMedia: number | null;
  precisaoMedia: number | null;
  tempoMedioSegundos: number | null;
  tempoTotalSegundos: number | null;
  ultimaSubmissao: string | null;
}

export interface MetricaCriterio {
  descricao: string;
  tipo: TipoCriterio;
  peso: number;
  avaliacoes: number;
  atendidas: number;
  taxaAcerto: number;
}

export interface MetricaDesafio {
  desafioId: number;
  titulo: string;
  nivel: NivelVaga;
  tipo: TipoDesafio;
  tecnologiaNome: string | null;
  tempoLimiteMinutos: number | null;
  submissoes: number;
  candidatos: number;
  aprovadas: number;
  taxaAprovacao: number;
  pontuacaoMedia: number | null;
  precisaoMedia: number | null;
  tempoMedioSegundos: number | null;
  criterioCritico: string | null;
  criterios: MetricaCriterio[];
}

export interface SubmissaoRecente {
  submissaoId: number;
  candidato: string;
  email: string;
  desafio: string;
  status: StatusSubmissao;
  pontuacao: number | null;
  precisao: number | null;
  duracaoSegundos: number | null;
  dataHora: string;
}

export interface PainelAdmin {
  resumo: ResumoAdmin;
  usuarios: MetricaUsuario[];
  desafios: MetricaDesafio[];
  ultimasSubmissoes: SubmissaoRecente[];
}

/** Rotulos em portugues para os enums; a UI nunca mostra a constante crua. */
export const ROTULO_NIVEL: Record<NivelVaga, string> = {
  ESTAGIO: "Estágio",
  JUNIOR: "Júnior",
  PLENO: "Pleno",
  SENIOR: "Sênior",
};

export const ROTULO_DIFICULDADE: Record<Dificuldade, string> = {
  FACIL: "Fácil",
  MEDIO: "Média",
  DIFICIL: "Difícil",
};

/* O rotulo diz o efeito, nao o nome tecnico da constante: quem le quer saber o que muda na tela. */
export const ROTULO_ORDEM: Record<OrdemDesafios, string> = {
  PADRAO: "Ordem do catálogo",
  DIFICULDADE_CRESCENTE: "Da mais fácil para a mais difícil",
  DIFICULDADE_DECRESCENTE: "Da mais difícil para a mais fácil",
  TITULO: "Título (A-Z)",
  TEMPO_CRESCENTE: "Menor tempo primeiro",
  TEMPO_DECRESCENTE: "Maior tempo primeiro",
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

export const ROTULO_CRITERIO: Record<TipoCriterio, string> = {
  OBRIGATORIO: "Essencial",
  PONTUAVEL: "Vale ponto",
  PROIBIDO: "Não pode aparecer",
};

/* ---------- Progresso e ranking ---------- */

/** Uma linha do ranking público. Traz apelido, nunca nome completo ou e-mail. */
export interface RankingItem {
  posicao: number;
  apelido: string;
  pontos: number;
  sequenciaAtual: number;
  questoesResolvidas: number;
}

export interface ConquistaResumo {
  desafioId: number;
  titulo: string;
  tecnologia: string;
  nivel: NivelVaga;
  pontos: number;
  precisao: number;
  conquistadoEm: string;
}

/** O progresso do candidato logado, como o painel dele mostra. */
export interface Progresso {
  apelido: string;
  pontos: number;
  sequenciaAtual: number;
  sequenciaRecorde: number;
  ultimoDiaPraticado: string | null;
  praticouHoje: boolean;
  questoesResolvidas: number;
  questoesDisponiveis: number;
  /** Nulo enquanto a pessoa não pontuou: sem pontos não há posição. */
  posicaoNoRanking: number | null;
  ultimasConquistas: ConquistaResumo[];
}

/**
 * O que a submissão mexeu no progresso. `primeiraVez` distingue a questão recém-conquistada da
 * refeita: refazer não paga de novo, e a tela precisa dizer isso.
 */
export interface GanhoProgresso {
  pontosGanhos: number;
  primeiraVez: boolean;
  sequenciaAtual: number;
  sequenciaCresceu: boolean;
}
