package com.k1ll4a.moneysave.sevice;

import com.k1ll4a.moneysave.domain.FinancialOperation;
import com.k1ll4a.moneysave.domain.OperationType;
import com.k1ll4a.moneysave.dto.CategoryBreakdownItem;
import com.k1ll4a.moneysave.dto.DailyExpensePoint;
import com.k1ll4a.moneysave.dto.DashboardData;
import com.k1ll4a.moneysave.dto.InsightItem;
import com.k1ll4a.moneysave.dto.RecentOperationItem;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class DashboardService {

    private static final BigDecimal DEFAULT_BUDGET_LIMIT = new BigDecimal("30000.00");

    private final FinancialOperationService financialOperationService;

    public DashboardService(FinancialOperationService financialOperationService) {
        this.financialOperationService = financialOperationService;
    }

    public DashboardData buildDashboard(UUID userId) {
        LocalDate now = LocalDate.now();
        List<FinancialOperation> currentMonthOperations = financialOperationService.getOperationsForMonth(userId, now);
        List<FinancialOperation> previousMonthOperations = financialOperationService.getOperationsForMonth(userId, now.minusMonths(1));
        List<FinancialOperation> recentOperations = financialOperationService.getRecentOperations(userId);

        BigDecimal monthExpenses = sumByType(currentMonthOperations, OperationType.EXPENSE);
        BigDecimal monthIncome = sumByType(currentMonthOperations, OperationType.INCOME);
        BigDecimal previousMonthExpenses = sumByType(previousMonthOperations, OperationType.EXPENSE);
        BigDecimal balance = monthIncome.subtract(monthExpenses);
        BigDecimal budgetLeft = DEFAULT_BUDGET_LIMIT.subtract(monthExpenses);
        BigDecimal averageExpensePerDay = averagePerDay(monthExpenses, now.getDayOfMonth());
        BigDecimal expenseChangePercent = percentChange(monthExpenses, previousMonthExpenses);

        return new DashboardData(
                monthExpenses,
                monthIncome,
                balance,
                balance.compareTo(BigDecimal.ZERO) >= 0,
                DEFAULT_BUDGET_LIMIT,
                budgetLeft,
                percentage(monthExpenses, DEFAULT_BUDGET_LIMIT),
                averageExpensePerDay,
                expenseChangePercent,
                expenseChangePercent.compareTo(BigDecimal.ZERO) > 0,
                buildBudgetForecast(monthExpenses, now),
                buildCategoryBreakdown(currentMonthOperations, monthExpenses),
                buildDailyExpenses(currentMonthOperations, now),
                buildRecentOperations(recentOperations),
                buildInsights(currentMonthOperations, previousMonthOperations, monthExpenses, averageExpensePerDay, now)
        );
    }

    private BigDecimal sumByType(List<FinancialOperation> operations, OperationType type) {
        return operations.stream()
                .filter(operation -> operation.getType() == type)
                .map(FinancialOperation::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal averagePerDay(BigDecimal amount, int dayOfMonth) {
        if (dayOfMonth <= 0) {
            return BigDecimal.ZERO;
        }
        return amount.divide(BigDecimal.valueOf(dayOfMonth), 2, RoundingMode.HALF_UP);
    }

    private BigDecimal percentChange(BigDecimal current, BigDecimal previous) {
        if (previous.compareTo(BigDecimal.ZERO) == 0) {
            return current.compareTo(BigDecimal.ZERO) == 0 ? BigDecimal.ZERO : new BigDecimal("100.00");
        }
        return current.subtract(previous)
                .multiply(BigDecimal.valueOf(100))
                .divide(previous, 2, RoundingMode.HALF_UP);
    }

    private String buildBudgetForecast(BigDecimal monthExpenses, LocalDate now) {
        BigDecimal averagePerDay = averagePerDay(monthExpenses, now.getDayOfMonth());
        if (averagePerDay.compareTo(BigDecimal.ZERO) == 0) {
            return "Пока недостаточно данных для прогноза бюджета.";
        }

        BigDecimal daysLeft = DEFAULT_BUDGET_LIMIT.subtract(monthExpenses)
                .divide(averagePerDay, 0, RoundingMode.DOWN);

        if (daysLeft.compareTo(BigDecimal.ZERO) <= 0) {
            return "Бюджет уже исчерпан. Стоит пересмотреть траты в этом месяце.";
        }

        return "Если темп сохранится, бюджета хватит примерно ещё на " + daysLeft.intValue() + " дн.";
    }

    private List<CategoryBreakdownItem> buildCategoryBreakdown(List<FinancialOperation> operations, BigDecimal totalExpenses) {
        Map<String, CategoryAccumulator> grouped = new LinkedHashMap<>();

        for (FinancialOperation operation : operations) {
            if (operation.getType() != OperationType.EXPENSE) {
                continue;
            }
            String key = operation.getCategory().getId().toString();
            grouped.computeIfAbsent(key, ignored -> new CategoryAccumulator(
                    operation.getCategory().getName(),
                    operation.getCategory().getColorHex(),
                    operation.getCategory().getIcon(),
                    BigDecimal.ZERO
            )).amount = grouped.get(key).amount.add(operation.getAmount());
        }

        return grouped.values().stream()
                .sorted(Comparator.comparing((CategoryAccumulator item) -> item.amount).reversed())
                .limit(6)
                .map(item -> new CategoryBreakdownItem(
                        item.name,
                        item.colorHex,
                        item.icon,
                        item.amount,
                        percentage(item.amount, totalExpenses)
                ))
                .toList();
    }

    private List<DailyExpensePoint> buildDailyExpenses(List<FinancialOperation> operations, LocalDate now) {
        Map<Integer, BigDecimal> dailyTotals = new LinkedHashMap<>();
        YearMonth yearMonth = YearMonth.from(now);
        for (int day = 1; day <= yearMonth.lengthOfMonth(); day++) {
            dailyTotals.put(day, BigDecimal.ZERO);
        }

        for (FinancialOperation operation : operations) {
            if (operation.getType() == OperationType.EXPENSE) {
                int day = operation.getOperationDate().getDayOfMonth();
                dailyTotals.put(day, dailyTotals.get(day).add(operation.getAmount()));
            }
        }

        BigDecimal max = dailyTotals.values().stream().max(BigDecimal::compareTo).orElse(BigDecimal.ZERO);
        return dailyTotals.entrySet().stream()
                .map(entry -> new DailyExpensePoint(entry.getKey(), entry.getValue(), percentage(entry.getValue(), max)))
                .toList();
    }

    private List<RecentOperationItem> buildRecentOperations(List<FinancialOperation> operations) {
        return operations.stream()
                .map(operation -> new RecentOperationItem(
                        operation.getOperationDate(),
                        operation.getCategory().getName(),
                        operation.getCategory().getColorHex(),
                        operation.getCategory().getIcon(),
                        operation.getType(),
                        operation.getAmount(),
                        operation.getPaymentMethod(),
                        operation.getComment(),
                        splitTags(operation.getTagsCsv())
                ))
                .toList();
    }

    private List<InsightItem> buildInsights(List<FinancialOperation> current, List<FinancialOperation> previous,
                                            BigDecimal monthExpenses, BigDecimal averagePerDay, LocalDate now) {
        List<InsightItem> items = new ArrayList<>();

        BigDecimal previousExpenses = sumByType(previous, OperationType.EXPENSE);
        BigDecimal change = percentChange(monthExpenses, previousExpenses);
        items.add(new InsightItem(
                "Сравнение с прошлым месяцем",
                "Расходы изменились на " + change.stripTrailingZeros().toPlainString() + "% относительно прошлого месяца."
        ));

        current.stream()
                .filter(operation -> operation.getType() == OperationType.EXPENSE)
                .max(Comparator.comparing(FinancialOperation::getAmount))
                .ifPresent(operation -> items.add(new InsightItem(
                        "Самая большая трата",
                        operation.getCategory().getName() + ": " + operation.getAmount().stripTrailingZeros().toPlainString()
                                + " на дату " + operation.getOperationDate()
                )));

        long after20Count = current.stream()
                .filter(operation -> operation.getType() == OperationType.EXPENSE)
                .filter(operation -> operation.getOperationDate().getDayOfMonth() >= 20)
                .count();
        if (after20Count > 0) {
            items.add(new InsightItem(
                    "Поведенческий паттерн",
                    "Часть заметных расходов приходится на вторую половину месяца. Это хороший кандидат для контроля бюджета."
            ));
        }

        items.add(new InsightItem(
                "Средний расход в день",
                "Сейчас вы тратите в среднем " + averagePerDay.stripTrailingZeros().toPlainString()
                        + " в день за " + now.getMonth().name().toLowerCase() + "."
        ));

        return items;
    }

    private int percentage(BigDecimal amount, BigDecimal total) {
        if (total == null || total.compareTo(BigDecimal.ZERO) == 0) {
            return 0;
        }
        return amount.multiply(BigDecimal.valueOf(100))
                .divide(total, 0, RoundingMode.HALF_UP)
                .intValue();
    }

    private List<String> splitTags(String tagsCsv) {
        if (tagsCsv == null || tagsCsv.isBlank()) {
            return List.of();
        }
        return List.of(tagsCsv.split(","));
    }

    private static final class CategoryAccumulator {
        private final String name;
        private final String colorHex;
        private final String icon;
        private BigDecimal amount;

        private CategoryAccumulator(String name, String colorHex, String icon, BigDecimal amount) {
            this.name = name;
            this.colorHex = colorHex;
            this.icon = icon;
            this.amount = amount;
        }
    }
}
