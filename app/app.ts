import Application from '@ember/application';

import loadInitializers from 'ember-load-initializers';
import { sync } from 'ember-primitives/color-scheme';
import Resolver from 'ember-resolver';
import config from 'package-majors/config/environment';

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  Resolver = Resolver;
}

loadInitializers(App, config.modulePrefix);
sync();
