-- ToeyMusic: Supabase schema + access policies
-- Run this entire file in Supabase Dashboard > SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.folders (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) between 1 and 120),
  created_at timestamptz not null default now()
);

create table if not exists public.tracks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  artist text not null default '',
  album text not null default '',
  genre text not null default '',
  duration numeric(10,2) not null default 0,
  folder_id uuid references public.folders(id) on delete set null,
  audio_path text not null unique,
  mime_type text not null default 'audio/mpeg',
  created_at timestamptz not null default now()
);

create index if not exists tracks_folder_id_idx on public.tracks(folder_id);
create index if not exists tracks_title_idx on public.tracks using gin (to_tsvector('simple', title));

alter table public.admin_users enable row level security;
alter table public.folders enable row level security;
alter table public.tracks enable row level security;

-- Public visitors may read the shared library.
drop policy if exists "Public can read folders" on public.folders;
create policy "Public can read folders" on public.folders for select to anon, authenticated using (true);

drop policy if exists "Public can read tracks" on public.tracks;
create policy "Public can read tracks" on public.tracks for select to anon, authenticated using (true);

-- An authenticated user can see only their own admin registration.
drop policy if exists "Admins can read own admin record" on public.admin_users;
create policy "Admins can read own admin record" on public.admin_users for select to authenticated using (user_id = auth.uid());

-- Only user IDs explicitly added to admin_users can change the catalogue.
drop policy if exists "Admins can insert folders" on public.folders;
create policy "Admins can insert folders" on public.folders for insert to authenticated
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can update folders" on public.folders;
create policy "Admins can update folders" on public.folders for update to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can delete folders" on public.folders;
create policy "Admins can delete folders" on public.folders for delete to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins can insert tracks" on public.tracks;
create policy "Admins can insert tracks" on public.tracks for insert to authenticated
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can update tracks" on public.tracks;
create policy "Admins can update tracks" on public.tracks for update to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can delete tracks" on public.tracks;
create policy "Admins can delete tracks" on public.tracks for delete to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

grant select on public.admin_users to authenticated;
grant select on public.folders, public.tracks to anon, authenticated;
grant insert, update, delete on public.folders, public.tracks to authenticated;

-- Public audio bucket. Keep public read, but restrict uploads/deletes to registered admins.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('music-files', 'music-files', true, 52428800,
  array['audio/mpeg','audio/mp4','audio/aac','audio/wav','audio/x-wav','audio/ogg','audio/flac','audio/webm'])
on conflict (id) do update set public = true, file_size_limit = 52428800,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Public can stream ToeyMusic audio" on storage.objects;
create policy "Public can stream ToeyMusic audio" on storage.objects for select to anon, authenticated
using (bucket_id = 'music-files');

drop policy if exists "Admins can upload ToeyMusic audio" on storage.objects;
create policy "Admins can upload ToeyMusic audio" on storage.objects for insert to authenticated
with check (bucket_id = 'music-files' and exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins can update ToeyMusic audio" on storage.objects;
create policy "Admins can update ToeyMusic audio" on storage.objects for update to authenticated
using (bucket_id = 'music-files' and exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (bucket_id = 'music-files' and exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins can delete ToeyMusic audio" on storage.objects;
create policy "Admins can delete ToeyMusic audio" on storage.objects for delete to authenticated
using (bucket_id = 'music-files' and exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
