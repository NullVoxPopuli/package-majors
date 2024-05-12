import Route from '@ember/routing/route';

import type { QueryData } from 'package-majors/types';

export default class History extends Route {
  queryParams = {
    // not yet implemented, because we don't have enough data
    year: {
      refreshModel: false,
    },
    week: {
      refreshModel: false,
    }
  }

  async model() {
    let queryData = this.modelFor('query') as QueryData;

    console.log('q', queryData);
  }
}
