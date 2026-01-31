-- SEED DATA script
-- Usage: Replace 'YOUR_TEACHER_UUID_HERE' with real UUID from auth.users or profiles table.
-- You can find your UUID in the Supabase Dashboard > Authentication > Users.

-- 1. Variables (Postgres doesn't support variables cleanly in standard SQL scripts without DO blocks, 
-- so strictly speaking, search/replace is easier for many users. 
-- However, we will use a DO block for cleaner execution if they copy-paste).

DO $$
DECLARE
  -- Dynamically select the first user (preferable a teacher) from profiles
  teacher_id uuid;
  
  -- Variables for generated IDs
  lesson1_id uuid := uuid_generate_v4();
  lesson2_id uuid := uuid_generate_v4();
  lesson3_id uuid := uuid_generate_v4();
BEGIN
  -- Attempt to finding a teacher first, otherwise any user
  SELECT id INTO teacher_id FROM profiles WHERE role = 'teacher' LIMIT 1;
  
  -- If no teacher, try any user
  IF teacher_id IS NULL THEN
      SELECT id INTO teacher_id FROM profiles LIMIT 1;
  END IF;

  -- If still null, raise error
  IF teacher_id IS NULL THEN
      RAISE EXCEPTION 'No users found in profiles table. Please Register a new user in the app first, then run this script.';
  END IF;

  -- Verify if the teacher exists in profiles (Optional safety check)
  -- IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = teacher_id) THEN
  --   RAISE NOTICE 'Teacher ID not found. Please create a user first.';
  --   RETURN;
  -- END IF;
  -- For seeding purposes, we force insert if using a system ID, or assume the user has replaced it.


  -- INSERT LESSONS
  INSERT INTO lessons (id, title, description, category, video_url, created_by)
  VALUES
  (
    lesson1_id,
    'Mastering Past Tense Verbs',
    'Learn how to correctly use regular and irregular verbs in the past tense with real-world examples. This comprehensive guide covers pronunciation and common mistakes.',
    'Grammar',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    teacher_id
  ),
  (
    lesson2_id,
    'Business English Basics',
    'Essential vocabulary and phrases for professional environments. Learn how to introduce yourself, send emails, and conduct meetings affecting.',
    'Business',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    teacher_id
  ),
  (
    lesson3_id,
    'Common English Idioms',
    'Understand the most used English idioms in daily conversation. From "break a leg" to "bite the bullet", speak like a native.',
    'Vocabulary',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    teacher_id
  );


  -- INSERT EXERCISES
  -- Lesson 1 Exercises
  INSERT INTO exercises (lesson_id, type, content)
  VALUES
  (
    lesson1_id,
    'writing',
    '{"question": "Yesterday, I ___ (go) to the store.", "answer": "went", "hint": "Irregular verb form of go"}'::jsonb
  ),
  (
    lesson1_id,
    'writing',
    '{"question": "She ___ (play) tennis last week.", "answer": "played", "hint": "Regular verb adding -ed"}'::jsonb
  );

  -- Lesson 2 Exercises
  INSERT INTO exercises (lesson_id, type, content)
  VALUES
  (
    lesson2_id,
    'reading',
    '{"question": "Which phrase is best for ending a formal email?", "options": ["See ya", "Sincerely", "Cheers"], "answer": "Sincerely"}'::jsonb
  );

  -- Lesson 3 Exercises
  INSERT INTO exercises (lesson_id, type, content)
  VALUES
  (
    lesson3_id,
    'writing',
    '{"question": "It is raining ___ and dogs.", "answer": "cats", "hint": "Complete the idiom"}'::jsonb
  );

END $$;
