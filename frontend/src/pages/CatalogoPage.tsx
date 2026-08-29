import { useEffect, useMemo, useState } from "react";
import { ErroDeApi, api } from "../api/client";
import type { Desafio, FiltroDesafios } from "../api/types";
import { DesafioCard } from "../components/DesafioCard";
import { Carregando, Falha, Vazio } from "../components/Estados";
import { FiltroTrilho, type Tecnologia } from "../components/FiltroTrilho";

export function CatalogoPage() {
  const [filtro, setFiltro] = useState<FiltroDesafios>({});
  const [desafios, setDesafios] = useState<Desafio[] | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  /*
   * A API nao expoe GET /api/tecnologias. A lista do filtro sai dos proprios desafios, guardada
   * na primeira carga sem filtro — assim escolher uma tecnologia nao encolhe as opcoes visiveis.
   */
  const [tecnologias, setTecnologias] = useState<Tecnologia[]>([]);

  useEffect(() => {
    let cancelado = false;
    setDesafios(null);
    setErro(null);

    api
      .listarDesafios(filtro)
      .then((lista) => {
        if (cancelado) return;
        setDesafios(lista);
        setTecnologias((atuais) => (atuais.length > 0 ? atuais : extrair(lista)));
      })
      .catch((causa: unknown) => {
        if (cancelado) return;
        setErro(
          causa instanceof ErroDeApi ? causa.message : "Falha ao carregar os desafios.",
        );
      });

    return () => {
      cancelado = true;
    };
  }, [filtro]);

  const total = desafios?.length ?? 0;
  const resumo = useMemo(() => {
    if (desafios == null) return "Carregando desafios";
    if (total === 0) return "Nenhum desafio encontrado";
    return `${total} ${total === 1 ? "desafio encontrado" : "desafios encontrados"}`;
  }, [desafios, total]);

  return (
    /* Tudo dentro do <main>: titulo, filtros e lista. Fora dele, o axe acusa conteudo sem
     * landmark (regra "region") e o leitor de tela nao alcanca o bloco pelo atalho de regioes. */
    <main id="conteudo" className="flex flex-col gap-12 px-6 py-12 md:px-12">
      <div className="flex flex-col gap-4">
        <h1 className="text-xl text-tinta">Treine antes da entrevista</h1>
        <p className="max-w-[var(--medida-texto)] text-md text-tinta-media">
          Escolha um desafio pelo nível da vaga que você quer, escreva a solução e receba a
          correção na hora.
        </p>
      </div>

      {/* Layout assimetrico: trilho estreito de filtros a esquerda, lista ocupando o resto. */}
      <div className="grid gap-12 lg:grid-cols-[16rem_minmax(0,1fr)]">
        <FiltroTrilho filtro={filtro} tecnologias={tecnologias} onMudar={setFiltro} />

        <section aria-label="Resultados" className="flex flex-col gap-6">
          <p aria-live="polite" className="text-sm text-tinta-fraca">
            {resumo}
          </p>

          {erro ? <Falha mensagem={erro} /> : null}

          {!erro && desafios == null ? <Carregando rotulo="Buscando desafios" /> : null}

          {!erro && desafios != null && total === 0 ? (
            <Vazio titulo="Nenhum desafio com esses filtros">
              Tente afrouxar um dos filtros — o catálogo ainda é pequeno e nem toda combinação de
              nível e tecnologia existe.
            </Vazio>
          ) : null}

          {desafios != null && total > 0 ? (
            <ul className="flex flex-col gap-6">
              {desafios.map((desafio) => (
                <li key={desafio.id}>
                  <DesafioCard desafio={desafio} />
                </li>
              ))}
            </ul>
          ) : null}
        </section>
      </div>
    </main>
  );
}

function extrair(lista: Desafio[]): Tecnologia[] {
  const porId = new Map<number, string>();
  for (const desafio of lista) {
    if (desafio.tecnologiaId != null && desafio.tecnologiaNome) {
      porId.set(desafio.tecnologiaId, desafio.tecnologiaNome);
    }
  }
  return [...porId.entries()]
    .map(([id, nome]) => ({ id, nome }))
    .sort((a, b) => a.nome.localeCompare(b.nome, "pt-BR"));
}
