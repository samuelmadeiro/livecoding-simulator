package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.FalaEntrevistadorDTO;
import com.portfolio.livecoding.dto.FalaEntrevistadorDTO.AjusteDTO;
import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.enums.StatusSubmissao;
import com.portfolio.livecoding.enums.TipoCriterio;
import com.portfolio.livecoding.service.ValidadorCodigoService.ItemAvaliado;
import com.portfolio.livecoding.service.ValidadorCodigoService.Resultado;
import java.util.List;
import org.springframework.stereotype.Service;

/**
 * Transforma o resultado da correcao na fala de quem estaria do outro lado da mesa.
 *
 * <p>A lista de itens verdes e vermelhos diz o que falhou; ela nao ensina. Numa entrevista de
 * verdade o candidato ouve alguem dizer o que gostou, onde a solucao trava, que caminho seguir e
 * como a avaliacao foi feita. E isso que esta classe monta — sem entregar a solucao pronta: cada
 * ajuste sai com a dica cadastrada para o criterio, que aponta a direcao e para por ali.
 *
 * <p>Nada aqui chama modelo de linguagem. O texto e montado por regra a partir do que a correcao
 * ja sabe: status, nota, precisao, tempo e quais criterios passaram.
 */
@Service
public class FeedbackEntrevistadorService {

    /** Personas fixas. O desafio escolhe uma pelo id, entao a mesma questao tem sempre a mesma voz. */
    private static final String[][] PERSONAS = {
            {"Marina Alencar", "Tech lead"},
            {"Rafael Duarte", "Engenheiro sênior"},
            {"Camila Rocha", "Coordenadora de engenharia"},
            {"Bruno Tavares", "Arquiteto de software"},
    };

    /** Quantos elogios e quantos ajustes a fala carrega. Além disso vira sermão, não retorno. */
    private static final int MAXIMO_ELOGIOS = 3;
    private static final int MAXIMO_AJUSTES = 4;

    public FalaEntrevistadorDTO gerar(Desafio desafio, Resultado resultado,
                                      Integer duracaoSegundos, String nomeCandidato) {

        String[] persona = PERSONAS[(int) (Math.abs(idDe(desafio)) % PERSONAS.length)];
        String primeiroNome = primeiroNome(nomeCandidato);

        List<ItemAvaliado> atendidos = resultado.itens().stream()
                .filter(ItemAvaliado::atendido)
                .toList();

        List<ItemAvaliado> pendentes = resultado.itens().stream()
                .filter(item -> !item.atendido())
                // Obrigatório antes de pontuável, e dentro de cada tipo o de maior peso primeiro:
                // o candidato lê de cima para baixo e o topo precisa ser o que mais custa.
                .sorted((a, b) -> {
                    int porTipo = Integer.compare(ordem(a.tipo()), ordem(b.tipo()));
                    return porTipo != 0 ? porTipo : Integer.compare(b.peso(), a.peso());
                })
                .toList();

        return new FalaEntrevistadorDTO(
                persona[0],
                persona[1],
                abertura(resultado, primeiroNome, desafio),
                elogios(atendidos, resultado),
                ajustes(pendentes),
                comentarioTempo(duracaoSegundos, desafio.getTempoLimiteMinutos(), resultado),
                comoAvaliei(resultado),
                fechamento(resultado, pendentes));
    }

    private String abertura(Resultado resultado, String nome, Desafio desafio) {
        String chamada = nome.isBlank() ? "Então" : nome + ", ";

        return switch (resultado.status()) {
            case APROVADO -> chamada + "li sua solução de \"" + desafio.getTitulo()
                    + "\" e ela resolve o que eu pedi. Numa entrevista de verdade eu seguiria a "
                    + "conversa a partir daqui, perguntando sobre casos de borda e desempenho.";
            case ERRO_COMPILACAO -> chamada + "antes de entrar no mérito da lógica: o que você me "
                    + "mandou não chega a rodar. Numa entrevista ao vivo eu pediria para você "
                    + "compilar antes de me explicar o raciocínio.";
            case PENDENTE -> chamada + "recebi sua solução, mas este desafio ainda não tem régua "
                    + "de correção fechada. Prefiro olhar com calma a te dar um veredito "
                    + "automático em que eu mesmo não confiaria.";
            case ERRO_TESTE -> chamada + "deixa eu te dar o retorno direto: sua solução vai no "
                    + "caminho certo em parte do problema, mas ainda não é o que eu aprovaria "
                    + "nesta vaga. Vou te mostrar exatamente onde ela para.";
        };
    }

