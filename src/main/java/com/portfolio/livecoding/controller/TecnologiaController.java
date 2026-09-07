package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.TecnologiaDTO;
import com.portfolio.livecoding.service.TecnologiaService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/tecnologias")
@RequiredArgsConstructor
public class TecnologiaController {

    private final TecnologiaService tecnologiaService;

    /** GET /api/tecnologias — o vocabulario do filtro do catalogo. Publico, como o catalogo. */
    @GetMapping
    public ResponseEntity<List<TecnologiaDTO>> listar() {
        return ResponseEntity.ok(tecnologiaService.listar());
    }
}
