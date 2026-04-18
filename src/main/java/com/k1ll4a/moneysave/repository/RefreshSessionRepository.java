package com.k1ll4a.moneysave.repository;


import org.springframework.data.jpa.repository.JpaRepository;

import com.k1ll4a.moneysave.domain.RefreshSession;

import java.util.Optional;
import java.util.UUID;

public interface RefreshSessionRepository extends JpaRepository<RefreshSession, UUID> {
    Optional<RefreshSession> findByIdAndUserId(UUID id, UUID userId);
}