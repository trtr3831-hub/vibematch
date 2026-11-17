-- VibeMatch: kendi hikayesini silme
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.
-- Hikaye silinince beğeni, görüntüleme ve öne çıkarma kayıtları ilişki kuralları (on delete cascade) ile birlikte silinir.

drop policy if exists "hikaye kendi silme" on public.hikayeler;
create policy "hikaye kendi silme" on public.hikayeler for delete to authenticated
  using (user_id = auth.uid());
