<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySave | Дашборд</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #eef5f1;
            --panel: rgba(250, 253, 251, 0.9);
            --card: #ffffff;
            --ink: #14211b;
            --muted: #64776f;
            --line: rgba(20, 33, 27, 0.08);
            --accent: #1f6b52;
            --accent-soft: rgba(31, 107, 82, 0.1);
            --danger: #b14a4d;
            --success: #1b7f5c;
            --shadow: 0 24px 70px rgba(18, 43, 33, 0.12);
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "IBM Plex Sans", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at top right, rgba(31, 107, 82, 0.14), transparent 30%),
                linear-gradient(135deg, #f6fbf8 0%, #e8f1eb 52%, #dce7e0 100%);
        }
        .wrap {
            width: min(1260px, calc(100% - 32px));
            margin: 24px auto 48px;
        }
        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 20px 24px;
            border-radius: 26px;
            background: rgba(17, 45, 34, 0.94);
            color: #f3fbf7;
            box-shadow: var(--shadow);
        }
        .brand {
            display: grid;
            gap: 4px;
        }
        .brand strong {
            font: 700 30px/1 "Space Grotesk", sans-serif;
        }
        .brand span {
            color: rgba(243, 251, 247, 0.74);
        }
        .actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .logout-form {
            display: flex;
            margin: 0;
        }
        .btn, .btn-ghost {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 48px;
            padding: 14px 18px;
            border-radius: 16px;
            text-decoration: none;
            font: 600 16px/1.2 "IBM Plex Sans", sans-serif;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }
        .btn {
            background: linear-gradient(135deg, var(--accent), #2b8a68);
            color: white;
        }
        .btn-ghost {
            background: rgba(243, 251, 247, 0.08);
            color: #f3fbf7;
            border: 1px solid rgba(243, 251, 247, 0.12);
        }
        .success {
            margin-top: 18px;
            padding: 14px 16px;
            border-radius: 16px;
            background: rgba(27, 127, 92, 0.12);
            color: var(--success);
        }
        .hero {
            margin-top: 22px;
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 20px;
        }
        .hero-panel, .budget-panel {
            padding: 28px;
            border-radius: 28px;
            background: var(--panel);
            box-shadow: var(--shadow);
        }
        .hero-panel h1 {
            margin: 0 0 12px;
            font: 700 clamp(34px, 4vw, 54px) / 0.98 "Space Grotesk", sans-serif;
        }
        .hero-panel p, .budget-panel p {
            margin: 0;
            color: var(--muted);
            line-height: 1.7;
        }
        .budget-value {
            display: block;
            margin: 18px 0 10px;
            font: 700 42px/1 "Space Grotesk", sans-serif;
        }
        .progress {
            margin-top: 20px;
            height: 14px;
            border-radius: 999px;
            background: rgba(31, 107, 82, 0.1);
            overflow: hidden;
        }
        .progress span {
            display: block;
            height: 100%;
            background: linear-gradient(135deg, #1f6b52, #43ad84);
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 16px;
            margin-top: 20px;
        }
        .stat {
            padding: 22px;
            border-radius: 24px;
            background: var(--card);
            box-shadow: var(--shadow);
        }
        .stat span {
            display: block;
            color: var(--muted);
            font-size: 13px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        .stat strong {
            font: 700 28px/1 "Space Grotesk", sans-serif;
        }
        .negative { color: var(--danger); }
        .positive { color: var(--success); }
        .grid {
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 20px;
            margin-top: 20px;
        }
        .panel {
            padding: 24px;
            border-radius: 26px;
            background: var(--card);
            box-shadow: var(--shadow);
        }
        .panel h2 {
            margin: 0 0 10px;
            font: 700 28px/1.05 "Space Grotesk", sans-serif;
        }
        .panel-subtitle {
            margin: 0 0 22px;
            color: var(--muted);
            line-height: 1.6;
        }
        .breakdown {
            display: grid;
            gap: 14px;
        }
        .breakdown-item {
            display: grid;
            gap: 10px;
        }
        .breakdown-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }
        .breakdown-title {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
        }
        .bar {
            height: 12px;
            border-radius: 999px;
            background: rgba(31, 107, 82, 0.08);
            overflow: hidden;
        }
        .bar span {
            display: block;
            height: 100%;
            border-radius: 999px;
        }
        .daily-chart {
            display: flex;
            align-items: end;
            gap: 6px;
            height: 220px;
        }
        .day {
            flex: 1;
            min-width: 6px;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: end;
            align-items: center;
            gap: 8px;
        }
        .day-bar {
            width: 100%;
            border-radius: 12px 12px 6px 6px;
            background: linear-gradient(180deg, #7fd4b0 0%, #1f6b52 100%);
            min-height: 2px;
        }
        .day-label {
            font-size: 11px;
            color: var(--muted);
        }
        .ops {
            display: grid;
            gap: 12px;
        }
        .op {
            display: grid;
            grid-template-columns: auto 1fr auto;
            gap: 14px;
            align-items: center;
            padding: 16px;
            border-radius: 18px;
            background: rgba(238, 245, 241, 0.8);
        }
        .icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            color: white;
            font-size: 22px;
            font-weight: 700;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.18);
        }
        .mini-icon {
            width: 26px;
            height: 26px;
            border-radius: 9px;
            display: inline-grid;
            place-items: center;
            color: white;
            font-size: 15px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.18);
        }
        .icon::before, .mini-icon::before { content: "•"; }
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
        .op-meta strong {
            display: block;
            margin-bottom: 4px;
        }
        .op-meta span {
            color: var(--muted);
            font-size: 14px;
        }
        .amount {
            font-weight: 700;
            text-align: right;
        }
        .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 8px;
        }
        .tag {
            padding: 6px 10px;
            border-radius: 999px;
            background: var(--accent-soft);
            color: var(--accent);
            font-size: 12px;
        }
        .insights {
            display: grid;
            gap: 12px;
        }
        .insight {
            padding: 16px;
            border-radius: 18px;
            background: rgba(31, 107, 82, 0.06);
        }
        .insight strong {
            display: block;
            margin-bottom: 6px;
        }
        .empty {
            color: var(--muted);
            line-height: 1.7;
        }
        @media (max-width: 1100px) {
            .hero, .grid { grid-template-columns: 1fr; }
            .stats { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 720px) {
            .wrap { width: min(100% - 16px, 1260px); }
            .topbar { padding: 18px; }
            .stats { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="wrap">
    <header class="topbar">
        <div class="brand">
            <strong>MoneySave</strong>
            <span>Личный финансовый кабинет для ${currentUserLogin}</span>
        </div>
        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/operations/new">Добавить операцию</a>
            <a class="btn-ghost" href="${pageContext.request.contextPath}/categories">Категории</a>
            <form class="logout-form" action="${pageContext.request.contextPath}/logout" method="post">
                <button class="btn-ghost" type="submit">Выйти</button>
            </form>
        </div>
    </header>

    <c:if test="${not empty dashboardSuccessMessage}">
        <div class="success">${dashboardSuccessMessage}</div>
    </c:if>

    <section class="hero">
        <div class="hero-panel">
            <h1>Контролируйте деньги по месяцам, категориям и ежедневным привычкам.</h1>
            <p>На этом дашборде собраны ключевые карточки месяца: общие доходы, расходы, баланс, остаток бюджета, последние операции и первые аналитические выводы по вашему финансовому поведению.</p>
        </div>
        <div class="budget-panel">
            <p>Остаток бюджета</p>
            <span class="budget-value"><fmt:formatNumber value="${dashboard.budgetLeft}" minFractionDigits="2" maxFractionDigits="2"/></span>
            <p>${dashboard.budgetForecastMessage}</p>
            <div class="progress">
                <span style="width: ${dashboard.budgetUsedPercent}%;"></span>
            </div>
        </div>
    </section>

    <section class="stats">
        <div class="stat">
            <span>Расходы за месяц</span>
            <strong><fmt:formatNumber value="${dashboard.monthExpenses}" minFractionDigits="2" maxFractionDigits="2"/></strong>
        </div>
        <div class="stat">
            <span>Доходы за месяц</span>
            <strong class="positive"><fmt:formatNumber value="${dashboard.monthIncome}" minFractionDigits="2" maxFractionDigits="2"/></strong>
        </div>
        <div class="stat">
            <span>Баланс</span>
            <strong class="${dashboard.balanceNonNegative ? 'positive' : 'negative'}"><fmt:formatNumber value="${dashboard.balance}" minFractionDigits="2" maxFractionDigits="2"/></strong>
        </div>
        <div class="stat">
            <span>Средний расход в день</span>
            <strong><fmt:formatNumber value="${dashboard.averageExpensePerDay}" minFractionDigits="2" maxFractionDigits="2"/></strong>
        </div>
        <div class="stat">
            <span>Месяц к месяцу</span>
            <strong class="${dashboard.expenseChangePositive ? 'negative' : 'positive'}"><fmt:formatNumber value="${dashboard.expenseChangePercent}" minFractionDigits="2" maxFractionDigits="2"/>%</strong>
        </div>
    </section>

    <section class="grid">
        <div class="panel">
            <h2>Расходы по категориям</h2>
            <p class="panel-subtitle">Круговую диаграмму можно будет добавить следующим шагом, но уже сейчас видно, какие категории съедают большую часть бюджета.</p>
            <c:choose>
                <c:when test="${not empty dashboard.categoryBreakdown}">
                    <div class="breakdown">
                        <c:forEach items="${dashboard.categoryBreakdown}" var="item">
                            <div class="breakdown-item">
                                <div class="breakdown-head">
                                    <span class="breakdown-title">
                                        <span class="mini-icon icon-${item.icon}" style="background:${item.colorHex};"></span>
                                        ${item.name}
                                    </span>
                                    <strong><fmt:formatNumber value="${item.amount}" minFractionDigits="2" maxFractionDigits="2"/> (${item.percent}%)</strong>
                                </div>
                                <div class="bar">
                                    <span style="width:${item.percent}%; background:${item.colorHex};"></span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty">Пока нет расходов за текущий месяц. Добавьте первую операцию, и здесь появится структура расходов по категориям.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="panel">
            <h2>Аналитические подсказки</h2>
            <p class="panel-subtitle">Базовые выводы по месяцу: что изменилось, где самые большие траты и как ведёт себя бюджет.</p>
            <div class="insights">
                <c:forEach items="${dashboard.insights}" var="insight">
                    <div class="insight">
                        <strong>${insight.title}</strong>
                        <span>${insight.description}</span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="grid">
        <div class="panel">
            <h2>Расходы по дням месяца</h2>
            <p class="panel-subtitle">Столбчатый график помогает быстро увидеть пики трат и дни, когда деньги уходят особенно активно.</p>
            <div class="daily-chart">
                <c:forEach items="${dashboard.dailyExpenses}" var="point">
                    <div class="day" title="День ${point.dayOfMonth}: ${point.amount}">
                        <div class="day-bar" style="height:${point.percent < 4 && point.amount > 0 ? 4 : point.percent}%;"></div>
                        <div class="day-label">${point.dayOfMonth}</div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="panel">
            <h2>Последние операции</h2>
            <p class="panel-subtitle">Ниже отображаются недавние доходы и расходы вместе с категорией, способом оплаты и тегами.</p>
            <c:choose>
                <c:when test="${not empty dashboard.recentOperations}">
                    <div class="ops">
                        <c:forEach items="${dashboard.recentOperations}" var="operation">
                            <div class="op">
                                <div class="icon icon-${operation.categoryIcon}" style="background:${operation.categoryColor};"></div>
                                <div class="op-meta">
                                    <strong>${operation.categoryName}</strong>
                                    <span>
                                        ${operation.operationDate} • ${operation.paymentMethodLabel}
                                        <c:if test="${not empty operation.comment}">• ${operation.comment}</c:if>
                                    </span>
                                    <c:if test="${not empty operation.tags}">
                                        <div class="tags">
                                            <c:forEach items="${operation.tags}" var="tag">
                                                <span class="tag">${tag}</span>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="amount ${operation.type == 'EXPENSE' ? 'negative' : 'positive'}">
                                    ${operation.type == 'EXPENSE' ? '-' : '+'}<fmt:formatNumber value="${operation.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty">Операций пока нет. Начните с добавления первой траты или дохода, и дашборд сразу станет живым.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</div>
</body>
</html>
