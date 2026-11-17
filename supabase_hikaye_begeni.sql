-- VibeMatch: hikaye beğenileri
-- Supabase SQL editöründe bir kez çalıştırılır. Tekrar çalıştırmak güvenlidir.

create table if not exists public.hikaye_begeniler (
  hikaye_id bigint not null references public.hikayeler(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (hikaye_id, user_id)
);

alter table public.hikaye_begeniler enable row level security;

drop policy if exists "hikaye begeni okuma" on public.hikaye_begeniler;
create policy "hikaye begeni okuma" on public.hikaye_begeniler for select to authenticated using (true);

drop policy if exists "hikaye begeni ekleme" on public.hikaye_begeniler;
create policy "hikaye begeni ekleme" on public.hikaye_begeniler for insert to authenticated with check (user_id = auth.uid());

drop policy if exists "hikaye begeni silme" on public.hikaye_begeniler;
create policy "hikaye begeni silme" on public.hikaye_begeniler for delete to authenticated using (user_id = auth.uid());
