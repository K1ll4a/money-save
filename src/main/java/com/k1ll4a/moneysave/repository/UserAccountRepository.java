package com.k1ll4a.moneysave.repository;

import com.k1ll4a.moneysave.domain.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserAccountRepository extends JpaRepository<UserAccount, UUID> {
    boolean existsByLogin(String login);
    Optional<UserAccount> findByLogin(String login);
}
