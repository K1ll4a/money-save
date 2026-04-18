<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySave | Категории</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #14211b;
            --muted: #64776f;
            --line: rgba(20, 33, 27, 0.12);
            --accent: #1f6b52;
            --danger: #a63d40;
            --success: #1b7f5c;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            padding: 24px;
            font-family: "IBM Plex Sans", sans-serif;
            color: var(--ink);
            background: linear-gradient(135deg, #f6fbf8 0%, #e8f1eb 55%, #dce7e0 100%);
        }
        .wrap {
            width: min(1180px, 100%);
            margin: 0 auto;
            display: grid;
            grid-template-columns: 0.95fr 1.05fr;
            gap: 20px;
        }
        .panel {
            padding: 28px;
            border-radius: 28px;
            background: rgba(250, 253, 251, 0.94);
            box-shadow: 0 24px 70px rgba(18, 43, 33, 0.12);
        }
        h1, h2 {
            margin: 0 0 12px;
            font: 700 clamp(30px, 4vw, 46px) / 0.98 "Space Grotesk", sans-serif;
        }
        h2 {
            font-size: 30px;
        }
        .lead {
            margin: 0 0 24px;
            color: var(--muted);
            line-height: 1.7;
        }
        .grid {
            display: grid;
            gap: 12px;
        }
        .category {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            padding: 16px;
            border-radius: 18px;
            background: white;
            border: 1px solid var(--line);
        }
        .meta {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .category-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            color: white;
            font-size: 22px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.18);
        }
        .category-icon::before { content: "•"; }
        .icon-fork::before { content: "🍽"; }
        .icon-car::before { content: "🚕"; }
        .icon-home::before { content: "⌂"; }
        .icon-repeat::before { content: "↻"; }
        .icon-spark::before { content: "★"; }
        .icon-health::before { content: "✚"; }
        .icon-shirt::before { content: "◈"; }
        .icon-book::before { content: "▣"; }
        .icon-dots::before { content: "…"; }
        .icon-wallet::before { content: "₽"; }
        .icon-pet::before { content: "♣"; }
        .icon-plane::before { content: "✈"; }
        .icon-gift::before { content: "◆"; }
        .icon-picker {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(118px, 1fr));
            gap: 10px;
        }
        .icon-choice {
            position: relative;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            border-radius: 18px;
            border: 1px solid var(--line);
            background: white;
            cursor: pointer;
            transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
        }
        .icon-choice:hover {
            transform: translateY(-1px);
            border-color: rgba(31, 107, 82, 0.34);
            box-shadow: 0 14px 32px rgba(18, 43, 33, 0.08);
        }
        .icon-choice input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }
        .icon-choice:has(input:checked) {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(31, 107, 82, 0.12);
        }
        .icon-choice .category-icon {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            font-size: 18px;
            background: var(--accent);
        }
        .icon-choice span:last-child {
            font-size: 14px;
            font-weight: 600;
        }
        .color-field {
            display: grid;
            grid-template-columns: 72px 1fr;
            gap: 12px;
            align-items: center;
        }
        input[type="color"] {
            height: 54px;
            padding: 6px;
            cursor: pointer;
        }
        .type {
            font-size: 12px;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        form {
            display: grid;
            gap: 16px;
        }
        label {
            display: grid;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
        }
        input {
            width: 100%;
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 16px 18px;
            font: 500 15px/1.2 "IBM Plex Sans", sans-serif;
            background: white;
        }
        .error-box, .success-box {
            padding: 14px 16px;
            border-radius: 16px;
            margin-bottom: 18px;
        }
        .error-box {
            background: rgba(166, 61, 64, 0.1);
            color: var(--danger);
        }
        .success-box {
            background: rgba(27, 127, 92, 0.12);
            color: var(--success);
        }
        .field-error {
            color: var(--danger);
            font-size: 13px;
        }
        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn, .btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 16px 22px;
            border-radius: 18px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }
        .btn {
            background: linear-gradient(135deg, var(--accent), #2b8a68);
            color: white;
        }
        .btn-secondary {
            background: transparent;
            color: var(--ink);
            border: 1px solid var(--line);
        }
        @media (max-width: 960px) {
            .wrap { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="wrap">
    <section class="panel">
        <h1>Категории расходов и доходов</h1>
        <p class="lead">Здесь собраны встроенные категории и ваши собственные. У каждой категории можно задать цвет и иконку, чтобы дашборд был визуально понятнее.</p>

        <div class="grid">
            <c:forEach items="${categoryOptions}" var="category">
                <div class="category">
                    <div class="meta">
                        <div class="category-icon icon-${category.icon}" style="background:${category.colorHex};"></div>
                        <div>
                            <strong>${category.name}</strong><br>
                            <span class="type">${category.builtIn ? 'Встроенная' : 'Пользовательская'} категория</span>
                        </div>
                    </div>
    
                </div>
            </c:forEach>
        </div>
    </section>

    <section class="panel">
        <h2>Добавить новую категорию</h2>
        <p class="lead">Создайте собственную категорию для учёта, если встроенных недостаточно. Цвет и иконка сразу будут видны в формах операций и на дашборде.</p>

        <c:if test="${not empty categoryErrorMessage}">
            <div class="error-box">${categoryErrorMessage}</div>
        </c:if>
        <c:if test="${not empty categorySuccessMessage}">
            <div class="success-box">${categorySuccessMessage}</div>
        </c:if>

        <form:form method="post" modelAttribute="categoryForm">
            <div>
                <label for="name">Название категории
                    <form:input path="name" id="name" placeholder="Например, Питомцы или Путешествия" />
                </label>
                <form:errors path="name" cssClass="field-error" />
            </div>

            <div>
                <label for="colorHex">Цвет категории
                    <span class="color-field">
                        <form:input path="colorHex" id="colorHex" type="color" />
                        <span>Выберите оттенок из палитры. Он будет использоваться на карточках, графиках и в списке операций.</span>
                    </span>
                </label>
                <form:errors path="colorHex" cssClass="field-error" />
            </div>

            <div>
                <span style="display:block; margin-bottom:10px; font-size:14px; font-weight:600;">Иконка категории</span>
                <div class="icon-picker">
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="wallet" />
                        <span class="category-icon icon-wallet"></span>
                        <span>Доходы</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="fork" />
                        <span class="category-icon icon-fork"></span>
                        <span>Еда</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="car" />
                        <span class="category-icon icon-car"></span>
                        <span>Транспорт</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="home" />
                        <span class="category-icon icon-home"></span>
                        <span>Дом</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="repeat" />
                        <span class="category-icon icon-repeat"></span>
                        <span>Подписки</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="spark" />
                        <span class="category-icon icon-spark"></span>
                        <span>Досуг</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="health" />
                        <span class="category-icon icon-health"></span>
                        <span>Здоровье</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="shirt" />
                        <span class="category-icon icon-shirt"></span>
                        <span>Одежда</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="book" />
                        <span class="category-icon icon-book"></span>
                        <span>Учёба</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="pet" />
                        <span class="category-icon icon-pet"></span>
                        <span>Питомцы</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="plane" />
                        <span class="category-icon icon-plane"></span>
                        <span>Поездки</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="gift" />
                        <span class="category-icon icon-gift"></span>
                        <span>Подарки</span>
                    </label>
                    <label class="icon-choice">
                        <form:radiobutton path="icon" value="dots" />
                        <span class="category-icon icon-dots"></span>
                        <span>Прочее</span>
                    </label>
                </div>
                <form:errors path="icon" cssClass="field-error" />
            </div>

            <div class="actions">
                <button class="btn" type="submit">Создать категорию</button>
                <a class="btn-secondary" href="${pageContext.request.contextPath}/dashboard">Назад в дашборд</a>
            </div>
        </form:form>
    </section>
</div>
</body>
</html>
