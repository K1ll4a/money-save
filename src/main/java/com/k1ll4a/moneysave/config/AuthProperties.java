package com.k1ll4a.moneysave.config;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.auth")
public record AuthProperties(
        @NotBlank String jwtSecret,
        @NotBlank String refreshPepper,
        @Min(60) long accessTokenTtlSeconds,
        @Min(60) long refreshTokenTtlSeconds
) {
}