package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.SubmissaoRequestDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.service.SubmissaoService;
import jakarta.validation.Valid;
import java.net.URI;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/submissoes")
@RequiredArgsConstructor
public class SubmissaoController {

    private final SubmissaoService submissaoService;

    /**
     * POST /api/submissoes — exige JWT.
     * A submissao e sempre atribuida ao dono do token, nunca a um id vindo do cliente.
     */
    @PostMapping
    public ResponseEntity<SubmissaoResponseDTO> criar(
            @RequestBody @Valid SubmissaoRequestDTO request,
            @AuthenticationPrincipal UserDetails usuarioAutenticado) {

        SubmissaoResponseDTO response =
                submissaoService.registrar(request, usuarioAutenticado.getUsername());
        return ResponseEntity
                .created(URI.create("/api/submissoes/" + response.submissaoId()))
                .body(response);
    }
}
