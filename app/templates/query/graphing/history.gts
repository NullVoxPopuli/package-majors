import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { modifier } from 'ember-modifier';
import { colorScheme } from 'ember-primitives/color-scheme';

import { format } from './current/util';
import { createChart } from './history/chart';
import { Tooltip } from './history/tooltip';

import type { IDC, ReshapedHistoricalData } from './history/util';
import type { TOC } from '@ember/component/template-only';
import type { DownloadsResponse, HistoryData } from 'package-majors/types';

let now = new Date();
let currentTime = now.toISOString().slice(0, 10);

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
function reshape(data: HistoryData): ReshapedHistoricalData {
  let { current, history } = data;

  let result: ReshapedHistoricalData = {};

  function addToResult(packageName: string, time: string, response: DownloadsResponse) {
    let formatted = format([response], 'majors', false);
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    let grouped = formatted[0]!.downloads;

    result[packageName] ||= {};

    for (let { version, downloadCount } of grouped) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      result[packageName]![version] ||= {};
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      result[packageName]![version]![time] = downloadCount;
    }
  }

  for (let [packageName, snapshots] of Object.entries(history)) {
    for (let snapshot of snapshots) {
      let time = `${snapshot.year}, week ${snapshot.week}`;

      addToResult(packageName, time, snapshot.response);
    }
  }

  for (let [packageName, response] of Object.entries(current)) {
    addToResult(packageName, currentTime, response);
  }

  return result;
}

const renderChart = modifier((element: HTMLCanvasElement, [data, updateTooltip]: [ReshapedHistoricalData, (context: IDC) => void]) => {
  let chart = createChart(element, data, updateTooltip);
  let update = () => chart.update();

  colorScheme.on.update(update);

  return () => {
    colorScheme.off.update(update);
    chart.destroy();
  };
});

class DataChart extends Component<{
  Args: {
    data: ReshapedHistoricalData;
  };
}>{ 
  @tracked tooltipContext: IDC;
  updateTooltip = (context: IDC) => this.tooltipContext = context;

  <template>
    <div
      style="
        display: grid;
        min-width: 100%;
        justify-content: center;
      "
    ><canvas {{renderChart @data this.updateTooltip}}></canvas></div>
    <Tooltip @context={{this.tooltipContext}} />
  </template>
}

export const Data: TOC<{
  Args: {
    data: HistoryData;
  };
}> = <template><DataChart @data={{reshape @data}} /></template>;
