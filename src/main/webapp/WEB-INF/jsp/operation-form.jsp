<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySave | Новая операция</title>
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
            width: min(980px, 100%);
            margin: 0 auto;
        }
        .card {
            padding: 32px;
            border-radius: 30px;
            background: rgba(250, 253, 251, 0.94);
            box-shadow: 0 24px 70px rgba(18, 43, 33, 0.12);
        }
        h1 {
            margin: 0 0 12px;
            font: 700 clamp(34px, 5vw, 52px) / 0.96 "Space Grotesk", sans-serif;
        }
        .lead {
            margin: 0 0 24px;
            color: var(--muted);
            line-height: 1.7;
        }
        .error-box {
            padding: 14px 16px;
            border-radius: 16px;
            background: rgba(166, 61, 64, 0.1);
            color: var(--danger);
            margin-bottom: 18px;
        }
        form {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }
        .full { grid-column: 1 / -1; }
        label {
            display: grid;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
        }
        input, select, textarea {
            width: 100%;
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 16px 18px;
            font: 500 15px/1.2 "IBM Plex Sans", sans-serif;
            background: white;
        }
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        .field-error {
            color: var(--danger);
            font-size: 13px;
        }
        .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .tag-option {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(31, 107, 82, 0.08);
            font-size: 14px;
            font-weight: 500;
        }
        .tag-option input {
            width: 16px;
            height: 16px;
            padding: 0;
        }
        .custom-tags {
            margin-top: 14px;
            display: grid;
            gap: 8px;
        }
        .hint {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.5;
        }
        .actions {
            grid-column: 1 / -1;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 8px;
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
        @media (max-width: 840px) {
            form { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="wrap">
    <section class="card">
        <h1>Новая финансовая операция</h1>
        <p class="lead">Добавьте доход или расход: выберите категорию, сумму, дату, способ оплаты, комментарий и теги. После сохранения операция сразу попадёт в дашборд.</p>

        <c:if test="${not empty operationErrorMessage}">
            <div class="error-box">${operationErrorMessage}</div>
        </c:if>

        <form:form method="post" modelAttribute="operationForm">
            <div>
                <label for="type">Тип операции
                    <form:select path="type" id="type">
                        <form:option value="EXPENSE" label="Расход" />
                        <form:option value="INCOME" label="Доход" />
                    </form:select>
                </label>
                <form:errors path="type" cssClass="field-error" />
            </div>

            <div>
                <label for="categoryId">Категория
                    <form:select path="categoryId" id="categoryId">
                        <form:option value="" label="Выберите категорию" />
                        <c:forEach items="${categoryOptions}" var="category">
                            <form:option value="${category.id}">${category.name}</form:option>
                        </c:forEach>
                    </form:select>
                </label>
                <form:errors path="categoryId" cssClass="field-error" />
            </div>

            <div>
                <label for="amount">Сумма
                    <form:input path="amount" id="amount" type="number" step="0.01" placeholder="Например, 1490.00" />
                </label>
                <form:errors path="amount" cssClass="field-error" />
            </div>

            <div>
                <label for="operationDate">Дата
                    <form:input path="operationDate" id="operationDate" type="date" />
                </label>
                <form:errors path="operationDate" cssClass="field-error" />
            </div>

            <div class="full">
                <label for="paymentMethod">Способ оплаты
                    <form:select path="paymentMethod" id="paymentMethod">
                        <form:option value="CASH" label="Наличные" />
                        <form:option value="CARD" label="Карта" />
                        <form:option value="TRANSFER" label="Перевод" />
                    </form:select>
                </label>
                <form:errors path="paymentMethod" cssClass="field-error" />
            </div>

            <div class="full">
                <label for="comment">Комментарий
                    <form:textarea path="comment" id="comment" placeholder="Например, ужин с друзьями, такси до аэропорта или ежемесячная подписка" />
                </label>
                <form:errors path="comment" cssClass="field-error" />
            </div>

            <div class="full">
                <span style="display:block; margin-bottom:10px; font-size:14px; font-weight:600;">Теги</span>
                <div class="tags">
                    <c:forEach items="${defaultTags}" var="tag">
                        <label class="tag-option">
                            <form:checkbox path="tags" value="${tag}" />
                            ${tag}
                        </label>
                    </c:forEach>
                </div>
                <label class="custom-tags" for="customTags">Свои теги
                    <form:input path="customTags" id="customTags" placeholder="Например: кофе, отпуск, подарок" />
                    <span class="hint">Можно добавить несколько тегов через запятую. Они сохранятся вместе с выбранными тегами выше.</span>
                </label>
                <form:errors path="customTags" cssClass="field-error" />
            </div>

            <div class="actions">
                <button class="btn" type="submit">Сохранить операцию</button>
                <a class="btn-secondary" href="${pageContext.request.contextPath}/dashboard">Назад в дашборд</a>
            </div>
        </form:form>
    </section>
</div>
</body>
</html>
