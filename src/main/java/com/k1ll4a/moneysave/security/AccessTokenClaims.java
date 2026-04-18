package com.k1ll4a.moneysave.security;

import java.util.UUID;

public record AccessTokenClaims(UUID userId, UUID sessionId, UUID accessJti) {
}