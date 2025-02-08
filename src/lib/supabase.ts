import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables. Please make sure PUBLIC_SUPABASE_URL and PUBLIC_SUPABASE_ANON_KEY are set in your .env file.');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    storageKey: 'finstat-auth',
    storage: typeof window !== 'undefined' ? window.localStorage : undefined
  }
});

export type Profile = {
  id: string;
  role: 'admin' | 'student';
  created_at: string;
  updated_at: string;
};

export type Module = {
  id: string;
  title: string;
  description: string | null;
  vimeo_url: string | null;
  order_number: number;
  created_at: string;
  updated_at: string;
};

export type Resource = {
  id: string;
  module_id: string;
  title: string;
  url: string;
  resource_type: 1 | 2 | 3;
  created_at: string;
};

export type Comment = {
  id: string;
  module_id: string;
  user_id: string;
  content: string;
  created_at: string;
  updated_at: string;
};
