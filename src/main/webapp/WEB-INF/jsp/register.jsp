<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySave | Регистрация</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #16231d;
            --muted: #64786f;
            --panel: rgba(250, 253, 251, 0.94);
            --line: rgba(22, 35, 29, 0.12);
            --accent: #1f6b52;
            --danger: #a63d40;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 24px;
            font-family: "IBM Plex Sans", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at top left, rgba(31, 107, 82, 0.2), transparent 32%),
                linear-gradient(135deg, #f6fbf8 0%, #e8f1eb 55%, #dce7e0 100%);
        }
        .shell {
            width: min(980px, 100%);
            display: grid;
            grid-template-columns: 0.95fr 1.05fr;
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 26px 70px rgba(18, 43, 33, 0.16);
            background: var(--panel);
        }
        .info {
            padding: 40px;
            background: linear-gradient(160deg, rgba(16, 39, 31, 0.95), rgba(30, 106, 81, 0.88));
            color: #f2fbf6;
        }
        .info h1 {
            margin: 18px 0 16px;
            font: 700 clamp(34px, 5vw, 54px) / 0.96 "Space Grotesk", sans-serif;
        }
        .info p {
            color: rgba(242, 251, 246, 0.8);
            line-height: 1.7;
        }
        .list {
            display: grid;
            gap: 14px;
            margin-top: 28px;
        }
        .list-item {
            padding: 16px;
            border-radius: 18px;
            background: rgba(242, 251, 246, 0.08);
            border: 1px solid rgba(242, 251, 246, 0.12);
        }
        .form-panel {
            padding: 40px;
        }
        .eyebrow {
            color: var(--accent);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-size: 12px;
            font-weight: 700;
        }
        .lead {
            color: var(--muted);
            line-height: 1.65;
            margin: 12px 0 28px;
        }
        form {
            display: grid;
            gap: 18px;
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
        .error-box {
            padding: 14px 16px;
            border-radius: 16px;
            background: rgba(166, 61, 64, 0.1);
            color: var(--danger);
            margin-bottom: 16px;
        }
        .field-error {
            color: var(--danger);
            font-size: 13px;
        }
        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 8px;
        }
        .btn {
            padding: 16px 22px;
            border-radius: 18px;
            border: none;
            cursor: pointer;
            font: 600 15px/1 "IBM Plex Sans", sans-serif;
            text-decoration: none;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--accent), #2b8a68);
            color: white;
            box-shadow: 0 18px 36px rgba(31, 107, 82, 0.22);
        }
        .btn-secondary {
            background: transparent;
            color: var(--ink);
            border: 1px solid var(--line);
        }
        @media (max-width: 920px) {
            .shell { grid-template-columns: 1fr; }
            .info, .form-panel { padding: 28px 24px; }
        }
    </style>
</head>
<body>
<section class="shell">
    <aside class="info">
        <div class="eyebrow">MoneySave</div>
        <h1>Создайте аккаунт для управления деньгами, а не просто списком трат.</h1>
        <p>После регистрации вы попадёте в дашборд, где сможете вести доходы и расходы, управлять категориями и смотреть ключевую аналитику по бюджету.</p>
        <div class="list">
            <div class="list-item">Добавляйте расходы и доходы с датой, категорией, тегами и способом оплаты.</div>
            <div class="list-item">Смотрите месячную сводку, баланс и средний расход в день.</div>
            <div class="list-item">Создавайте собственные категории с цветом и иконкой под свой стиль учёта.</div>
        </div>
    </aside>

    <div class="form-panel">
        <div class="eyebrow">Регистрация</div>
        <p class="lead">Введите логин и пароль. После этого аккаунт сохранится в базе, и вы сразу перейдёте в финансовый кабинет.</p>

        <c:if test="${not empty errorMessage}">
            <div class="error-box">${errorMessage}</div>
        </c:if>

        <form:form method="post" modelAttribute="registrationForm">
            <div>
                <label for="login">Логин
                    <form:input path="login" id="login" placeholder="Например, TimDan" />
                </label>
                <form:errors path="login" cssClass="field-error" />
            </div>
            <div>
                <label for="password">Пароль
                    <form:password path="password" id="password" placeholder="Минимум 6 символов" />
                </label>
                <form:errors path="password" cssClass="field-error" />
            </div>
            <div class="actions">
                <button class="btn btn-primary" type="submit">Создать аккаунт</button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/">Назад ко входу</a>
            </div>
        </form:form>
    </div>
</section>
</body>
</html>
