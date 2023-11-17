import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Colors,
  Legend,
  LinearScale,
  Tooltip,
} from 'chart.js';
import { modifier } from 'ember-modifier';
import { groupByMajor, type Grouped } from 'package-majors/utils';

import { DataTable } from './data-table';

import type { TOC } from '@ember/component/template-only';
import type { DownloadsResponse } from 'package-majors/types';

Chart.register(Colors, BarController, BarElement, CategoryScale, LinearScale, Legend, Tooltip);

function allMajors(data: FormattedData[]): string[] {
  let majors = new Set<string>();

  for (let datum of data) {
    for (let downloadStat of datum.downloads) {
      majors.add(downloadStat.major);
    }
  }

  return [...majors].sort();
}

const renderChart = modifier((element: HTMLCanvasElement, [data]: [FormattedData[]]) => {
  let chart = new Chart(element, {
    type: 'bar',
    data: {
      labels: allMajors(data),
      datasets: data.map((packageData) => {
        return {
          label: packageData.name,
          data: packageData.downloads,
          backgroundColor: '#8844cc',
        };
      }),
    },
    options: {
      responsive: true,
      plugins: {
        // colors: {
        //   forceOverride: true,
        // },
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
          },
        },
        legend: {
          labels: {
            color: 'white',
            font: {
              size: 16,
            },
          },
        },
      },
      scales: {
        y: { ticks: { color: 'white' } },
        x: {
          type: 'category',
          ticks: {
            color: 'white',
            callback: function (value: string | number) {
              return `v${this.getLabelForValue(value as number)}`;
            },
          },
        },
      },
      parsing: {
        xAxisKey: 'major',
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

  return () => chart.destroy();
});

const DataChart: TOC<{
  Args: {
    data: FormattedData[];
  };
}> = <template><canvas {{renderChart @data}}></canvas></template>;

interface FormattedData {
  name: string;
  downloads: Grouped;
}

function format(data: DownloadsResponse[]) {
  const grouped = data.map((datum) => {
    return {
      name: datum.package,
      downloads: groupByMajor(datum.downloads),
    };
  });

  return grouped;
}

export const Data: TOC<{
  Args: {
    data: {
      packages: string[];
      stats: DownloadsResponse[];
    };
  };
}> = <template>
  {{#if @data.stats}}
    {{#let (format @data.stats) as |formattedData|}}

      <DataChart @data={{formattedData}} />

    {{/let}}
  {{/if}}
</template>;
