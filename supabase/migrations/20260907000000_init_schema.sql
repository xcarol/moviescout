-- 1. Profiles Table
-- Automatically linked to auth.users
create table public.profiles (
  id uuid references auth.users(id) on delete cascade not null primary key,
  username text unique,
  avatar_url text,
  providers_string text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Configure RLS (Row Level Security) for profiles
alter table public.profiles enable row level security;

create policy "Profiles are public."
  on public.profiles for select
  using ( true );

create policy "Users can update their own profile."
  on public.profiles for update
  using ( auth.uid() = id );

-- Trigger to create a profile when a new user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. User Titles Table
-- Unifies Watchlist, Rateslist, Custom Lists, etc.
create table public.user_titles (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  tmdb_id integer not null,
  media_type text not null check (media_type in ('movie', 'tv', 'person')),
  list_name text not null, -- e.g., 'watchlist', 'rateslist'
  
  -- Specific fields depending on the list
  rating numeric(3,1), -- Used when list_name = 'rateslist'
  is_pinned boolean default false, -- Used when list_name = 'watchlist'
  notify_new_seasons boolean default false, -- Used when list_name = 'rateslist' and media_type = 'tv'
  last_notified_season integer default 0, -- Control flag for notifications
  
  rated_date timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  
  -- Ensure a user cannot have the same item duplicated in the same list
  unique (user_id, tmdb_id, media_type, list_name)
);

-- Configure RLS for user_titles
alter table public.user_titles enable row level security;

create policy "Users can view their own items."
  on public.user_titles for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own items."
  on public.user_titles for insert
  with check ( auth.uid() = user_id );

create policy "Users can delete their own items."
  on public.user_titles for delete
  using ( auth.uid() = user_id );

create policy "Users can update their own items."
  on public.user_titles for update
  using ( auth.uid() = user_id );

-- IMPORTANT: Supabase Realtime requires explicit table enablement
alter publication supabase_realtime add table public.user_titles;


-- 3. User Episode Ratings Table
create table public.user_episode_ratings (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  show_tmdb_id integer not null,
  season_number integer not null,
  episode_number integer not null,
  episode_tmdb_id integer not null,
  rating numeric(3,1) not null,
  
  rated_date timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  
  -- Un usuari només pot tenir una valoració per episodi
  unique (user_id, episode_tmdb_id)
);

-- Configure RLS
alter table public.user_episode_ratings enable row level security;

create policy "Users can view their own episode ratings."
  on public.user_episode_ratings for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own episode ratings."
  on public.user_episode_ratings for insert
  with check ( auth.uid() = user_id );

create policy "Users can delete their own episode ratings."
  on public.user_episode_ratings for delete
  using ( auth.uid() = user_id );

create policy "Users can update their own episode ratings."
  on public.user_episode_ratings for update
  using ( auth.uid() = user_id );

-- Supabase Realtime
alter publication supabase_realtime add table public.user_episode_ratings;

-- Trigger to automatically update updated_at
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

create trigger set_user_titles_updated_at
  before update on public.user_titles
  for each row execute procedure public.set_updated_at();
  
create trigger set_user_episode_ratings_updated_at
  before update on public.user_episode_ratings
  for each row execute procedure public.set_updated_at();
