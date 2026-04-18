package com.k1ll4a.moneysave.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import com.k1ll4a.moneysave.config.AuthProperties;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import java.util.UUID;

@Component
public class JwtProvider {

    private final SecretKey key;
    private final AuthProperties properties;

    public JwtProvider(AuthProperties properties) {
        this.properties = properties;
        this.key = Keys.hmacShaKeyFor(properties.jwtSecret().getBytes(StandardCharsets.UTF_8));
    }

    public String generateAccessToken(UUID userId, UUID sessionId, UUID accessJti, Instant now) {
        Instant exp = now.plusSeconds(properties.accessTokenTtlSeconds());
        return Jwts.builder()
                .subject(userId.toString())
                .id(accessJti.toString())
                .claim("sid", sessionId.toString())
                .issuedAt(Date.from(now))
                .expiration(Date.from(exp))
                .signWith(key, Jwts.SIG.HS512)
                .compact();
    }

    public AccessTokenClaims parseAndValidate(String token) {
        Claims claims = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();

        return new AccessTokenClaims(
                UUID.fromString(claims.getSubject()),
                UUID.fromString(claims.get("sid", String.class)),
                UUID.fromString(claims.getId())
        );
    }

    public AccessTokenClaims parseIgnoringExpiration(String token) {
        try {
            return parseAndValidate(token);
        } catch (ExpiredJwtException ex) {
            Claims claims = ex.getClaims();
            return new AccessTokenClaims(
                    UUID.fromString(claims.getSubject()),
                    UUID.fromString(claims.get("sid", String.class)),
                    UUID.fromString(claims.getId())
            );
        } catch (JwtException | IllegalArgumentException ex) {
            throw new com.k1ll4a.moneysave.exception.AuthException("Invalid access token");
        }
    }
}