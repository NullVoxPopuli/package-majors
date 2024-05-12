import Route from '@ember/routing/route';

import { getPackagesData, getQP, type Transition } from './-request';

import type { QueryData } from 'package-majors/types';

export default class Query extends Route {
  queryParams = {
    packages: {
      refreshModel: true,
    },
    /*
     * Toggles:
     */
    minors: {
      refreshModel: false,
    },
    old: {
      refreshModel: false,
    },
  };

  async model(_: unknown, transition: Transition): Promise<QueryData> {
    let rawPackages = getQP(transition);
    let packages = rawPackages
      .split(',')
      .map((str) => str.trim())
      .filter(Boolean);

    let { stats, histories } = await getPackagesData(packages);

    return {
      packages,
      stats,
      histories,
    };
  }
}
