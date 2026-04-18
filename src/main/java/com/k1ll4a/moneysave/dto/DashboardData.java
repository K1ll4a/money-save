package com.k1ll4a.moneysave.dto;

import java.math.BigDecimal;
import java.util.List;

public record DashboardData(
        BigDecimal monthExpenses,
        BigDecimal monthIncome,
        BigDecimal balance,
        boolean balanceNonNegative,
        BigDecimal budgetLimit,
        BigDecimal budgetLeft,
        int budgetUsedPercent,
        BigDecimal averageExpensePerDay,
        BigDecimal expenseChangePercent,
        boolean expenseChangePositive,
        String budgetForecastMessage,
        List<CategoryBreakdownItem> categoryBreakdown,
        List<DailyExpensePoint> dailyExpenses,
        List<RecentOperationItem> recentOperations,
        List<InsightItem> insights
) {
    public BigDecimal getMonthExpenses() { return monthExpenses; }
    public BigDecimal getMonthIncome() { return monthIncome; }
    public BigDecimal getBalance() { return balance; }
    public boolean isBalanceNonNegative() { return balanceNonNegative; }
    public BigDecimal getBudgetLimit() { return budgetLimit; }
    public BigDecimal getBudgetLeft() { return budgetLeft; }
    public int getBudgetUsedPercent() { return budgetUsedPercent; }
    public BigDecimal getAverageExpensePerDay() { return averageExpensePerDay; }
    public BigDecimal getExpenseChangePercent() { return expenseChangePercent; }
    public boolean isExpenseChangePositive() { return expenseChangePositive; }
    public String getBudgetForecastMessage() { return budgetForecastMessage; }
    public List<CategoryBreakdownItem> getCategoryBreakdown() { return categoryBreakdown; }
    public List<DailyExpensePoint> getDailyExpenses() { return dailyExpenses; }
    public List<RecentOperationItem> getRecentOperations() { return recentOperations; }
    public List<InsightItem> getInsights() { return insights; }
}
