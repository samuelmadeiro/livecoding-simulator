package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.dto.TentativaResponseDTO;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.service.DesafioService;
import com.portfolio.livecoding.service.TentativaService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.jetbrains.annotations.NotNull;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/desafios")
@RequiredArgsConstructor
public class DesafioController {

    private final DesafioService desafioService;
    private final TentativaService tentativaService;

    /** GET /api/desafios?nivel=JUNIOR&tecnologiaId=1&tipo=API_REST — todos os filtros opcionais. */
    @GetMapping
    public ResponseEntity<List<DesafioResponseDTO>> listar(
            @RequestParam(required = false) NivelVaga nivel,
            @RequestParam(required = false) Long tecnologiaId,
            @RequestParam(required = false) TipoDesafio tipo) {

        DesafioFiltroDTO filtro = new DesafioFiltroDTO(nivel, tecnologiaId, tipo);
        return ResponseEntity.ok(desafioService.listar(filtro));
    }

    @GetMapping("/{id}")
    public ResponseEntity<DesafioResponseDTO> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(desafioService.buscarPorId(id));
    }

    /**
     * POST /api/desafios/{id}/iniciar — abre o cronometro da questao. Exige JWT: o tempo pertence
     * a um candidato. Chamar de novo devolve a tentativa que ja estava aberta, entao recarregar a
     * pagina nao zera o relogio nem cria tentativa duplicada.
     *
     * <p>Fica sob /api/desafios, mas nao entra no permitAll do catalogo: la sao liberados apenas
     * os GET.
     */
    @PostMapping("/{id}/iniciar")
    public ResponseEntity<TentativaResponseDTO> iniciar(
            @PathVariable Long id,
            @AuthenticationPrincipal @NotNull UserDetails usuarioAutenticado) {

        return ResponseEntity.ok(tentativaService.iniciar(id, usuarioAutenticado.getUsername()));
    }
}
