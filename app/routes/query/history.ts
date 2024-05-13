import Route from '@ember/routing/route';

import { cached } from '../-request';

import type { HistoryData, QueryData } from 'package-majors/types';

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

  async model(): Promise<HistoryData> {
    let queryData = this.modelFor('query') as QueryData;
    let history = await getHistory(queryData);

    return {
      current: byPackage(queryData.stats),
      history,
    }
  }
}

function byPackage(stats: QueryData['stats']) {
  let result: Record<string, QueryData['stats'][number]> = {};

  for (let stat of stats) {
   let { package: packageName } = stat;

    result[packageName] = stat;
  }

  return result;
}

async function getHistory(queryData: QueryData) {
  let results: HistoryData['history'] = {};

  let promises = Object.entries(queryData.histories).map(async ([packageName, manifest]) => {
    if (!manifest) {
      results[packageName] = [];

      return;
    }

     let promises = manifest.snapshots.map(url => {
      return cached.get(url);
    });

    let snapshots = await Promise.all(promises);

    results[packageName] = snapshots;
  });

  await Promise.all(promises);

  return results;
}
