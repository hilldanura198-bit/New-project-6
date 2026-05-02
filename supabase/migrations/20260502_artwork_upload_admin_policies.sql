alter table public.profiles
  add column if not exists role text not null default 'user';

alter table public.artworks
  add column if not exists user_id uuid references auth.users(id) on delete set null,
  add column if not exists year integer,
  add column if not exists medium text,
  add column if not exists category text,
  add column if not exists updated_at timestamptz not null default timezone('utc', now());

create index if not exists artworks_user_id_idx on public.artworks(user_id);

alter table public.artworks enable row level security;

drop policy if exists "Anyone can read artworks" on public.artworks;
create policy "Anyone can read artworks"
  on public.artworks
  for select
  to authenticated
  using (true);

drop policy if exists "Admins can insert artworks" on public.artworks;
create policy "Admins can insert artworks"
  on public.artworks
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and lower(p.role) = 'admin'
    )
  );

drop policy if exists "Admins can update artworks" on public.artworks;
create policy "Admins can update artworks"
  on public.artworks
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and lower(p.role) = 'admin'
    )
  )
  with check (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and lower(p.role) = 'admin'
    )
  );

drop policy if exists "Admins can delete artworks" on public.artworks;
create policy "Admins can delete artworks"
  on public.artworks
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and lower(p.role) = 'admin'
    )
  );

drop policy if exists "Admins can upload artwork images" on storage.objects;
create policy "Admins can upload artwork images"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'artworks'
    and exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and lower(p.role) = 'admin'
    )
  );

drop policy if exists "Anyone can read artwork images" on storage.objects;
create policy "Anyone can read artwork images"
  on storage.objects
  for select
  to public
  using (bucket_id = 'artworks');
