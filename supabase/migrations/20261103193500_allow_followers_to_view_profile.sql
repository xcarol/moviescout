-- 1. Helper function to check if the current user follows a target user
-- Using security definer to avoid RLS recursion with user_follows
create or replace function public.is_following(target_user_id uuid)
returns boolean as $$
  select exists (
    select 1 from public.user_follows
    where follower_id = auth.uid()
    and following_id = target_user_id
  );
$$ language sql security definer stable;

-- 2. Update profiles select policy to allow viewing basic profile if public, own, or followed
drop policy if exists "Profiles are viewable if public or own." on public.profiles;
drop policy if exists "Profiles are viewable if public, own, or followed." on public.profiles;

create policy "Profiles are viewable if public, own, or followed."
  on public.profiles for select
  using (
    is_public = true
    or auth.uid() = id
    or public.is_following(id)
  );
