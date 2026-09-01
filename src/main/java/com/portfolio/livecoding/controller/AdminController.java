package com.portfolio.livecoding.controller;

import com.portfolio.livecoding.dto.admin.PainelAdminDTO;
import com.portfolio.livecoding.service.AdminMetricasService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Area do admin. O acesso e barrado por rota no SecurityConfig
 * ({@code /api/admin/** exige ROLE_ADMIN}), e nao por checagem dentro do metodo: regra de
 * autorizacao esquecida em um controller novo e como vaza painel administrativo.
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminMetricasService adminMetricasService;

    /** GET /api/admin/metricas — resumo, candidatos, desafios e as ultimas submissoes. */
    @GetMapping("/metricas")
    public ResponseEntity<PainelAdminDTO> metricas() {
        return ResponseEntity.ok(adminMetricasService.montarPainel());
    }
}
