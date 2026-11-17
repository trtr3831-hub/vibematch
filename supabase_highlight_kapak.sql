-- VibeMatch: öne çıkarılan kapak fotoğrafı
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

alter table public.highlights add column if not exists kapak_hikaye_id bigint references public.hikayeler(id) on delete set null;
