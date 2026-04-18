<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySave | Личный финансовый кабинет</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #edf5f1;
            --ink: #13211b;
            --muted: #60746b;
            --card: rgba(250, 253, 251, 0.84);
            --line: rgba(19, 33, 27, 0.1);
            --accent: #1e6a51;
            --accent-strong: #174f3d;
            --accent-soft: rgba(30, 106, 81, 0.12);
            --danger: #a63d40;
            --shadow: 0 28px 90px rgba(16, 40, 30, 0.15);
        }

        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            font-family: "IBM Plex Sans", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at top left, rgba(30, 106, 81, 0.18), transparent 30%),
                radial-gradient(circle at bottom right, rgba(79, 122, 106, 0.14), transparent 24%),
                linear-gradient(135deg, #f5faf7 0%, #e8f1eb 52%, #dbe6df 100%);
            display: grid;
            place-items: center;
            padding: 24px;
        }
        .layout {
            width: min(1180px, 100%);
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            border-radius: 32px;
            overflow: hidden;
            box-shadow: var(--shadow);
            background: var(--card);
            border: 1px solid rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(14px);
        }
        .hero {
            padding: 56px;
            background:
                linear-gradient(160deg, rgba(16, 39, 31, 0.96), rgba(28, 92, 67, 0.88)),
                linear-gradient(120deg, #17372d, #24493c);
            color: #f2fbf6;
            position: relative;
        }
        .hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(transparent 0%, rgba(255,255,255,0.05) 100%),
                repeating-linear-gradient(135deg, rgba(255,255,255,0.03) 0, rgba(255,255,255,0.03) 14px, transparent 14px, transparent 28px);
            pointer-events: none;
        }
        .badge {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(242, 251, 246, 0.08);
            border: 1px solid rgba(242, 251, 246, 0.14);
            font-size: 13px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }
        .badge::before {
            content: "";
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #7de0a4;
            box-shadow: 0 0 16px rgba(125, 224, 164, 0.8);
        }
        h1 {
            position: relative;
            z-index: 1;
            margin: 26px 0 16px;
            max-width: 560px;
            font: 700 clamp(40px, 6vw, 72px) / 0.95 "Space Grotesk", sans-serif;
            letter-spacing: -0.05em;
        }
        .hero p {
            position: relative;
            z-index: 1;
            margin: 0;
            max-width: 540px;
            font-size: 18px;
            line-height: 1.7;
            color: rgba(242, 251, 246, 0.82);
        }
        .hero-grid {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-top: 42px;
        }
        .hero-card {
            padding: 18px;
            border-radius: 20px;
            background: rgba(242, 251, 246, 0.08);
            border: 1px solid rgba(242, 251, 246, 0.12);
        }
        .hero-card strong {
            display: block;
            margin-bottom: 8px;
            font: 700 26px/1 "Space Grotesk", sans-serif;
        }
        .panel {
            padding: 48px 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(180deg, rgba(249, 252, 250, 0.82), rgba(255, 255, 255, 0.95));
        }
        .card {
            width: min(390px, 100%);
        }
        .eyebrow {
            margin: 0 0 12px;
            color: var(--accent);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            font-size: 12px;
            font-weight: 700;
        }
        .card h2 {
            margin: 0 0 10px;
            font: 700 34px/1.05 "Space Grotesk", sans-serif;
        }
        .card p {
            color: var(--muted);
            line-height: 1.65;
            margin-bottom: 28px;
        }
        .error-box {
            padding: 14px 16px;
            border-radius: 16px;
            background: rgba(166, 61, 64, 0.1);
            color: var(--danger);
            margin-bottom: 16px;
        }
        form {
            display: grid;
            gap: 16px;
        }
        .field {
            display: grid;
            gap: 8px;
        }
        label {
            font-size: 14px;
            font-weight: 600;
        }
        input {
            width: 100%;
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 16px 18px;
            font: 500 15px/1.2 "IBM Plex Sans", sans-serif;
            color: var(--ink);
            background: rgba(255,255,255,0.96);
            outline: none;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }
        input:focus {
            border-color: rgba(30, 106, 81, 0.65);
            box-shadow: 0 0 0 5px rgba(30, 106, 81, 0.12);
            transform: translateY(-1px);
        }
        .field-error {
            color: var(--danger);
            font-size: 13px;
        }
        .action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 16px 20px;
            border-radius: 18px;
            border: none;
            cursor: pointer;
            background: linear-gradient(135deg, var(--accent), #2b8a68);
            color: white;
            font: 600 16px/1 "IBM Plex Sans", sans-serif;
            box-shadow: 0 18px 38px rgba(30, 106, 81, 0.24);
        }
        .meta {
            margin-top: 26px;
            padding-top: 20px;
            border-top: 1px solid var(--line);
            color: var(--muted);
            font-size: 14px;
            line-height: 1.7;
        }
        .meta a {
            color: var(--accent-strong);
            font-weight: 600;
            text-decoration: none;
        }
        @media (max-width: 960px) {
            .layout { grid-template-columns: 1fr; }
            .hero, .panel { padding: 32px 24px; }
            .hero-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main class="layout">
    <section class="hero">
        <span class="badge">MoneySave Finance</span>
        <h1>Финансовый трекер, который показывает не только траты, но и картину месяца.</h1>
        <p>После входа вы попадаете в дашборд с карточками доходов и расходов, операциями, категориями и базовой аналитикой по бюджету.</p>

        <div class="hero-grid">
            <div class="hero-card">
                <strong>Операции</strong>
                <span>Расходы, доходы, комментарии, теги и способ оплаты в одном месте.</span>
            </div>
            <div class="hero-card">
                <strong>Категории</strong>
                <span>Встроенные группы трат плюс собственные категории с цветом и иконкой.</span>
            </div>
            <div class="hero-card">
                <strong>Аналитика</strong>
                <span>Траты за месяц, динамика по дням, сравнение периодов и подсказки по бюджету.</span>
            </div>
            <div class="hero-card">
                <strong>Дашборд</strong>
                <span>Последние операции и важные показатели сразу после входа в аккаунт.</span>
            </div>
        </div>
    </section>

    <section class="panel">
        <div class="card">
            <p class="eyebrow">Вход</p>
            <h2>Открыть личный кабинет</h2>
            <p>Введите логин и пароль, чтобы перейти к дашборду. Если аккаунта ещё нет, вы сможете создать его за минуту.</p>

            <c:if test="${not empty loginErrorMessage}">
                <div class="error-box">${loginErrorMessage}</div>
            </c:if>

            <form:form method="post" modelAttribute="loginForm">
                <div class="field">
                    <label for="login">Логин</label>
                    <form:input path="login" id="login" placeholder="Например, TimDan" />
                    <form:errors path="login" cssClass="field-error" />
                </div>
                <div class="field">
                    <label for="password">Пароль</label>
                    <form:password path="password" id="password" placeholder="Введите пароль" />
                    <form:errors path="password" cssClass="field-error" />
                </div>
                <button class="action" type="submit">Войти в систему</button>
            </form:form>

            <div class="meta">
                Нет аккаунта?<br>
                <a href="${pageContext.request.contextPath}/register">Создать аккаунт и начать вести финансы</a>
            </div>
        </div>
    </section>
</main>
</body>
</html>
