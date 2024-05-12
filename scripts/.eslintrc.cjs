'use strict';

/**
 * ESLint is really complicated right now, so all of it is abstracted away.
 * Updates coming soon (and hopefully to the built-in ember experience).
 */
const { configs } = require('@nullvoxpopuli/eslint-configs');

module.exports = configs.nodeCJS();
