-- 1. Ensure email is removed from profiles and add is_public (default false for Privacy by Default)
alter table public.profiles drop column if exists email;
alter table public.profiles add column if not exists is_public boolean default false not null;

-- 2. Update handle_new_user trigger to populate is_public as false without email
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, avatar_url, is_public)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    coalesce(new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'picture'),
    false
  )
  on conflict (id) do update set
    username = coalesce(excluded.username, public.profiles.username),
    avatar_url = coalesce(excluded.avatar_url, public.profiles.avatar_url);
  return new;
end;
$$ language plpgsql security definer;

-- 3. Restrict profiles select to public profiles or own profile
drop policy if exists "Profiles are public." on public.profiles;
drop policy if exists "Profiles are viewable if public or own." on public.profiles;

create policy "Profiles are viewable if public or own."
  on public.profiles for select
  using ( is_public = true or auth.uid() = id );

-- 4. Update user_follows policies to restrict select to owner or public profiles
drop policy if exists "Follows are viewable by everyone." on public.user_follows;
drop policy if exists "Follows are viewable by owner or if public." on public.user_follows;

create policy "Follows are viewable by owner or if public."
  on public.user_follows for select
  using (
    auth.uid() = follower_id
    or exists (
      select 1 from public.profiles
      where profiles.id = user_follows.following_id
      and profiles.is_public = true
    )
  );

-- 5. Restrict user_titles select to own items or public profiles
drop policy if exists "Users can view their own items." on public.user_titles;
drop policy if exists "User titles are viewable by everyone." on public.user_titles;
drop policy if exists "User titles are viewable if profile is public or own." on public.user_titles;

create policy "User titles are viewable if profile is public or own."
  on public.user_titles for select
  using (
    auth.uid() = user_id
    or exists (
      select 1 from public.profiles
      where profiles.id = user_titles.user_id
      and profiles.is_public = true
    )
  );
