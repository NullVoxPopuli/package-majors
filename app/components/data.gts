import Component from '@glimmer/component';
import { service } from '@ember/service';

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
import { groupByMajor, groupByMinor, type Grouped, versionComparator } from 'package-majors/utils';

import type { TOC } from '@ember/component/template-only';
import type RouterService from '@ember/routing/router-service';
import type { DownloadsResponse } from 'package-majors/types';

Chart.register(Colors, BarController, BarElement, CategoryScale, LinearScale, Legend, Tooltip);

function sortLabels(data: FormattedData[]): string[] {
  let versions = new Set<string>();

  for (let datum of data) {
    for (let downloadStat of datum.downloads) {
      versions.add(downloadStat.version);
    }
  }

  return [...versions].sort(versionComparator);
}

const colors = ['#8844cc', '#44cc88', '#cc8844', '#cc4488', '#88cc44', '#4488cc'];

const renderChart = modifier((element: HTMLCanvasElement, [data]: [FormattedData[]]) => {
  let chart = new Chart(element, {
    type: 'bar',
    data: {
      labels: sortLabels(data),
      datasets: data.map((packageData, i) => {
        return {
          label: packageData.name,
          data: packageData.downloads,
          backgroundColor: colors[i % colors.length],
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
}> = <template>
  <div
    style="
  display: grid;
  min-width: 100%;
  justify-content: center;
  "
  ><canvas {{renderChart @data}}></canvas></div>
</template>;

interface FormattedData {
  name: string;
  downloads: Grouped;
}

function format(data: DownloadsResponse[], groupBy: 'minors' | 'majors') {
  const grouped = data.map((datum) => {
    let downloads =
      groupBy === 'minors' ? groupByMinor(datum.downloads) : groupByMajor(datum.downloads);

    return {
      name: datum.package,
      downloads,
    };
  });

  return grouped;
}

export class Data extends Component<{
  Args: {
    data: {
      packages: string[];
      stats: DownloadsResponse[];
    };
  };
}> {
  <template>
    {{#if @data.stats}}
      <DataChart @data={{this.formattedData}} />
    {{/if}}
  </template>

  @service declare router: RouterService;

  get groupBy(): 'minors' | 'majors' {
    let qps = this.router.currentRoute?.queryParams;

    if (qps?.['minors']) {
      return 'minors';
    }

    return 'majors';
  }

  get formattedData() {
    return format(this.args.data.stats, this.groupBy);
  }
}
