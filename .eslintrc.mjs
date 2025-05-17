import { configs } from "@nullvoxpopuli/eslint-configs";

const config = configs.ember();

export default [
  ...config,
  {
    files: ["*.{cjs,js}"],
    rules: {
      "n/no-unsupported-syntax": "off",
      "n/no-unsupported-features": "off",
    },
  },
];
