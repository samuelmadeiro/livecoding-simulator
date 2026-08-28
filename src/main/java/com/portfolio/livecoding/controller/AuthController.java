package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.AuthResponseDTO;
import com.portfolio.livecoding.dto.LoginRequestDTO;
import com.portfolio.livecoding.dto.RegistroRequestDTO;
import com.portfolio.livecoding.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /** Cadastro publico do candidato. Ja devolve o token, evitando um login extra. */
    @PostMapping("/register")
    public ResponseEntity<AuthResponseDTO> registrar(@RequestBody @Valid RegistroRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.registrar(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> login(@RequestBody @Valid LoginRequestDTO request) {
        return ResponseEntity.ok(authService.autenticar(request));
    }
}
