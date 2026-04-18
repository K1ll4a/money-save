package com.k1ll4a.moneysave.dto;

import jakarta.validation.constraints.NotBlank;

public record RefreshTokenRequest(
        @NotBlank String accessToken,
        @NotBlank String refreshToken
) {
}