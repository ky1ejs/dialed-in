import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['esm'],
  outDir: 'dist',
  target: 'es2020',
  clean: true,
  sourcemap: true,
  dts: true, // generates .d.ts files
});

