create extension if not exists pgcrypto;
create extension if not exists vector;

create table public.mediums (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table public.grades (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  sort_order int not null
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  education_level text not null check (education_level in ('O/L', 'A/L')),
  medium_id uuid not null references public.mediums(id),
  avatar_url text,
  coins int not null default 0 check (coins >= 0),
  xp int not null default 0 check (xp >= 0),
  streak_days int not null default 0 check (streak_days >= 0),
  current_rank text not null default 'Bronze',
  last_activity_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.subjects (
  id uuid primary key default gen_random_uuid(),
  grade_id uuid not null references public.grades(id),
  medium_id uuid not null references public.mediums(id),
  name text not null,
  slug text not null unique,
  icon_key text not null,
  color_hex text not null,
  sort_order int not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.chapters (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  title text not null,
  slug text not null,
  sort_order int not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  unique(subject_id, slug)
);

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  chapter_id uuid not null references public.chapters(id) on delete cascade,
  title text not null,
  summary text not null,
  body_md text not null,
  exam_tip text,
  estimated_minutes int not null default 5,
  sort_order int not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.flashcards (
  id uuid primary key default gen_random_uuid(),
  chapter_id uuid not null references public.chapters(id) on delete cascade,
  front text not null,
  back text not null,
  difficulty text not null default 'normal',
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  chapter_id uuid not null references public.chapters(id) on delete cascade,
  prompt text not null,
  explanation text,
  difficulty text not null default 'normal',
  created_at timestamptz not null default now()
);

create table public.quiz_options (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.quiz_questions(id) on delete cascade,
  label text not null,
  is_correct boolean not null default false
);

create table public.past_papers (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  year int not null,
  paper_type text not null,
  storage_path text not null,
  created_at timestamptz not null default now()
);

create table public.user_progress (
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject_id uuid references public.subjects(id) on delete cascade,
  chapter_id uuid references public.chapters(id) on delete cascade,
  lesson_id uuid references public.lessons(id) on delete cascade,
  progress_percent numeric(5,2) not null default 0,
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  primary key (user_id, subject_id, chapter_id, lesson_id)
);

create table public.study_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject_id uuid references public.subjects(id),
  activity_type text not null,
  duration_seconds int not null default 0,
  created_at timestamptz not null default now()
);

create table public.coin_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  amount int not null,
  reason text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table public.rewards (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text not null,
  reward_type text not null check (
    reward_type in ('panda_outfit', 'profile_frame', 'chat_sticker', 'theme', 'badge')
  ),
  asset_url text,
  coin_price int not null check (coin_price >= 0),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.user_rewards (
  user_id uuid not null references public.profiles(id) on delete cascade,
  reward_id uuid not null references public.rewards(id) on delete cascade,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, reward_id)
);

create table public.achievements (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text not null,
  icon_url text,
  coin_reward int not null default 0
);

create table public.user_achievements (
  user_id uuid not null references public.profiles(id) on delete cascade,
  achievement_id uuid not null references public.achievements(id) on delete cascade,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, achievement_id)
);

create table public.ranks (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  min_xp int not null check (min_xp >= 0),
  min_coins int not null check (min_coins >= 0),
  sort_order int not null
);

create table public.leaderboard_snapshots (
  id uuid primary key default gen_random_uuid(),
  leaderboard_type text not null check (
    leaderboard_type in ('overall', 'subject', 'friends')
  ),
  subject_id uuid references public.subjects(id),
  period_start date not null,
  period_end date not null,
  generated_at timestamptz not null default now()
);

create table public.leaderboard_entries (
  snapshot_id uuid not null references public.leaderboard_snapshots(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  rank_position int not null check (rank_position > 0),
  coins int not null default 0,
  xp int not null default 0,
  activity_score numeric(10,2) not null default 0,
  primary key (snapshot_id, user_id)
);

create table public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  provider text not null,
  provider_customer_id text,
  provider_subscription_id text,
  status text not null,
  plan_code text not null,
  current_period_start timestamptz,
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.ai_conversations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null default 'AI Panda chat',
  created_at timestamptz not null default now()
);

create table public.ai_messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.ai_conversations(id) on delete cascade,
  role text not null check (role in ('user', 'assistant', 'system')),
  content text not null,
  created_at timestamptz not null default now()
);

create table public.knowledge_documents (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid references public.subjects(id),
  title text not null,
  source_type text not null,
  storage_path text,
  created_at timestamptz not null default now()
);

create table public.knowledge_chunks (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.knowledge_documents(id) on delete cascade,
  content text not null,
  embedding vector(1536),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index idx_subjects_grade_medium on public.subjects(grade_id, medium_id);
create index idx_chapters_subject on public.chapters(subject_id, sort_order);
create index idx_lessons_chapter on public.lessons(chapter_id, sort_order);
create index idx_flashcards_chapter on public.flashcards(chapter_id, sort_order);
create index idx_progress_user on public.user_progress(user_id);
create index idx_coin_ledger_user_created on public.coin_ledger(user_id, created_at desc);
create index idx_leaderboard_entries_position on public.leaderboard_entries(snapshot_id, rank_position);
create index idx_subscriptions_user on public.subscriptions(user_id, status);
create index idx_knowledge_chunks_embedding on public.knowledge_chunks
using ivfflat (embedding vector_cosine_ops) with (lists = 100);
