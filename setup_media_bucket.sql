-- Create the 'media' bucket if it doesn't exist
insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

-- Remove the 'alter table' command as it requires ownership and RLS is likely already enabled.

-- Drop existing policies to avoid conflicts (if re-running)
-- Note: You might see warnings if they don't exist, which is fine.
drop policy if exists "Public Access Board Media" on storage.objects;
drop policy if exists "Authenticated Upload Media" on storage.objects;
drop policy if exists "Public Access" on storage.objects; -- Cleaning up previous name attempt
drop policy if exists "Authenticated Upload" on storage.objects; -- Cleaning up previous name attempt

-- Policy: Allow public access to view files in 'media' bucket
create policy "Public Access Board Media"
on storage.objects for select
using ( bucket_id = 'media' );

-- Policy: Allow authenticated users (teachers) to upload files to 'media' bucket
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
