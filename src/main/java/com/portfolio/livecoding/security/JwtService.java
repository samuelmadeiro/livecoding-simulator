package com.portfolio.livecoding.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * Emissao e validacao dos tokens JWT.
 * O subject do token e o email do usuario; a role viaja como claim customizada.
 */
@Service
public class JwtService {

    private final SecretKey chave;
    private final long expiracaoMs;

    public JwtService(@Value("${app.jwt.secret}") String secret,
                      @Value("${app.jwt.expiracao-ms}") long expiracaoMs) {
        this.chave = Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));
        this.expiracaoMs = expiracaoMs;
    }

    public String gerarToken(String email, String role) {
        Date agora = new Date();
        return Jwts.builder()
                .subject(email)
                .claim("role", role)
                .issuedAt(agora)
                .expiration(new Date(agora.getTime() + expiracaoMs))
                .signWith(chave)
                .compact();
    }

    /** Retorna o email (subject) do token, ou null se ele for invalido ou estiver expirado. */
    public String extrairEmail(String token) {
        Claims claims = extrairClaims(token);
        return claims == null ? null : claims.getSubject();
    }

    public String extrairRole(String token) {
        Claims claims = extrairClaims(token);
        return claims == null ? null : claims.get("role", String.class);
    }

    public boolean tokenValido(String token) {
        return extrairClaims(token) != null;
    }

    public long getExpiracaoMs() {
        return expiracaoMs;
    }

    private Claims extrairClaims(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(chave)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (JwtException | IllegalArgumentException ex) {
            // Assinatura invalida, token expirado ou malformado: tratado como nao autenticado.
            return null;
        }
    }
}
