import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { getDefaultDateCutoff } from 'package-majors/utils';

import { cached } from '../-request';

import type Settings from 'package-majors/services/settings';
import type { HistoryData, QueryData, TotalDownloadsResponse } from 'package-majors/types';

export default class History extends Route {
  @service declare settings: Settings;

  queryParams = {
    // not yet implemented, because we don't have enough data
    year: {
      refreshModel: false,
    },
    week: {
      refreshModel: false,
    },
    dateCutoff: {
      refreshModel: true,
    },
  };

  async model(): Promise<HistoryData> {
    const queryData = this.modelFor('query') as QueryData;
    const dateCutoff = this.settings.dateCutoff || getDefaultDateCutoff();
    const history = await getHistory(queryData, dateCutoff);
    const totals = await getTotalDownloads(queryData.packages, history, dateCutoff);

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

async function getHistory(queryData: QueryData, dateCutoff: string) {
  const results: HistoryData['history'] = {};
  const cutoffDate = new Date(dateCutoff);

  const promises = Object.entries(queryData.histories).map(async ([packageName, manifest]) => {
    if (!manifest) {
      results[packageName] = [];

      return;
    }

    const promises = manifest.snapshots.map((url) => {
      return cached.get(url);
    });

    const snapshots = await Promise.all(promises);

    const filteredSnapshots = snapshots.filter((snapshot: { timestamp?: string }) => {
      if (!snapshot.timestamp) return true;

      const snapshotDate = new Date(snapshot.timestamp);

      return snapshotDate >= cutoffDate;
    });

    results[packageName] = filteredSnapshots;
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
  history: HistoryData['history'],
  dateCutoff: string
): Promise<{ [packageName: string]: TotalDownloadsResponse }> {
  const results: { [packageName: string]: TotalDownloadsResponse } = {};

  // Use the date cutoff as the start date
  const startDate = dateCutoff;
  const now = new Date();
  const endDate = now.toISOString().slice(0, 10);

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
