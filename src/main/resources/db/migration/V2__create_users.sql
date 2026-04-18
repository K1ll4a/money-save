create table if not exists users (
    id uuid primary key,
    login varchar(100) not null unique,
    password_hash varchar(100) not null,
    created_at timestamp with time zone not null
);

create unique index if not exists idx_users_login
    on users (login);
