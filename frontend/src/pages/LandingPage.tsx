import { useEffect, useState } from "react";
import { Link, Navigate } from "react-router-dom";
import { ArrowRight, Flame, Target, Trophy } from "lucide-react";
import { api } from "../api/client";
import type { RankingItem } from "../api/types";
import { useAuth } from "../auth/useAuth";
import { TabelaRanking } from "../components/TabelaRanking";

/*
 * Landing pública.
 *
 * Quem já entrou não precisa de argumento de venda: vai direto para o painel. A landing existe
 * para quem ainda não tem conta.
 *
 * O texto assume uma posição em vez de prometer tudo: o produto treina a etapa técnica do
 * processo, e as outras quatro etapas aparecem para a pessoa saber onde essa peça se encaixa.
 * Prometer preparar para dinâmica de grupo e entrevista de negócio seria vender o que o sistema
 * não faz.
 */

/** As cinco etapas de um processo seletivo de tecnologia, na ordem em que acontecem. */
const ETAPAS = [
  {
    numero: "01",
    titulo: "Triagem de currículo",
    texto:
      "Recrutamento lê o currículo e o LinkedIn procurando aderência à vaga. Aqui não há prova: o que conta é o histórico já construído.",
    treinada: false,
  },
  {
    numero: "02",
    titulo: "Avaliação online",
    texto:
      "Gupy, HackerRank ou Mettl. Teste de fit cultural e raciocínio lógico, seguido do desafio técnico: algoritmos e lógica para estágio; API, SQL e orientação a objetos para júnior.",
    treinada: true,
  },
  {
    numero: "03",
    titulo: "Dinâmica de grupo",
    texto:
      "Predominante em estágio. Um case de negócio resolvido em equipe, com o avaliador observando comunicação, trabalho em grupo e capacidade analítica sob pressão.",
    treinada: false,
  },
  {
    numero: "04",
    titulo: "Entrevista técnica",
    texto:
      "Com tech leads. Em estágio: lógica, orientação a objetos, HTTP, Git e banco de dados. Em júnior: deep dive e live coding sobre REST, testes com JUnit e Mockito, mensageria, microsserviços e SOLID.",
    treinada: true,
  },
  {
    numero: "05",
    titulo: "Entrevista de negócio e proposta",
    texto:
      "Conversa com o gestor do time para alinhar expectativas, cultura e disponibilidade. Depois vêm a oferta formal, a checagem de documentos e os exames admissionais.",
    treinada: false,
  },
];

