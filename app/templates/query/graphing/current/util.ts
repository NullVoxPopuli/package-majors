import {
  filterDownloads,
  getTotalDownloads,
  groupByMajor,
  groupByMinor,
  type Grouped,
} from 'package-majors/utils';

import type { DownloadsResponse } from 'package-majors/types';

export interface FormattedData {
  name: string;
  downloads: Grouped;
}

export function format(data: DownloadsResponse[], groupBy: 'minors' | 'majors', showOld: boolean) {
  const grouped = data.map((datum) => {
    let dls = datum.downloads;

    if (!showOld) {
      const total = getTotalDownloads(dls);
      const onePercent = total * 0.01;

      dls = filterDownloads(dls, onePercent);
    }

    const downloads = groupBy === 'minors' ? groupByMinor(dls) : groupByMajor(dls);

    return {
      name: datum.package,
      downloads,
    };
  });

  return grouped;
}
