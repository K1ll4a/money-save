package com.k1ll4a.moneysave.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import com.k1ll4a.moneysave.config.AuthProperties;
import com.k1ll4a.moneysave.exception.AuthException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HexFormat;
import java.util.UUID;

@Component
public class RefreshTokenService {

    private final SecureRandom secureRandom = new SecureRandom();
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    private final AuthProperties properties;

    public RefreshTokenService(AuthProperties properties) {
        this.properties = properties;
    }

    public GeneratedRefreshToken generate(UUID refreshId) {
        byte[] secretBytes = new byte[32];
        secureRandom.nextBytes(secretBytes);

        String secret = Base64.getUrlEncoder().withoutPadding().encodeToString(secretBytes);
        String payload = refreshId + ":" + secret;
        String signature = hmacSha256Hex(payload);

        String rawToken = payload + ":" + signature;
        String encodedToken = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(rawToken.getBytes(StandardCharsets.UTF_8));

        return new GeneratedRefreshToken(encodedToken, encoder.encode(secret));
    }

    public ParsedRefreshToken parseAndVerify(String encoded) {
        try {
            byte[] decoded = Base64.getUrlDecoder().decode(encoded);
            String raw = new String(decoded, StandardCharsets.UTF_8);
            String[] parts = raw.split(":");
            if (parts.length != 3) {
                throw new AuthException("Invalid refresh token");
            }

            UUID refreshId = UUID.fromString(parts[0]);
            String secret = parts[1];
            String signature = parts[2];

            String payload = parts[0] + ":" + secret;
            String expected = hmacSha256Hex(payload);
            if (!expected.equals(signature)) {
                throw new AuthException("Refresh token was modified");
            }

            return new ParsedRefreshToken(refreshId, secret);
        } catch (IllegalArgumentException ex) {
            throw new AuthException("Invalid refresh token");
        }
    }

    public boolean matches(String plainSecret, String hash) {
        return encoder.matches(plainSecret, hash);
    }

    private String hmacSha256Hex(String value) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(properties.refreshPepper().getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            return HexFormat.of().formatHex(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception ex) {
            throw new IllegalStateException("Cannot sign refresh token", ex);
        }
    }

    public record GeneratedRefreshToken(String token, String tokenHash) {}
    public record ParsedRefreshToken(UUID refreshId, String secret) {}
}