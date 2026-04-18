package com.k1ll4a.moneysave.sevice;

import com.k1ll4a.moneysave.domain.UserAccount;
import com.k1ll4a.moneysave.dto.LoginForm;
import com.k1ll4a.moneysave.exception.AuthException;
import com.k1ll4a.moneysave.repository.UserAccountRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserLoginService {

    private final UserAccountRepository userAccountRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UserLoginService(UserAccountRepository userAccountRepository) {
        this.userAccountRepository = userAccountRepository;
    }

    public UserAccount authenticate(LoginForm form) {
        String normalizedLogin = form.getLogin().trim();

        UserAccount user = userAccountRepository.findByLogin(normalizedLogin)
                .orElseThrow(() -> new AuthException("Неверный логин или пароль"));

        if (!passwordEncoder.matches(form.getPassword(), user.getPasswordHash())) {
            throw new AuthException("Неверный логин или пароль");
        }

        return user;
    }
}