export function LandingPage() {
  const { autenticado } = useAuth();
  const [ranking, setRanking] = useState<RankingItem[]>([]);

  useEffect(() => {
    let ativo = true;
    // Ranking é enfeite da home: se falhar, a página continua servindo. Sem estado de erro.
    api
      .buscarRanking()
      .then((lista) => {
        if (ativo) setRanking(lista);
      })
      .catch(() => {});
    return () => {
      ativo = false;
    };
  }, []);

  if (autenticado) {
    return <Navigate to="/painel" replace />;
  }

  return (
    <main id="conteudo" className="flex flex-col">
      {/* ---------- Abertura ---------- */}
      <section className="border-b border-borda px-6 py-16 md:px-12 md:py-24">
        <div className="flex flex-col gap-8 lg:flex-row lg:items-start lg:justify-between">
          <div className="flex max-w-[var(--medida-texto)] flex-col gap-6">
            <p className="font-codigo text-sm text-acento-escuro">
              Etapa 02 e 04 do processo seletivo
            </p>

            <h1 className="text-xl text-tinta">
              Você não perde a vaga por não saber programar. Perde por travar na hora.
            </h1>

            <p className="text-tinta-media">
              O desafio técnico e o live coding são as etapas que mais reprovam candidato de
              estágio e júnior — não por falta de conhecimento, mas por falta de repetição sob
              cronômetro. Este simulador existe para essas duas.
            </p>

            <p className="text-tinta-media">
              São 255 questões de Python, Java e SQL, divididas em estágio, júnior e pleno. Cada
              uma diz o que se espera, mostra um exemplo resolvido e devolve, ao final, o retorno
              que um entrevistador daria: o que faltou, por que importa e como corrigir.
            </p>

            <div className="flex flex-wrap items-center gap-4">
              <Link
                to="/cadastrar"
                className="inline-flex min-h-11 items-center gap-2 rounded-padrao border border-acento bg-acento px-5 py-2 font-medium text-tinta-invertida hover:bg-acento-escuro"
              >
                Começar a praticar
                <ArrowRight aria-hidden="true" size={18} />
              </Link>

              <Link
                to="/desafios"
                className="inline-flex min-h-11 items-center text-tinta underline decoration-borda-forte underline-offset-4 hover:decoration-acento"
              >
                Ver as questões antes
              </Link>
            </div>
          </div>

          {/* Prova social só aparece quando existe. Tabela vazia na home não convence ninguém. */}
          {ranking.length > 0 && (
            <aside
              aria-labelledby="titulo-ranking-home"
              className="w-full max-w-md shrink-0 border border-borda bg-elevada p-6 rounded-padrao"
            >
              <h2
                id="titulo-ranking-home"
                className="flex items-center gap-2 text-md text-tinta"
              >
                <Trophy aria-hidden="true" size={20} className="text-acento" />
                Quem está treinando
              </h2>
              <p className="mt-1 mb-4 text-sm text-tinta-fraca">
                Cada questão resolvida paga uma vez. Repetir a mesma não sobe o placar.
              </p>
              <TabelaRanking itens={ranking.slice(0, 5)} compacta />
            </aside>
          )}
        </div>
      </section>

      {/* ---------- As cinco etapas ---------- */}
      <section
        aria-labelledby="titulo-etapas"
        className="border-b border-borda px-6 py-16 md:px-12"
      >
        <h2 id="titulo-etapas" className="text-lg text-tinta">
          Onde este treino entra no processo
        </h2>
        <p className="mt-3 max-w-[var(--medida-texto)] text-tinta-media">
          Um processo seletivo de tecnologia tem cinco etapas. Este simulador treina duas delas — e
          diz isso de frente, porque saber o que ele não faz é tão útil quanto saber o que faz.
        </p>

        <ol className="mt-8 flex flex-col gap-px overflow-hidden border border-borda rounded-padrao">
          {ETAPAS.map((etapa) => (
            <li
              key={etapa.numero}
              className={`flex flex-col gap-2 p-6 md:flex-row md:gap-6 ${
                etapa.treinada ? "bg-elevada" : "bg-afundada"
              }`}
            >
              <p className="font-codigo text-sm text-tinta-fraca md:w-12 md:shrink-0">
                {etapa.numero}
              </p>

              <div className="flex flex-col gap-2 md:flex-1">
                <h3 className="flex flex-wrap items-center gap-3 text-md text-tinta">
                  {etapa.titulo}
                  {/* O selo é texto, e não só uma cor de fundo diferente na linha. */}
                  {etapa.treinada && (
                    <span className="inline-flex items-center gap-1 border border-acento px-2 py-0.5 text-xs text-acento-escuro rounded-padrao">
                      <Target aria-hidden="true" size={12} />
                      treinada aqui
                    </span>
                  )}
                </h3>
                <p className="max-w-[var(--medida-texto)] text-sm text-tinta-media">
                  {etapa.texto}
                </p>
              </div>
            </li>
          ))}
        </ol>
      </section>

      {/* ---------- Como o treino funciona ---------- */}
      <section
        aria-labelledby="titulo-como"
        className="border-b border-borda px-6 py-16 md:px-12"
      >
        <h2 id="titulo-como" className="text-lg text-tinta">
          Como o treino funciona
        </h2>

        <div className="mt-8 grid gap-6 md:grid-cols-3">
          <article className="flex flex-col gap-2 border border-borda bg-elevada p-6 rounded-padrao">
            <h3 className="text-md text-tinta">Cronômetro do servidor</h3>
            <p className="text-sm text-tinta-media">
              O relógio começa quando você abre a questão e é medido no servidor, não no navegador.
              Recarregar a página não zera nada — como numa prova de verdade.
            </p>
          </article>

          <article className="flex flex-col gap-2 border border-borda bg-elevada p-6 rounded-padrao">
            <h3 className="text-md text-tinta">Correção que explica</h3>
            <p className="text-sm text-tinta-media">
              Cada questão tem critérios próprios, com peso. Você recebe o que passou, o que faltou
              e a dica de cada item — não um "errado" seco.
            </p>
          </article>

          <article className="flex flex-col gap-2 border border-borda bg-elevada p-6 rounded-padrao">
            <h3 className="flex items-center gap-2 text-md text-tinta">
              <Flame aria-hidden="true" size={18} className="text-acento" />
              Constância medida
            </h3>
            <p className="text-sm text-tinta-media">
              A sequência conta dias praticados, e sobe mesmo quando você erra — porque tentar já é
              praticar. Os pontos, esses só vêm com a questão resolvida.
            </p>
          </article>
        </div>
      </section>

      {/* ---------- Fechamento ---------- */}
      <section className="px-6 py-16 md:px-12">
        <div className="flex max-w-[var(--medida-texto)] flex-col gap-5">
          <h2 className="text-lg text-tinta">Comece pela questão de hoje</h2>
          <p className="text-tinta-media">
            Criar conta leva um minuto e não pede cartão. O catálogo inteiro fica aberto para você
            olhar antes, se preferir.
          </p>
          <Link
            to="/cadastrar"
            className="inline-flex min-h-11 w-fit items-center gap-2 rounded-padrao border border-acento bg-acento px-5 py-2 font-medium text-tinta-invertida hover:bg-acento-escuro"
          >
            Criar conta
            <ArrowRight aria-hidden="true" size={18} />
          </Link>
        </div>
      </section>
    </main>
  );
}
