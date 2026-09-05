package com.portfolio.livecoding.service;

import com.portfolio.livecoding.repository.UsuarioRepository;
import java.text.Normalizer;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * Gera o apelido publico a partir do nome do cadastro.
 *
 * <p>O ranking e visivel para visitante anonimo, entao ele nao pode carregar nome completo nem
 * e-mail. O primeiro nome resolve: identifica sem expor.
 */
@Service
@RequiredArgsConstructor
public class ApelidoService {

    /** Bate com o length da coluna: apelido maior seria cortado no banco. */
    private static final int TAMANHO_MAXIMO = 40;

    private final UsuarioRepository usuarioRepository;

    public String gerar(String nome) {
        String base = primeiroNome(nome);

        if (!usuarioRepository.existsByApelido(base)) {
            return base;
        }

        // Homonimo ganha numero. O limite existe para o metodo nao virar laco infinito se algo der
        // muito errado; na pratica ele nunca e alcancado.
        for (int sufixo = 2; sufixo < 1000; sufixo++) {
            String candidato = encurtar(base, sufixo) + " " + sufixo;
            if (!usuarioRepository.existsByApelido(candidato)) {
                return candidato;
            }
        }

        return base + " " + System.currentTimeMillis() % 100000;
    }

    /**
     * Primeiro nome, sem acento e capitalizado.
     *
     * <p>Tira o acento porque o apelido e comparado por igualdade no indice unico: "Joao" e "João"
     * seriam dois apelidos diferentes na tabela e a mesma pessoa aos olhos de quem le o ranking.
     */
    private String primeiroNome(String nome) {
        String limpo = nome == null ? "" : nome.trim();

        if (limpo.isEmpty()) {
            return "Candidato";
        }

        String primeiro = limpo.split("\\s+")[0];
        String semAcento = Normalizer.normalize(primeiro, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replaceAll("[^A-Za-z0-9]", "");

        if (semAcento.isEmpty()) {
            return "Candidato";
        }

        String capitalizado = semAcento.substring(0, 1).toUpperCase()
                + semAcento.substring(1).toLowerCase();

        return capitalizado.length() > TAMANHO_MAXIMO
                ? capitalizado.substring(0, TAMANHO_MAXIMO)
                : capitalizado;
    }

    /** Abre espaco para o sufixo sem estourar o limite da coluna. */
    private String encurtar(String base, int sufixo) {
        int espacoDoSufixo = String.valueOf(sufixo).length() + 1;
        int limite = TAMANHO_MAXIMO - espacoDoSufixo;
        return base.length() > limite ? base.substring(0, limite) : base;
    }
}
