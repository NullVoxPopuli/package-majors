import EmberRouter from '@ember/routing/router';

import { properLinks } from 'ember-primitives/proper-links';
import config from 'package-majors/config/environment';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('history-list');
  this.route('query', { path: 'q' }, function () {
    this.route('history', { path: 'h' });
  });
});
