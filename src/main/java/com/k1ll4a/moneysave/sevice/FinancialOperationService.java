package com.k1ll4a.moneysave.sevice;

import com.k1ll4a.moneysave.domain.Category;
import com.k1ll4a.moneysave.domain.FinancialOperation;
import com.k1ll4a.moneysave.dto.OperationForm;
import com.k1ll4a.moneysave.repository.FinancialOperationRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class FinancialOperationService {

    private final FinancialOperationRepository financialOperationRepository;
    private final CategoryService categoryService;
    private final Clock clock = Clock.systemUTC();

    public FinancialOperationService(FinancialOperationRepository financialOperationRepository,
                                     CategoryService categoryService) {
        this.financialOperationRepository = financialOperationRepository;
        this.categoryService = categoryService;
    }

    @Transactional
    public FinancialOperation create(UUID userId, OperationForm form) {
        Category category = categoryService.getCategoryForUser(form.getCategoryId(), userId);

        FinancialOperation operation = new FinancialOperation(
                UUID.randomUUID(),
                userId,
                category,
                form.getType(),
                form.getAmount(),
                form.getOperationDate(),
                normalizeComment(form.getComment()),
                form.getPaymentMethod(),
                joinTags(mergeTags(form)),
                Instant.now(clock)
        );

        return financialOperationRepository.save(operation);
    }

    public List<FinancialOperation> getOperationsForMonth(UUID userId, LocalDate monthDate) {
        LocalDate start = monthDate.withDayOfMonth(1);
        LocalDate end = start.plusMonths(1).minusDays(1);
        return financialOperationRepository.findByUserIdAndOperationDateBetween(userId, start, end);
    }

    public List<FinancialOperation> getRecentOperations(UUID userId) {
        return financialOperationRepository.findTop10ByUserIdOrderByOperationDateDescCreatedAtDesc(userId);
    }

    private String normalizeComment(String comment) {
        if (comment == null || comment.isBlank()) {
            return null;
        }
        return comment.trim();
    }

    private List<String> mergeTags(OperationForm form) {
        List<String> mergedTags = new ArrayList<>();
        if (form.getTags() != null) {
            mergedTags.addAll(form.getTags());
        }
        if (form.getCustomTags() != null && !form.getCustomTags().isBlank()) {
            for (String customTag : form.getCustomTags().split(",")) {
                mergedTags.add(customTag);
            }
        }
        return mergedTags;
    }

    private String joinTags(List<String> tags) {
        if (tags == null || tags.isEmpty()) {
            return null;
        }
        return tags.stream()
                .filter(tag -> tag != null && !tag.isBlank())
                .map(String::trim)
                .distinct()
                .reduce((left, right) -> left + "," + right)
                .orElse(null);
    }
}
