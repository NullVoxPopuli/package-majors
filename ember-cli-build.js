'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');

const { maybeEmbroider } = require('@embroider/test-setup');

module.exports = function (defaults) {
  const app = new EmberApp(defaults, {
    // Add options here
    'ember-cli-babel': {
      enableTypeScriptTransform: true,
      disableDecoratorTransforms: true,
    },
    babel: {
      plugins: [
        // add the new transform.
        [
          // eslint-disable-next-line n/no-missing-require
          require.resolve('decorator-transforms'),
          {
            runtime: {
              // eslint-disable-next-line n/no-missing-require
              import: require.resolve('decorator-transforms/runtime'),
            },
          },
        ],
      ],
    },
  });

  return maybeEmbroider(app, {
    extraPublicTrees: [],
    staticAddonTrees: true,
    staticAddonTestSupportTrees: true,
    staticHelpers: true,
    staticModifiers: true,
    staticComponents: true,
    staticEmberSource: true,
    amdCompatibility: {
      es: [],
    },
    // splitAtRoutes: ['route.name'], // can also be a RegExp
    packagerOptions: {
      webpackConfig: {
        devtool: 'source-map',
      },
    },
  });
};
