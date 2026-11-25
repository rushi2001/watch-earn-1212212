-- Supabase SQL Editor मध्ये हे पूर्ण पेस्ट करून RUN करा

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  points integer not null default 0,
  last_claim timestamptz,
  created_at timestamptz default now()
);

create table if not exists public.points_log (
  id bigserial primary key,
  user_id uuid references auth.users(id) on delete cascade,
  points integer not null,
  source text not null default 'video',
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.points_log enable row level security;

-- युजर फक्त स्वतःचा डेटा वाचू शकतो. थेट बदल करता येत नाही.
create policy "own profile read" on public.profiles
  for select using (auth.uid() = id);
create policy "own log read" on public.points_log
  for select using (auth.uid() = user_id);

-- नवीन युजर साइनअप झाला की प्रोफाइल आपोआप तयार होते
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email) values (new.id, new.email);
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- पॉइंट्स क्लेम: सर्व्हरवर 60 सेकंदांचे बंधन (फसवणूक टाळण्यासाठी)
create or replace function public.claim_points()
returns integer language plpgsql security definer set search_path = public as $$
declare
  uid uuid := auth.uid();
  last timestamptz;
  newpoints integer;
begin
  if uid is null then raise exception 'लॉगिन करा'; end if;
  select last_claim into last from public.profiles where id = uid for update;
  if last is not null and now() - last < interval '60 seconds' then
    raise exception 'थोडा वेळ थांबा';
  end if;
  update public.profiles
    set points = points + 1, last_claim = now()
    where id = uid returning points into newpoints;
  insert into public.points_log (user_id, points, source) values (uid, 1, 'video');
  return newpoints;
end; $$;

grant execute on function public.claim_points() to authenticated;
