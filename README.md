# MoneySave

Веб-приложение для личного учёта финансов: регистрация пользователя, добавление
доходов и расходов, категории, теги, способы оплаты и дашборд с базовой
аналитикой по месяцу.

MoneySave помогает быстро понять, куда уходят деньги, какие категории занимают
большую часть бюджета и как меняются траты по дням.

![Java](https://img.shields.io/badge/Java-17-1f6b52)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.5-2b8a68)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-2a6f97)
![Docker](https://img.shields.io/badge/Docker-Compose-5c6b73)

## Возможности

- Регистрация и вход пользователя
- Защищённые JSP-страницы через серверную сессию
- JWT-сервис для API-аутентификации
- Добавление доходов и расходов
- Выбор категории, суммы, даты, комментария и способа оплаты
- Встроенные категории: еда, транспорт, жильё, подписки, развлечения, здоровье,
  одежда, образование и прочее
- Создание собственных категорий
- Выбор цвета категории через палитру
- Выбор иконки категории из готового набора
- Предустановленные и пользовательские теги операций
- Дашборд с расходами, доходами, балансом, бюджетом, графиком по дням,
  разбивкой по категориям и последними операциями

## Стек

| Часть проекта | Технологии |
| --- | --- |
| Бэкенд | Java 17, Spring Boot 3.3.5 |
| Интерфейс | JSP, JSTL, Spring MVC Form Tags |
| ORM | Hibernate, Spring Data JPA |
| База данных | PostgreSQL 16 |
| Миграции | Flyway |
| Валидация | Jakarta Bean Validation, Hibernate Validator |
| Безопасность | Spring Security Crypto, JWT |
| Сборка | Maven Wrapper |
| Запуск | Docker, Docker Compose |

## Страницы приложения

Приложение работает с context path `/api`.

| Страница | URL |
| --- | --- |
| Вход | `http://localhost:8080/api` |
| Регистрация | `http://localhost:8080/api/register` |
| Дашборд | `http://localhost:8080/api/dashboard` |
| Новая операция | `http://localhost:8080/api/operations/new` |
| Категории | `http://localhost:8080/api/categories` |

## Быстрый запуск через Docker

Самый удобный способ запуска - Docker Compose. Он поднимает приложение и
PostgreSQL одной командой.

```bash
cp .env.example .env
docker compose up --build
```

После запуска приложение будет доступно по адресу:

```text
http://localhost:8080/api
```

PostgreSQL будет доступен на:

```text
localhost:5432
```

Если порт `5432` уже занят, поменяйте `DB_EXTERNAL_PORT` в `.env`.

## Переменные окружения

Основные настройки лежат в `.env.example`. Для локального запуска достаточно
скопировать файл в `.env`.

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `DB_HOST` | `localhost` | Хост PostgreSQL |
| `DB_PORT` | `5432` | Порт PostgreSQL для приложения |
| `DB_NAME` | `api_test` | Название базы данных |
| `DB_USERNAME` | `postgres` | Пользователь БД |
| `DB_PASSWORD` | `postgres` | Пароль БД |
| `DB_EXTERNAL_PORT` | `5432` | Порт БД на хост-машине |
| `APP_PORT` | `8080` | Порт приложения на хост-машине |
| `APP_AUTH_JWT_SECRET` | секрет для разработки | Секрет для JWT |
| `APP_AUTH_REFRESH_PEPPER` | pepper для разработки | Pepper для refresh-токенов |
| `APP_AUTH_ACCESS_TOKEN_TTL_SECONDS` | `900` | Время жизни access-токена |
| `APP_AUTH_REFRESH_TOKEN_TTL_SECONDS` | `2592000` | Время жизни refresh-токена |

Для разработки значения по умолчанию подходят. Для окружения, приближенного к
боевому, секреты авторизации нужно заменить.

## Локальный запуск без Docker

Сначала нужно поднять PostgreSQL и создать базу:

```bash
createdb api_test
```

Затем можно запустить приложение:

```bash
./mvnw spring-boot:run
```

Если настройки базы отличаются от дефолтных, передайте их через переменные
окружения:

```bash
DB_HOST=localhost \
DB_PORT=5432 \
DB_NAME=api_test \
DB_USERNAME=postgres \
DB_PASSWORD=postgres \
./mvnw spring-boot:run
```

## Сборка

Полная сборка:

```bash
./mvnw clean package
```

Быстрая сборка без тестов:

```bash
./mvnw clean package -DskipTests
```

Docker-образ:

```bash
docker build -t money-save .
```

Для полноценного запуска лучше использовать Docker Compose, потому что он сразу
поднимает и приложение, и PostgreSQL.

## Миграции базы данных

За структуру базы отвечает Flyway. Миграции автоматически применяются при старте
приложения.

Текущие миграции:

- `V1__create_refresh_sessions.sql`
- `V2__create_users.sql`
- `V3__create_categories_and_operations.sql`

Hibernate настроен в режиме проверки схемы:

```properties
spring.jpa.hibernate.ddl-auto=validate
```

То есть Flyway создаёт и меняет таблицы, а Hibernate проверяет, что Java-модели
соответствуют текущей схеме БД.

## Структура проекта

```text
src/main/java/com/k1ll4a/moneysave
├── config        # Конфигурация приложения
├── controller    # MVC и auth-контроллеры
├── domain        # JPA-сущности и enum-типы
├── dto           # Формы, ответы и DTO для дашборда
├── exception     # Исключения приложения
├── repository    # Репозитории Spring Data JPA
├── security      # Логика JWT и refresh-токенов
└── sevice        # Бизнес-логика

src/main/resources
├── application.properties
└── db/migration  # SQL-миграции Flyway

src/main/webapp/WEB-INF/jsp
├── index.jsp
├── register.jsp
├── dashboard.jsp
├── operation-form.jsp
└── categories.jsp
```

## Полезные команды

```bash
# Запустить весь проект
docker compose up --build

# Остановить контейнеры
docker compose down

# Остановить контейнеры и удалить volume с БД
docker compose down -v

# Собрать приложение локально
./mvnw clean package -DskipTests

# Смотреть логи приложения
docker compose logs -f app

# Открыть psql внутри контейнера PostgreSQL
docker compose exec postgres psql -U postgres -d api_test
```

## Основной сценарий

1. Пользователь регистрируется.
2. Заходит в аккаунт.
3. Добавляет собственные категории, если встроенных не хватает.
4. Вносит доходы и расходы за день.
5. Открывает дашборд и видит аналитику по месяцу.

## Что можно улучшить дальше

- Редактирование и удаление операций
- Настраиваемый месячный бюджет
- Более подробные графики и сравнение месяцев
- Регулярные платежи и подписки
- Экспорт операций в CSV
- Поиск аномально больших трат
- REST API для операций и категорий
