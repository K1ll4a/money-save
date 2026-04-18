package com.k1ll4a.moneysave.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "financial_operations")
public class FinancialOperation {

    @Id
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 20)
    private OperationType type;

    @Column(name = "amount", nullable = false, precision = 14, scale = 2)
    private BigDecimal amount;

    @Column(name = "operation_date", nullable = false)
    private LocalDate operationDate;

    @Column(name = "comment_text", length = 500)
    private String comment;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false, length = 20)
    private PaymentMethod paymentMethod;

    @Column(name = "tags_csv", length = 250)
    private String tagsCsv;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    protected FinancialOperation() {
    }

    public FinancialOperation(UUID id, UUID userId, Category category, OperationType type, BigDecimal amount,
                              LocalDate operationDate, String comment, PaymentMethod paymentMethod,
                              String tagsCsv, Instant createdAt) {
        this.id = id;
        this.userId = userId;
        this.category = category;
        this.type = type;
        this.amount = amount;
        this.operationDate = operationDate;
        this.comment = comment;
        this.paymentMethod = paymentMethod;
        this.tagsCsv = tagsCsv;
        this.createdAt = createdAt;
    }

    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public Category getCategory() {
        return category;
    }

    public OperationType getType() {
        return type;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public LocalDate getOperationDate() {
        return operationDate;
    }

    public String getComment() {
        return comment;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public String getTagsCsv() {
        return tagsCsv;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
