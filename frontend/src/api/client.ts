import type {
  Autenticacao,
  Desafio,
  FiltroDesafios,
  Submissao,
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
  listarDesafios(filtro: FiltroDesafios = {}): Promise<Desafio[]> {
    const parametros = new URLSearchParams();
    if (filtro.nivel) parametros.set("nivel", filtro.nivel);
    if (filtro.tipo) parametros.set("tipo", filtro.tipo);
    if (filtro.tecnologiaId != null) {
      parametros.set("tecnologiaId", String(filtro.tecnologiaId));
    }
    const consulta = parametros.toString();
    return requisitar<Desafio[]>(`/api/desafios${consulta ? `?${consulta}` : ""}`);
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

  enviarSubmissao(
    desafioId: number,
    codigoEnviado: string,
    token: string,
  ): Promise<Submissao> {
    return requisitar<Submissao>(
      "/api/submissoes",
      { method: "POST", body: JSON.stringify({ desafioId, codigoEnviado }) },
      token,
    );
  },
};
