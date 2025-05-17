import { globalIgnores } from "eslint/config";

import { configs } from "@nullvoxpopuli/eslint-configs";

const config = configs.ember(import.meta.dirname);

export default [
  ...config,
  globalIgnores(["public"]),
  {
    files: ["**/*.{ts,gts}"],
    rules: {
      "@typescript-eslint/no-unsafe-assignment": "off",
      "@typescript-eslint/no-unsafe-return": "off",
      "@typescript-eslint/no-unsafe-member-access": "off",
      "@typescript-eslint/no-unsafe-call": "off",
    },
  },
  {
    files: ["*.{cjs,js}"],
    rules: {
      "n/no-unsupported-syntax": "off",
      "n/no-unsupported-features": "off",
    },
  },
];
