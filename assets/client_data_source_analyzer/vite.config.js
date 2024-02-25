import { defineConfig } from 'vite';
import babel from 'vite-plugin-babel';

export default defineConfig({
  base: './',
  plugins: [
    babel(),
  ],
  build: {
    rollupOptions: {
      output: {
        entryFileNames: 'bundle.js',
        chunkFileNames: 'bundle.js',
        assetFileNames: '[name][extname]'
      }
    }
  }
});
