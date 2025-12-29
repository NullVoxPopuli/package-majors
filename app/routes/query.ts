import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { getPackagesData, getQP, type Transition } from './-request';

import type Settings from 'package-majors/services/settings';
import type { QueryData } from 'package-majors/types';

export default class Query extends Route {
  @service declare settings: Settings;

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
    showTotal: {
      refreshModel: false,
    },
  };

  async model(_: unknown, transition: Transition): Promise<QueryData> {
    const rawPackages = getQP(transition);
    const packages = rawPackages
      .split(',')
      .map((str) => str.trim())
      .filter(Boolean);

    const { stats, histories } = await getPackagesData(packages);

    return {
      packages,
      stats,
      histories,
    };
  }
}
