/** Formatacao compartilhada entre a pagina do desafio e o painel do admin. */

const TRACO = "—";

/** Segundos em "12 min 30 s". Nulo vira travessao: dado ausente nao pode virar zero na tela. */
export function formatarDuracao(segundos: number | null | undefined): string {
  if (segundos == null) return TRACO;
  if (segundos < 60) return `${segundos} s`;

  const minutos = Math.floor(segundos / 60);
  const resto = segundos % 60;

  if (minutos < 60) {
    return resto === 0 ? `${minutos} min` : `${minutos} min ${resto} s`;
  }

  const horas = Math.floor(minutos / 60);
  const minutosRestantes = minutos % 60;
  return minutosRestantes === 0 ? `${horas} h` : `${horas} h ${minutosRestantes} min`;
}

/** Segundos em "07:42", para o cronometro correndo na tela. */
export function formatarRelogio(segundos: number): string {
  const seguro = Math.max(segundos, 0);
  const minutos = Math.floor(seguro / 60);
  const resto = seguro % 60;
  return `${String(minutos).padStart(2, "0")}:${String(resto).padStart(2, "0")}`;
}

export function formatarPercentual(valor: number | null | undefined): string {
  return valor == null ? TRACO : `${valor}%`;
}

export function formatarNota(valor: number | null | undefined): string {
  return valor == null ? TRACO : String(valor);
}

export function formatarDataHora(iso: string | null | undefined): string {
  if (!iso) return TRACO;
  const data = new Date(iso);
  if (Number.isNaN(data.getTime())) return TRACO;
  return data.toLocaleString("pt-BR", {
    day: "2-digit",
    month: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
}
