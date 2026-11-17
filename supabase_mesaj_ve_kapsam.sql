-- VibeMatch: mesajlarda fotoğraf/ses + gizli hesap kuralı (öne çıkarılanlar, reels)
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

-- 1) Mesajlar: fotoğraf ve ses; metin artık zorunlu değil
alter table public.mesajlar_db add column if not exists foto text;
alter table public.mesajlar_db add column if not exists ses text;
alter table public.mesajlar_db alter column metin drop not null;

-- 2) Gizli hesap: öne çıkarılanlar ve reels yalnızca sahibi, herkese açık hesap veya onaylı takipçi görebilir
drop policy if exists "gizli highlight gorunurlugu" on public.highlights;
create policy "gizli highlight gorunurlugu" on public.highlights as restrictive for select to authenticated
  using (
    user_id = auth.uid()
    or not exists (select 1 from public.profiles p where p.id = highlights.user_id and p.gizlilik = 'takipci')
    or exists (select 1 from public.takipler t where t.takipci_id = auth.uid() and t.takip_edilen_id = highlights.user_id)
  );

drop policy if exists "gizli reel gorunurlugu" on public.reeller;
create policy "gizli reel gorunurlugu" on public.reeller as restrictive for select to authenticated
  using (
    user_id = auth.uid()
    or not exists (select 1 from public.profiles p where p.id = reeller.user_id and p.gizlilik = 'takipci')
    or exists (select 1 from public.takipler t where t.takipci_id = auth.uid() and t.takip_edilen_id = reeller.user_id)
  );
