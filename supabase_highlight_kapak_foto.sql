-- VibeMatch: öne çıkarılan kapak fotoğrafı (galeriden yüklenen)
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

alter table public.highlights add column if not exists kapak_foto text;
