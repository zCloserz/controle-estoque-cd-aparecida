-- Controle de Estoque CD Aparecida
-- Execute este arquivo no SQL Editor do projeto Supabase.
-- Cada usuário acessa apenas seus próprios dados. PC e celular usam a mesma conta.

create table if not exists public.products (
  id uuid not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  code text not null,
  barcode text,
  name text not null,
  unit text not null,
  min numeric,
  updated_at timestamptz not null default now(),
  primary key (id, user_id),
  constraint products_unit_check check (unit in ('kg','un','cx','pct','L'))
);

create unique index if not exists products_user_code_unique
  on public.products(user_id, code);

create unique index if not exists products_user_barcode_unique
  on public.products(user_id, barcode)
  where barcode is not null and barcode <> '';

create table if not exists public.moves (
  id uuid not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id uuid not null,
  type text not null check (type in ('entrada','saida','ajuste')),
  qty numeric not null,
  date date not null,
  doc text,
  lot text,
  expiry date,
  obs text,
  created bigint not null default 0,
  updated_at timestamptz not null default now(),
  primary key (id, user_id),
  constraint moves_product_owner_fk
    foreign key (product_id, user_id)
    references public.products(id, user_id)
    on delete restrict,
  constraint moves_qty_nonzero check (qty <> 0)
);

create index if not exists moves_user_date_idx
  on public.moves(user_id, date desc);

alter table public.products enable row level security;
alter table public.moves enable row level security;

drop policy if exists "Users manage their own products" on public.products;
create policy "Users manage their own products"
  on public.products for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage their own moves" on public.moves;
create policy "Users manage their own moves"
  on public.moves for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Atualiza o carimbo de alteração automaticamente.
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at
before update on public.products
for each row execute function public.set_updated_at();

drop trigger if exists moves_set_updated_at on public.moves;
create trigger moves_set_updated_at
before update on public.moves
for each row execute function public.set_updated_at();

[executed on device: zCLOSER (fe9db097-636b-4fa4-a08e-4c4795f19ab1)]

-- Habilita atualizações em tempo real para sincronização entre dispositivos.
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='products') then
    alter publication supabase_realtime add table public.products;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='moves') then
    alter publication supabase_realtime add table public.moves;
  end if;
end $$;
