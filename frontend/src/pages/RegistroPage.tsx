import { useState, type FormEvent } from "react";
import { Link, useNavigate } from "react-router-dom";
import { ErroDeApi } from "../api/client";
import { useAuth } from "../auth/useAuth";
import { Botao } from "../components/Botao";
import { CampoTexto } from "../components/CampoTexto";
import { Falha } from "../components/Estados";

export function RegistroPage() {
  const { cadastrar } = useAuth();
  const navegar = useNavigate();

  const [nome, setNome] = useState("");
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
      await cadastrar(nome, email, senha);
      navegar("/", { replace: true });
    } catch (causa: unknown) {
      if (causa instanceof ErroDeApi) {
        // 409 (e-mail ja cadastrado) vem so em `mensagem`; 400 vem no mapa por campo.
        setErro(causa.message);
        setPorCampo(causa.porCampo);
      } else {
        setErro("Falha ao criar a conta.");
      }
    } finally {
      setEnviando(false);
    }
  }

  return (
    <main id="conteudo" className="px-6 py-16 md:px-12">
      <form
        onSubmit={submeter}
        noValidate
        className="flex max-w-[24rem] flex-col gap-6"
      >
        <h1 className="text-lg text-tinta">Criar conta</h1>

        <div aria-live="assertive">{erro ? <Falha mensagem={erro} /> : null}</div>

        <CampoTexto
          rotulo="Nome"
          autoComplete="name"
          value={nome}
          onChange={(evento) => setNome(evento.target.value)}
          erro={porCampo.nome}
          required
        />

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
          autoComplete="new-password"
          dica="No mínimo 8 caracteres."
          value={senha}
          onChange={(evento) => setSenha(evento.target.value)}
          erro={porCampo.senha}
          required
        />

        <div className="flex flex-wrap items-center gap-4">
          <Botao type="submit" disabled={enviando}>
            {enviando ? "Criando..." : "Criar conta"}
          </Botao>
          <Link
            to="/entrar"
            className="text-sm text-tinta-media underline decoration-borda-forte underline-offset-4 hover:text-tinta hover:decoration-acento"
          >
            Já tenho conta
          </Link>
        </div>
      </form>
    </main>
  );
}
