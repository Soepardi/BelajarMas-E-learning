-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ==========================================
-- 1. TABLES & RLS
-- ==========================================

-- PROFILES TABLE (Public User Data)
create table if not exists profiles (
  id uuid references auth.users not null primary key,
  email text,
  full_name text,
  role text check (role in ('student', 'teacher')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS for Profiles
alter table profiles enable row level security;
create policy "Public profiles are viewable by everyone." on profiles for select using (true);
create policy "Users can insert their own profile." on profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile." on profiles for update using (auth.uid() = id);

-- LESSONS TABLE
create table if not exists lessons (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  description text,
  category text, 
  video_url text,
  created_by uuid references profiles(id) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS for Lessons
alter table lessons enable row level security;
create policy "Lessons are viewable by everyone." on lessons for select using (true);
create policy "Teachers can insert lessons." on lessons for insert with check (
  exists (select 1 from profiles where id = auth.uid() and role = 'teacher')
);
create policy "Teachers can update their own lessons." on lessons for update using (
  auth.uid() = created_by
);
create policy "Teachers can delete their own lessons." on lessons for delete using (
  auth.uid() = created_by
);


-- EXERCISES TABLE
create table if not exists exercises (
  id uuid default uuid_generate_v4() primary key,
  lesson_id uuid references lessons(id) on delete cascade not null,
  type text check (type in ('reading', 'writing', 'grammar')) not null,
  content jsonb not null, -- Stores question, correct answer, etc.
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS for Exercises
alter table exercises enable row level security;
create policy "Exercises are viewable by everyone." on exercises for select using (true);
create policy "Teachers can insert exercises." on exercises for insert with check (
  exists (select 1 from profiles where id = auth.uid() and role = 'teacher')
);


-- PROGRESS TABLE
create table if not exists progress (
  id uuid default uuid_generate_v4() primary key,
  student_id uuid references profiles(id) not null,
  lesson_id uuid references lessons(id) on delete cascade not null, -- Added CASCADE here directly
  status text check (status in ('started', 'completed')) default 'started',
  score integer default 0,
  completed_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(student_id, lesson_id)
);

-- RLS for Progress
alter table progress enable row level security;
create policy "Users can view their own progress." on progress for select using (auth.uid() = student_id);
create policy "Users can insert/update their own progress." on progress for all using (auth.uid() = student_id);


-- ==========================================
-- 2. FUNCTIONS & TRIGGERS
-- ==========================================

-- Function to handle new users (Auto-create profile)
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (
    new.id, 
    new.email, 
    new.raw_user_meta_data->>'full_name', 
    coalesce(new.raw_user_meta_data->>'role', 'student') 
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger for new user creation
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Backfill Profiles (Safe to run multiple times)
insert into public.profiles (id, email, full_name, role)
select 
  id, 
  email, 
  raw_user_meta_data->>'full_name', 
  coalesce(raw_user_meta_data->>'role', 'student')
from auth.users
on conflict (id) do nothing;
