import { globalIgnores } from "eslint/config";

import { configs } from "@nullvoxpopuli/eslint-configs";

const config = configs.ember(import.meta.dirname);

export default [
  ...config,
  globalIgnores(["public"]),
  {
    files: ["*.{cjs,js}"],
    rules: {
      "n/no-unsupported-syntax": "off",
      "n/no-unsupported-features": "off",
    },
  },
];
