import { BarController, BarElement, CategoryScale, Chart, Colors, Legend,LinearScale, Tooltip } from "chart.js";
import { modifier } from 'ember-modifier';
import getMajor from 'semver/functions/major';

import type { DownloadsByMajor,DownloadsResponse } from './types';
import type { TOC } from '@ember/component/template-only';

type Grouped = ReturnType<typeof groupByMajor>;

Chart.register(
  Colors, BarController, BarElement, CategoryScale, LinearScale, Legend, Tooltip
);

function groupByMajor(downloads: DownloadsResponse['downloads']) {
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

const DataTable: TOC<{ Args: {
  data: Grouped; 
}}> = <template>
  <table>
    <thead>
      <tr>
        <th>Major</th>
        <th>Downloads</th>
      </tr>
    </thead>
    <tbody>
      {{#each @data as |group|}}
        <tr>
          <td>
            {{group.major}}
          </td>
          <td>
            {{group.downloadCount}}
          </td>
        </tr>
      {{/each}}
    </tbody>
  </table>
</template>;

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
      plugins: {
        tooltip: {
          enabled: true,
        },
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
