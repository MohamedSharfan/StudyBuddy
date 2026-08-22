-- StudyBuddy production schema (run in Supabase SQL Editor once)
-- Extends auth.users with searchable profiles, study progress, and connections.

create extension if not exists pgcrypto;

-- Profiles (1:1 with auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text not null default 'Student',
  education_level text not null default 'O/L'
    check (education_level in ('O/L', 'A/L')),
  medium text not null default 'Tamil',
  province text,
  bio text not null default '',
  headline text not null default '',
  avatar_url text,
  email text,
  coins int not null default 0 check (coins >= 0),
  streak_days int not null default 0 check (streak_days >= 0),
  current_rank text not null default 'Bronze',
  lifetime_earned int not null default 0,
  last_activity_day date,
  badge_codes text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists profiles_username_lower_idx
  on public.profiles (lower(username))
  where username is not null;

-- Study completions (lesson / quiz / flashcard)
create table if not exists public.user_lesson_completions (
  user_id uuid not null references public.profiles(id) on delete cascade,
  lesson_id text not null,
  completed_at timestamptz not null default now(),
  primary key (user_id, lesson_id)
);

create table if not exists public.user_quiz_completions (
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject_id text not null,
  score_percent int not null default 0,
  completed_at timestamptz not null default now(),
  primary key (user_id, subject_id)
);

create table if not exists public.user_flashcard_completions (
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject_id text not null,
  completed_at timestamptz not null default now(),
  primary key (user_id, subject_id)
);

-- LinkedIn-style connections
create table if not exists public.student_connections (
  from_user_id uuid not null references public.profiles(id) on delete cascade,
  to_user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null check (status in ('pending', 'accepted')),
  created_at timestamptz not null default now(),
  primary key (from_user_id, to_user_id),
  check (from_user_id <> to_user_id)
);

alter table public.profiles enable row level security;
alter table public.user_lesson_completions enable row level security;
alter table public.user_quiz_completions enable row level security;
alter table public.user_flashcard_completions enable row level security;
alter table public.student_connections enable row level security;

-- Profiles: anyone authenticated can read (for search/ranks); owner writes
drop policy if exists "profiles_read" on public.profiles;
create policy "profiles_read" on public.profiles
  for select to authenticated using (true);

drop policy if exists "profiles_upsert_own" on public.profiles;
create policy "profiles_upsert_own" on public.profiles
  for all to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Completions: owner only
drop policy if exists "lesson_own" on public.user_lesson_completions;
create policy "lesson_own" on public.user_lesson_completions
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "quiz_own" on public.user_quiz_completions;
create policy "quiz_own" on public.user_quiz_completions
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "flash_own" on public.user_flashcard_completions;
create policy "flash_own" on public.user_flashcard_completions
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Connections: participants can read/write
drop policy if exists "connections_read" on public.student_connections;
create policy "connections_read" on public.student_connections
  for select to authenticated
  using (auth.uid() = from_user_id or auth.uid() = to_user_id);

drop policy if exists "connections_write" on public.student_connections;
create policy "connections_write" on public.student_connections
  for all to authenticated
  using (auth.uid() = from_user_id or auth.uid() = to_user_id)
  with check (auth.uid() = from_user_id or auth.uid() = to_user_id);

-- Auto-create empty profile on signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, display_name, email, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', 'Student'),
    new.email,
    coalesce(new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'picture')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
