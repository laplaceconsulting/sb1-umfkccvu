import { defineConfig } from 'astro/config';
   import tailwind from '@astrojs/tailwind';
   import react from '@astrojs/react';
   import netlify from '@astrojs/netlify';

   export default defineConfig({
     integrations: [tailwind(), react()],
     output: 'server',
     adapter: netlify({
       edgeMiddleware: true
     }),
     vite: {
       define: {
         'process.env.SUPABASE_URL': JSON.stringify(process.env.PUBLIC_SUPABASE_URL),
         'process.env.SUPABASE_ANON_KEY': JSON.stringify(process.env.PUBLIC_SUPABASE_ANON_KEY)
       }
     }
   });
