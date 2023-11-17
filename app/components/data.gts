import { BarController, BarElement, CategoryScale, Chart, Colors, Legend,LinearScale, Tooltip } from "chart.js";
import { modifier } from 'ember-modifier';
import { groupByMajor, type Grouped } from 'package-majors/utils';

import { DataTable } from './data-table';

import type { TOC } from '@ember/component/template-only';
import type { DownloadsResponse } from 'package-majors/types';


Chart.register(
  Colors, BarController, BarElement, CategoryScale, LinearScale, Legend, Tooltip
);


const renderChart = modifier(( element: HTMLCanvasElement, [data]: [Grouped] ) => {
  let chart = new Chart(element, {
    type: 'bar',
    data: {
      labels: data.map(datum => `v${datum.major}.*`),
      datasets: [
        {
          label: 'Downloads by Major Version',
          data: data.map(datum => datum.downloadCount),
          backgroundColor: '#8844cc',
        }
      ]
    },
    options: {
      responsive: true,
      plugins: {
        tooltip: {
          enabled: true,
        },
        legend: {
            labels: {
                color: "white",
                font: {
                  size: 16
                }
            }
        },

      },
      scales: {
        y: { ticks: { color: 'white' } },
        x: { ticks: { color: 'white' } }
      },
      transitions: {
        show: {
          animations: {
            y: {
              from: 0
            }
          }
        }
      }
    }
  });

  return () => chart.destroy();
});

const DataChart: TOC<{
  Args: {
    data: Grouped;
  }
}> = <template>
  <canvas {{renderChart @data}}></canvas>
</template>;

export const Data: TOC<{
  Args: {
    data: DownloadsResponse;
  }
}> = <template>
  {{#let (groupByMajor @data.downloads) as |grouped|}}
    <details><summary>Data as a Table</summary>
      <DataTable @data={{grouped}} />
    </details>

    <DataChart @data={{grouped}} />
  {{/let}}
</template>;
