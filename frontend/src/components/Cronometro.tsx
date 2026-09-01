import { Clock } from "lucide-react";
import { formatarRelogio } from "../util/formato";

/*
 * Relógio da questão. O tempo é do servidor (a tentativa aberta em POST /api/desafios/{id}/iniciar);
 * aqui só corre o segundo a segundo a partir do que veio de lá — recarregar a página não devolve
 * tempo ao candidato.
 *
 * Passar do tempo sugerido muda o tom para alerta, mas não bloqueia nada: numa entrevista real o
 * relógio estourado é assunto de conversa, não um envio recusado.
 */
export function Cronometro({
  segundos,
  limiteMinutos,
}: {
  segundos: number;
  limiteMinutos: number | null;
}) {
  const estourou = limiteMinutos != null && segundos > limiteMinutos * 60;

  const aparencia = estourou
    ? "border-alerta bg-alerta-suave text-alerta"
    : "border-borda-forte bg-afundada text-tinta-media";

  return (
    <p
      className={`inline-flex items-center gap-2 rounded-padrao border px-3 py-2 text-sm ${aparencia}`}
    >
      <Clock aria-hidden="true" size={16} className="shrink-0" />
      {/* Atualiza a cada segundo: anunciar cada tique seria ruído para quem usa leitor de tela. */}
      <span aria-hidden="true" className="font-codigo tabular-nums">
        {formatarRelogio(segundos)}
      </span>
      <span className="sr-only">
        Tempo decorrido: {Math.floor(segundos / 60)} minutos.
      </span>
      {limiteMinutos != null ? (
        <span className="text-tinta-fraca">
          {estourou ? `acima dos ${limiteMinutos} min sugeridos` : `de ${limiteMinutos} min`}
        </span>
      ) : null}
    </p>
  );
}
