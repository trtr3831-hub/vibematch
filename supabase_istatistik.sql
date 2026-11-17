-- VibeMatch: profil ziyaret kayıtları (hesap istatistikleri)
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.
-- Okuma yalnızca profilin sahibine ve ziyaret edene açık; başka kullanıcılar göremez.

create table if not exists public.profil_ziyaretleri (
  ziyaret_eden uuid not null default auth.uid() references auth.users(id) on delete cascade,
  hedef uuid not null references auth.users(id) on delete cascade,
  gun date not null default current_date,
  primary key (ziyaret_eden, hedef, gun),
  check (ziyaret_eden <> hedef)
);

alter table public.profil_ziyaretleri enable row level security;

drop policy if exists "profil ziyaret okuma" on public.profil_ziyaretleri;
create policy "profil ziyaret okuma" on public.profil_ziyaretleri for select to authenticated
  using (hedef = auth.uid() or ziyaret_eden = auth.uid());

drop policy if exists "profil ziyaret ekleme" on public.profil_ziyaretleri;
create policy "profil ziyaret ekleme" on public.profil_ziyaretleri for insert to authenticated
  with check (ziyaret_eden = auth.uid());
