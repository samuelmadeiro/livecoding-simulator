package com.portfolio.livecoding.entity;

import com.portfolio.livecoding.enums.Role;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "usuarios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 120)
    private String nome;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false)
    private String senha;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Role role;

    /*
     * Progresso do candidato.
     *
     * Apelido e a identidade publica: o ranking aparece para visitante anonimo e nao pode expor
     * e-mail. Pontos e sequencia sao derivados das conquistas, mas ficam gravados aqui porque a
     * home le o ranking a cada visita, e recalcular a soma de todo mundo por leitura sairia caro
     * sem necessidade.
     */

    @Column(nullable = false, length = 40, unique = true)
    private String apelido;

    @Column(nullable = false)
    private Integer pontos = 0;

    @Column(name = "sequencia_atual", nullable = false)
    private Integer sequenciaAtual = 0;

    @Column(name = "sequencia_recorde", nullable = false)
    private Integer sequenciaRecorde = 0;

    /** Data, e nao timestamp: a sequencia conta dias praticados, nao horarios. */
    @Column(name = "ultimo_dia_praticado")
    private LocalDate ultimoDiaPraticado;
}
