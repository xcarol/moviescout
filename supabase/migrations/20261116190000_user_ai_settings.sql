-- Private table for syncing user AI settings (with client-encrypted API keys)
create table if not exists public.user_ai_settings (
  user_id uuid references public.profiles(id) on delete cascade not null primary key,
  active_provider text,
  ai_translation_enabled boolean default false not null,
  providers jsonb default '{}'::jsonb not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.user_ai_settings enable row level security;

create policy "Users can view their own ai settings."
  on public.user_ai_settings for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own ai settings."
  on public.user_ai_settings for insert
  with check ( auth.uid() = user_id );

create policy "Users can update their own ai settings."
  on public.user_ai_settings for update
  using ( auth.uid() = user_id );

create policy "Users can delete their own ai settings."
  on public.user_ai_settings for delete
  using ( auth.uid() = user_id );

create trigger set_user_ai_settings_updated_at
  before update on public.user_ai_settings
  for each row execute procedure public.set_updated_at();

