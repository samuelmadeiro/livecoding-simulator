import { useEffect, useState } from "react";
import { Link, Navigate } from "react-router-dom";
import { ArrowRight, Trophy } from "lucide-react";
import { api, ErroDeApi } from "../api/client";
import { ROTULO_NIVEL, type Progresso, type RankingItem } from "../api/types";
import { useAuth } from "../auth/useAuth";
import { CartaoSequencia } from "../components/CartaoSequencia";
import { Carregando, Falha } from "../components/Estados";
import { TabelaRanking } from "../components/TabelaRanking";

/*
 * Painel do candidato: a página principal de quem já entrou.
 *
 * A ordem da tela responde, de cima para baixo: pratiquei hoje? quanto já andei? onde estou em
 * relação aos outros? o que faço agora? A chamada para a próxima questão fica acima do ranking de
 * propósito — o objetivo do produto é a pessoa praticar, não conferir placar.
 */
export function PainelPage() {
  const { autenticado, sessao } = useAuth();
  const token = sessao?.token;
  const [progresso, setProgresso] = useState<Progresso | null>(null);
  const [ranking, setRanking] = useState<RankingItem[]>([]);
  const [erro, setErro] = useState<string | null>(null);
  const [carregando, setCarregando] = useState(true);

  useEffect(() => {
    if (!token) return;

    let ativo = true;
    setCarregando(true);

    Promise.all([api.buscarProgresso(token), api.buscarRanking()])
      .then(([meuProgresso, listaRanking]) => {
        if (!ativo) return;
        setProgresso(meuProgresso);
        setRanking(listaRanking);
        setErro(null);
      })
      .catch((falha: unknown) => {
        if (!ativo) return;
        setErro(falha instanceof ErroDeApi ? falha.message : "Não foi possível carregar seu progresso.");
      })
      .finally(() => {
        if (ativo) setCarregando(false);
      });

    return () => {
      ativo = false;
    };
  }, [token]);

  if (!autenticado) {
    return <Navigate to="/" replace />;
  }

  if (carregando) {
    return (
      <main id="conteudo" className="px-6 py-12 md:px-12">
        <Carregando rotulo="Carregando seu progresso..." />
      </main>
    );
  }

  if (erro || !progresso) {
    return (
      <main id="conteudo" className="px-6 py-12 md:px-12">
        <Falha mensagem={erro ?? "Não foi possível carregar seu progresso."} />
      </main>
    );
  }

  const restantes = progresso.questoesDisponiveis - progresso.questoesResolvidas;

  return (
    <main id="conteudo" className="flex flex-col gap-10 px-6 py-12 md:px-12">
      <header className="flex flex-col gap-2">
        <h1 className="text-lg text-tinta">Olá, {progresso.apelido}</h1>
        <p className="text-tinta-media">
          {progresso.praticouHoje
            ? "Dia registrado. Se quiser continuar, o catálogo está logo abaixo."
            : "Você ainda não praticou hoje."}
        </p>
      </header>

      <div className="grid gap-6 lg:grid-cols-[minmax(0,20rem)_minmax(0,1fr)]">
        <CartaoSequencia progresso={progresso} />

        <section
          aria-labelledby="titulo-numeros"
          className="flex flex-col gap-4 border border-borda bg-elevada p-6 rounded-padrao"
        >
          <h2 id="titulo-numeros" className="text-sm text-tinta-media">
            Seus números
          </h2>

          <dl className="grid grid-cols-2 gap-x-8 gap-y-5 sm:grid-cols-3">
            <div className="flex flex-col gap-1">
              <dt className="text-xs text-tinta-fraca">Pontos</dt>
              <dd className="font-codigo text-lg text-tinta">{progresso.pontos}</dd>
            </div>

            <div className="flex flex-col gap-1">
              <dt className="text-xs text-tinta-fraca">Questões resolvidas</dt>
              <dd className="font-codigo text-lg text-tinta">
                {progresso.questoesResolvidas}
                <span className="text-sm text-tinta-fraca"> / {progresso.questoesDisponiveis}</span>
              </dd>
            </div>

            <div className="flex flex-col gap-1">
              <dt className="text-xs text-tinta-fraca">Posição no ranking</dt>
              <dd className="font-codigo text-lg text-tinta">
                {progresso.posicaoNoRanking == null ? (
                  <span className="text-sm text-tinta-fraca">resolva uma questão</span>
                ) : (
                  `${progresso.posicaoNoRanking}º`
                )}
              </dd>
            </div>
          </dl>

          <Link
            to="/desafios"
            className="inline-flex min-h-11 w-fit items-center gap-2 rounded-padrao border border-acento bg-acento px-5 py-2 font-medium text-tinta-invertida hover:bg-acento-escuro"
          >
            {progresso.questoesResolvidas === 0 ? "Resolver a primeira questão" : "Praticar agora"}
            <ArrowRight aria-hidden="true" size={18} />
          </Link>

          {restantes > 0 && (
            <p className="text-sm text-tinta-fraca">
              Faltam {restantes} {restantes === 1 ? "questão" : "questões"} no catálogo.
            </p>
          )}
        </section>
      </div>

      {progresso.ultimasConquistas.length > 0 && (
        <section aria-labelledby="titulo-conquistas" className="flex flex-col gap-4">
          <h2 id="titulo-conquistas" className="text-md text-tinta">
            Suas últimas conquistas
          </h2>

          <ul className="flex flex-col gap-px overflow-hidden border border-borda rounded-padrao">
            {progresso.ultimasConquistas.map((conquista) => (
              <li
                key={conquista.desafioId}
                className="flex flex-wrap items-baseline justify-between gap-3 bg-elevada p-4"
              >
                <Link
                  to={`/desafios/${conquista.desafioId}`}
                  className="text-tinta underline decoration-borda-forte underline-offset-4 hover:decoration-acento"
                >
                  {conquista.titulo}
                </Link>
                <span className="text-sm text-tinta-fraca">
                  {conquista.tecnologia} · {ROTULO_NIVEL[conquista.nivel]} · {conquista.pontos} pts
                  · {conquista.precisao}% de precisão
                </span>
              </li>
            ))}
          </ul>
        </section>
      )}

      <section aria-labelledby="titulo-ranking" className="flex flex-col gap-4">
        <h2 id="titulo-ranking" className="flex items-center gap-2 text-md text-tinta">
          <Trophy aria-hidden="true" size={20} className="text-acento" />
          Ranking geral
        </h2>
        <TabelaRanking itens={ranking} meuApelido={progresso.apelido} />
      </section>
    </main>
  );
}
