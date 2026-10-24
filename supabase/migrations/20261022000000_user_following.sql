-- 1. Add email column to profiles
alter table public.profiles add column if not exists email text;

-- Update existing profiles with email from auth.users
update public.profiles p
set email = u.email
from auth.users u
where p.id = u.id and p.email is null;

-- Update handle_new_user trigger to populate email as well
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, avatar_url, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    coalesce(new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'picture'),
    new.email
  )
  on conflict (id) do update set
    username = coalesce(excluded.username, public.profiles.username),
    avatar_url = coalesce(excluded.avatar_url, public.profiles.avatar_url),
    email = coalesce(excluded.email, public.profiles.email);
  return new;
end;
$$ language plpgsql security definer;

-- 2. Create user_follows table
create table if not exists public.user_follows (
  follower_id uuid references public.profiles(id) on delete cascade not null,
  following_id uuid references public.profiles(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  primary key (follower_id, following_id)
);

alter table public.user_follows enable row level security;

create policy "Follows are viewable by everyone."
  on public.user_follows for select
  using ( true );

create policy "Users can follow others."
  on public.user_follows for insert
  with check ( auth.uid() = follower_id );

create policy "Users can unfollow others."
  on public.user_follows for delete
  using ( auth.uid() = follower_id );

-- 3. Allow public read on user_titles so other users can view pinned titles and rated titles
drop policy if exists "Users can view their own items." on public.user_titles;
drop policy if exists "User titles are viewable by everyone." on public.user_titles;

create policy "User titles are viewable by everyone."
  on public.user_titles for select
  using ( true );
