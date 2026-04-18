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
        .color {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            color: white;
            font-weight: 700;
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
                        <div class="color" style="background:${category.colorHex};">${category.icon}</div>
                        <div>
                            <strong>${category.name}</strong><br>
                            <span class="type">${category.builtIn ? 'Встроенная' : 'Пользовательская'} категория</span>
                        </div>
                    </div>
                    <span>${category.colorHex}</span>
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
                    <form:input path="colorHex" id="colorHex" placeholder="#1F6B52" />
                </label>
                <form:errors path="colorHex" cssClass="field-error" />
            </div>

            <div>
                <label for="icon">Иконка
                    <form:input path="icon" id="icon" placeholder="Например, pet, plane, gift" />
                </label>
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
