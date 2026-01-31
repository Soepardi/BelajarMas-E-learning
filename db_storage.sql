-- ==========================================
-- STORAGE BUCKET SETUP
-- ==========================================

-- 1. Create the 'media' bucket if it doesn't exist
insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do update
set public = true; -- Ensure it is public even if it existed before

-- 2. POLICIES
-- Drop existing policies to avoid conflicts when re-running
drop policy if exists "Public Access Board Media" on storage.objects;
drop policy if exists "Public Access" on storage.objects; -- clean up old names
drop policy if exists "Authenticated Upload Media" on storage.objects;
drop policy if exists "Authenticated Upload" on storage.objects; -- clean up old names
drop policy if exists "Individual Update Media" on storage.objects;
drop policy if exists "Individual Delete Media" on storage.objects;

-- Policy: Allow public access to view files in 'media' bucket
create policy "Public Access Board Media"
on storage.objects for select
using ( bucket_id = 'media' );

-- Policy: Allow authenticated users (teachers/students) to upload files to 'media' bucket
create policy "Authenticated Upload Media"
on storage.objects for insert
with check (
  bucket_id = 'media' 
  and auth.role() = 'authenticated'
);

-- Policy: Allow users to update their own files
create policy "Individual Update Media"
on storage.objects for update
using ( auth.uid() = owner );

-- Policy: Allow users to delete their own files
create policy "Individual Delete Media"
on storage.objects for delete
using ( auth.uid() = owner );
