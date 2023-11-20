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
import { colorScheme } from 'ember-primitives/color-scheme';
import { groupByMajor, type Grouped } from 'package-majors/utils';

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

  return [...majors].sort((a, b) => Number(a) - Number(b));
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
            color: 'currentColor',
            font: {
              size: 16,
            },
          },
        },
      },
      scales: {
        y: { ticks: { color: 'currentColor' } },
        x: {
          type: 'category',
          ticks: {
            color: 'currentColor',
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

  let update = () => chart.update();

  colorScheme.on.update(update);

  return () => {
    colorScheme.off.update(update);
    chart.destroy();
  };
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
