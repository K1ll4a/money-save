package com.k1ll4a.moneysave.sevice;

import com.k1ll4a.moneysave.domain.UserAccount;
import com.k1ll4a.moneysave.dto.RegistrationForm;
import com.k1ll4a.moneysave.exception.AuthException;
import com.k1ll4a.moneysave.repository.UserAccountRepository;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.Instant;
import java.util.UUID;

@Service
public class UserRegistrationService {

    private final UserAccountRepository userAccountRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    private final Clock clock = Clock.systemUTC();

    public UserRegistrationService(UserAccountRepository userAccountRepository) {
        this.userAccountRepository = userAccountRepository;
    }

    @Transactional
    public UserAccount register(RegistrationForm form) {
        String normalizedLogin = form.getLogin().trim();
        if (userAccountRepository.existsByLogin(normalizedLogin)) {
            throw new AuthException("Пользователь с таким логином уже существует");
        }

        UserAccount user = new UserAccount(
                UUID.randomUUID(),
                normalizedLogin,
                passwordEncoder.encode(form.getPassword()),
                Instant.now(clock)
        );

        return userAccountRepository.save(user);
    }
}
