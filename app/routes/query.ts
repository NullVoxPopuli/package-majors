import Route from '@ember/routing/route';

import type RouterService from '@ember/routing/router-service';

type Transition = ReturnType<RouterService['transitionTo']>;

function urlFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`;
}

const CACHE = new Map();

async function getStats(packageName: string) {
  if (CACHE.has(packageName)) {
    return CACHE.get(packageName);
  }

  let result = await fetch(urlFor(packageName)).then((response) => response.json());

  CACHE.set(packageName, result);

  return Object.freeze(result);
}

function getQP(transition: Transition): string {
  let qps = transition.to?.queryParams;

  if (!qps) return '';
  if (!('packages' in qps)) return '';

  let packages = qps['packages'];

  if (typeof packages !== 'string') return '';

  return packages || '';
}

export default class Query extends Route {
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
    }
  };

  async model(_: unknown, transition: Transition) {
    let rawPackages = getQP(transition);
    let packages = rawPackages
      .split(',')
      .map((str) => str.trim())
      .filter(Boolean);

    let stats = await Promise.all(
      packages.map((packageName) => {
        return getStats(packageName);
      })
    );

    return {
      packages,
      stats,
    };
  }
}
