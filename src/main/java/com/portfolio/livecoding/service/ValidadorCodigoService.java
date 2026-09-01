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
 * <p>A versao anterior aprovava ou reprovava por uma unica palavra-chave fixa por tipo de desafio,
 * o que dava dois falsos resultados obvios: uma solucao correta que nao usasse aquele token exato
 * reprovava, e um comentario com o token aprovava. Agora sao varios sinais com peso, definidos por
 * desafio no banco, e comentarios sao descartados antes da analise.
 *
 * <p>Substituivel futuramente por um runner em sandbox (Docker / Judge0).
 */
@Service
public class ValidadorCodigoService {

    /**
     * Resultado da analise: status final, feedback, nota de 0 a 100 e o detalhamento por criterio.
     */
    public record Resultado(StatusSubmissao status,
                            String mensagemFeedback,
                            int pontuacao,
                            List<ItemAvaliado> itens) {
    }

    /** Um criterio ja avaliado, pronto para virar linha de feedback. */
    public record ItemAvaliado(String descricao, boolean atendido) {
    }

    private static final int TAMANHO_MINIMO = 20;

    /** Percentual minimo dos criterios pontuaveis para aprovar. */
    private static final int PONTUACAO_MINIMA = 70;

    /** Comentarios de linha (// e #), de bloco e docstrings triplas do Python. */
    private static final Pattern COMENTARIOS = Pattern.compile(
            "(?s)/\\*.*?\\*/|//[^\\n]*|#[^\\n]*|\"\"\".*?\"\"\"|'''.*?'''");

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

        if (desafio.getTemplateCodigo() != null
                && bruto.equals(desafio.getTemplateCodigo().trim())) {
            return reprovado(StatusSubmissao.ERRO_TESTE,
                    "O codigo enviado e identico ao template. Nenhum teste passou.");
        }

        if (criterios == null || criterios.isEmpty()) {
            return validarPorHeuristicaDeTipo(bruto, desafio);
        }

        return avaliarCriterios(bruto, criterios);
    }

    private Resultado avaliarCriterios(String bruto, List<CriterioAvaliacao> criterios) {
        // Criterios PONTUAVEL e OBRIGATORIO rodam sobre o codigo sem comentarios: um "// return"
        // nao pode contar como implementacao. PROIBIDO roda sobre o texto cru, porque justamente
        // o que ele procura (um TODO deixado para tras) costuma morar num comentario.
        String analisavel = semComentarios(bruto);

        List<ItemAvaliado> itens = new ArrayList<>();
        String bloqueio = null;
        boolean obrigatorioFalhou = false;

        int pesoTotal = 0;
        int pesoAtendido = 0;

        for (CriterioAvaliacao criterio : criterios) {
            boolean proibido = criterio.getTipo() == TipoCriterio.PROIBIDO;
            boolean casou = casa(criterio.getPadrao(), proibido ? bruto : analisavel);

            switch (criterio.getTipo()) {
                case PROIBIDO -> {
                    itens.add(new ItemAvaliado(criterio.getDescricao(), !casou));
                    if (casou && bloqueio == null) {
                        bloqueio = criterio.getDescricao();
                    }
                }
                case OBRIGATORIO -> {
                    itens.add(new ItemAvaliado(criterio.getDescricao(), casou));
                    obrigatorioFalhou = obrigatorioFalhou || !casou;
                }
                case PONTUAVEL -> {
                    itens.add(new ItemAvaliado(criterio.getDescricao(), casou));
                    int peso = criterio.getPeso() == null ? 1 : criterio.getPeso();
                    pesoTotal += peso;
                    if (casou) {
                        pesoAtendido += peso;
                    }
                }
            }
        }

        int pontuacao = pesoTotal == 0 ? 100 : Math.round(100f * pesoAtendido / pesoTotal);

        if (bloqueio != null) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Testes falharam: " + bloqueio.toLowerCase() + ".", pontuacao, itens);
        }

        if (obrigatorioFalhou) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Testes falharam: um requisito essencial nao foi atendido. Confira os itens abaixo.",
                    pontuacao, itens);
        }

        if (pontuacao < PONTUACAO_MINIMA) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Solucao parcial: " + pontuacao + " de 100, e o minimo e " + PONTUACAO_MINIMA
                            + ". Confira os itens que ficaram de fora.",
                    pontuacao, itens);
        }

        return new Resultado(StatusSubmissao.APROVADO,
                "Todos os requisitos essenciais foram atendidos. Pontuacao: " + pontuacao + " de 100.",
                pontuacao, itens);
    }

    /**
     * Rede de seguranca para desafios ainda sem criterios cadastrados: mantem o comportamento
     * antigo de palavra-chave por tipo, agora ao menos ignorando comentarios.
     */
    private Resultado validarPorHeuristicaDeTipo(String bruto, Desafio desafio) {
        String palavraChave = switch (desafio.getTipo()) {
            case API_REST -> "mapping";
            case ALGORITMO_EASY -> "return";
            case BANCO_DADOS -> "select";
        };

        if (!semComentarios(bruto).toLowerCase().contains(palavraChave)) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Testes falharam: a solucao nao contempla '" + palavraChave
                            + "', esperado para desafios do tipo " + desafio.getTipo() + ".",
                    0, List.of());
        }

        return new Resultado(StatusSubmissao.APROVADO,
                "Todos os testes simulados passaram. Bom trabalho!", 100, List.of());
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
        return new Resultado(status, mensagem, 0, List.of());
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
