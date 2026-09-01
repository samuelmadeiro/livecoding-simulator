# Front-end do LiveCoding Simulator

SPA em React 19 + TypeScript + Tailwind v4 sobre a API do projeto. Cobre o fluxo do candidato —
catálogo filtrável, leitura do enunciado, escrita da solução cronometrada, envio autenticado e
correção com o retorno do entrevistador — e o painel de quem administra, em `/admin`.

## Rodar

O back-end precisa estar no ar em `http://localhost:8080` (veja [EXECUTANDO.md](../EXECUTANDO.md)).

```bash
npm install
```

```bash
npm run dev
```

A aplicação sobe em `http://localhost:5173`, origem já liberada no CORS do back-end. Para apontar
para outro endereço, defina `VITE_API_URL`.

Entre com o usuário de demonstração criado pelo `DataLoader`: `demo@livecoding.dev` / `demo12345`.
Para ver o painel, entre com a conta de admin de desenvolvimento: `admin@livecoding.dev` /
`admin12345`. O link **Painel** só aparece no cabeçalho para quem tem role `ADMIN`.

## Decisões de design

O produto simula a pressão de uma entrevista técnica cronometrada, então a interface se comporta
como ferramenta de trabalho, não como página de captura:

- **Tipografia.** Space Grotesk nos títulos, IBM Plex Sans no texto, IBM Plex Mono no código —
  enunciado e solução precisam se distinguir antes da leitura.
- **Paleta.** Neutros quentes com acento único em terracota, no lugar do cinza-azulado de
  dashboard. Todos os pares de cor foram conferidos contra a WCAG antes de virar componente.
- **Raio único de 3px** no projeto inteiro, deliberadamente diferente do arredondamento padrão do
  Tailwind.
- **Layout assimétrico:** filtros em trilho à esquerda e lista à direita no catálogo; enunciado e
  editor lado a lado no desafio.
- **Cronômetro do servidor.** O relógio da questão parte do tempo devolvido por
  `POST /api/desafios/{id}/iniciar` e só corre na tela — recarregar a página não devolve tempo.
- **Duas medidas, não uma.** A correção mostra nota e precisão lado a lado, porque respondem
  perguntas diferentes: a nota conta só o que valia ponto, a precisão conta a régua inteira.
- **Tabelas do painel rolam no próprio contêiner** (`overflow-x-auto`), e cada percentual vem
  escrito ao lado da barra: a barra é reforço, nunca a única leitura do valor.
- Sem emoji, sem gradiente decorativo. Ícones vêm de um conjunto único, `lucide-react`.

Todo valor visual sai de `src/design-tokens.css`. Não existe cor, espaçamento ou tamanho de fonte
escrito direto no componente.

## Acessibilidade

Verificado com axe-core nas telas do candidato, sem violações. Além disso:

- Contraste conferido par a par: mínimo 4.5:1 em texto e 3:1 em componente e indicador de foco.
- Anel de foco duplo, porque um anel simples não contrasta com o botão de acento.
- Fluxo completo por teclado, com ordem de Tab igual à ordem visual e link para pular a navegação.
- No editor, Tab indenta e **Escape libera o foco** — a saída aparece na tela, não só no código.
- O resultado da correção é anunciado em região viva e recebe o foco quando chega.
- Status nunca depende só de cor: sempre com ícone e rótulo.

Em desenvolvimento, o axe-core roda a cada render e reporta violações no console.

## Limitações conhecidas

- **Sem realce de sintaxe.** O editor é um `<textarea>` com fonte monoespacada; CodeMirror ou
  Monaco não se justificam para enviar um trecho que o back-end corrige por heurística estática.
- **Token em `sessionStorage`.** Sobrevive ao refresh e morre com a aba, mas fica exposto a XSS. A
  alternativa correta é cookie `HttpOnly`, o que exige o back-end deixar de ser stateless por
  header `Authorization`.
- **Filtro de tecnologia derivado da listagem.** A API não expõe `GET /api/tecnologias`, então as
  opções saem dos desafios já carregados.
