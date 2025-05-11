/*
  # Create dummy users and profiles

  1. Changes
    - Insert dummy users for testing
      - Admin user: admin@example.com / admin123
      - Regular user: user@example.com / user123

  2. Security
    - Users are created with proper role assignments
    - Passwords are properly hashed
*/

-- Create admin user
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  confirmation_token,
  email_change_token_current,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'fd3d4c8e-9f89-4ca1-8f8b-2d56333e8b66',
  'authenticated',
  'authenticated',
  'admin@example.com',
  crypt('admin123', gen_salt('bf')),
  now(),
  now(),
  now(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

-- Create regular user
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  confirmation_token,
  email_change_token_current,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'b0e7d6f5-c4a3-4b2d-9e1f-8c5d2a3b1c0d',
  'authenticated',
  'authenticated',
  'user@example.com',
  crypt('user123', gen_salt('bf')),
  now(),
  now(),
  now(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

-- Create admin profile
INSERT INTO public.profiles (
  id,
  role,
  created_at,
  updated_at
) VALUES (
  'fd3d4c8e-9f89-4ca1-8f8b-2d56333e8b66',
  'admin',
  now(),
  now()
) ON CONFLICT (id) DO NOTHING;

-- Create user profile
INSERT INTO public.profiles (
  id,
  role,
  created_at,
  updated_at
) VALUES (
  'b0e7d6f5-c4a3-4b2d-9e1f-8c5d2a3b1c0d',
  'user',
  now(),
  now()
) ON CONFLICT (id) DO NOTHING;