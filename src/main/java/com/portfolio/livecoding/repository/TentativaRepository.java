package com.portfolio.livecoding.repository;

import com.portfolio.livecoding.entity.Tentativa;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TentativaRepository extends JpaRepository<Tentativa, Long> {

    /** A tentativa em aberto mais recente do candidato naquele desafio. */
    Optional<Tentativa> findFirstByUsuarioIdAndDesafioIdAndFinalizadoEmIsNullOrderByIniciadoEmDesc(
            Long usuarioId, Long desafioId);

    /** Busca por id restrita ao dono: ninguem fecha o cronometro de outro candidato. */
    Optional<Tentativa> findByIdAndUsuarioId(Long id, Long usuarioId);
}
