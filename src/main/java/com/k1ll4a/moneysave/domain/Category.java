package com.k1ll4a.moneysave.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "categories")
public class Category {

    @Id
    private UUID id;

    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "color_hex", nullable = false, length = 7)
    private String colorHex;

    @Column(name = "icon", nullable = false, length = 40)
    private String icon;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    protected Category() {
    }

    public Category(UUID id, UUID userId, String name, String colorHex, String icon, Instant createdAt) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.colorHex = colorHex;
        this.icon = icon;
        this.createdAt = createdAt;
    }

    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getColorHex() {
        return colorHex;
    }

    public String getIcon() {
        return icon;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public boolean isBuiltIn() {
        return userId == null;
    }
}
