package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.DesafioFiltroDTO;
import com.portfolio.livecoding.dto.DesafioResponseDTO;
import com.portfolio.livecoding.exception.RecursoNaoEncontradoException;
import com.portfolio.livecoding.repository.DesafioRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DesafioService {

    private final DesafioRepository desafioRepository;

    @Transactional(readOnly = true)
    public List<DesafioResponseDTO> listar(DesafioFiltroDTO filtro) {
        return desafioRepository
                .buscarComFiltros(filtro.nivel(), filtro.tecnologiaId(), filtro.tipo())
                .stream()
                .map(DesafioResponseDTO::fromEntity)
                .toList();
    }

    @Transactional(readOnly = true)
    public DesafioResponseDTO buscarPorId(Long id) {
        return desafioRepository.findById(id)
                .map(DesafioResponseDTO::fromEntity)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Desafio nao encontrado: id " + id));
    }
}
