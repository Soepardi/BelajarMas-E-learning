-- Force the 'media' bucket to be public
update storage.buckets
set public = true
where id = 'media';

-- Re-verify policies (just in case)
drop policy if exists "Public Access Board Media" on storage.objects;
create policy "Public Access Board Media"
on storage.objects for select
using ( bucket_id = 'media' );
