package com.k1ll4a.moneysave.dto;

import com.k1ll4a.moneysave.domain.OperationType;
import com.k1ll4a.moneysave.domain.PaymentMethod;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record RecentOperationItem(
        LocalDate operationDate,
        String categoryName,
        String categoryColor,
        String categoryIcon,
        OperationType type,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        String comment,
        List<String> tags
) {
    public LocalDate getOperationDate() { return operationDate; }
    public String getCategoryName() { return categoryName; }
    public String getCategoryColor() { return categoryColor; }
    public String getCategoryIcon() { return categoryIcon; }
    public OperationType getType() { return type; }
    public BigDecimal getAmount() { return amount; }
    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public String getComment() { return comment; }
    public List<String> getTags() { return tags; }
}
