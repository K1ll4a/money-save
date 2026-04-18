package com.k1ll4a.moneysave.dto;

public record TokenPairResponse(
        String accessToken,
        String refreshToken,
        String tokenType,
        long expiresIn
) {
}