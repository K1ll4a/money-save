package com.k1ll4a.moneysave.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class CategoryForm {

    @NotBlank(message = "Введите название категории")
    @Size(max = 100, message = "Название категории должно быть не длиннее 100 символов")
    private String name;

    @NotBlank(message = "Укажите цвет")
    @Pattern(regexp = "^#[0-9A-Fa-f]{6}$", message = "Цвет должен быть в формате #RRGGBB")
    private String colorHex = "#1F6B52";

    @NotBlank(message = "Укажите иконку")
    @Size(max = 40, message = "Иконка должна быть не длиннее 40 символов")
    private String icon = "wallet";

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColorHex() {
        return colorHex;
    }

    public void setColorHex(String colorHex) {
        this.colorHex = colorHex;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }
}
