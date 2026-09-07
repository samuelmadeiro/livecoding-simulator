package com.portfolio.livecoding.dto;

import com.portfolio.livecoding.entity.Tecnologia;

/** Uma tecnologia do catalogo, como o filtro do front precisa dela. */
public record TecnologiaDTO(Long id, String nome) {

    public static TecnologiaDTO fromEntity(Tecnologia tecnologia) {
        return new TecnologiaDTO(tecnologia.getId(), tecnologia.getNome());
    }
}
