'use strict';

/**
 * ESLint is really complicated right now, so all of it is abstracted away.
 * Updates coming soon (and hopefully to the built-in ember experience).
 */
const { configs } = require('@nullvoxpopuli/eslint-configs');

const config = configs.ember();

module.exports = {
  ...config,
  overrides: [
    ...config.overrides,
    {
      files: ['**/*.gts'],
      plugins: ['ember'],
      parser: 'ember-eslint-parser',
    },
    {
      files: ['**/*.gjs'],
      plugins: ['ember'],
      parser: 'ember-eslint-parser',
    },
    {
      files: ['*.{cjs,js}'],
      rules: {
        'n/no-unsupported-syntax': 'off',
        'n/no-unsupported-features': 'off',
      },
    },
  ],
};
