package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.enums.NivelVaga;
import com.portfolio.livecoding.enums.TipoDesafio;
import com.portfolio.livecoding.service.DesafioService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/desafios")
@RequiredArgsConstructor
public class DesafioController {

    private final DesafioService desafioService;

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
}
