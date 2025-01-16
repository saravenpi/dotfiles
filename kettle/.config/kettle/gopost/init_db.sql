CREATE TABLE IF NOT EXISTS public.users (
    id serial NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone NULL,
    deleted_at timestamp without time zone NULL,
    username text NULL,
    email text NULL,
    password text NULL,
);

ALTER TABLE public.users
DROP CONSTRAINT IF EXISTS users_pkey;

ALTER TABLE public.users
ADD CONSTRAINT users_pkey PRIMARY KEY (id);
