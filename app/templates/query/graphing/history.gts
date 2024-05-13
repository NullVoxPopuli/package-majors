import { modifier } from "ember-modifier";
import { colorScheme } from "ember-primitives/color-scheme";

import { createChart } from "./history/chart";

import type { TOC } from '@ember/component/template-only';
import type { HistoryData } from "package-majors/types";

interface ReshapedHistoricalData {}

/**
  * Reshapes the data fetched from the network
  * for chart.js' line graphs
  */
function reshape(data: HistoryData): ReshapedHistoricalData[] {
}

const renderChart = modifier((element: HTMLCanvasElement, [data]: [ReshapedHistoricalData[]]) => {
  let chart = createChart(element, data);
  let update = () => chart.update();

  colorScheme.on.update(update);

  return () => {
    colorScheme.off.update(update);
    chart.destroy();
  };
});


const DataChart: TOC<{
  Args: {
    data: ReshapedHistoricalData[];
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


export const Data: TOC<{
  Args: {
    data: HistoryData;
  };
}> =
  <template>
    <DataChart @data={{reshape @data}} />
  </template>

