import Route from '@ember/routing/route';

import { getPackagesData, getQP, type Transition } from './-request';



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

  async model(_: unknown, transition: Transition) {
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
