import { sentryVitePlugin } from "@sentry/vite-plugin";
import { defineConfig } from "vite"
import { svelte } from "@sveltejs/vite-plugin-svelte"
import path from "path"

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [svelte(), sentryVitePlugin({
    org: "pwr-studio-0s",
    project: "this-cursed-machine"
  })],
  resolve: {
    alias: {
      '@mud': path.resolve(__dirname, './src/mud'),
      '@svelte': path.resolve(__dirname, './src/svelte'),
      '@components': path.resolve(__dirname, './src/svelte/components'),
      '@modules': path.resolve(__dirname, './src/svelte/modules/')
    }
  },
  publicDir: "./src/svelte/public",
  server: {
    port: 5173,
    fs: {
      strict: false,
    }
  },
  optimizeDeps: {
    esbuildOptions: {
      target: "es2022",
    },
  },
  build: {
    target: "es2022",
    minify: true,
    sourcemap: true,
  },
  define: {
    "process.env": {},
  },
})