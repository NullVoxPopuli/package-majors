import './styles.css';

import { on } from '@ember/modifier';

import { autoPlacement, autoUpdate, computePosition } from '@floating-ui/dom';
import { modifier } from 'ember-modifier';

import type { IDC } from './util';
import type { TOC } from '@ember/component/template-only';

function colorAt(context: IDC, index: number) {
  return context.tooltip.labelColors[index].backgroundColor;
}

const updatePosition = modifier((element: HTMLElement, [context]) => {
  if (!context) return;

  const { tooltip } = context;

  const virtual = {
    getBoundingClientRect() {
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
      };
    },
    contextElement: document.querySelector('canvas').parentElement,
  };

  element.style.opacity = 1;

  const cleanup = autoUpdate(virtual, element, () => {
    computePosition(virtual, element, {
      strategy: 'fixed',
      middleware: [autoPlacement()],
    }).then(({ x, y }) => {
      element.style.top = `${y}px`;
      element.style.left = `${x}px`;
    });
  });

  return () => {
    cleanup();
    element.style.opacity = 0;
  };
});

function hide() {
  document.querySelector('#history-chart-tooltip').style.opacity = 0;
}

export const Tooltip: TOC<{
  Args: {
    context: IDC;
  };
}> = <template>
  <div id="history-chart-tooltip" {{updatePosition @context}}>
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
            <td><span style="background: {{colorAt @context i}}"></span></td>
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
</template>;