    private List<String> elogios(List<ItemAvaliado> atendidos, Resultado resultado) {
        if (atendidos.isEmpty()) {
            if (resultado.status() == StatusSubmissao.ERRO_COMPILACAO) {
                return List.of("Você enviou dentro do tempo em vez de travar — isso conta, "
                        + "mesmo com o código quebrado.");
            }
            return List.of();
        }

        return atendidos.stream()
                // Mesma ordem dos ajustes: o essencial primeiro, depois o que pesa mais.
                .sorted((a, b) -> {
                    int porTipo = Integer.compare(ordem(a.tipo()), ordem(b.tipo()));
                    return porTipo != 0 ? porTipo : Integer.compare(b.peso(), a.peso());
                })
                .limit(MAXIMO_ELOGIOS)
                .map(item -> switch (item.tipo()) {
                    case OBRIGATORIO -> "O essencial está lá: " + minuscula(item.descricao()) + ".";
                    case PROIBIDO -> "Entregou limpo: " + minuscula(item.descricao()) + ".";
                    case PONTUAVEL -> "Gostei que você cuidou de um detalhe que muita gente pula: "
                            + minuscula(item.descricao()) + ".";
                })
                .toList();
    }

    private List<AjusteDTO> ajustes(List<ItemAvaliado> pendentes) {
        return pendentes.stream()
                .limit(MAXIMO_AJUSTES)
                .map(item -> new AjusteDTO(
                        item.descricao(),
                        item.dica() == null || item.dica().isBlank() ? dicaPadrao(item) : item.dica(),
                        porQueImporta(item)))
                .toList();
    }

    private String dicaPadrao(ItemAvaliado item) {
        return switch (item.tipo()) {
            case OBRIGATORIO -> "Volte ao enunciado e confira este ponto: sem ele a questão não "
                    + "conta como resolvida.";
            case PONTUAVEL -> "Cobrir este ponto é o que separa a solução que funciona da solução "
                    + "que eu aprovaria.";
            case PROIBIDO -> "Isso é sinal de código entregue pela metade. Limpe antes de enviar.";
        };
    }

    private String porQueImporta(ItemAvaliado item) {
        return switch (item.tipo()) {
            case OBRIGATORIO -> "Requisito essencial: sem ele eu não considero a questão resolvida, "
                    + "por melhor que esteja o resto.";
            case PROIBIDO -> "Sinal de código inacabado. É a primeira coisa que eu reparo ao abrir "
                    + "um pull request.";
            case PONTUAVEL -> item.peso() >= 3
                    ? "Peso alto na minha régua (" + item.peso() + "): é aqui que eu separo quem "
                            + "faz funcionar de quem entrega bem."
                    : "Peso menor (" + item.peso() + "), mas é o tipo de detalhe que aparece na "
                            + "revisão de código.";
        };
    }

    private String comentarioTempo(Integer duracaoSegundos, Integer limiteMinutos,
                                   Resultado resultado) {
        if (duracaoSegundos == null) {
            return "Esta tentativa não foi cronometrada, então não comento o tempo. Abra o desafio "
                    + "pela página dele para o relógio contar junto na próxima.";
        }

        String gasto = formatarDuracao(duracaoSegundos);

        if (limiteMinutos == null || limiteMinutos <= 0) {
            return "Você levou " + gasto + " nesta questão.";
        }

        int limiteSegundos = limiteMinutos * 60;
        boolean aprovado = resultado.status() == StatusSubmissao.APROVADO;

        if (duracaoSegundos > limiteSegundos) {
            return "Você levou " + gasto + ", acima dos " + limiteMinutos + " minutos que eu daria "
                    + "para esta questão. " + (aprovado
                            ? "A solução está boa; o que treinaria agora é velocidade, não conteúdo."
                            : "Numa entrevista o tempo teria acabado antes da solução ficar de pé.");
        }

        if (duracaoSegundos < limiteSegundos / 2) {
            return "Você levou " + gasto + ", bem dentro dos " + limiteMinutos + " minutos. "
                    + (aprovado
                            ? "Rápido e correto — foi o que eu esperava ver."
                            : "Sobrou tempo: valia ter relido o enunciado antes de enviar.");
        }

        return "Você levou " + gasto + ", dentro dos " + limiteMinutos + " minutos previstos. "
                + "Ritmo compatível com o que eu vejo em entrevista.";
    }

