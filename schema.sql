-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- PROFILES TABLE (Public User Data)
create table profiles (
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

-- TRIGGER: Auto-create profile on signup
-- Note: You might handle this in your application logic (as done in register.html) 
-- or use a trigger. Since register.html does it manually, a trigger is optional but safer.
-- We will stick to the manual insert in register.html for simplicity as per current code.


-- LESSONS TABLE
create table lessons (
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
create table exercises (
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
create table progress (
  id uuid default uuid_generate_v4() primary key,
  student_id uuid references profiles(id) not null,
  lesson_id uuid references lessons(id) not null,
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

-- STORAGE BUCKETS (If not already created via dashboard)
-- insert into storage.buckets (id, name) values ('lessons', 'lessons');
-- Policy for storage objects would be needed too.
-- create policy "Any user can view lesson media" on storage.objects for select using ( bucket_id = 'lessons' );
-- create policy "Teachers can upload lesson media" on storage.objects for insert with check (
--   bucket_id = 'lessons' and exists (select 1 from profiles where id = auth.uid() and role = 'teacher')
-- );
