import { ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { defineConfig } from "vite";

export default defineConfig(({ mode }) => {
  let isProduction = mode === "production";

  console.debug(`
    mode: ${mode}
    isProduction: ${isProduction}
    NODE_ENV: ${process.env.NODE_ENV}
  `);

  return {
    plugins: [
      ember(),
      // extra plugins here
      babel({
        babelHelpers: "runtime",
        extensions,
      }),
    ],
    build: {
      target: "esnext",
      minify: isProduction ? "terser" : false,
      terserOptions: {
        module: true,
        toplevel: false,
        ecma: 2022,
        output: {
          comments: false,
        },
        compress: {
          ecma: 2022,
          module: true,
          passes: 6,
          sequences: 30,
          arguments: false,
          keep_fargs: false,
          toplevel: false,
          unsafe: true,
          hoist_funs: true,
          conditionals: true,
          drop_debugger: true,
          evaluate: true,
          reduce_vars: true,
          side_effects: true,
          dead_code: true,
          defaults: true,
          unused: true,
        },
      },
    },
  };
});
