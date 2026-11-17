-- VibeMatch: profil web sitesi ve rozet
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

alter table public.profiles add column if not exists web text;
alter table public.profiles add column if not exists rozet text;
