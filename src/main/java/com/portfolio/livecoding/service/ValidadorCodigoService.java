package com.portfolio.livecoding.service;

import com.portfolio.livecoding.entity.CriterioAvaliacao;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.enums.TipoCriterio;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import org.springframework.stereotype.Service;

/**
 * Simulacao de correcao automatica. Nao executa codigo: aplica os criterios cadastrados para o
 * desafio (tabela criterios_avaliacao) sobre o texto enviado.
 *
 * <p>Duas regras existem justamente para que nenhum desafio seja dado como resolvido por causa de
 * um unico sinal — um {@code @GetMapping} solto, um {@code return} solto:
 *
 * <ul>
 *   <li>desafio sem criterios cadastrados nao aprova mais por palavra-chave do tipo. A submissao
 *       fica PENDENTE, para revisao manual. A heuristica antiga era exatamente o falso positivo
 *       que se queria evitar: um "mapping" em qualquer lugar do arquivo aprovava a questao.</li>
 *   <li>aprovar exige quatro coisas ao mesmo tempo: nenhum criterio PROIBIDO casado, todos os
 *       OBRIGATORIO atendidos, nota dos PONTUAVEL acima de {@value #PONTUACAO_MINIMA} e precisao
 *       geral acima de {@value #PRECISAO_MINIMA}. Um desafio com menos de
 *       {@value #CRITERIOS_MINIMOS_PARA_APROVAR} criterios nunca aprova sozinho: regua curta
 *       demais para sustentar um veredito.</li>
 * </ul>
 *
 * <p>Substituivel futuramente por um runner em sandbox (Docker / Judge0).
 */
@Service
public class ValidadorCodigoService {

    /**
     * Resultado da analise.
     *
     * @param pontuacao nota de 0 a 100 sobre os criterios PONTUAVEL — o quanto a solucao entregou
     *                  do que valia ponto.
     * @param precisao  0 a 100 sobre o peso de todos os criterios, com OBRIGATORIO contando
     *                  dobrado e PROIBIDO contando quando nao casa. Responde outra pergunta: o
     *                  quanto a solucao chegou perto da regua inteira do desafio.
     */
    public record Resultado(StatusSubmissao status,
                            String mensagemFeedback,
                            int pontuacao,
                            int precisao,
                            List<ItemAvaliado> itens) {
    }

    /** Um criterio ja avaliado, pronto para virar linha de feedback e linha de historico. */
    public record ItemAvaliado(CriterioAvaliacao criterio,
                               String descricao,
                               TipoCriterio tipo,
                               int peso,
                               String dica,
                               boolean atendido) {
    }

    private static final int TAMANHO_MINIMO = 20;

    /** Percentual minimo dos criterios pontuaveis para aprovar. */
    private static final int PONTUACAO_MINIMA = 70;

    /** Percentual minimo da regua inteira para aprovar. Exige largura, nao um sinal isolado. */
    private static final int PRECISAO_MINIMA = 75;

    /** Abaixo disso a regua nao sustenta um veredito automatico. */
    private static final int CRITERIOS_MINIMOS_PARA_APROVAR = 3;

    /** Quantos caracteres significativos a solucao precisa acrescentar ao template. */
    private static final int MINIMO_ACRESCENTADO_AO_TEMPLATE = 15;

    /** Comentarios de linha (// e #), de bloco e docstrings triplas do Python. */
    private static final Pattern COMENTARIOS = Pattern.compile(
            "(?s)/\\*.*?\\*/|//[^\\n]*|#[^\\n]*|\"\"\".*?\"\"\"|'''.*?'''");

    /**
     * Sinal de que existe codigo de verdade, e nao um punhado de anotacoes e assinaturas: um bloco
     * com conteudo, uma funcao Python ou uma consulta SQL.
     */
    private static final Pattern CORPO_EXECUTAVEL = Pattern.compile(
            "(?is)\\{[^{}]*\\S[^{}]*\\}|\\bdef\\s+\\w+\\s*\\(|\\bselect\\b.+?\\bfrom\\b");

    private static final Pattern ESPACOS = Pattern.compile("\\s+");

