import { useState, type FormEvent } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { ErroDeApi } from "../api/client";
import { useAuth } from "../auth/useAuth";
import { Botao } from "../components/Botao";
import { CampoTexto } from "../components/CampoTexto";
import { Falha } from "../components/Estados";

export function LoginPage() {
  const { entrar } = useAuth();
  const navegar = useNavigate();
  const local = useLocation();
  const destino = (local.state as { de?: string } | null)?.de ?? "/";

  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [erro, setErro] = useState<string | null>(null);
  const [porCampo, setPorCampo] = useState<Record<string, string>>({});
  const [enviando, setEnviando] = useState(false);

  async function submeter(evento: FormEvent) {
    evento.preventDefault();
    setEnviando(true);
    setErro(null);
    setPorCampo({});

    try {
      await entrar(email, senha);
      navegar(destino, { replace: true });
    } catch (causa: unknown) {
      if (causa instanceof ErroDeApi) {
        setErro(causa.message);
        setPorCampo(causa.porCampo);
      } else {
        setErro("Falha ao entrar.");
      }
    } finally {
      setEnviando(false);
    }
  }

  return (
    <main id="conteudo" className="px-6 py-16 md:px-12">
      <div className="grid gap-12 lg:grid-cols-[minmax(0,24rem)_minmax(0,22rem)]">
        <form onSubmit={submeter} noValidate className="flex flex-col gap-6">
          <h1 className="text-lg text-tinta">Entrar</h1>

          <div aria-live="assertive">
            {erro ? <Falha mensagem={erro} /> : null}
          </div>

          <CampoTexto
            rotulo="E-mail"
            type="email"
            autoComplete="email"
            value={email}
            onChange={(evento) => setEmail(evento.target.value)}
            erro={porCampo.email}
            required
          />

          <CampoTexto
            rotulo="Senha"
            type="password"
            autoComplete="current-password"
            value={senha}
            onChange={(evento) => setSenha(evento.target.value)}
            erro={porCampo.senha}
            required
          />

          <div className="flex flex-wrap items-center gap-4">
            <Botao type="submit" disabled={enviando}>
              {enviando ? "Entrando..." : "Entrar"}
            </Botao>
            <Link
              to="/cadastrar"
              className="text-sm text-tinta-media underline decoration-borda-forte underline-offset-4 hover:text-tinta hover:decoration-acento"
            >
              Criar uma conta
            </Link>
          </div>
        </form>

        <aside className="flex flex-col gap-3 border border-borda bg-afundada p-6 rounded-padrao">
          <h2 className="text-md text-tinta">Conta de demonstração</h2>
          <p className="text-tinta-media">
            O backend cria um candidato de exemplo ao subir. Use para testar sem se cadastrar:
          </p>
          <dl className="flex flex-col gap-2 font-codigo text-sm text-tinta">
            <div className="flex gap-2">
              <dt className="text-tinta-fraca">e-mail</dt>
              <dd>demo@livecoding.dev</dd>
            </div>
            <div className="flex gap-2">
              <dt className="text-tinta-fraca">senha</dt>
              <dd>demo12345</dd>
            </div>
          </dl>
        </aside>
      </div>
    </main>
  );
}
