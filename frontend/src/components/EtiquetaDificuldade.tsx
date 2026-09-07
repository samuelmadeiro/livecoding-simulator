import { ROTULO_DIFICULDADE, type Dificuldade } from "../api/types";
import { Etiqueta } from "./Etiqueta";

/*
 * Verde, ambar e vermelho na ordem que quem treina para entrevista ja espera de um catalogo de
 * questoes. A cor so reforca: a etiqueta continua escrevendo a dificuldade por extenso, entao quem
 * nao distingue as cores le a mesma informacao.
 */
const TOM_POR_DIFICULDADE = {
  FACIL: "ok",
  MEDIO: "alerta",
  DIFICIL: "erro",
} as const;

export function EtiquetaDificuldade({ dificuldade }: { dificuldade: Dificuldade }) {
  return (
    <Etiqueta tom={TOM_POR_DIFICULDADE[dificuldade]}>{ROTULO_DIFICULDADE[dificuldade]}</Etiqueta>
  );
}
