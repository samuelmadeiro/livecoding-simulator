package com.portfolio.livecoding.service;

import com.portfolio.livecoding.dto.TecnologiaDTO;
import com.portfolio.livecoding.repository.TecnologiaRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TecnologiaService {

    private final TecnologiaRepository tecnologiaRepository;

    /**
     * O vocabulario inteiro de tecnologias, em ordem alfabetica. O filtro do catalogo precisa da
     * lista completa: montar as opcoes a partir dos desafios que voltaram encolheria o filtro a
     * cada busca — e, com paginacao, mostraria so o que calhou de cair na primeira pagina.
     */
    @Transactional(readOnly = true)
    public List<TecnologiaDTO> listar() {
        return tecnologiaRepository.findAll(Sort.by("nome"))
                .stream()
                .map(TecnologiaDTO::fromEntity)
                .toList();
    }
}
