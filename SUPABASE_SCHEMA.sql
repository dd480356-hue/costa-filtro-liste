-- Filtro Liste — schema Supabase (Postgres)
-- Eseguire nel SQL Editor del progetto Supabase (regione EU).

create table if not exists public.records (
  key        text primary key,
  doc        jsonb not null,
  updated_at timestamptz default now()
);

create table if not exists public.rules (
  id         int primary key,
  doc        jsonb not null,
  updated_at timestamptz default now()
);

-- Row Level Security
alter table public.records enable row level security;
alter table public.rules   enable row level security;

-- Accesso condiviso al team: qualunque utente AUTENTICATO ha pieno accesso.
-- (Nessun accesso per utenti anonimi.)
drop policy if exists "records_auth_all" on public.records;
create policy "records_auth_all" on public.records
  for all to authenticated using (true) with check (true);

drop policy if exists "rules_auth_all" on public.rules;
create policy "rules_auth_all" on public.rules
  for all to authenticated using (true) with check (true);
