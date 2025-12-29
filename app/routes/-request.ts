import { assert } from '@ember/debug';

import type RouterService from '@ember/routing/router-service';
import type { DownloadsResponse, Histories, PackageManifest } from 'package-majors/types';

export type Transition = ReturnType<RouterService['transitionTo']>;

const CACHE = new Map<string, unknown>();

export const cached = {
  get: async (url: string) => {
    if (CACHE.has(url)) {
      return CACHE.get(url);
    }

    const response = await fetch(url);
    const result = await response.json();

    CACHE.set(url, result);

    return Object.freeze(result);
  },
};

function statsURLFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`;
}

function historyManifestURLFor(packageName: string) {
  return `/history/${packageName}/manifest.json`;
}

async function getStats(packages: string[]): Promise<DownloadsResponse[]> {
  const stats = await Promise.all(
    packages.map((packageName) => {
      return cached.get(statsURLFor(packageName));
    })
  );

  return stats;
}

async function getHistories(packages: string[]): Promise<Histories> {
  const ordered = await Promise.allSettled<PackageManifest>(
    packages.map((packageName) => {
      return cached.get(historyManifestURLFor(packageName));
    })
  );

  const result: Histories = {};

  for (let i = 0; i < packages.length; i++) {
    const name = packages[i];
    const promiseState = ordered[i];

    assert(`[BUG]: packages and promise states got out of sync`, name);
    assert(`[BUG]: packages and promise states got out of sync`, promiseState);

    const history = promiseState?.status === 'fulfilled' ? promiseState.value : null;

    result[name] = history;
  }

  return result;
}

export async function getPackagesData(packages: string[]): Promise<{
  stats: DownloadsResponse[];
  histories: Histories;
}> {
  const [stats, histories] = await Promise.all([getStats(packages), getHistories(packages)]);

  return { stats, histories };
}

export function getQP(transition: Transition): string {
  const qps = transition.to?.queryParams;

  if (!qps) return '';
  if (!('packages' in qps)) return '';

  const packages = qps['packages'];

  if (typeof packages !== 'string') return '';

  return packages || '';
}
