import Component from '@glimmer/component';
import { service } from '@ember/service';

import { modifier } from 'ember-modifier';
import { colorScheme } from 'ember-primitives/color-scheme';

import { createChart } from './current/chart';
import { format } from './current/util';

import type { FormattedData } from './current/util';
import type { TOC } from '@ember/component/template-only';
import type RouterService from '@ember/routing/router-service';
import type { QueryData } from 'package-majors/types';

const renderChart = modifier((element: HTMLCanvasElement, [data]: [FormattedData[]]) => {
  const chart = createChart(element, data);
  const update = () => chart.update();

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
  <canvas {{renderChart @data}}></canvas>
</template>;

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
        <DataChart @data={{this.formattedData}} />
      </div>
    {{/if}}
  </template>

  @service declare router: RouterService;

  get groupBy(): 'minors' | 'majors' {
    const qps = this.router.currentRoute?.queryParams;

    if (qps?.['minors'] === 'true' || qps?.['minors'] === 'on') {
      return 'minors';
    }

    return 'majors';
  }

  get showOld(): boolean {
    const qps = this.router.currentRoute?.queryParams;

    return qps?.['old'] === 'on' || qps?.['old'] === 'true';
  }

  get formattedData() {
    return format(this.args.data.stats, this.groupBy, this.showOld);
  }
}
