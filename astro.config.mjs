import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import react from '@astrojs/react';
import node from '@astrojs/node';

export default defineConfig({
  integrations: [tailwind(), react()],
  output: 'server',
  adapter: node({
    mode: 'standalone'
  }),
  vite: {
    define: {
      'process.env.SUPABASE_URL': JSON.stringify(process.env.PUBLIC_SUPABASE_URL),
      'process.env.SUPABASE_ANON_KEY': JSON.stringify(process.env.PUBLIC_SUPABASE_ANON_KEY)
    }
  }
});
