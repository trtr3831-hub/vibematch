-- VibeMatch: bildirimlerde kimden (etkileşimi yapan kullanıcı)
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.
-- Varsayılan auth.uid(): bildirimi ekleyen kullanıcı otomatik yazılır; mevcut ekleme kodları değişmez.

alter table public.bildirimler add column if not exists kimden uuid default auth.uid();

-- Bildirimleri temizleme: yalnızca kendi bildirimlerim
drop policy if exists "bildirim kendi silme" on public.bildirimler;
create policy "bildirim kendi silme" on public.bildirimler for delete to authenticated
  using (alici = auth.uid());
