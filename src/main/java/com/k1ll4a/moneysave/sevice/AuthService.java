package com.k1ll4a.moneysave.sevice;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import com.k1ll4a.moneysave.config.AuthProperties;
import com.k1ll4a.moneysave.domain.RefreshSession;
import com.k1ll4a.moneysave.dto.TokenPairResponse;
import com.k1ll4a.moneysave.exception.AuthException;
import com.k1ll4a.moneysave.repository.RefreshSessionRepository;
import com.k1ll4a.moneysave.security.AccessTokenClaims;
import com.k1ll4a.moneysave.security.JwtProvider;
import com.k1ll4a.moneysave.security.RefreshTokenService;

import java.time.Clock;
import java.time.Instant;
import java.util.UUID;

@Service
public class AuthService {

    private final RefreshSessionRepository refreshSessionRepository;
    private final JwtProvider jwtProvider;
    private final RefreshTokenService refreshTokenService;
    private final AuthProperties properties;
    private final Clock clock;

    public AuthService(RefreshSessionRepository refreshSessionRepository,
                       JwtProvider jwtProvider,
                       RefreshTokenService refreshTokenService,
                       AuthProperties properties) {
        this.refreshSessionRepository = refreshSessionRepository;
        this.jwtProvider = jwtProvider;
        this.refreshTokenService = refreshTokenService;
        this.properties = properties;
        this.clock = Clock.systemUTC();
    }

    @Transactional
    public TokenPairResponse issuePair(UUID userId) {
        Instant now = Instant.now(clock);
        UUID sessionId = UUID.randomUUID();
        UUID accessJti = UUID.randomUUID();
        UUID refreshId = UUID.randomUUID();

        String accessToken = jwtProvider.generateAccessToken(userId, sessionId, accessJti, now);
        RefreshTokenService.GeneratedRefreshToken generated = refreshTokenService.generate(refreshId);

        RefreshSession session = new RefreshSession(
                refreshId,
                userId,
                sessionId,
                accessJti,
                generated.tokenHash(),
                now.plusSeconds(properties.refreshTokenTtlSeconds()),
                now
        );

        refreshSessionRepository.save(session);

        return new TokenPairResponse(
                accessToken,
                generated.token(),
                "Bearer",
                properties.accessTokenTtlSeconds()
        );
    }

    @Transactional
    public TokenPairResponse refresh(String accessToken, String refreshToken) {
        Instant now = Instant.now(clock);

        AccessTokenClaims claims = jwtProvider.parseIgnoringExpiration(accessToken);
        RefreshTokenService.ParsedRefreshToken parsedRefresh = refreshTokenService.parseAndVerify(refreshToken);

        RefreshSession stored = refreshSessionRepository.findByIdAndUserId(parsedRefresh.refreshId(), claims.userId())
                .orElseThrow(() -> new AuthException("Refresh session not found"));

        if (stored.isUsedOrRevoked()) {
            throw new AuthException("Refresh token has already been used");
        }
        if (stored.isExpired(now)) {
            throw new AuthException("Refresh token is expired");
        }
        if (!stored.getSessionId().equals(claims.sessionId())) {
            throw new AuthException("Refresh token is not linked to this access token");
        }
        if (!stored.getAccessJti().equals(claims.accessJti())) {
            throw new AuthException("Refresh token is not linked to this access token");
        }
        if (!refreshTokenService.matches(parsedRefresh.secret(), stored.getTokenHash())) {
            throw new AuthException("Refresh token is invalid");
        }

        stored.markUsed(now);
        refreshSessionRepository.save(stored);

        return issuePair(claims.userId());
    }
}