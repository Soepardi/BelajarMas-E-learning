-- 1. Create (or replace) the function to handle new users
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

-- 2. Create (or replace) the trigger
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3. FIX YOUR EXISTING USER (Backfill)
-- This inserts a profile for any user in auth.users that doesn't have one yet.
insert into public.profiles (id, email, full_name, role)
select 
  id, 
  email, 
  raw_user_meta_data->>'full_name', 
  coalesce(raw_user_meta_data->>'role', 'student')
from auth.users
on conflict (id) do nothing;
