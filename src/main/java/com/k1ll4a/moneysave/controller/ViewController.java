package com.k1ll4a.moneysave.controller;

import com.k1ll4a.moneysave.domain.Category;
import com.k1ll4a.moneysave.domain.OperationType;
import com.k1ll4a.moneysave.domain.PaymentMethod;
import com.k1ll4a.moneysave.domain.UserAccount;
import com.k1ll4a.moneysave.dto.CategoryForm;
import com.k1ll4a.moneysave.dto.DashboardData;
import com.k1ll4a.moneysave.dto.LoginForm;
import com.k1ll4a.moneysave.dto.OperationForm;
import com.k1ll4a.moneysave.dto.RegistrationForm;
import com.k1ll4a.moneysave.exception.AuthException;
import com.k1ll4a.moneysave.sevice.CategoryService;
import com.k1ll4a.moneysave.sevice.DashboardService;
import com.k1ll4a.moneysave.sevice.FinancialOperationService;
import com.k1ll4a.moneysave.sevice.UserLoginService;
import com.k1ll4a.moneysave.sevice.UserRegistrationService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.UUID;

@Controller
public class ViewController {

    private static final String SESSION_USER_ID = "currentUserId";
    private static final String SESSION_USER_LOGIN = "currentUserLogin";
    private static final List<String> DEFAULT_TAGS = List.of(
            "еда", "такси", "подписка", "срочно", "развлечения", "здоровье", "дом", "обучение"
    );

    private final UserRegistrationService userRegistrationService;
    private final UserLoginService userLoginService;
    private final CategoryService categoryService;
    private final FinancialOperationService financialOperationService;
    private final DashboardService dashboardService;

    public ViewController(UserRegistrationService userRegistrationService,
                          UserLoginService userLoginService,
                          CategoryService categoryService,
                          FinancialOperationService financialOperationService,
                          DashboardService dashboardService) {
        this.userRegistrationService = userRegistrationService;
        this.userLoginService = userLoginService;
        this.categoryService = categoryService;
        this.financialOperationService = financialOperationService;
        this.dashboardService = dashboardService;
    }

    @GetMapping("/")
    public String index(Model model, HttpSession session) {
        if (isLoggedIn(session)) {
            return "redirect:/dashboard";
        }
        if (!model.containsAttribute("loginForm")) {
            model.addAttribute("loginForm", new LoginForm());
        }
        return "index";
    }

    @PostMapping("/")
    public String login(@Valid @ModelAttribute("loginForm") LoginForm loginForm,
                        BindingResult bindingResult,
                        Model model,
                        HttpSession session) {
        if (bindingResult.hasErrors()) {
            return "index";
        }

        UserAccount user;
        try {
            user = userLoginService.authenticate(loginForm);
        } catch (AuthException ex) {
            model.addAttribute("loginErrorMessage", ex.getMessage());
            return "index";
        }

        session.setAttribute(SESSION_USER_ID, user.getId().toString());
        session.setAttribute(SESSION_USER_LOGIN, user.getLogin());
        return "redirect:/dashboard";
    }

    @GetMapping("/register")
    public String registerPage(Model model, HttpSession session) {
        if (isLoggedIn(session)) {
            return "redirect:/dashboard";
        }
        if (!model.containsAttribute("registrationForm")) {
            model.addAttribute("registrationForm", new RegistrationForm());
        }
        return "register";
    }

    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("registrationForm") RegistrationForm registrationForm,
                           BindingResult bindingResult,
                           Model model,
                           HttpSession session) {
        if (bindingResult.hasErrors()) {
            return "register";
        }

        UserAccount user;
        try {
            user = userRegistrationService.register(registrationForm);
        } catch (AuthException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            return "register";
        }

        session.setAttribute(SESSION_USER_ID, user.getId().toString());
        session.setAttribute(SESSION_USER_LOGIN, user.getLogin());
        return "redirect:/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        UUID userId = requireUserId(session);
        addCommonUserAttributes(model, session, userId);
        DashboardData dashboardData = dashboardService.buildDashboard(userId);
        model.addAttribute("dashboard", dashboardData);
        return "dashboard";
    }

    @GetMapping("/operations/new")
    public String newOperationPage(Model model, HttpSession session) {
        UUID userId = requireUserId(session);
        addCommonUserAttributes(model, session, userId);
        if (!model.containsAttribute("operationForm")) {
            model.addAttribute("operationForm", new OperationForm());
        }
        return "operation-form";
    }

    @PostMapping("/operations/new")
    public String createOperation(@Valid @ModelAttribute("operationForm") OperationForm operationForm,
                                  BindingResult bindingResult,
                                  Model model,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        UUID userId = requireUserId(session);
        if (bindingResult.hasErrors()) {
            addCommonUserAttributes(model, session, userId);
            return "operation-form";
        }

        try {
            financialOperationService.create(userId, operationForm);
        } catch (AuthException ex) {
            addCommonUserAttributes(model, session, userId);
            model.addAttribute("operationErrorMessage", ex.getMessage());
            return "operation-form";
        }

        redirectAttributes.addFlashAttribute("dashboardSuccessMessage", "Операция успешно добавлена.");
        return "redirect:/dashboard";
    }

    @GetMapping("/categories")
    public String categoriesPage(Model model, HttpSession session) {
        UUID userId = requireUserId(session);
        addCommonUserAttributes(model, session, userId);
        if (!model.containsAttribute("categoryForm")) {
            model.addAttribute("categoryForm", new CategoryForm());
        }
        return "categories";
    }

    @PostMapping("/categories")
    public String createCategory(@Valid @ModelAttribute("categoryForm") CategoryForm categoryForm,
                                 BindingResult bindingResult,
                                 Model model,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        UUID userId = requireUserId(session);
        if (bindingResult.hasErrors()) {
            addCommonUserAttributes(model, session, userId);
            return "categories";
        }

        try {
            categoryService.createCustomCategory(userId, categoryForm);
        } catch (AuthException ex) {
            addCommonUserAttributes(model, session, userId);
            model.addAttribute("categoryErrorMessage", ex.getMessage());
            return "categories";
        }

        redirectAttributes.addFlashAttribute("categorySuccessMessage", "Новая категория добавлена.");
        return "redirect:/categories";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @ExceptionHandler(AuthException.class)
    public String handlePageAuthException(AuthException ex, HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("loginErrorMessage", ex.getMessage());
        return "redirect:/";
    }

    private void addCommonUserAttributes(Model model, HttpSession session, UUID userId) {
        model.addAttribute("currentUserLogin", session.getAttribute(SESSION_USER_LOGIN));
        model.addAttribute("categoryOptions", categoryService.getAvailableCategories(userId));
        model.addAttribute("paymentMethods", PaymentMethod.values());
        model.addAttribute("operationTypes", OperationType.values());
        model.addAttribute("defaultTags", DEFAULT_TAGS);
    }

    private UUID requireUserId(HttpSession session) {
        Object rawUserId = session.getAttribute(SESSION_USER_ID);
        if (rawUserId == null) {
            throw new AuthException("Сессия истекла. Войдите снова.");
        }
        return UUID.fromString(rawUserId.toString());
    }

    private boolean isLoggedIn(HttpSession session) {
        return session.getAttribute(SESSION_USER_ID) != null;
    }
}
