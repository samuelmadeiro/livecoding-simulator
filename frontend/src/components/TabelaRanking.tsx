import { Flame } from "lucide-react";
import type { RankingItem } from "../api/types";

interface Props {
  itens: RankingItem[];
  /** Apelido de quem está vendo, para destacar a própria linha. */
  meuApelido?: string | null;
  compacta?: boolean;
}

/*
 * Ranking público. Identifica por apelido, nunca por nome completo ou e-mail — a lista aparece na
 * home para visitante anônimo.
 *
 * É uma <table> de verdade, e não uma pilha de divs: leitor de tela anuncia a posição junto do
 * cabeçalho da coluna, e a pessoa entende que "3" é a colocação e não a pontuação.
 */
export function TabelaRanking({ itens, meuApelido, compacta = false }: Props) {
  if (itens.length === 0) {
    return (
      <p className="text-sm text-tinta-media">
        Ninguém pontuou ainda. A primeira questão resolvida abre a tabela.
      </p>
    );
  }

  return (
    <div className="overflow-x-auto">
      <table className="w-full border-collapse text-left">
        <caption className="sr-only">
          Classificação por pontos. Cada questão resolvida paga uma vez.
        </caption>
        <thead>
          <tr className="border-b border-borda text-xs text-tinta-fraca">
            <th scope="col" className="py-2 pr-3 font-medium">
              #
            </th>
            <th scope="col" className="py-2 pr-3 font-medium">
              Candidato
            </th>
            <th scope="col" className="py-2 pr-3 text-right font-medium">
              Pontos
            </th>
            {!compacta && (
              <th scope="col" className="py-2 pr-3 text-right font-medium">
                Questões
              </th>
            )}
            <th scope="col" className="py-2 text-right font-medium">
              Sequência
            </th>
          </tr>
        </thead>
        <tbody>
          {itens.map((item) => {
            const euMesmo = meuApelido != null && item.apelido === meuApelido;

            return (
              <tr
                key={item.apelido}
                /* A própria linha ganha fundo e um marcador textual: cor sozinha não informa. */
                className={`border-b border-borda last:border-0 ${
                  euMesmo ? "bg-acento-suave" : ""
                }`}
              >
                <td className="py-2 pr-3 font-codigo text-sm text-tinta-fraca">{item.posicao}</td>
                <td className="py-2 pr-3 text-tinta">
                  {item.apelido}
                  {euMesmo && <span className="ml-2 text-xs text-acento-escuro">você</span>}
                </td>
                <td className="py-2 pr-3 text-right font-codigo text-tinta">{item.pontos}</td>
                {!compacta && (
                  <td className="py-2 pr-3 text-right font-codigo text-tinta-media">
                    {item.questoesResolvidas}
                  </td>
                )}
                <td className="py-2 text-right">
                  <span className="inline-flex items-center gap-1 font-codigo text-tinta-media">
                    <Flame aria-hidden="true" size={14} className="text-acento" />
                    {item.sequenciaAtual}
                    <span className="sr-only">
                      {item.sequenciaAtual === 1 ? " dia seguido" : " dias seguidos"}
                    </span>
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
