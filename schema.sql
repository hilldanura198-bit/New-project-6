-- schema.sql
-- Production-ready Supabase schema for Flutter Art Gallery App

-- Extensions
create extension if not exists pgcrypto;

-- =========================
-- 1) PROFILES
-- =========================
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null check (char_length(trim(username)) >= 3),
  email text not null,
  avatar_url text,
  bio text default '',
  role text not null default 'user' check (role in ('user', 'admin')),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists profiles_username_unique_idx
  on public.profiles (lower(username));

create index if not exists profiles_role_idx
  on public.profiles (role);

-- =========================
-- 2) ARTWORKS
-- =========================
create table if not exists public.artworks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  artist_name text not null,
  year integer not null check (year between 1000 and 3000),
  medium text not null,
  description text not null,
  image_url text not null,
  category text not null,
  user_id uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists artworks_created_at_idx
  on public.artworks (created_at desc);

create index if not exists artworks_user_id_idx
  on public.artworks (user_id);

create index if not exists artworks_title_idx
  on public.artworks using gin (to_tsvector('simple', coalesce(title, '')));

create index if not exists artworks_artist_name_idx
  on public.artworks using gin (to_tsvector('simple', coalesce(artist_name, '')));

create index if not exists artworks_category_idx
  on public.artworks (category);

-- =========================
-- 3) FAVORITES
-- =========================
create table if not exists public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  artwork_id uuid not null references public.artworks(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  unique (user_id, artwork_id)
);

create index if not exists favorites_user_id_idx
  on public.favorites (user_id);

create index if not exists favorites_artwork_id_idx
  on public.favorites (artwork_id);

-- =========================
-- 4) UPDATED_AT TRIGGER
-- =========================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_profiles_set_updated_at on public.profiles;
create trigger trg_profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

drop trigger if exists trg_artworks_set_updated_at on public.artworks;
create trigger trg_artworks_set_updated_at
before update on public.artworks
for each row
execute function public.set_updated_at();

-- =========================
-- 5) RLS ENABLE
-- =========================
alter table public.profiles enable row level security;
alter table public.artworks enable row level security;
alter table public.favorites enable row level security;

-- =========================
-- 6) RLS POLICIES: PROFILES
-- =========================
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "profiles_select_admin" on public.profiles;
create policy "profiles_select_admin"
on public.profiles
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

-- =========================
-- 7) RLS POLICIES: ARTWORKS
-- =========================
drop policy if exists "artworks_public_read" on public.artworks;
create policy "artworks_public_read"
on public.artworks
for select
to anon, authenticated
using (true);

drop policy if exists "artworks_admin_insert" on public.artworks;
create policy "artworks_admin_insert"
on public.artworks
for insert
to authenticated
with check (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
  and user_id = auth.uid()
);

drop policy if exists "artworks_admin_update" on public.artworks;
create policy "artworks_admin_update"
on public.artworks
for update
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
)
with check (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

drop policy if exists "artworks_admin_delete" on public.artworks;
create policy "artworks_admin_delete"
on public.artworks
for delete
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

-- =========================
-- 8) RLS POLICIES: FAVORITES
-- =========================
drop policy if exists "favorites_select_own" on public.favorites;
create policy "favorites_select_own"
on public.favorites
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "favorites_insert_own" on public.favorites;
create policy "favorites_insert_own"
on public.favorites
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "favorites_delete_own" on public.favorites;
create policy "favorites_delete_own"
on public.favorites
for delete
to authenticated
using (auth.uid() = user_id);

-- =========================
-- 9) OPTIONAL: AUTO-CREATE PROFILE ON SIGNUP
-- =========================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)),
    new.email,
    'user'
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- =========================
-- 10) STORAGE POLICIES (artworks bucket)
-- =========================
drop policy if exists "storage_artworks_public_read" on storage.objects;
create policy "storage_artworks_public_read"
on storage.objects
for select
to public
using (bucket_id = 'artworks');

drop policy if exists "storage_artworks_admin_insert" on storage.objects;
create policy "storage_artworks_admin_insert"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'artworks'
  and exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

drop policy if exists "storage_artworks_admin_update" on storage.objects;
create policy "storage_artworks_admin_update"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'artworks'
  and exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
)
with check (
  bucket_id = 'artworks'
  and exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

drop policy if exists "storage_artworks_admin_delete" on storage.objects;
create policy "storage_artworks_admin_delete"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'artworks'
  and exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);
