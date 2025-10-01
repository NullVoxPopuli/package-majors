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
  };

  async model(_: unknown, transition: Transition): Promise<QueryData> {
    const rawPackages = getQP(transition);
    const packages = rawPackages
      .split(',')
      .map((str) => str.trim())
      .filter(Boolean);

    const qps = transition.to?.queryParams;
    const year = qps?.['year'] as string;
    const week = qps?.['week'] as string;

    const { stats, histories } = await getPackagesData(packages, year, week);

    return {
      packages,
      stats,
      histories,
    };
  }
}
