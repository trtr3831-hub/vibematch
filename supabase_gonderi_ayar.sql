-- VibeMatch: gönderi ayarları (beğenileri gizle) ve düzenleme izni
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

alter table public.gonderiler add column if not exists begeni_gizli boolean not null default false;

-- Gönderi sahibi kendi gönderisini güncelleyebilsin (düzenleme ve beğenileri gizleme)
drop policy if exists "gonderi guncelleme" on public.gonderiler;
create policy "gonderi guncelleme" on public.gonderiler for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
