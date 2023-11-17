import getMajor from 'semver/functions/major';

import type { DownloadsResponse, ErrorResponse } from './types';

export type Grouped = ReturnType<typeof groupByMajor>;

export function groupByMajor(downloads: DownloadsResponse['downloads']) {
  let groups: Record<number, number> = {};

  for (let [version, downloadCount] of Object.entries(downloads)) {
    let major = getMajor(version);

    groups[major] ||= 0;
    groups[major] += downloadCount;
  }

  return Object.entries(groups).map(([major, downloadCount]) => {
    return { major, downloadCount }
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
