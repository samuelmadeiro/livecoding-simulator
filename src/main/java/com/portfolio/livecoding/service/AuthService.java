package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.AuthResponseDTO;
import com.portfolio.livecoding.dto.LoginRequestDTO;
import com.portfolio.livecoding.dto.RegistroRequestDTO;
import com.portfolio.livecoding.entity.Usuario;
import com.portfolio.livecoding.enums.Role;
import com.portfolio.livecoding.exception.EmailJaCadastradoException;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.UsuarioRepository;
import com.portfolio.livecoding.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    @Transactional
    public AuthResponseDTO registrar(RegistroRequestDTO request) {
        usuarioRepository.findByEmail(request.email()).ifPresent(existente -> {
            throw new EmailJaCadastradoException("Email ja cadastrado: " + request.email());
        });

        Usuario usuario = new Usuario();
        usuario.setNome(request.nome());
        usuario.setEmail(request.email());
        usuario.setSenha(passwordEncoder.encode(request.senha()));
        usuario.setRole(Role.CANDIDATO);

        Usuario salvo = usuarioRepository.save(usuario);

        return montarResposta(salvo);
    }

    @Transactional(readOnly = true)
    public AuthResponseDTO autenticar(LoginRequestDTO request) {
        // Lanca BadCredentialsException (tratada como 401) quando email ou senha nao batem.
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.senha()));

        Usuario usuario = usuarioRepository.findByEmail(request.email())
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuario nao encontrado: " + request.email()));

        return montarResposta(usuario);
    }

    private AuthResponseDTO montarResposta(Usuario usuario) {
        String token = jwtService.gerarToken(usuario.getEmail(), usuario.getRole().name());
        return AuthResponseDTO.bearer(
                token,
                jwtService.getExpiracaoMs(),
                usuario.getNome(),
                usuario.getEmail(),
                usuario.getRole());
    }
}
