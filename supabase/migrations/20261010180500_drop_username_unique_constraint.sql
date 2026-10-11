-- Remove UNIQUE constraint on profiles.username
-- The primary user identifier is already the id (UUID from auth.users), and email is unique in auth.users.
-- User display names do not need to be unique and should allow real user names without conflict.
alter table public.profiles drop constraint if exists profiles_username_key;