    public Resultado validar(String codigo, Desafio desafio, List<CriterioAvaliacao> criterios) {
        String bruto = codigo == null ? "" : codigo.trim();

        if (bruto.length() < TAMANHO_MINIMO) {
            return reprovado(StatusSubmissao.ERRO_COMPILACAO,
                    "Codigo muito curto para ser avaliado. Implemente a solucao antes de enviar.");
        }

        if (!delimitadoresBalanceados(bruto)) {
            return reprovado(StatusSubmissao.ERRO_COMPILACAO,
                    "Chaves ou parenteses desbalanceados. Revise a sintaxe.");
        }

        String analisavel = semComentarios(bruto);

        // A comparacao com o template vem antes da checagem de corpo: template sem corpo de
        // metodo tambem falharia ali, e "voce me devolveu o template" e um retorno bem mais util
        // do que "nao encontrei corpo de metodo".
        Comparacao comparacao = compararComTemplate(analisavel, desafio.getTemplateCodigo());

        if (comparacao == Comparacao.IDENTICO) {
            return reprovado(StatusSubmissao.ERRO_TESTE,
                    "O codigo enviado e identico ao template. Nenhum teste passou.");
        }

        if (comparacao == Comparacao.QUASE_IDENTICO) {
            return reprovado(StatusSubmissao.ERRO_TESTE,
                    "O codigo enviado e o template com poucos caracteres a mais. "
                            + "A implementacao ainda nao esta ai.");
        }

        if (!CORPO_EXECUTAVEL.matcher(analisavel).find()) {
            return reprovado(StatusSubmissao.ERRO_COMPILACAO,
                    "Nao encontrei corpo de metodo, funcao ou consulta no que voce enviou. "
                            + "Assinatura e anotacao sozinhas nao resolvem a questao.");
        }

        if (criterios == null || criterios.isEmpty()) {
            // Antes, aqui uma palavra-chave por tipo de desafio decidia aprovado ou reprovado.
            // Um "mapping" perdido no arquivo aprovava a questao inteira: exatamente o falso
            // positivo que esta classe existe para nao cometer.
            return new Resultado(StatusSubmissao.PENDENTE,
                    "Este desafio ainda nao tem regua de correcao cadastrada. A submissao ficou "
                            + "registrada para revisao manual, sem nota automatica.",
                    0, 0, List.of());
        }

        return avaliarCriterios(bruto, analisavel, criterios);
    }

    private Resultado avaliarCriterios(String bruto, String analisavel,
                                       List<CriterioAvaliacao> criterios) {
        // Criterios PONTUAVEL e OBRIGATORIO rodam sobre o codigo sem comentarios: um "// return"
        // nao pode contar como implementacao. PROIBIDO roda sobre o texto cru, porque justamente
        // o que ele procura (um TODO deixado para tras) costuma morar num comentario.
        List<ItemAvaliado> itens = new ArrayList<>();
        String bloqueio = null;
        String obrigatorioFaltando = null;

        int pesoPontuavel = 0;
        int pesoPontuado = 0;
        int pesoTotal = 0;
        int pesoAtendido = 0;

        for (CriterioAvaliacao criterio : criterios) {
            boolean proibido = criterio.getTipo() == TipoCriterio.PROIBIDO;
            boolean casou = casa(criterio.getPadrao(), proibido ? bruto : analisavel);
            boolean atendido = proibido != casou;

            int peso = criterio.getPeso() == null ? 1 : criterio.getPeso();
            // OBRIGATORIO pesa dobrado na precisao: e o que decide se a questao foi resolvida.
            int pesoNaPrecisao = criterio.getTipo() == TipoCriterio.OBRIGATORIO ? peso * 2 : peso;

            pesoTotal += pesoNaPrecisao;
            if (atendido) {
                pesoAtendido += pesoNaPrecisao;
            }

            if (criterio.getTipo() == TipoCriterio.PONTUAVEL) {
                pesoPontuavel += peso;
                if (atendido) {
                    pesoPontuado += peso;
                }
            }

            if (proibido && casou && bloqueio == null) {
                bloqueio = criterio.getDescricao();
            }
            if (criterio.getTipo() == TipoCriterio.OBRIGATORIO && !casou
                    && obrigatorioFaltando == null) {
                obrigatorioFaltando = criterio.getDescricao();
            }

            itens.add(new ItemAvaliado(criterio, criterio.getDescricao(), criterio.getTipo(),
                    peso, criterio.getDica(), atendido));
        }

        int pontuacao = pesoPontuavel == 0 ? 100 : Math.round(100f * pesoPontuado / pesoPontuavel);
        int precisao = pesoTotal == 0 ? 0 : Math.round(100f * pesoAtendido / pesoTotal);

        if (bloqueio != null) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Testes falharam: " + bloqueio.toLowerCase() + ".", pontuacao, precisao, itens);
        }

