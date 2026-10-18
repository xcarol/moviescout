create table if not exists public.user_comments (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  tmdb_id integer not null,
  media_type text not null check (media_type in ('movie', 'tv')),
  comment text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique (user_id, tmdb_id, media_type)
);

alter table public.user_comments enable row level security;

create policy "Comments are viewable by everyone."
  on public.user_comments for select
  using ( true );

create policy "Users can insert their own comment."
  on public.user_comments for insert
  with check ( auth.uid() = user_id );

create policy "Users can update their own comment."
  on public.user_comments for update
  using ( auth.uid() = user_id );

create policy "Users can delete their own comment."
  on public.user_comments for delete
  using ( auth.uid() = user_id );

create trigger set_user_comments_updated_at
  before update on public.user_comments
  for each row execute procedure public.set_updated_at();
