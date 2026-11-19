-- Supabase schema for Controle de Estoque — CD Aparecida
-- Execute once in Supabase SQL Editor using the project owner account.
-- Safe to re-run: creates missing objects and does not delete existing rows.

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  code text not null,
  barcode text,
  name text not null,
  unit text not null check (unit in ('kg','un','cx','pct','L')),
  min numeric(14,3),
  created_at timestamptz not null default now(),
  constraint products_user_id_id_key unique (user_id, id),
  constraint products_user_code_key unique (user_id, code),
  constraint products_min_nonnegative check (min is null or min >= 0)
);

create unique index if not exists products_user_barcode_unique
  on public.products(user_id, barcode)
  where barcode is not null and barcode <> '';

create table if not exists public.moves (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  product_id uuid not null,
  type text not null check (type in ('entrada','saida','ajuste')),
  qty numeric(14,3) not null,
  date date not null default current_date,
  doc text,
  lot text,
  expiry date,
  obs text,
  created_at timestamptz not null default now(),
  constraint moves_product_owner_fk
    foreign key (user_id, product_id)
    references public.products(user_id, id)
    on delete restrict,
  constraint moves_qty_valid check (
    (type = 'ajuste' and qty <> 0) or
    (type in ('entrada','saida') and qty > 0)
  )
);

create index if not exists products_user_id_idx on public.products(user_id);
create index if not exists moves_user_date_idx on public.moves(user_id, date desc);
create index if not exists moves_product_id_idx on public.moves(product_id);

alter table public.products enable row level security;
alter table public.moves enable row level security;

drop policy if exists "Users can read own products" on public.products;
create policy "Users can read own products" on public.products
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can insert own products" on public.products;
create policy "Users can insert own products" on public.products
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can update own products" on public.products;
create policy "Users can update own products" on public.products
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete own products without movements" on public.products;
create policy "Users can delete own products without movements" on public.products
  for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Users can read own moves" on public.moves;
create policy "Users can read own moves" on public.moves
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can insert own moves" on public.moves;
create policy "Users can insert own moves" on public.moves
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can update own moves" on public.moves;
create policy "Users can update own moves" on public.moves
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete own moves" on public.moves;
create policy "Users can delete own moves" on public.moves
  for delete to authenticated using (auth.uid() = user_id);

-- Enable Realtime for cross-device updates. Ignore duplicate publication entries.
do $$
begin
  alter publication supabase_realtime add table public.products;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
do $$
begin
  alter publication supabase_realtime add table public.moves;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
