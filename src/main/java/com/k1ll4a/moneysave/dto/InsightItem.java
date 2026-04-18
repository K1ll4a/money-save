package com.k1ll4a.moneysave.dto;

public record InsightItem(String title, String description) {
    public String getTitle() { return title; }
    public String getDescription() { return description; }
}
