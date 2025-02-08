/*
  # Atualizar permissões de admin

  1. Alterações
    - Atualiza as políticas de RLS para módulos
    - Garante que admins possam gerenciar módulos
    - Mantém restrições de acesso para usuários normais

  2. Segurança
    - Mantém RLS ativo
    - Reforça verificação de perfil admin
*/

-- Atualiza as políticas de módulos para admin
CREATE POLICY "Admins can manage modules" ON modules
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

-- Garante que usuários autenticados possam visualizar módulos
CREATE POLICY "Users can view modules" ON modules
  FOR SELECT USING (
    auth.role() = 'authenticated'
  );