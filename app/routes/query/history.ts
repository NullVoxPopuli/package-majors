import Route from '@ember/routing/route';

import { cached } from '../-request';

import type { HistoryData, QueryData, TotalDownloadsResponse } from 'package-majors/types';

export default class History extends Route {
  queryParams = {
    // not yet implemented, because we don't have enough data
    year: {
      refreshModel: false,
    },
    week: {
      refreshModel: false,
    },
  };

  async model(): Promise<HistoryData> {
    const queryData = this.modelFor('query') as QueryData;
    const history = await getHistory(queryData);
    const totals = await getTotalDownloads(queryData.packages, history);

    const result = {
      current: byPackage(queryData.stats),
      history,
      totals,
    };

    return result;
  }
}

function byPackage(stats: QueryData['stats']) {
  const result: Record<string, QueryData['stats'][number]> = {};

  for (const stat of stats) {
    const { package: packageName } = stat;

    result[packageName] = stat;
  }

  return result;
}

async function getHistory(queryData: QueryData) {
  const results: HistoryData['history'] = {};

  const promises = Object.entries(queryData.histories).map(async ([packageName, manifest]) => {
    if (!manifest) {
      results[packageName] = [];

      return;
    }

    const promises = manifest.snapshots.map((url) => {
      return cached.get(url);
    });

    const snapshots = await Promise.all(promises);

    results[packageName] = snapshots;
  });

  await Promise.all(promises);

  return results;
}

/**
 * Fetches total download data from npm API for the given packages
 * https://github.com/npm/registry/blob/main/docs/download-counts.md
 */
async function getTotalDownloads(
  packages: string[],
  history: HistoryData['history']
): Promise<{ [packageName: string]: TotalDownloadsResponse }> {
  const results: { [packageName: string]: TotalDownloadsResponse } = {};

  // Calculate the date range from the historical data
  let earliestTimestamp: string | null = null;

  for (const snapshots of Object.values(history)) {
    for (const snapshot of snapshots) {
      if (!earliestTimestamp || snapshot.timestamp < earliestTimestamp) {
        earliestTimestamp = snapshot.timestamp;
      }
    }
  }

  const now = new Date();
  const endDate = now.toISOString().slice(0, 10);

  // If we have historical data, use the earliest timestamp as start date
  // Otherwise fall back to 18 months ago (npm API limit is around 18 months)
  let startDate: string;

  if (earliestTimestamp) {
    startDate = earliestTimestamp.slice(0, 10);
  } else {
    const fallbackDate = new Date(now);

    fallbackDate.setMonth(now.getMonth() - 18);
    startDate = fallbackDate.toISOString().slice(0, 10);
  }

  const promises = packages.map(async (packageName) => {
    try {
      const url = `https://api.npmjs.org/downloads/range/${startDate}:${endDate}/${encodeURIComponent(packageName)}`;
      const response = await cached.get(url);

      results[packageName] = response as TotalDownloadsResponse;
    } catch (error) {
      console.error(`Failed to fetch total downloads for ${packageName}:`, error);
      // Continue even if one package fails
    }
  });

  await Promise.all(promises);

  return results;
}
