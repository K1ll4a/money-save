package com.k1ll4a.moneysave.dto;

import java.math.BigDecimal;

public record DailyExpensePoint(
        int dayOfMonth,
        BigDecimal amount,
        int percent
) {
    public int getDayOfMonth() { return dayOfMonth; }
    public BigDecimal getAmount() { return amount; }
    public int getPercent() { return percent; }
}
