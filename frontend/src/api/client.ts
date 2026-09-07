import type {
  Autenticacao,
  ConsultaDesafios,
  Desafio,
  Pagina,
  PainelAdmin,
  Progresso,
  RankingItem,
  Submissao,
  Tecnologia,
  Tentativa,
} from "./types";

const BASE = import.meta.env.VITE_API_URL ?? "http://localhost:8080";

/**
 * Erro de API com o corpo ja traduzido. O GlobalExceptionHandler devolve `mensagem` em 404/409/401
 * e um mapa `erros` (campo -> mensagem) em 400 de validacao; os dois formatos chegam aqui.
 */
export class ErroDeApi extends Error {
  readonly status: number;
  readonly porCampo: Record<string, string>;

  constructor(status: number, mensagem: string, porCampo: Record<string, string> = {}) {
    super(mensagem);
    this.name = "ErroDeApi";
    this.status = status;
    this.porCampo = porCampo;
  }

  get naoAutorizado(): boolean {
    return this.status === 401 || this.status === 403;
  }
}

interface CorpoDeErro {
  mensagem?: string;
  erros?: Record<string, string>;
}

async function requisitar<T>(
  caminho: string,
  opcoes: RequestInit = {},
  token?: string | null,
): Promise<T> {
  const cabecalhos = new Headers(opcoes.headers);
  if (opcoes.body) {
    cabecalhos.set("Content-Type", "application/json");
  }
  if (token) {
    cabecalhos.set("Authorization", `Bearer ${token}`);
  }

  let resposta: Response;
  try {
    resposta = await fetch(`${BASE}${caminho}`, { ...opcoes, headers: cabecalhos });
  } catch {
    // Falha de rede nao tem status: o backend pode estar fora do ar ou o CORS barrou.
    throw new ErroDeApi(0, "Não foi possível falar com o servidor. Ele está no ar?");
  }

  if (resposta.status === 204) {
    return undefined as T;
  }

  const texto = await resposta.text();
  const corpo: unknown = texto ? JSON.parse(texto) : null;

  if (!resposta.ok) {
    const erro = (corpo ?? {}) as CorpoDeErro;
    const porCampo = erro.erros ?? {};
    const mensagem =
      erro.mensagem ??
      Object.values(porCampo)[0] ??
      mensagemPadrao(resposta.status);
    throw new ErroDeApi(resposta.status, mensagem, porCampo);
  }

  return corpo as T;
}

function mensagemPadrao(status: number): string {
  if (status === 401) return "Sessão expirada. Entre de novo para enviar sua solução.";
  if (status === 403) return "Você não tem permissão para isso.";
  if (status === 404) return "Não encontramos o que você procurava.";
  if (status >= 500) return "O servidor falhou ao responder. Tente de novo em instantes.";
  return "Não foi possível concluir a operação.";
}

export const api = {
  /**
   * Uma pagina do catalogo. Parametro ausente = sem filtro; a ordem e o tamanho tem padrao no
   * backend, entao a URL so carrega o que a pessoa escolheu.
   */
  listarDesafios(consulta: ConsultaDesafios = {}): Promise<Pagina<Desafio>> {
    const parametros = new URLSearchParams();
    if (consulta.nivel) parametros.set("nivel", consulta.nivel);
    if (consulta.tipo) parametros.set("tipo", consulta.tipo);
    if (consulta.dificuldade) parametros.set("dificuldade", consulta.dificuldade);
    if (consulta.tecnologiaId != null) {
      parametros.set("tecnologiaId", String(consulta.tecnologiaId));
    }
    if (consulta.ordenar) parametros.set("ordenar", consulta.ordenar);
    if (consulta.pagina != null) parametros.set("pagina", String(consulta.pagina));
    if (consulta.tamanho != null) parametros.set("tamanho", String(consulta.tamanho));

    const query = parametros.toString();
    return requisitar<Pagina<Desafio>>(`/api/desafios${query ? `?${query}` : ""}`);
  },

  /**
   * O vocabulario do filtro de tecnologia. Vem da API, e nao dos desafios que voltaram: com
   * paginacao, a fatia visivel nao conhece o catalogo inteiro.
   */
  listarTecnologias(): Promise<Tecnologia[]> {
    return requisitar<Tecnologia[]>("/api/tecnologias");
  },

  buscarDesafio(id: number): Promise<Desafio> {
    return requisitar<Desafio>(`/api/desafios/${id}`);
  },

  entrar(email: string, senha: string): Promise<Autenticacao> {
    return requisitar<Autenticacao>("/api/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, senha }),
    });
  },

  cadastrar(nome: string, email: string, senha: string): Promise<Autenticacao> {
    return requisitar<Autenticacao>("/api/auth/register", {
      method: "POST",
      body: JSON.stringify({ nome, email, senha }),
    });
  },

  /**
   * Abre (ou recupera) o cronometro do desafio. Chamar de novo devolve a tentativa que ja estava
   * aberta, entao recarregar a pagina no meio da questao nao zera o relogio.
   */
  iniciarDesafio(desafioId: number, token: string): Promise<Tentativa> {
    return requisitar<Tentativa>(
      `/api/desafios/${desafioId}/iniciar`,
      { method: "POST" },
      token,
    );
  },

  enviarSubmissao(
    desafioId: number,
    codigoEnviado: string,
    token: string,
    tentativaId?: number | null,
  ): Promise<Submissao> {
    // O tempo gasto nao vai no corpo de proposito: quem mede e o servidor, a partir da tentativa.
    return requisitar<Submissao>(
      "/api/submissoes",
      {
        method: "POST",
        body: JSON.stringify({ desafioId, codigoEnviado, tentativaId: tentativaId ?? null }),
      },
      token,
    );
  },

  buscarPainelAdmin(token: string): Promise<PainelAdmin> {
    return requisitar<PainelAdmin>("/api/admin/metricas", {}, token);
  },

  /** Ranking público: sem token, porque a home mostra ele para quem ainda não tem conta. */
  buscarRanking(): Promise<RankingItem[]> {
    return requisitar<RankingItem[]>("/api/ranking");
  },

  buscarProgresso(token: string): Promise<Progresso> {
    return requisitar<Progresso>("/api/progresso", {}, token);
  },
};
