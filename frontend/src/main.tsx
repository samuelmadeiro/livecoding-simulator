import React, { StrictMode } from "react";
import ReactDOM, { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import App from "./App";
import "./index.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </StrictMode>,
);

/*
 * axe-core so em desenvolvimento: reporta violacao de acessibilidade no console a cada render.
 * Carregado depois do render e sem await no topo do modulo — com top-level await, o entry passa a
 * depender da resolucao dessa dependencia e uma reotimizacao do Vite derruba a aplicacao inteira
 * com "504 (Outdated Optimize Dep)", deixando a tela em branco.
 */
if (import.meta.env.DEV) {
  void import("@axe-core/react").then((modulo) => {
    void modulo.default(React, ReactDOM, 1000);
  });
}
