import { Botao } from "./Botao";

interface Props {
  /** Indice da pagina atual, comecando em zero — o mesmo que a API usa. */
  pagina: number;
  totalPaginas: number;
  onIr: (pagina: number) => void;
}

/** Quantos numeros aparecem de uma vez. Impar de proposito: a pagina atual fica no meio. */
const JANELA = 5;

/*
 * <nav> rotulada com a lista de paginas: o leitor de tela anuncia "navegacao, paginacao do
 * catalogo" e pula direto para ela. O numero da pagina atual carrega aria-current="page", que e o
 * que diz onde a pessoa esta — a cor do botao sozinha nao diz.
 */
export function Paginacao({ pagina, totalPaginas, onIr }: Props) {
  if (totalPaginas <= 1) {
    return null;
  }

  const primeira = pagina <= 0;
  const ultima = pagina >= totalPaginas - 1;

  return (
    <nav aria-label="Paginação do catálogo" className="flex flex-wrap items-center gap-4">
      <Botao variante="secundario" disabled={primeira} onClick={() => onIr(pagina - 1)}>
        Anterior
      </Botao>

      <ul className="flex flex-wrap items-center gap-2">
        {numerosVisiveis(pagina, totalPaginas).map((numero) => (
          <li key={numero}>
            <Botao
              variante={numero === pagina ? "primario" : "discreto"}
              aria-current={numero === pagina ? "page" : undefined}
              aria-label={`Página ${numero + 1} de ${totalPaginas}`}
              onClick={() => onIr(numero)}
            >
              {numero + 1}
            </Botao>
          </li>
        ))}
      </ul>

      <Botao variante="secundario" disabled={ultima} onClick={() => onIr(pagina + 1)}>
        Próxima
      </Botao>
    </nav>
  );
}

/*
 * A janela desliza com a pagina atual e encosta nas pontas: perto do inicio ela nao mostra numeros
 * negativos, perto do fim nao mostra paginas que nao existem, e no meio a atual fica centrada.
 */
function numerosVisiveis(pagina: number, totalPaginas: number): number[] {
  const largura = Math.min(JANELA, totalPaginas);
  const meio = Math.floor(largura / 2);
  const inicio = Math.min(Math.max(pagina - meio, 0), totalPaginas - largura);

  return Array.from({ length: largura }, (_, posicao) => inicio + posicao);
}
