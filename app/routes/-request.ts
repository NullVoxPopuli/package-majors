import { assert } from '@ember/debug';

import type RouterService from '@ember/routing/router-service';
export type Transition = ReturnType<RouterService['transitionTo']>;

const CACHE = new Map();

export const cached = {
  get: async (url: string) => {
    if (CACHE.has(url)) {
      return CACHE.get(url);
    }

    let response = await fetch(url);
    let result = await response.json();

    CACHE.set(url, result);

    return Object.freeze(result);
  }
}

function statsURLFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`;
}

function historyManifestURLFor(packageName: string) {
  return `/history/${packageName}/manifest.json`;
}

async function getStats(packages: string[]) {
  let stats = await Promise.all(
    packages.map((packageName) => {
      return cached.get(statsURLFor(packageName));
    })
  );

  return stats;
}

interface Manifest {
  // Date timestamp
  lastUpdated: string;
  // urls
  snapshots: string[];
}

async function getHistories(packages: string[]): Promise<Record<string, Manifest | null>> {
  let ordered = await Promise.allSettled<Manifest>(packages.map(packageName => {
    return cached.get(historyManifestURLFor(packageName));
  }))

  let result: Record<string, Manifest | null> = {};

  for (let i = 0; i < packages.length; i++) {
    let name = packages[i];
    let promiseState = ordered[i];

    assert(`[BUG]: packages and promise states got out of sync`, name);
    assert(`[BUG]: packages and promise states got out of sync`, promiseState);

    let history = promiseState?.status === 'fulfilled' ? promiseState.value : null;

    result[name] = history;

  }

  return result;
}


export async function getPackagesData(packages: string[]) {
  let [stats, histories] = await Promise.all([
    getStats(packages),
    getHistories(packages),
  ]);

  return { stats, histories };
}

export function getQP(transition: Transition): string {
  let qps = transition.to?.queryParams;

  if (!qps) return '';
  if (!('packages' in qps)) return '';

  let packages = qps['packages'];

  if (typeof packages !== 'string') return '';

  return packages || '';
}

