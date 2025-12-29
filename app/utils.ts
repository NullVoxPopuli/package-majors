import semverCoerce from 'semver/functions/coerce';
import semverCompare from 'semver/functions/compare';
import getMajor from 'semver/functions/major';
import getMinor from 'semver/functions/minor';
import isValid from 'semver/functions/valid';

import type { DownloadsResponse, ErrorResponse, QueryData } from './types';

export type Grouped = ReturnType<typeof groupByMajor>;

export function versionComparator(a: number | string, b: number | string) {
  const semverA = semverCoerce(a);
  const semverB = semverCoerce(b);

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
  const copy = { ...downloads };

  const sortedVersions = Object.keys(downloads).sort(versionComparator);

  for (const version of sortedVersions) {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const downloadCount = downloads[version]!;

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

  for (const [, downloadCount] of Object.entries(downloads)) {
    total += downloadCount;
  }

  return total;
}

export function groupByMajor(downloads: DownloadsResponse['downloads']) {
  const groups: Record<number, number> = {};

  for (const [version, downloadCount] of Object.entries(downloads)) {
    if (!isValid(version)) {
      console.error(`${version} is invalid and will be omitted from the dataset.`);

      continue;
    }

    const major = getMajor(version);

    groups[major] ||= 0;
    groups[major] += downloadCount;
  }

  return Object.entries(groups).map(([major, downloadCount]) => {
    return { version: major, downloadCount };
  });
}

export function groupByMinor(downloads: DownloadsResponse['downloads']): Grouped {
  const groups: Record<string, number> = {};

  for (const [version, downloadCount] of Object.entries(downloads)) {
    if (!isValid(version)) {
      console.error(`${version} is invalid and will be omitted from the dataset.`);

      continue;
    }

    const major = getMajor(version);
    const minor = getMinor(version);
    const majorMinor = `${major}.${minor}`;

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

export function hasHistory(histories: QueryData['histories']) {
  return Object.values(histories).filter(Boolean).length > 0;
}

/**
 * Gets the default date cutoff (1 year ago from today) in YYYY-MM-DD format
 */
export function getDefaultDateCutoff(): string {
  const date = new Date();

  date.setFullYear(date.getFullYear() - 1);

  return date.toISOString().slice(0, 10);
}

/**
 * Normalizes a date value to YYYY-MM-DD format
 * Accepts Date objects, ISO strings, or already formatted YYYY-MM-DD strings
 */
export function normalizeDateString(value: string | Date | undefined): string {
  if (!value) return getDefaultDateCutoff();

  // If it's already in YYYY-MM-DD format, return as-is
  if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value)) {
    return value;
  }

  // Parse and convert to YYYY-MM-DD
  const date = new Date(value);

  if (isNaN(date.getTime())) {
    return getDefaultDateCutoff();
  }

  return date.toISOString().slice(0, 10);
}
