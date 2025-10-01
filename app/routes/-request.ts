import { assert } from '@ember/debug';

import type RouterService from '@ember/routing/router-service';
import type { Histories, PackageManifest } from 'package-majors/types';

export type Transition = ReturnType<RouterService['transitionTo']>;

const CACHE = new Map<string, unknown>();

export const cached = {
  get: async (url: string, sub?: boolean) => {
    if (CACHE.has(url)) {
      return CACHE.get(url);
    }

    const response = await fetch(url);
    let result = await response.json();

    if(sub) {
      result = result.response
    }

    CACHE.set(url, result);

    return Object.freeze(result);
  },
};

function statsURLFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`;
}

function historyURLFor(packageName: string, year: string, week: string) {
  return `/history/${encodeURIComponent(packageName)}/${year}/${week}.json`;
}

function historyManifestURLFor(packageName: string) {
  return `/history/${packageName}/manifest.json`;
}

async function getStats(packages: string[], year?: string, week?: string) {
  const stats = await Promise.all(
    packages.map((packageName) => {
      if(year && week) {
        return cached.get(historyURLFor(packageName, year, week), true)
      } else {
        return cached.get(statsURLFor(packageName));
      }
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

export async function getPackagesData(packages: string[], year?: string, week?: string) {
  const [stats, histories] = await Promise.all([getStats(packages, year, week), getHistories(packages)]);

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
