-- Fix RLS recursion on profiles update policy
-- Safe policy: no self-select in USING/WITH CHECK

drop policy if exists "User can update own profile" on public.profiles;

create policy "User can update own profile"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);
