-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Profiles are viewable by users" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Modules are viewable by authenticated users" ON modules;
DROP POLICY IF EXISTS "Admins can insert modules" ON modules;
DROP POLICY IF EXISTS "Admins can update modules" ON modules;
DROP POLICY IF EXISTS "Admins can delete modules" ON modules;
DROP POLICY IF EXISTS "Resources are viewable by authenticated users" ON resources;
DROP POLICY IF EXISTS "Admins can insert resources" ON resources;
DROP POLICY IF EXISTS "Admins can update resources" ON resources;
DROP POLICY IF EXISTS "Admins can delete resources" ON resources;
DROP POLICY IF EXISTS "Comments are viewable by authenticated users" ON comments;
DROP POLICY IF EXISTS "Users can insert own comments" ON comments;
DROP POLICY IF EXISTS "Users can update own comments" ON comments;
DROP POLICY IF EXISTS "Users can delete own comments" ON comments;
DROP POLICY IF EXISTS "Admins can delete any comment" ON comments;

-- Ensure RLS is enabled
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Recreate policies
-- Profiles policies
CREATE POLICY "Profiles are viewable by users" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Modules policies
CREATE POLICY "Modules are viewable by authenticated users" ON modules
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can insert modules" ON modules
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admins can update modules" ON modules
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admins can delete modules" ON modules
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

-- Resources policies
CREATE POLICY "Resources are viewable by authenticated users" ON resources
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can insert resources" ON resources
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admins can update resources" ON resources
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admins can delete resources" ON resources
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

-- Comments policies
CREATE POLICY "Comments are viewable by authenticated users" ON comments
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert own comments" ON comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments" ON comments
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments" ON comments
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Admins can delete any comment" ON comments
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS handle_updated_at_profiles ON profiles;
DROP TRIGGER IF EXISTS handle_updated_at_modules ON modules;
DROP TRIGGER IF EXISTS handle_updated_at_comments ON comments;

-- Drop existing function if it exists
DROP FUNCTION IF EXISTS handle_updated_at();

-- Recreate function and triggers
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate triggers
CREATE TRIGGER handle_updated_at_profiles
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();

CREATE TRIGGER handle_updated_at_modules
  BEFORE UPDATE ON modules
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();

CREATE TRIGGER handle_updated_at_comments
  BEFORE UPDATE ON comments
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();