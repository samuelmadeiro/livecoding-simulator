import { Route, Routes } from "react-router-dom";
import { AuthProvider } from "./auth/AuthContext";
import { RotaAdmin } from "./auth/RotaAdmin";
import { Cabecalho } from "./components/Cabecalho";
import { AdminPage } from "./pages/AdminPage";
import { CatalogoPage } from "./pages/CatalogoPage";
import { DesafioPage } from "./pages/DesafioPage";
import { LandingPage } from "./pages/LandingPage";
import { LoginPage } from "./pages/LoginPage";
import { PainelPage } from "./pages/PainelPage";
import { RegistroPage } from "./pages/RegistroPage";

export default function App() {
  return (
    <AuthProvider>
      {/* Primeiro item do Tab: pular a navegacao e ir direto ao conteudo (WCAG 2.4.1). */}
      <a href="#conteudo" className="pular-para-conteudo">
        Pular para o conteúdo
      </a>

      <Cabecalho />

      <Routes>
        {/*
          A raiz decide sozinha para quem serve: a LandingPage manda quem ja entrou para o painel,
          e mostra a apresentacao para quem ainda nao tem conta. O catalogo saiu da raiz e ganhou
          endereco proprio, porque agora ele e uma etapa do fluxo e nao a porta de entrada.
        */}
        <Route path="/" element={<LandingPage />} />
        <Route path="/painel" element={<PainelPage />} />
        <Route path="/desafios" element={<CatalogoPage />} />
        <Route path="/desafios/:id" element={<DesafioPage />} />
        <Route path="/entrar" element={<LoginPage />} />
        <Route path="/cadastrar" element={<RegistroPage />} />
        <Route
          path="/admin"
          element={
            <RotaAdmin>
              <AdminPage />
            </RotaAdmin>
          }
        />
        <Route path="*" element={<NaoEncontrada />} />
      </Routes>
    </AuthProvider>
  );
}

function NaoEncontrada() {
  return (
    <main id="conteudo" className="flex flex-col gap-4 px-6 py-16 md:px-12">
      <h1 className="text-lg text-tinta">Página não encontrada</h1>
      <p className="max-w-[var(--medida-texto)] text-tinta-media">
        O endereço que você abriu não existe nesta aplicação.
      </p>
      <a
        href="/"
        className="w-fit text-tinta underline decoration-borda-forte underline-offset-4 hover:decoration-acento"
      >
        Voltar para o catálogo
      </a>
    </main>
  );
}
