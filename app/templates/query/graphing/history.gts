import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';

import { modifier } from 'ember-modifier';
import { colorScheme } from 'ember-primitives/color-scheme';

import { format } from './current/util';
import { createChart } from './history/chart';
import { Tooltip } from './history/tooltip';

import type { IDC, ReshapedHistoricalData, TotalsByTime } from './history/util';
import type Settings from 'package-majors/services/settings';
import type { DownloadsResponse, HistoryData } from 'package-majors/types';

const now = new Date();
const currentTime = now.toISOString().slice(0, 10);

/**
 * Reshapes the data fetched from the network
 * for chart.js' line graphs
 *
 * each line/data-set is a version (major)
 *   (this type of chart will not support minors, as it would be too busy.
 *    we probably could do it though if the data were filtered to have fewer lines some how
 *   )
 * y-axis is is download count (same as the main chart)
 * x-axis is time (unlike the main chart)
 * But this will be reshaped again for the graph.
 * Here, we want a stable sane shape that's for humans to understand,
 * as chart.js may not be used forever (but it's pretty good).
 *
 * Adding to the complication here, is that multiple packages
 * can be queried at the same time.
 * (Not decided here)
 * Each package should have its own color-range.
 * So maybe versions are each a range of the same color?
 */
function reshape(data: HistoryData): {
  versions: ReshapedHistoricalData;
  totals: TotalsByTime;
} {
  const { current, history, totals } = data;

  const versionsResult: ReshapedHistoricalData = {};
  const totalsResult: TotalsByTime = {};

  function addToResult(packageName: string, time: string, response: DownloadsResponse) {
    const formatted = format([response], 'majors', false);

    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const grouped = formatted[0]!.downloads;

    versionsResult[packageName] ||= {};

    for (const { version, downloadCount } of grouped) {
      versionsResult[packageName][version] ||= {};

      versionsResult[packageName][version][time] = downloadCount;
    }
  }

  for (const [packageName, snapshots] of Object.entries(history)) {
    for (const snapshot of snapshots) {
      const time = `${snapshot.year}, week ${snapshot.week}`;

      addToResult(packageName, time, snapshot.response);
    }
  }

  for (const [packageName, response] of Object.entries(current)) {
    addToResult(packageName, currentTime, response);
  }

  // Process totals data - only for weeks that exist in version data
  if (totals) {
    for (const [packageName, totalData] of Object.entries(totals)) {
      totalsResult[packageName] ||= {};

      // Get all weeks that exist for this package in the version data
      const existingWeeks = new Set<string>();
      const packageVersions = versionsResult[packageName];

      if (packageVersions) {
        for (const versionData of Object.values(packageVersions)) {
          for (const week of Object.keys(versionData)) {
            existingWeeks.add(week);
          }
        }
      }

      // Group downloads by week to match the version data
      if (totalData && totalData.downloads && existingWeeks.size > 0) {
        const weeklyTotals: { [week: string]: number } = {};

        for (const { day, downloads } of totalData.downloads) {
          const date = new Date(day);
          const year = date.getFullYear();
          const weekNumber = getWeekNumber(date);
          const weekKey = `${year}, week ${weekNumber}`;

          weeklyTotals[weekKey] = (weeklyTotals[weekKey] || 0) + downloads;
        }

        // Only add totals for weeks that exist in the version data
        for (const [week, total] of Object.entries(weeklyTotals)) {
          if (existingWeeks.has(week)) {
            totalsResult[packageName][week] = total;
          }
        }
      }
    }
  }

  return { versions: versionsResult, totals: totalsResult };
}

/**
 * Get the ISO week number for a date
 */
function getWeekNumber(date: Date): number {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const dayNum = d.getUTCDay() || 7;

  d.setUTCDate(d.getUTCDate() + 4 - dayNum);

  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);

  return weekNo;
}

const renderChart = modifier(
  (
    element: HTMLCanvasElement,
    [data, totals, updateTooltip, showTotal]: [
      ReshapedHistoricalData,
      TotalsByTime,
      (context: IDC) => void,
      boolean,
    ]
  ) => {
    const chart = createChart(element, data, totals, updateTooltip, showTotal);
    const update = () => chart.update();

    colorScheme.on.update(update);

    return () => {
      colorScheme.off.update(update);
      chart.destroy();
    };
  }
);

class DataChart extends Component<{
  Args: {
    data: ReshapedHistoricalData;
    totals: TotalsByTime;
    showTotal: boolean;
  };
}> {
  @tracked tooltipContext: IDC;
  updateTooltip = (context: IDC) => (this.tooltipContext = context);

  <template>
    <div
      style="
        display: grid;
        min-width: 100%;
        justify-content: center;
      "
    ><canvas {{renderChart @data @totals this.updateTooltip @showTotal}}></canvas></div>
    <Tooltip @context={{this.tooltipContext}} />
  </template>
}

class Data extends Component<{
  Args: {
    data: HistoryData;
  };
}> {
  @service declare settings: Settings;

  <template>
    {{#let (reshape @data) as |reshaped|}}
      <DataChart
        @data={{reshaped.versions}}
        @totals={{reshaped.totals}}
        @showTotal={{this.settings.showTotal}}
      />
    {{/let}}
  </template>
}

export { Data };
