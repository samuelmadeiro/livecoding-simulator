package com.portfolio.livecoding.config;

import com.portfolio.livecoding.entity.Desafio;
import com.portfolio.livecoding.entity.Tecnologia;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.repository.DesafioRepository;
import com.portfolio.livecoding.repository.TecnologiaRepository;
import com.portfolio.livecoding.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * Popula o H2 com dados de exemplo para testar a API rapidamente.
 * Ativo apenas fora do perfil prod.
 */
@Component
@Profile("!prod")
@RequiredArgsConstructor
public class DataLoader implements CommandLineRunner {

    private final UsuarioRepository usuarioRepository;
    private final TecnologiaRepository tecnologiaRepository;
    private final DesafioRepository desafioRepository;

    @Override
    public void run(String... args) {
        if (usuarioRepository.count() > 0) {
            return;
        }

        Usuario demo = new Usuario();
        demo.setNome("Candidato Demo");
        demo.setEmail("demo@livecoding.dev");
        demo.setSenha("senha-nao-criptografada-apenas-demo");
        usuarioRepository.save(demo);

        Tecnologia java = novaTecnologia("Java");
        Tecnologia node = novaTecnologia("Node");
        novaTecnologia("Python");

        Desafio api = new Desafio();
        api.setTitulo("CRUD de Produtos");
        api.setDescricao("Implemente o endpoint GET /produtos retornando a lista de produtos.");
        api.setNivel(NivelVaga.JUNIOR);
        api.setTipo(TipoDesafio.API_REST);
        api.setTempoLimiteMinutos(45);
        api.setTemplateCodigo("""
                @RestController
                public class ProdutoController {
                    // TODO: implementar
                }
                """);
        api.setTecnologia(java);
        desafioRepository.save(api);

        Desafio algoritmo = new Desafio();
        algoritmo.setTitulo("Soma de Pares");
        algoritmo.setDescricao("Dado um array de inteiros, retorne a soma dos numeros pares.");
        algoritmo.setNivel(NivelVaga.ESTAGIO);
        algoritmo.setTipo(TipoDesafio.ALGORITMO_EASY);
        algoritmo.setTempoLimiteMinutos(20);
        algoritmo.setTemplateCodigo("""
                function somaPares(numeros) {
                    // TODO: implementar
                }
                """);
        algoritmo.setTecnologia(node);
        desafioRepository.save(algoritmo);
    }

    private Tecnologia novaTecnologia(String nome) {
        Tecnologia tecnologia = new Tecnologia();
        tecnologia.setNome(nome);
        return tecnologiaRepository.save(tecnologia);
    }
}
