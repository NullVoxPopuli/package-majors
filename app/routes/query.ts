import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { getPackagesData, getQP, type Transition } from './-request';

import type Settings from 'package-majors/services/settings';
import type { DownloadsResponse, QueryData, StatsForWeek } from 'package-majors/types';

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

    const { stats: statsRequest, histories } = await getPackagesData(packages);

    const stats = addTotals(statsRequest);

    return {
      packages,
      stats,
      histories,
    };
  }
}

function addTotals(stats: Array<DownloadsResponse>) {
  const result: Array<StatsForWeek> = [];

  for (const stat of stats) {
    const clone: StatsForWeek = { ...stat, total: 0 };

    for (const count of Object.values(clone.downloads)) {
      clone.total = clone.total + count;
    }

    result.push(clone);
  }

  return result;
}
