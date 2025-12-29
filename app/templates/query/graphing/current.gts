import Component from '@glimmer/component';
import { service } from '@ember/service';

import { modifier } from 'ember-modifier';
import { colorScheme } from 'ember-primitives/color-scheme';

import { createChart } from './current/chart';
import { format } from './current/util';

import type { FormattedData } from './current/util';
import type Settings from '#services/settings.ts';
import type { QueryData } from 'package-majors/types';

const renderChart = modifier(
  (element: HTMLCanvasElement, [data, sourceData]: [FormattedData[], QueryData]) => {
    const chart = createChart(element, data, sourceData);
    const update = () => chart.update();

    colorScheme.on.update(update);

    return () => {
      colorScheme.off.update(update);
      chart.destroy();
    };
  }
);

export class Data extends Component<{
  Args: {
    data: QueryData;
  };
}> {
  <template>
    {{#if @data.stats}}
      <div
        style="
          display: grid;
          min-width: 100%;
          grid-template-rows: min-content 1fr;
          max-height: 100dvh;
        "
      >
        <h3 style="margin-top: 0; position: absolute;">In the last week...</h3>
        <canvas {{renderChart this.formattedData @data}}></canvas>
      </div>
    {{/if}}
  </template>

  @service declare settings: Settings;

  get groupBy(): 'minors' | 'majors' {
    if (this.settings.minors) {
      return 'minors';
    }

    return 'majors';
  }

  get showOld(): boolean {
    return this.settings.old;
  }

  get formattedData() {
    return format(this.args.data.stats, this.groupBy, this.showOld);
  }
}
