import {
  NIVEIS,
  ROTULO_NIVEL,
  ROTULO_TIPO,
  TIPOS,
  type FiltroDesafios,
  type NivelVaga,
  type TipoDesafio,
} from "../api/types";
import { Botao } from "./Botao";

export interface Tecnologia {
  id: number;
  nome: string;
}

interface Props {
  filtro: FiltroDesafios;
  tecnologias: Tecnologia[];
  onMudar: (filtro: FiltroDesafios) => void;
}

/*
 * Filtros como grupos de radio, nao select: sao poucos valores e todos cabem na tela, entao o
 * candidato ve o vocabulario inteiro do catalogo sem abrir nada. Radio tambem ja vem com
 * navegacao por seta e anuncio de grupo pelo leitor de tela.
 */
export function FiltroTrilho({ filtro, tecnologias, onMudar }: Props) {
  const limpo = !filtro.nivel && !filtro.tipo && filtro.tecnologiaId == null;

  /* <section> rotulada, nao <aside>: o trilho vive dentro do <main> do catalogo, e um
   * complementary aninhado no main confunde a lista de landmarks do leitor de tela. */
  return (
    <section aria-labelledby="titulo-filtros" className="flex flex-col gap-8">
      <div className="flex items-baseline justify-between gap-4">
        <h2 id="titulo-filtros" className="text-md text-tinta">
          Filtros
        </h2>
        {!limpo ? (
          <Botao variante="discreto" onClick={() => onMudar({})}>
            Limpar
          </Botao>
        ) : null}
      </div>

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
