-- Fix infinite recursion on profiles RLS update policy
DROP POLICY IF EXISTS "User can update own profile" ON public.profiles;

CREATE POLICY "User can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);
