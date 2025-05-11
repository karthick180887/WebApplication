/*
  # Fix Authentication Schema

  1. Changes
    - Ensure auth schema exists
    - Create auth.users table if not exists
    - Set up proper RLS policies
    - Add necessary indexes
  
  2. Security
    - Enable RLS
    - Add policies for user authentication
*/

-- Create auth schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS auth;

-- Create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS auth.users (
  instance_id uuid,
  id uuid PRIMARY KEY,
  aud varchar(255),
  role varchar(255),
  email varchar(255) UNIQUE,
  encrypted_password varchar(255),
  email_confirmed_at timestamp with time zone,
  invited_at timestamp with time zone,
  confirmation_token varchar(255),
  confirmation_sent_at timestamp with time zone,
  recovery_token varchar(255),
  recovery_sent_at timestamp with time zone,
  email_change_token_new varchar(255),
  email_change_token_current varchar(255),
  email_change_confirm_status smallint,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  phone varchar(255) DEFAULT NULL::character varying,
  phone_confirmed_at timestamp with time zone,
  phone_change varchar(255) DEFAULT ''::character varying,
  phone_change_token varchar(255) DEFAULT ''::character varying,
  phone_change_sent_at timestamp with time zone,
  confirmed_at timestamp with time zone,
  email_change varchar(255) DEFAULT ''::character varying,
  email_change_sent_at timestamp with time zone,
  last_sign_in_at timestamp with time zone,
  raw_app_meta_data jsonb,
  raw_user_meta_data jsonb,
  is_super_admin boolean,
  CONSTRAINT users_email_key UNIQUE (email),
  CONSTRAINT users_phone_key UNIQUE (phone)
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS users_email_idx ON auth.users (email);

-- Enable RLS
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

-- Create policy for users to read their own data
CREATE POLICY "Users can read own data"
  ON auth.users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- Create policy for users to update their own data
CREATE POLICY "Users can update own data"
  ON auth.users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Ensure profiles table has proper foreign key constraint
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_id_fkey,
  ADD CONSTRAINT profiles_id_fkey 
  FOREIGN KEY (id) 
  REFERENCES auth.users(id) 
  ON DELETE CASCADE;