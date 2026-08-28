package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Tecnologia;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TecnologiaRepository extends JpaRepository<Tecnologia, Long> {

    Optional<Tecnologia> findByNomeIgnoreCase(String nome);
}
