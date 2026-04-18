create table if not exists refresh_sessions (
    id uuid primary key,
    user_id uuid not null,
    session_id uuid not null,
    access_jti uuid not null,
    token_hash varchar(120) not null,
    expires_at timestamp with time zone not null,
    created_at timestamp with time zone not null,
    used_at timestamp with time zone,
    revoked_at timestamp with time zone
);

create index if not exists idx_refresh_sessions_user_id
    on refresh_sessions (user_id);

create index if not exists idx_refresh_sessions_session_id
    on refresh_sessions (session_id);

create index if not exists idx_refresh_sessions_expires_at
    on refresh_sessions (expires_at);
