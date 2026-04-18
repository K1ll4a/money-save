package com.k1ll4a.moneysave.dto;

import java.math.BigDecimal;

public record CategoryBreakdownItem(
        String name,
        String colorHex,
        String icon,
        BigDecimal amount,
        int percent
) {
    public String getName() { return name; }
    public String getColorHex() { return colorHex; }
    public String getIcon() { return icon; }
    public BigDecimal getAmount() { return amount; }
    public int getPercent() { return percent; }
}
