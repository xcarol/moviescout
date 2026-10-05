-- Function to allow an authenticated user to permanently delete their own account.
-- Because public.profiles, user_titles, and user_episode_ratings have ON DELETE CASCADE
-- linked to auth.users, deleting the row in auth.users automatically wipes all user data in cascade.
create or replace function public.delete_user_account()
returns void
language sql
security definer
set search_path = public
as $$
  delete from auth.users where id = auth.uid();
$$;

-- Grant execution to authenticated users
grant execute on function public.delete_user_account() to authenticated;
