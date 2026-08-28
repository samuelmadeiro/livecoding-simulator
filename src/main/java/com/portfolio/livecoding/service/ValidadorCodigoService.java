package com.portfolio.livecoding.service;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.StatusSubmissao;
import org.springframework.stereotype.Service;

/**
 * Simulacao de correcao automatica.
 * Nao executa codigo: aplica heuristicas estaticas simples.
 * Substituivel futuramente por um runner em sandbox (Docker / Judge0).
 */
@Service
public class ValidadorCodigoService {

    /** Resultado da analise: status final + feedback exibido ao candidato. */
    public record Resultado(StatusSubmissao status, String mensagemFeedback) {
    }

    private static final int TAMANHO_MINIMO = 20;

    public Resultado validar(String codigo, Desafio desafio) {
        String limpo = codigo == null ? "" : codigo.trim();

        if (limpo.length() < TAMANHO_MINIMO) {
            return new Resultado(StatusSubmissao.ERRO_COMPILACAO,
                    "Codigo muito curto para ser avaliado. Implemente a solucao antes de enviar.");
        }

        if (!chavesBalanceadas(limpo)) {
            return new Resultado(StatusSubmissao.ERRO_COMPILACAO,
                    "Chaves ou parenteses desbalanceados. Revise a sintaxe.");
        }

        if (desafio.getTemplateCodigo() != null
                && limpo.equals(desafio.getTemplateCodigo().trim())) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "O codigo enviado e identico ao template. Nenhum teste passou.");
        }

        String palavraChave = palavraChaveEsperada(desafio);
        if (!limpo.toLowerCase().contains(palavraChave)) {
            return new Resultado(StatusSubmissao.ERRO_TESTE,
                    "Testes falharam: a solucao nao contempla '" + palavraChave
                            + "', esperado para desafios do tipo " + desafio.getTipo() + ".");
        }

        return new Resultado(StatusSubmissao.APROVADO,
                "Todos os testes simulados passaram. Bom trabalho!");
    }

    private boolean chavesBalanceadas(String codigo) {
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

    private String palavraChaveEsperada(Desafio desafio) {
        return switch (desafio.getTipo()) {
            case API_REST -> "mapping";
            case ALGORITMO_EASY -> "return";
            case BANCO_DADOS -> "select";
        };
    }
}
