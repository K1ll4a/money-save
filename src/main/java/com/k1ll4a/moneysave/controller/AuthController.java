package com.k1ll4a.moneysave.controller;

import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.k1ll4a.moneysave.dto.RefreshTokenRequest;
import com.k1ll4a.moneysave.dto.TokenPairResponse;
import com.k1ll4a.moneysave.sevice.AuthService;

import java.util.UUID;

@RestController
@RequestMapping("/auth")
@Validated
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/token")
    public TokenPairResponse issue(@RequestParam("guid") UUID userId) {
        return authService.issuePair(userId);
    }

    @PostMapping("/refresh")
    public TokenPairResponse refresh(@Valid @RequestBody RefreshTokenRequest request) {
        return authService.refresh(request.accessToken(), request.refreshToken());
    }
}