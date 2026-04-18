package com.k1ll4a.moneysave.sevice;

import com.k1ll4a.moneysave.domain.Category;
import com.k1ll4a.moneysave.dto.CategoryForm;
import com.k1ll4a.moneysave.exception.AuthException;
import com.k1ll4a.moneysave.repository.CategoryRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.Instant;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final Clock clock = Clock.systemUTC();

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<Category> getAvailableCategories(UUID userId) {
        return categoryRepository.findAvailableForUser(userId).stream()
                .sorted(Comparator
                        .comparing((Category category) -> !category.isBuiltIn())
                        .thenComparing(Category::getName))
                .toList();
    }

    public Category getCategoryForUser(UUID categoryId, UUID userId) {
        return categoryRepository.findById(categoryId)
                .filter(category -> category.isBuiltIn() || userId.equals(category.getUserId()))
                .orElseThrow(() -> new AuthException("Категория недоступна"));
    }

    @Transactional
    public Category createCustomCategory(UUID userId, CategoryForm form) {
        String name = form.getName().trim();
        if (categoryRepository.existsByUserIdAndName(userId, name)) {
            throw new AuthException("У вас уже есть категория с таким названием");
        }

        Category category = new Category(
                UUID.randomUUID(),
                userId,
                name,
                form.getColorHex(),
                form.getIcon().trim(),
                Instant.now(clock)
        );

        return categoryRepository.save(category);
    }
}
