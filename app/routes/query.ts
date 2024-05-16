import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { hasHistory } from 'package-majors/utils';

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
    let rawPackages = getQP(transition);
    let packages = rawPackages
      .split(',')
      .map((str) => str.trim())
      .filter(Boolean);

    let { stats, histories } = await getPackagesData(packages);

    this.settings.hasHistory = hasHistory(histories);

    return {
      packages,
      stats,
      histories,
    };
  }
}
