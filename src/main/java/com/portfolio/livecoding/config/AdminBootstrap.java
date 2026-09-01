package com.portfolio.livecoding.config;

import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Cria (ou promove) a conta de admin a partir da configuracao.
 *
 * <p>Fica fora do DataLoader e sem @Profile de proposito: o admin precisa existir tambem em
 * producao, onde o usuario demo nao pode existir. O gatilho e a configuracao, nao o perfil —
 * {@code app.admin.email} e {@code app.admin.senha} vazios (o default do perfil prod) simplesmente
 * nao criam nada, e ninguem sobe um ambiente com senha de admin conhecida por acidente.
 *
 * <p>A senha nunca e reescrita numa conta que ja existe. Se ela ja e admin, este runner nao faz
 * nada; trocar a senha a cada boot transformaria uma variavel de ambiente esquecida numa
 * reversao silenciosa de credencial.
 */
@Component
@RequiredArgsConstructor
public class AdminBootstrap implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(AdminBootstrap.class);

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.admin.nome:Administrador}")
    private String nome;

    @Value("${app.admin.email:}")
    private String email;

    @Value("${app.admin.senha:}")
    private String senha;

    @Override
    @Transactional
    public void run(String... args) {
        if (email == null || email.isBlank() || senha == null || senha.isBlank()) {
            log.info("Nenhum admin configurado (app.admin.email / app.admin.senha vazios).");
            return;
        }

        usuarioRepository.findByEmail(email).ifPresentOrElse(this::promover, this::criar);
    }

    private void promover(Usuario existente) {
        if (existente.getRole() == Role.ADMIN) {
            return;
        }
        existente.setRole(Role.ADMIN);
        usuarioRepository.save(existente);
        log.info("Usuario {} promovido a ADMIN.", existente.getEmail());
    }

    private void criar() {
        Usuario admin = new Usuario();
        admin.setNome(nome);
        admin.setEmail(email);
        admin.setSenha(passwordEncoder.encode(senha));
        admin.setRole(Role.ADMIN);
        usuarioRepository.save(admin);
        log.info("Admin criado: {}", email);
    }
}
