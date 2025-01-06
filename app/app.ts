import Application from '@ember/application';
import { isTesting, macroCondition } from '@embroider/macros';
import compatModules from '@embroider/virtual/compat-modules';

import { sync } from 'ember-primitives/color-scheme';
import Resolver from 'ember-resolver';
import config from 'package-majors/config/environment';

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  Resolver = Resolver.withModules(compatModules);
}

if (macroCondition(isTesting())) {
  // No themes in testing... yet?
  // (QUnit doesn't have good dark mode CSS)
} else {
  sync();
}