        if (obrigatorioFaltando != null) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Testes falharam: um requisito essencial nao foi atendido ("
                            + obrigatorioFaltando + "). Confira os itens abaixo.",
                    pontuacao, precisao, itens);
        }

        if (pontuacao < PONTUACAO_MINIMA) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Solucao parcial: " + pontuacao + " de 100, e o minimo e " + PONTUACAO_MINIMA
                            + ". Confira os itens que ficaram de fora.",
                    pontuacao, precisao, itens);
        }

        if (precisao < PRECISAO_MINIMA) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Solucao parcial: precisao de " + precisao + "% sobre os criterios do desafio, "
                            + "abaixo dos " + PRECISAO_MINIMA + "% exigidos.",
                    pontuacao, precisao, itens);
        }

        if (criterios.size() < CRITERIOS_MINIMOS_PARA_APROVAR) {
            return new Resultado(StatusSubmissao.PENDENTE,
                    "Este desafio tem criterios de menos para uma aprovacao automatica confiavel. "
                            + "A submissao foi registrada para revisao manual.",
                    pontuacao, precisao, itens);
        }

        return new Resultado(StatusSubmissao.APROVADO,
                "Todos os requisitos essenciais foram atendidos. Pontuacao: " + pontuacao
                        + " de 100, precisao de " + precisao + "%.",
                pontuacao, precisao, itens);
    }

    private enum Comparacao { IDENTICO, QUASE_IDENTICO, DIFERENTE }

    /**
     * Compara ignorando comentarios e espacos: reindentar o template ou apagar o TODO dele nao
     * transforma o template numa solucao.
     */
    private Comparacao compararComTemplate(String analisavel, String template) {
        if (template == null || template.isBlank()) {
            return Comparacao.DIFERENTE;
        }

        String codigoNormalizado = normalizar(analisavel);
        String templateNormalizado = normalizar(semComentarios(template));

        if (templateNormalizado.isEmpty()) {
            return Comparacao.DIFERENTE;
        }
        if (codigoNormalizado.equals(templateNormalizado)) {
            return Comparacao.IDENTICO;
        }

        int acrescentado = codigoNormalizado.length() - templateNormalizado.length();
        if (acrescentado <= 0 || acrescentado >= MINIMO_ACRESCENTADO_AO_TEMPLATE) {
            return Comparacao.DIFERENTE;
        }

        // O template inteiro continua ali, so que com um punhado de caracteres enfiados no meio:
        // o comeco e o fim batem e cobrem o template todo. Comparar por "contem" nao pegaria este
        // caso, porque o acrescimo costuma entrar dentro das chaves.
        boolean molduraIntacta = prefixoComum(codigoNormalizado, templateNormalizado)
                + sufixoComum(codigoNormalizado, templateNormalizado)
                >= templateNormalizado.length();

        return molduraIntacta ? Comparacao.QUASE_IDENTICO : Comparacao.DIFERENTE;
    }

    private int prefixoComum(String a, String b) {
        int limite = Math.min(a.length(), b.length());
        int i = 0;
        while (i < limite && a.charAt(i) == b.charAt(i)) {
            i++;
        }
        return i;
    }

    private int sufixoComum(String a, String b) {
        int limite = Math.min(a.length(), b.length());
        int i = 0;
        while (i < limite && a.charAt(a.length() - 1 - i) == b.charAt(b.length() - 1 - i)) {
            i++;
        }
        return i;
    }

    private String normalizar(String codigo) {
        return ESPACOS.matcher(codigo).replaceAll("");
    }

    /** Regex invalida no banco nao pode derrubar a correcao: conta como criterio nao atendido. */
    private boolean casa(String padrao, String texto) {
        try {
            return Pattern.compile(padrao, Pattern.CASE_INSENSITIVE).matcher(texto).find();
        } catch (PatternSyntaxException e) {
            return false;
        }
    }

    private String semComentarios(String codigo) {
        return COMENTARIOS.matcher(codigo).replaceAll(" ");
    }

    private Resultado reprovado(StatusSubmissao status, String mensagem) {
        return new Resultado(status, mensagem, 0, 0, List.of());
    }

    private boolean delimitadoresBalanceados(String codigo) {
        int chaves = 0;
        int parenteses = 0;
        for (char c : codigo.toCharArray()) {
            switch (c) {
                case '{' -> chaves++;
                case '}' -> chaves--;
                case '(' -> parenteses++;
                case ')' -> parenteses--;
                default -> {
                }
            }
            if (chaves < 0 || parenteses < 0) {
                return false;
            }
        }
        return chaves == 0 && parenteses == 0;
    }
}
