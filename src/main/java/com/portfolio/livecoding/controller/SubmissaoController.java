package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.SubmissaoRequestDTO;
import com.portfolio.livecoding.dto.SubmissaoResponseDTO;
import com.portfolio.livecoding.service.SubmissaoService;
import jakarta.validation.Valid;
import java.net.URI;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/submissoes")
@RequiredArgsConstructor
public class SubmissaoController {

    private final SubmissaoService submissaoService;

    /**
     * POST /api/submissoes
     * Enquanto o projeto nao tem Spring Security, o usuario vem do header
     * X-Usuario-Id (default 1 = usuario demo criado pelo DataLoader).
     */
    @PostMapping
    public ResponseEntity<SubmissaoResponseDTO> criar(
            @RequestBody @Valid SubmissaoRequestDTO request,
            @RequestHeader(name = "X-Usuario-Id", defaultValue = "1") Long usuarioId) {

        SubmissaoResponseDTO response = submissaoService.registrar(request, usuarioId);
        return ResponseEntity
                .created(URI.create("/api/submissoes/" + response.submissaoId()))
                .body(response);
    }
}
