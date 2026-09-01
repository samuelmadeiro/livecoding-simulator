package com.portfolio.livecoding.config;

import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Cria o usuario de testes. O catalogo de desafios nao vive mais aqui: veio para as migrations
 * (db/migration/V3__seed_catalogo.sql), que rodam em qualquer banco e deixam os dados gravados.
 *
 * <p>O usuario demo continua em Java, e nao no SQL, por dois motivos: a senha precisa passar pelo
 * PasswordEncoder da aplicacao, e o perfil prod nao pode ganhar uma conta de teste.
 */
@Component
@Profile("!prod")
@RequiredArgsConstructor
public class DataLoader implements CommandLineRunner {

    /** Senha em claro do usuario demo, documentada no README para testes manuais. */
    private static final String SENHA_DEMO = "demo12345";

    private static final String EMAIL_DEMO = "demo@livecoding.dev";

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        // Guard por e-mail, e nao por count(): com o catalogo vindo da migration, contar linhas de
        // outra tabela nao diz nada sobre a existencia deste usuario.
        if (usuarioRepository.findByEmail(EMAIL_DEMO).isPresent()) {
            return;
        }

        Usuario demo = new Usuario();
        demo.setNome("Candidato Demo");
        demo.setEmail(EMAIL_DEMO);
        demo.setSenha(passwordEncoder.encode(SENHA_DEMO));
        demo.setRole(Role.CANDIDATO);
        usuarioRepository.save(demo);
    }
}
