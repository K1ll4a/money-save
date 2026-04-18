package com.k1ll4a.moneysave.dto;

import com.k1ll4a.moneysave.domain.OperationType;
import com.k1ll4a.moneysave.domain.PaymentMethod;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OperationForm {

    @NotNull(message = "Выберите тип операции")
    private OperationType type = OperationType.EXPENSE;

    @NotNull(message = "Выберите категорию")
    private UUID categoryId;

    @NotNull(message = "Укажите сумму")
    @DecimalMin(value = "0.01", message = "Сумма должна быть больше нуля")
    private BigDecimal amount;

    @NotNull(message = "Укажите дату")
    private LocalDate operationDate = LocalDate.now();

    @Size(max = 500, message = "Комментарий должен быть не длиннее 500 символов")
    private String comment;

    @NotNull(message = "Выберите способ оплаты")
    private PaymentMethod paymentMethod = PaymentMethod.CARD;

    private List<String> tags = new ArrayList<>();

    @Size(max = 160, message = "Свои теги должны быть не длиннее 160 символов")
    private String customTags;

    public OperationType getType() {
        return type;
    }

    public void setType(OperationType type) {
        this.type = type;
    }

    public UUID getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(UUID categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDate getOperationDate() {
        return operationDate;
    }

    public void setOperationDate(LocalDate operationDate) {
        this.operationDate = operationDate;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public String getCustomTags() {
        return customTags;
    }

    public void setCustomTags(String customTags) {
        this.customTags = customTags;
    }
}
