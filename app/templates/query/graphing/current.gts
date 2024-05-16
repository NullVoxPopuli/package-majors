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

export class Data extends Component<{
  Args: {
    data: QueryData;
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

  get showOld(): boolean {
    let qps = this.router.currentRoute?.queryParams;

    return qps?.['old'] === 'on';
  }

  get formattedData() {
    return format(this.args.data.stats, this.groupBy, this.showOld);
  }
}