    private String comoAvaliei(Resultado resultado) {
        if (resultado.itens().isEmpty()) {
            return "Não cheguei a pontuar por critério: a análise parou antes disso.";
        }

        long obrigatorios = contar(resultado, TipoCriterio.OBRIGATORIO);
        long pontuaveis = contar(resultado, TipoCriterio.PONTUAVEL);
        long proibidos = contar(resultado, TipoCriterio.PROIBIDO);

        int total = resultado.itens().size();

        return "Como eu cheguei nesses números: esta questão tem " + total
                + (total == 1 ? " critério — " : " critérios — ")
                + obrigatorios + (obrigatorios == 1 ? " essencial, " : " essenciais, ")
                + pontuaveis + (pontuaveis == 1 ? " que vale ponto e " : " que valem ponto e ")
                + proibidos + (proibidos == 1 ? " que reprova se aparecer. " : " que reprovam se aparecerem. ")
                + "Sua nota (" + resultado.pontuacao()
                + " de 100) sai só dos que valem ponto, cada um com o peso dele. A precisão ("
                + resultado.precisao() + "%) soma a régua inteira, com os essenciais contando "
                + "dobrado. Nenhum critério sozinho aprova a questão: acertar a anotação da rota e "
                + "parar por aí dá sinal verde num item e vermelho em todos os outros.";
    }

    private String fechamento(Resultado resultado, List<ItemAvaliado> pendentes) {
        return switch (resultado.status()) {
            case APROVADO -> "Fechado por mim. Se quiser subir o nível, tente a mesma questão "
                    + "cronometrando e explicando a solução em voz alta — é isso que eu ouviria "
                    + "numa entrevista ao vivo.";
            case ERRO_COMPILACAO -> "Ajuste a sintaxe, rode uma vez na sua máquina e me manda de "
                    + "novo. Código que não compila eu nem consigo avaliar.";
            case PENDENTE -> "Deixei registrado para revisão manual. Enquanto isso, compare sua "
                    + "solução com o enunciado item a item.";
            case ERRO_TESTE -> pendentes.isEmpty()
                    ? "Reveja a solução com o enunciado do lado e me manda a próxima versão."
                    : "Comece por \"" + pendentes.getFirst().descricao() + "\": é o ponto que mais "
                            + "custa na sua nota. Resolvido esse, me manda de novo que eu olho.";
        };
    }

    private long contar(Resultado resultado, TipoCriterio tipo) {
        return resultado.itens().stream().filter(item -> item.tipo() == tipo).count();
    }

    private int ordem(TipoCriterio tipo) {
        return switch (tipo) {
            case OBRIGATORIO -> 0;
            case PROIBIDO -> 1;
            case PONTUAVEL -> 2;
        };
    }

    private String formatarDuracao(int segundos) {
        if (segundos < 60) {
            return segundos + (segundos == 1 ? " segundo" : " segundos");
        }
        int minutos = segundos / 60;
        int resto = segundos % 60;
        String base = minutos + (minutos == 1 ? " minuto" : " minutos");
        return resto == 0 ? base : base + " e " + resto + "s";
    }

    private String minuscula(String descricao) {
        if (descricao == null || descricao.isBlank()) {
            return "";
        }
        return Character.toLowerCase(descricao.charAt(0)) + descricao.substring(1);
    }

    private String primeiroNome(String nome) {
        if (nome == null || nome.isBlank()) {
            return "";
        }
        return nome.trim().split("\\s+")[0];
    }

    private long idDe(Desafio desafio) {
        return desafio.getId() == null ? 0L : desafio.getId();
    }
}
