import './styles.css';

import { assert } from '@ember/debug';
import { htmlSafe as trusted } from '@ember/template';

import { Popover } from 'ember-primitives/components/popover';

import type { IDC } from './util';
import type { TOC } from '@ember/component/template-only';

function colorAt(context: IDC, index: number) {
  return context.tooltip.labelColors[index].backgroundColor;
}

function updatePosition(context: IDC, setHook: (element: IDC) => void) {
  if (!context) return;

  const { tooltip } = context;

  const arrowElement = document.querySelector('canvas')?.parentElement;

  assert('[BUG]: Lost the arrow element', arrowElement);

  const virtual = document.createElement('div');

  virtual.getBoundingClientRect = () => {
    const x = tooltip.caretX;
    const y = tooltip.caretY;

    return {
      x,
      y,
      top: y,
      left: x,
      bottom: y + 4,
      right: x + 4,
      width: 4,
      height: 4,
      toJSON() {
        return { _: 'not-implemented' };
      },
    } as const;
  };

  setHook(virtual);
}

function styleForColor(context: IDC, i: number) {
  return trusted(`--dataset-color: ${colorAt(context, i)};`);
}

const isZero = (x: IDC) => x?.tooltip?.opacity === 0;

export const Tooltip: TOC<{
  Args: {
    context: IDC;
  };
}> = <template>
  <Popover @offsetOptions={{8}} as |p|>
    {{updatePosition @context p.setReference}}
    <p.Content id="history-chart-tooltip" data-hidden={{isZero @context}}>
      <div class="arrow" {{p.arrow}}></div>
      <header>
        {{#each @context.tooltip.title as |title|}}
          {{title}}
        {{/each}}
      </header>
      <table>
        <thead>
          <tr>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {{#each @context.tooltip.dataPoints as |dataPoint i|}}
            <tr style={{styleForColor @context i}} class="{{if dataPoint.element.active 'active'}}">
              <td><span></span></td>
              <td>{{dataPoint.dataset.label}}</td>
              <td>{{dataPoint.formattedValue}}</td>
            </tr>
          {{/each}}
        </tbody>
      </table>

      <footer>
        {{#each @context.tooltip.footer as |foot|}}
          {{foot}}
        {{/each}}
      </footer>
    </p.Content>
  </Popover>
</template>;
