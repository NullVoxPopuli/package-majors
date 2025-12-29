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
const isNotTotal = (x: IDC) => x.dataset.label !== 'total';
const isTotal = (x: IDC) => x?.dataset?.label === 'total';

/**
 * All the data is array-based, which is a little obnoxious for sorting and ordering
 */
function indexData(context: IDC) {
  if (!context) return [];

  const result = [];
  let dataForTotal;
  let total = 0;

  for (const dp of context.tooltip.dataPoints) {
    if (isNotTotal(dp)) {
      total += dp.parsed.y || 0;
    }
  }

  for (let i = 0; i < context.tooltip.dataPoints.length; i++) {
    const dataPoint = context.tooltip.dataPoints[i];

    const style = styleForColor(context, i);
    const isActive = dataPoint.element.active;
    const hasPercentage = isNotTotal(dataPoint);
    const value = dataPoint.parsed.y || 0;
    const percentage = ((value / total) * 100).toFixed(1);

    const data = {
      style,
      isActive,
      hasPercentage,
      label: dataPoint.dataset.label,
      formattedValue: dataPoint.formattedValue,
      percentage: hasPercentage ? ` (${percentage}%)` : 0,
    };

    if (isTotal(dataPoint)) {
      dataForTotal = data;
      continue;
    }

    result.push(data);
  }

  result.push(dataForTotal);

  return result;
}

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
          {{#each (indexData @context) as |data|}}
            <tr style={{data.style}} class="{{if data.isActive 'active'}}">
              <td><span></span></td>
              <td>{{data.label}}</td>
              <td>{{data.formattedValue}}</td>
              <td>
                {{#if data.hasPercentage}}
                  {{data.percentage}}
                {{/if}}
              </td>
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
