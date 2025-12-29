/**
 * This file exiss mostly to abstract away the *massive* amount of config that is usually involved with creating charts (from any charting library).
 *
 * This allows the component/framework code to be more isolated so that viewers have a better idea of
 * what is Ember vs what is Chart.js vs what may be "Vanilla"
 */
import { colorScheme } from 'ember-primitives/color-scheme';
import { versionComparator } from 'package-majors/utils';

import { Chart, colors } from '../setup-chart';

import type { FormattedData } from './util';
import type { QueryData } from '#app/types.ts';

function sortLabels(data: FormattedData[]): string[] {
  const versions = new Set<string>();

  for (const datum of data) {
    for (const downloadStat of datum.downloads) {
      versions.add(downloadStat.version);
    }
  }

  return [...versions].sort(versionComparator);
}

export function createChart(
  element: HTMLCanvasElement,
  data: FormattedData[],
  sourceData: QueryData
) {
  // Chart.JS + Chrome does not support `currentColor` for label/tick colors.
  const textColor = colorScheme.current === 'dark' ? 'white' : 'black';
  const gridColor = colorScheme.current === 'dark' ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0,0,0,0.1)';

  return new Chart(element, {
    type: 'bar',
    data: {
      labels: sortLabels(data),
      datasets: data.map((packageData, i) => {
        const total = sourceData.stats.find((x) => x.package === packageData.name)?.total;

        return {
          label: packageData.name,
          data: packageData.downloads,
          backgroundColor: colors[i % colors.length],
          total,
        };
      }),
    },
    options: {
      maintainAspectRatio: false,
      responsive: true,
      plugins: {
        tooltip: {
          enabled: true,
          padding: 8,
          bodyFont: {
            size: 16,
          },
          callbacks: {
            title: (items) => {
              return items.map((i) => `v${i.label}`);
            },
            label: (context) => {
              if (!context.parsed.y) return void 0;

              const label = context.dataset.label || '';
              const value = context.parsed.y;
              // @ts-expect-error why is total missing?
              const total = context.dataset.total || 0;
              const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : '0.0';

              return `${label}: ${value.toLocaleString()} (${percentage}%)`;
            },
          },
        },
        legend: {
          labels: {
            color: textColor,
            font: {
              size: 16,
            },
          },
        },
      },
      scales: {
        y: {
          ticks: { color: textColor },
          grid: {
            color: gridColor,
          },
        },
        x: {
          type: 'category',
          grid: {
            color: gridColor,
          },
          ticks: {
            color: textColor,
            callback: function (value: string | number) {
              return `v${this.getLabelForValue(value as number)}`;
            },
          },
        },
      },
      parsing: {
        xAxisKey: 'version',
        yAxisKey: 'downloadCount',
      },
      transitions: {
        show: {
          animations: {
            y: {
              from: 0,
            },
          },
        },
      },
    },
  });
}
