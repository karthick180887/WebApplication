/*
  # Update profiles table with authentication support
  
  1. Changes
    - Add email and password fields to profiles table
    - Add authentication-related timestamps
    - Update RLS policies for proper authentication
  
  2. Security
    - Enable RLS on profiles table
    - Add policies for authenticated users
*/

-- Add authentication fields to profiles table if they don't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'email') THEN
    ALTER TABLE public.profiles ADD COLUMN email text UNIQUE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'last_sign_in_at') THEN
    ALTER TABLE public.profiles ADD COLUMN last_sign_in_at timestamptz;
  END IF;
END $$;

-- Ensure RLS is enabled
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can read own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;

-- Create updated policies
CREATE POLICY "Users can read own profile"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Insert test users if they don't exist
INSERT INTO public.profiles (id, email, role)
VALUES 
  ('00000000-0000-0000-0000-000000000001', 'admin@example.com', 'admin'),
  ('00000000-0000-0000-0000-000000000002', 'user@example.com', 'user')
ON CONFLICT (id) DO NOTHING;