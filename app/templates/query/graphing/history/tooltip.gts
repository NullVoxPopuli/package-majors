import './styles.css';

import { assert } from '@ember/debug';
import { on } from '@ember/modifier';
import { htmlSafe as trusted } from '@ember/template';

import { arrow, autoPlacement, autoUpdate, computePosition, offset, shift } from '@floating-ui/dom';
import { modifier } from 'ember-modifier';
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

  let virtual = document.createElement('div');

  virtual.getBoundingClientRect = () => {
      let x = tooltip.caretX;
      let y = tooltip.caretY;

      return {
        x,
        y,
        top: y,
        left: x,
        bottom: y + 4,
        right: x + 4,
        width: 4,
        height: 4,
      } as const;
    };

  setHook(virtual);

}

function hide() {
  let el = document.querySelector('#history-chart-tooltip') as HTMLElement;

  if (!el): return;

    el.style.opacity = 0;
}

function queryCanvas() {
  const contextElement = document.querySelector('canvas');

  assert('[BUG]: Lost the context element', contextElement);

  return contextElement;
}

function styleForColor(context: IDC, i: number) {
  return trusted(`background: ${colorAt(context, i)};`);
}

function shiftOptions() {
  return {
    elementContext: queryCanvas(),
  }
}

function offsetOptions() {
  return {
    mainAxis: 8,
    elementContext: queryCanvas(),
  }
}

export const Tooltip: TOC<{
  Args: {
    context: IDC;
  };
}> = <template>
  <Popover @offsetOptions={{(offsetOptions)}} @shiftOptions={{(shiftOptions)}} as |p|>
    {{ (updatePosition @context p.setHook) }}
    <p.Content>
      <div class="arrow" {{p.arrow}}></div>
      <div id="history-chart-tooltip">
        <button type="button" class="close" aria-label="Close" {{on "click" hide}}>×</button>
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
              <tr class="{{if dataPoint.element.active 'active'}}">
                <td><span
                  style={{styleForColor @context i}}
                  ></span></td>
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
      </div>
    </p.Content>
  </Popover>
</template>;
