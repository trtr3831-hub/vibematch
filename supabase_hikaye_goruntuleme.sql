-- VibeMatch: hikaye görüntüleme kayıtları
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.
-- Okuma: yalnızca hikayenin sahibi (görüntüleyenleri) ve izleyen kişi (kendi kaydını).

create table if not exists public.hikaye_goruntuleme (
  hikaye_id bigint not null references public.hikayeler(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (hikaye_id, user_id)
);

alter table public.hikaye_goruntuleme enable row level security;

drop policy if exists "hikaye goruntuleme okuma" on public.hikaye_goruntuleme;
create policy "hikaye goruntuleme okuma" on public.hikaye_goruntuleme for select to authenticated
  using (
    user_id = auth.uid()
    or exists (select 1 from public.hikayeler s where s.id = hikaye_id and s.user_id = auth.uid())
  );

drop policy if exists "hikaye goruntuleme ekleme" on public.hikaye_goruntuleme;
create policy "hikaye goruntuleme ekleme" on public.hikaye_goruntuleme for insert to authenticated
  with check (user_id = auth.uid());
