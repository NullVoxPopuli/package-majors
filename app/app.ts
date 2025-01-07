import Application from '@ember/application';
import { isTesting, macroCondition } from '@embroider/macros';

import { sync } from 'ember-primitives/color-scheme';
import Resolver from 'ember-resolver';

import config from './config/environment';
import Router from './router';

function formatAsResolverEntries(imports: Record<string, unknown>) {
  return Object.fromEntries(
    Object.entries(imports).map(([k, v]) => [
      k.replace(/\.g?(j|t)s$/, '').replace(/^\.\//, 'package-majors/'),
      v,
    ])
  );
}

const resolverRegistry = {
  ...formatAsResolverEntries(import.meta.glob('./templates/**/*', { eager: true })),
  ...formatAsResolverEntries(import.meta.glob('./services/**/*', { eager: true })),
  ...formatAsResolverEntries(import.meta.glob('./routes/**/*', { eager: true })),
  'package-majors/router': Router,
};

console.log(resolverRegistry);

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  // Resolver will be going away eventually
  Resolver = Resolver.withModules(resolverRegistry);
}

if (macroCondition(isTesting())) {
  // No themes in testing... yet?
  // (QUnit doesn't have good dark mode CSS)
} else {
  sync();
}
