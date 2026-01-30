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
      babel({
        babelHelpers: "runtime",
        extensions,
      }),
    ],
  };
});
