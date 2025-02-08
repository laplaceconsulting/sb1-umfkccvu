-- Drop existing policies
DROP POLICY IF EXISTS "Admins can insert modules" ON modules;
DROP POLICY IF EXISTS "Admins can update modules" ON modules;
DROP POLICY IF EXISTS "Admins can delete modules" ON modules;

-- Recreate module policies with fixed admin checks
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