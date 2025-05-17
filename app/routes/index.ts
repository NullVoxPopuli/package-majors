import Route from '@ember/routing/route';
import { service } from '@ember/service';

import type RouterService from '@ember/routing/router-service';

export default class Query extends Route {
  @service declare router: RouterService;

  beforeModel() {
    return this.router.replaceWith('query', { queryParams: { packages: '@angular/core' } });
  }
}
