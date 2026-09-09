import { ChevronDown } from "lucide-react";
import { useState } from "react";
import {
  DIFICULDADES,
  NIVEIS,
  ROTULO_DIFICULDADE,
  ROTULO_NIVEL,
  ROTULO_TIPO,
  TIPOS,
  type ConsultaDesafios,
  type Dificuldade,
  type NivelVaga,
  type Tecnologia,
  type TipoDesafio,
} from "../api/types";
import { Botao } from "./Botao";

interface Props {
  filtro: ConsultaDesafios;
  tecnologias: Tecnologia[];
  onMudar: (filtro: ConsultaDesafios) => void;
  /** O recorte de pendentes só existe para quem entrou: o servidor o ignora sem token. */
  mostrarPendentes?: boolean;
}

/*
 * Filtros como grupos de radio, nao select: sao poucos valores e todos cabem na tela, entao o
 * candidato ve o vocabulario inteiro do catalogo sem abrir nada. Radio tambem ja vem com
 * navegacao por seta e anuncio de grupo pelo leitor de tela.
 *
 * Nivel e dificuldade sao grupos separados porque respondem perguntas diferentes: um diz para qual
 * vaga a questao serve, o outro quanto ela cobra. Com um eixo so, quem estuda para junior nao
 * consegue pedir as questoes leves daquele nivel antes das pesadas.
 */
export function FiltroTrilho({ filtro, tecnologias, onMudar, mostrarPendentes = false }: Props) {
  /*
   * Fechado por padrao: no celular, quem chega ao catalogo quer ver questao, e nao formulario.
   * No desktop o estado nem e consultado — a classe lg:flex mantem o trilho aberto sempre.
   */
  const [aberto, setAberto] = useState(false);

  const limpo =
    !filtro.nivel &&
    !filtro.tipo &&
    !filtro.dificuldade &&
    filtro.tecnologiaId == null &&
    !filtro.naoResolvidas;

  /* <section> rotulada, nao <aside>: o trilho vive dentro do <main> do catalogo, e um
   * complementary aninhado no main confunde a lista de landmarks do leitor de tela. */
  return (
    <section aria-labelledby="titulo-filtros" className="flex flex-col gap-8">
      <div className="flex items-baseline justify-between gap-4">
        <h2 id="titulo-filtros" className="text-md text-tinta">
          Filtros
          {/* No celular o painel fecha, então o título precisa dizer que há filtro valendo. */}
          {!limpo ? (
            <span className="text-sm text-acento-escuro lg:hidden"> · ativos</span>
          ) : null}
        </h2>

        <div className="flex items-center gap-3">
          {!limpo ? (
            <Botao variante="discreto" onClick={() => onMudar({})}>
              Limpar
            </Botao>
          ) : null}

          {/*
           * Só no celular. Em tela pequena, os quatro grupos somam dezenove opções empilhadas
           * antes do primeiro card, e a lista ficava fora da primeira tela. No desktop o trilho
           * tem coluna própria e continua sempre aberto.
           */}
          <button
            type="button"
            onClick={() => setAberto((atual) => !atual)}
            aria-expanded={aberto}
            aria-controls="corpo-filtros"
            className="inline-flex min-h-10 items-center gap-1 rounded-padrao border border-borda-forte px-3 py-1 text-sm text-tinta-media hover:text-tinta lg:hidden"
          >
            {aberto ? "Ocultar" : "Mostrar"}
            <ChevronDown
              aria-hidden="true"
              size={16}
              className={aberto ? "rotate-180 transition-transform" : "transition-transform"}
            />
          </button>
        </div>
      </div>

      <div
        id="corpo-filtros"
        className={`flex-col gap-8 ${aberto ? "flex" : "hidden"} lg:flex`}
      >

      {/*
       * Fora dos grupos de radio de proposito: os outros filtros recortam o catalogo por atributo
       * da questao, e este recorta pelo historico de quem esta olhando. Como e uma escolha de
       * ligar ou desligar, e caixa de marcacao, e nao mais um "Todos / opcao".
       */}
      {mostrarPendentes ? (
        <label className="flex cursor-pointer items-start gap-3 text-base text-tinta-media hover:text-tinta">
          <input
            type="checkbox"
            checked={filtro.naoResolvidas ?? false}
            onChange={(evento) =>
              onMudar({ ...filtro, naoResolvidas: evento.target.checked || undefined })
            }
            className="mt-1 size-4 accent-[var(--acento)]"
          />
          <span>
            Só as que faltam
            <span className="block text-xs text-tinta-fraca">
              Esconde as questões que você já resolveu.
            </span>
          </span>
        </label>
      ) : null}

      <Grupo
        legenda="Nível da vaga"
        nome="nivel"
        valor={filtro.nivel ?? ""}
        opcoes={NIVEIS.map((n) => ({ valor: n, rotulo: ROTULO_NIVEL[n] }))}
        onEscolher={(valor) =>
          onMudar({ ...filtro, nivel: (valor || undefined) as NivelVaga | undefined })
        }
      />

      <Grupo
        legenda="Dificuldade"
        nome="dificuldade"
        valor={filtro.dificuldade ?? ""}
        opcoes={DIFICULDADES.map((d) => ({ valor: d, rotulo: ROTULO_DIFICULDADE[d] }))}
        onEscolher={(valor) =>
          onMudar({ ...filtro, dificuldade: (valor || undefined) as Dificuldade | undefined })
        }
      />

      <Grupo
        legenda="Tipo de desafio"
        nome="tipo"
        valor={filtro.tipo ?? ""}
        opcoes={TIPOS.map((t) => ({ valor: t, rotulo: ROTULO_TIPO[t] }))}
        onEscolher={(valor) =>
          onMudar({ ...filtro, tipo: (valor || undefined) as TipoDesafio | undefined })
        }
      />

      {tecnologias.length > 0 ? (
        <Grupo
          legenda="Tecnologia"
          nome="tecnologia"
          valor={filtro.tecnologiaId != null ? String(filtro.tecnologiaId) : ""}
          opcoes={tecnologias.map((t) => ({ valor: String(t.id), rotulo: t.nome }))}
          onEscolher={(valor) =>
            onMudar({ ...filtro, tecnologiaId: valor ? Number(valor) : undefined })
          }
        />
      ) : null}
      </div>
    </section>
  );
}

interface GrupoProps {
  legenda: string;
  nome: string;
  valor: string;
  opcoes: { valor: string; rotulo: string }[];
  onEscolher: (valor: string) => void;
}

function Grupo({ legenda, nome, valor, opcoes, onEscolher }: GrupoProps) {
  return (
    <fieldset className="flex flex-col gap-3 border-0 p-0">
      <legend className="mb-3 text-xs font-semibold uppercase tracking-wide text-tinta-fraca">
        {legenda}
      </legend>

      {[{ valor: "", rotulo: "Todos" }, ...opcoes].map((opcao) => (
        <label
          key={opcao.valor || "todos"}
          className="flex cursor-pointer items-center gap-3 text-base text-tinta-media hover:text-tinta"
        >
          <input
            type="radio"
            name={nome}
            value={opcao.valor}
            checked={valor === opcao.valor}
            onChange={() => onEscolher(opcao.valor)}
            className="size-4 accent-[var(--acento)]"
          />
          <span>{opcao.rotulo}</span>
        </label>
      ))}
    </fieldset>
  );
}
