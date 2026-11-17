-- VibeMatch: gizlilik ve gönderi varsayılanları (sunucuda saklanır)
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

-- 1) Profil tercihleri
alter table public.profiles add column if not exists gizlilik text not null default 'herkes';
alter table public.profiles add column if not exists varsayilan_begeni_gizli boolean not null default false;
alter table public.profiles add column if not exists varsayilan_yorum_kapali boolean not null default false;
alter table public.profiles drop constraint if exists profiles_gizlilik_chk;
alter table public.profiles add constraint profiles_gizlilik_chk check (gizlilik in ('herkes', 'takipci'));

-- 2) Gönderi: yorumları kapat
alter table public.gonderiler add column if not exists yorum_kapali boolean not null default false;

-- 3) Yorumlar kapalıysa sunucu da yeni yorumu reddetsin (mevcut izinlere ek kısıt)
drop policy if exists "kapali gonderiye yorum yok" on public.yorumlar;
create policy "kapali gonderiye yorum yok" on public.yorumlar as restrictive for insert to authenticated
  with check (not exists (select 1 from public.gonderiler g where g.id = gonderi_id and g.yorum_kapali));
