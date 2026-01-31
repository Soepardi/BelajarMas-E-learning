-- Drop the existing constraint that blocks deletion
ALTER TABLE progress
DROP CONSTRAINT progress_lesson_id_fkey;

-- Re-add the constraint with ON DELETE CASCADE
ALTER TABLE progress
ADD CONSTRAINT progress_lesson_id_fkey
FOREIGN KEY (lesson_id)
REFERENCES lessons(id)
ON DELETE CASCADE;
