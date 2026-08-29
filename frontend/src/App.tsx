import { Route, Routes } from "react-router-dom";
import { AuthProvider } from "./auth/AuthContext";
import { Cabecalho } from "./components/Cabecalho";
import { CatalogoPage } from "./pages/CatalogoPage";
import { DesafioPage } from "./pages/DesafioPage";
import { LoginPage } from "./pages/LoginPage";
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
        <Route path="/" element={<CatalogoPage />} />
        <Route path="/desafios/:id" element={<DesafioPage />} />
        <Route path="/entrar" element={<LoginPage />} />
        <Route path="/cadastrar" element={<RegistroPage />} />
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
