-- Allow authenticated users to insert their own profile.
-- This ensures that if a profile row was missing or deleted,
-- the application can safely recreate it via upsert.
create policy "Users can insert their own profile."
  on public.profiles for insert
  with check ( auth.uid() = id );
