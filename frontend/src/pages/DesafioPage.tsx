import { ArrowLeft, Clock } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { ErroDeApi, api } from "../api/client";
import {
  ROTULO_NIVEL,
  ROTULO_TIPO,
  type Desafio,
  type Submissao,
} from "../api/types";
import { useAuth } from "../auth/useAuth";
import { Botao } from "../components/Botao";
import { EditorCodigo } from "../components/EditorCodigo";
import { Carregando, Falha } from "../components/Estados";
import { Etiqueta } from "../components/Etiqueta";
import { ResultadoSubmissao } from "../components/ResultadoSubmissao";

export function DesafioPage() {
  const { id } = useParams<{ id: string }>();
  const navegar = useNavigate();
  const { sessao, autenticado } = useAuth();

  const [desafio, setDesafio] = useState<Desafio | null>(null);
  const [erroCarga, setErroCarga] = useState<string | null>(null);
  const [codigo, setCodigo] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [resultado, setResultado] = useState<Submissao | null>(null);
  const [erroEnvio, setErroEnvio] = useState<string | null>(null);
  const ancoraResultado = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const numero = Number(id);
    if (!Number.isInteger(numero)) {
      setErroCarga("Endereço de desafio inválido.");
      return;
    }

    let cancelado = false;
    api
      .buscarDesafio(numero)
      .then((encontrado) => {
        if (cancelado) return;
        setDesafio(encontrado);
        setCodigo(encontrado.templateCodigo ?? "");
      })
      .catch((causa: unknown) => {
        if (cancelado) return;
        setErroCarga(
          causa instanceof ErroDeApi ? causa.message : "Falha ao carregar o desafio.",
        );
      });

    return () => {
      cancelado = true;
    };
  }, [id]);

  async function enviar() {
    if (!desafio || !sessao) return;

    setEnviando(true);
    setErroEnvio(null);
    setResultado(null);

    try {
      const resposta = await api.enviarSubmissao(desafio.id, codigo, sessao.token);
      setResultado(resposta);
      // Move o foco para o resultado: sem isso, quem usa teclado ou leitor de tela nao percebe
      // que a resposta chegou no fim da pagina.
      requestAnimationFrame(() => ancoraResultado.current?.focus());
    } catch (causa: unknown) {
      if (causa instanceof ErroDeApi && causa.naoAutorizado) {
        navegar("/entrar", { state: { de: `/desafios/${desafio.id}` } });
        return;
      }
      setErroEnvio(
        causa instanceof ErroDeApi ? causa.message : "Falha ao enviar a solução.",
      );
    } finally {
      setEnviando(false);
    }
  }

  if (erroCarga) {
    return (
      <div className="px-6 py-12 md:px-12">
        <Falha
          mensagem={erroCarga}
          acao={
            <Link
              to="/"
              className="text-sm text-tinta underline decoration-borda-forte underline-offset-4 hover:decoration-acento"
            >
              Voltar para o catálogo
            </Link>
          }
        />
      </div>
    );
  }

  if (!desafio) {
    return (
      <div className="px-6 py-12 md:px-12">
        <Carregando rotulo="Abrindo o desafio" />
      </div>
    );
  }

  const vazio = codigo.trim().length === 0;

  return (
    <div className="flex flex-col gap-8 px-6 py-12 md:px-12">
      {/* Em <nav> proprio: link solto fora de landmark e invisivel para quem navega por regioes. */}
      <nav aria-label="Trilha">
        <Link
          to="/"
          className="inline-flex w-fit items-center gap-2 text-sm text-tinta-media underline decoration-borda-forte underline-offset-4 hover:text-tinta hover:decoration-acento"
        >
          <ArrowLeft aria-hidden="true" size={16} />
          Todos os desafios
        </Link>
      </nav>

      {/* Enunciado a esquerda, editor a direita: o candidato le e escreve sem trocar de tela. */}
      <div className="grid items-start gap-12 lg:grid-cols-[minmax(0,26rem)_minmax(0,1fr)]">
        <main id="conteudo" className="flex flex-col gap-6">
          <div className="flex flex-wrap items-center gap-2">
            <Etiqueta tom="acento">{ROTULO_NIVEL[desafio.nivel]}</Etiqueta>
            <Etiqueta>{ROTULO_TIPO[desafio.tipo]}</Etiqueta>
            {desafio.tecnologiaNome ? <Etiqueta>{desafio.tecnologiaNome}</Etiqueta> : null}
          </div>

          <h1 className="text-lg text-tinta">{desafio.titulo}</h1>

          <p className="max-w-[var(--medida-texto)] text-tinta-media">{desafio.descricao}</p>

          {desafio.tempoLimiteMinutos != null ? (
            <p className="flex items-center gap-2 text-sm text-tinta-fraca">
              <Clock aria-hidden="true" size={16} />
              <span>
                Numa entrevista real, esta questão levaria cerca de{" "}
                {desafio.tempoLimiteMinutos} minutos.
              </span>
            </p>
          ) : null}
        </main>

        <section aria-labelledby="titulo-solucao" className="flex flex-col gap-6">
          <h2 id="titulo-solucao" className="text-md text-tinta">
            Sua solução
          </h2>

          <EditorCodigo
            rotulo="Código da solução"
            valor={codigo}
            onMudar={setCodigo}
            desabilitado={enviando}
          />

          <div className="flex flex-wrap items-center gap-4">
            {autenticado ? (
              <Botao onClick={enviar} disabled={enviando || vazio}>
                {enviando ? "Corrigindo..." : "Enviar para correção"}
              </Botao>
            ) : (
              <Link
                to="/entrar"
                state={{ de: `/desafios/${desafio.id}` }}
                className="inline-flex min-h-10 items-center rounded-padrao border border-acento bg-acento px-4 py-2 text-sm font-medium text-tinta-invertida hover:bg-acento-escuro"
              >
                Entrar para enviar
              </Link>
            )}

            {desafio.templateCodigo ? (
              <Botao
                variante="secundario"
                onClick={() => setCodigo(desafio.templateCodigo ?? "")}
                disabled={enviando}
              >
                Restaurar template
              </Botao>
            ) : null}
          </div>

          {/* Region viva: a correcao e anunciada, nao so pintada de verde ou vermelho. */}
          <div
            ref={ancoraResultado}
            tabIndex={-1}
            aria-live="polite"
            className="flex flex-col gap-4"
          >
            {erroEnvio ? <Falha mensagem={erroEnvio} /> : null}
            {resultado ? <ResultadoSubmissao submissao={resultado} /> : null}
          </div>
        </section>
      </div>
    </div>
  );
}
