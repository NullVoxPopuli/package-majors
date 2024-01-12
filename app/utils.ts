import semverCoerce from 'semver/functions/coerce';
import semverCompare from 'semver/functions/compare';
import getMajor from 'semver/functions/major';
import getMinor from 'semver/functions/minor';
import isValid from 'semver/functions/valid';

import type { DownloadsResponse, ErrorResponse } from './types';

export type Grouped = ReturnType<typeof groupByMajor>;

export function versionComparator(a: number | string, b: number | string) {
  let semverA = semverCoerce(a);
  let semverB = semverCoerce(b);

  if (semverA === null) return -1;
  if (semverB === null) return 1;

  return semverCompare(semverA, semverB);
}

/**
 * Filters minimum downloads up until the first version that contains more than
 * `minDownloads`
 */
export function filterDownloads(
  downloads: DownloadsResponse['downloads'],
  minDownloads: number
): DownloadsResponse['downloads'] {
  // We must copy the object, becaues it's cached and long lived, se we can't mutate it.
  let copy = { ...downloads };

  let sortedVersions = Object.keys(downloads).sort(versionComparator);

  for (let version of sortedVersions) {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    let downloadCount = downloads[version]!;

    if (downloadCount < minDownloads) {
      delete copy[version];
    } else {
      break;
    }
  }

  return copy;
}

export function getTotalDownloads(downloads: DownloadsResponse['downloads']): number {
  let total = 0;

  for (let [, downloadCount] of Object.entries(downloads)) {
    total += downloadCount;
  }

  return total;
}

export function groupByMajor(downloads: DownloadsResponse['downloads']) {
  let groups: Record<number, number> = {};

  for (let [version, downloadCount] of Object.entries(downloads)) {
    if (!isValid(version)) {
      console.error(`${version} is invalid and will be omitted from the dataset.`);

      continue;
    }

    let major = getMajor(version);

    groups[major] ||= 0;
    groups[major] += downloadCount;
  }

  return Object.entries(groups).map(([major, downloadCount]) => {
    return { version: major, downloadCount };
  });
}

export function groupByMinor(downloads: DownloadsResponse['downloads']): Grouped {
  let groups: Record<string, number> = {};

  for (let [version, downloadCount] of Object.entries(downloads)) {
    if (!isValid(version)) {
      console.error(`${version} is invalid and will be omitted from the dataset.`);

      continue;
    }

    let major = getMajor(version);
    let minor = getMinor(version);
    let majorMinor = `${major}.${minor}`;

    groups[majorMinor] ||= 0;
    groups[majorMinor] += downloadCount;
  }

  return Object.entries(groups).map(([majorMinor, downloadCount]) => {
    return { version: majorMinor, downloadCount };
  });
}

export function isDownloadsResponse(data: unknown): data is DownloadsResponse {
  if (typeof data !== 'object') return false;
  if (data === null) return false;

  if (!('package' in data && 'downloads' in data)) return false;

  if (typeof data.downloads !== 'object') return false;
  if (data.downloads === null) return false;

  return true;
}

export function isError(data: unknown): data is ErrorResponse {
  if (typeof data !== 'object') return false;
  if (data === null) return false;

  return 'error' in data;
}
