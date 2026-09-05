package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.ProgressoDTO;
import com.portfolio.livecoding.dto.RankingItemDTO;
import com.portfolio.livecoding.service.RankingService;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Ranking publico e progresso individual.
 *
 * <p>O ranking e aberto de proposito: ele aparece na home para quem ainda nao tem conta, e por
 * isso devolve apelido em vez de nome ou e-mail. O progresso exige autenticacao e sai sempre do
 * principal do token, nunca de um id vindo do cliente.
 */
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ProgressoController {

    private final RankingService rankingService;

    @GetMapping("/ranking")
    public List<RankingItemDTO> ranking() {
        return rankingService.ranking();
    }

    @GetMapping("/progresso")
    public ResponseEntity<ProgressoDTO> progresso(Principal principal) {
        return ResponseEntity.ok(rankingService.progressoDe(principal.getName()));
    }
}
