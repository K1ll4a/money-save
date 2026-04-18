create table if not exists categories (
    id uuid primary key,
    user_id uuid,
    name varchar(100) not null,
    color_hex varchar(7) not null,
    icon varchar(40) not null,
    created_at timestamp with time zone not null
);

create unique index if not exists idx_categories_builtin_name
    on categories (name)
    where user_id is null;

create unique index if not exists idx_categories_user_name
    on categories (user_id, name)
    where user_id is not null;

create table if not exists financial_operations (
    id uuid primary key,
    user_id uuid not null,
    category_id uuid not null references categories(id),
    type varchar(20) not null,
    amount numeric(14, 2) not null,
    operation_date date not null,
    comment_text varchar(500),
    payment_method varchar(20) not null,
    tags_csv varchar(250),
    created_at timestamp with time zone not null
);

create index if not exists idx_financial_operations_user_date
    on financial_operations (user_id, operation_date desc);

create index if not exists idx_financial_operations_user_type
    on financial_operations (user_id, type);

insert into categories (id, user_id, name, color_hex, icon, created_at)
values
    ('11111111-1111-1111-1111-111111111111', null, 'Еда', '#2D7A5F', 'fork', now()),
    ('22222222-2222-2222-2222-222222222222', null, 'Транспорт', '#2A6F97', 'car', now()),
    ('33333333-3333-3333-3333-333333333333', null, 'Жильё', '#5C6B73', 'home', now()),
    ('44444444-4444-4444-4444-444444444444', null, 'Подписки', '#6C5CE7', 'repeat', now()),
    ('55555555-5555-5555-5555-555555555555', null, 'Развлечения', '#A44A3F', 'spark', now()),
    ('66666666-6666-6666-6666-666666666666', null, 'Здоровье', '#1B8A5A', 'health', now()),
    ('77777777-7777-7777-7777-777777777777', null, 'Одежда', '#8D6A9F', 'shirt', now()),
    ('88888888-8888-8888-8888-888888888888', null, 'Образование', '#3B6EA5', 'book', now()),
    ('99999999-9999-9999-9999-999999999999', null, 'Прочее', '#7A8C85', 'dots', now())
on conflict do nothing;
