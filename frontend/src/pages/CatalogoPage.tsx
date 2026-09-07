import { useCallback, useEffect, useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { ErroDeApi, api } from "../api/client";
import {
  DIFICULDADES,
  NIVEIS,
  ORDENS,
  ROTULO_ORDEM,
  TIPOS,
  type ConsultaDesafios,
  type Desafio,
  type FiltroDesafios,
  type OrdemDesafios,
  type Pagina,
  type Tecnologia,
} from "../api/types";
import { DesafioCard } from "../components/DesafioCard";
import { Carregando, Falha, Vazio } from "../components/Estados";
import { FiltroTrilho } from "../components/FiltroTrilho";
import { Paginacao } from "../components/Paginacao";

export function CatalogoPage() {
  /*
   * A consulta mora na URL, e nao em useState. Assim o filtro, a ordem e a pagina sobrevivem ao
   * F5, voltam com o botao de voltar do navegador e podem ser enviados como link para outra
   * pessoa — tres coisas que o estado local perde.
   */
  const [parametros, setParametros] = useSearchParams();
  const chave = parametros.toString();
  const consulta = useMemo(() => lerConsulta(new URLSearchParams(chave)), [chave]);

  const [resultado, setResultado] = useState<Pagina<Desafio> | null>(null);
  const [erro, setErro] = useState<string | null>(null);
  const [tecnologias, setTecnologias] = useState<Tecnologia[]>([]);

  /*
   * O vocabulario do filtro vem de /api/tecnologias, e nao dos desafios que voltaram: a pagina
   * atual conhece nove questoes, e nao o catalogo. Se a chamada falhar, o grupo some da tela em
   * vez de mostrar uma lista pela metade — os outros filtros continuam funcionando.
   */
  useEffect(() => {
    let cancelado = false;

    api
      .listarTecnologias()
      .then((lista) => {
        if (!cancelado) setTecnologias(lista);
      })
      .catch(() => {
        if (!cancelado) setTecnologias([]);
      });

    return () => {
      cancelado = true;
    };
  }, []);

  useEffect(() => {
    let cancelado = false;
    setResultado(null);
    setErro(null);

    api
      .listarDesafios(consulta)
      .then((pagina) => {
        if (cancelado) return;
        setResultado(pagina);
      })
      .catch((causa: unknown) => {
        if (cancelado) return;
        setErro(causa instanceof ErroDeApi ? causa.message : "Falha ao carregar os desafios.");
      });

    return () => {
      cancelado = true;
    };
  }, [consulta]);

  const navegar = useCallback(
    (nova: ConsultaDesafios) => setParametros(escrever(nova)),
    [setParametros],
  );

  /* Filtro ou ordem nova recomeca na primeira pagina: a pagina 7 do recorte antigo pode nem
   * existir no novo, e cair numa lista vazia depois de clicar num filtro parece defeito. */
  const aplicarFiltro = useCallback(
    (filtro: FiltroDesafios) => navegar({ ...filtro, ordenar: consulta.ordenar, pagina: 0 }),
    [navegar, consulta.ordenar],
  );

  const aplicarOrdem = useCallback(
    (ordenar: OrdemDesafios) => navegar({ ...consulta, ordenar, pagina: 0 }),
    [navegar, consulta],
  );

  const irParaPagina = useCallback(
    (pagina: number) => {
      navegar({ ...consulta, pagina });
      // A lista trocou inteira; sem isso, quem clica em "Próxima" continua no rodape da anterior.
      window.scrollTo({ top: 0, behavior: "smooth" });
    },
    [navegar, consulta],
  );

  /* Link antigo apontando para uma pagina que o filtro atual nao alcanca mais: em vez de mostrar
   * "nenhum desafio", volta para a ultima pagina que existe. */
  useEffect(() => {
    if (resultado && resultado.conteudo.length === 0 && resultado.totalItens > 0) {
      navegar({ ...consulta, pagina: Math.max(resultado.totalPaginas - 1, 0) });
    }
  }, [resultado, consulta, navegar]);

  const resumo = useMemo(() => {
    if (resultado == null) return "Carregando desafios";
    if (resultado.totalItens === 0) return "Nenhum desafio encontrado";

    const quantos = `${resultado.totalItens} ${
      resultado.totalItens === 1 ? "desafio encontrado" : "desafios encontrados"
    }`;
    if (resultado.totalPaginas <= 1) return quantos;
    return `${quantos} · página ${resultado.pagina + 1} de ${resultado.totalPaginas}`;
  }, [resultado]);

  return (
    /* Tudo dentro do <main>: titulo, filtros e lista. Fora dele, o axe acusa conteudo sem
     * landmark (regra "region") e o leitor de tela nao alcanca o bloco pelo atalho de regioes. */
    <main id="conteudo" className="flex flex-col gap-12 px-6 py-12 md:px-12">
      <div className="flex flex-col gap-4">
        <h1 className="text-xl text-tinta">Treine antes da entrevista</h1>
        <p className="max-w-[var(--medida-texto)] text-md text-tinta-media">
          Escolha um desafio pelo nível da vaga e pela dificuldade que você quer encarar, escreva a
          solução e receba a correção na hora.
        </p>
      </div>

      {/* Layout assimetrico: trilho estreito de filtros a esquerda, lista ocupando o resto. */}
      <div className="grid gap-12 lg:grid-cols-[16rem_minmax(0,1fr)]">
        <FiltroTrilho filtro={consulta} tecnologias={tecnologias} onMudar={aplicarFiltro} />

        <section aria-label="Resultados" className="flex flex-col gap-6">
          <div className="flex flex-wrap items-center justify-between gap-4">
            <p aria-live="polite" className="text-sm text-tinta-fraca">
              {resumo}
            </p>

            <div className="flex items-center gap-3">
              <label htmlFor="ordenar" className="text-sm text-tinta-fraca">
                Ordenar por
              </label>
              <select
                id="ordenar"
                value={consulta.ordenar ?? "PADRAO"}
                onChange={(evento) => aplicarOrdem(evento.target.value as OrdemDesafios)}
                className="min-h-10 rounded-padrao border border-borda-forte bg-elevada px-3 py-2 text-sm text-tinta"
              >
                {ORDENS.map((ordem) => (
                  <option key={ordem} value={ordem}>
                    {ROTULO_ORDEM[ordem]}
                  </option>
                ))}
              </select>
            </div>
          </div>

          {erro ? <Falha mensagem={erro} /> : null}

          {!erro && resultado == null ? <Carregando rotulo="Buscando desafios" /> : null}

          {!erro && resultado != null && resultado.totalItens === 0 ? (
            <Vazio titulo="Nenhum desafio com esses filtros">
              Tente afrouxar um dos filtros — nem toda combinação de nível, dificuldade e
              tecnologia existe no catálogo.
            </Vazio>
          ) : null}

          {resultado != null && resultado.conteudo.length > 0 ? (
            <>
              <ul className="flex flex-col gap-6">
                {resultado.conteudo.map((desafio) => (
                  <li key={desafio.id}>
                    <DesafioCard desafio={desafio} />
                  </li>
                ))}
              </ul>

              <Paginacao
                pagina={resultado.pagina}
                totalPaginas={resultado.totalPaginas}
                onIr={irParaPagina}
              />
            </>
          ) : null}
        </section>
      </div>
    </main>
  );
}

/*
 * A URL e digitavel e colavel, entao o que vem dela e tratado como entrada de fora: valor que nao
 * pertence ao vocabulario do catalogo vira "sem filtro", e nao um parametro invalido enviado a API.
 */
function lerConsulta(parametros: URLSearchParams): ConsultaDesafios {
  const pagina = Number(parametros.get("pagina"));

  return {
    nivel: umDe(NIVEIS, parametros.get("nivel")),
    tipo: umDe(TIPOS, parametros.get("tipo")),
    dificuldade: umDe(DIFICULDADES, parametros.get("dificuldade")),
    tecnologiaId: inteiroPositivo(parametros.get("tecnologiaId")),
    ordenar: umDe(ORDENS, parametros.get("ordenar")) ?? "PADRAO",
    pagina: Number.isInteger(pagina) && pagina > 0 ? pagina : 0,
  };
}

/** So o que a pessoa escolheu entra na URL: sem isso, o endereco do catalogo limpo viria sujo. */
function escrever(consulta: ConsultaDesafios): URLSearchParams {
  const parametros = new URLSearchParams();

  if (consulta.nivel) parametros.set("nivel", consulta.nivel);
  if (consulta.dificuldade) parametros.set("dificuldade", consulta.dificuldade);
  if (consulta.tipo) parametros.set("tipo", consulta.tipo);
  if (consulta.tecnologiaId != null) {
    parametros.set("tecnologiaId", String(consulta.tecnologiaId));
  }
  if (consulta.ordenar && consulta.ordenar !== "PADRAO") {
    parametros.set("ordenar", consulta.ordenar);
  }
  if (consulta.pagina) parametros.set("pagina", String(consulta.pagina));

  return parametros;
}

function umDe<T extends string>(valores: readonly T[], bruto: string | null): T | undefined {
  return valores.includes(bruto as T) ? (bruto as T) : undefined;
}

function inteiroPositivo(bruto: string | null): number | undefined {
  const numero = Number(bruto);
  return bruto != null && Number.isInteger(numero) && numero > 0 ? numero : undefined;
}
