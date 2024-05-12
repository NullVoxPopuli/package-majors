'use strict';

/**
 * ESLint is really complicated right now, so all of it is abstracted away.
 * Updates coming soon (and hopefully to the built-in ember experience).
 */
const { configs } = require('@nullvoxpopuli/eslint-configs');

const config = configs.ember();

module.exports = {
  ...config,
  overrides: [...config.overrides],
};
