import Color from 'color';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Chart, colors } from '../setup-chart';

import type { IDC, ReshapedHistoricalData } from './util';

const formatter = new Intl.NumberFormat('en-US');

/**
 * Labels for the X-axis (time)
 */
function sortLabels(data: ReshapedHistoricalData) {
  let labels = new Set<string>();

  for (let byVersion of Object.values(data)) {
    for (let timeSeries of Object.values(byVersion)) {
      let keys = Object.keys(timeSeries);

      keys.forEach((key) => labels.add(key));
    }
  }

  return sortByWeek([...labels].map((x) => ({ week: x }))).map((x) => x.week);
}

/**
 * Most data entries contain YYYY, week #
 * But the last entry should be YYYY-MM-DD (today)
 */
export function sortByWeek<Datum extends { week: string }>(data: Datum[]) {
  return data.sort((a, b) => {
    // comma or hyphen?
    if (!a.week.includes('week') || !b.week.includes('week')) {
      if (a.week.includes('week')) return -1;
      if (b.week.includes('week')) return 1;

      return 0;
    }

    let aParts = a.week.split(', week ');
    let bParts = b.week.split(', week ');

    if (!aParts?.[0]) {
      return 1;
    }

    if (!bParts?.[0]) {
      return -1;
    }

    if (!aParts?.[1]) {
      return 1;
    }

    if (!bParts?.[1]) {
      return -1;
    }

    let year = parseInt(aParts[0], 10) - parseInt(bParts[0], 10);

    if (year === 0) {
      return parseInt(aParts[1], 10) - parseInt(bParts[1], 10);
    }

    return year;
  });
}

const increments = [0.1, 0.2, 0.3, 0.4, 0.5];

function datasetsFor(data: ReshapedHistoricalData) {
  let result = [];
  let packageNames = Object.keys(data);
  let numPackages = packageNames.length;

  function colorFor(packageName: string, version: string) {
    if (numPackages === 1) {
      let versions = Object.keys(data[packageName] || {});

      let i = versions.indexOf(version);
      let chosen = colors[i % colors.length];

      return new Color(chosen).rgb().string();
    }

    let i = packageNames.indexOf(packageName);
    let baseColor = colors[i % colors.length];

    let color = new Color(baseColor);

    let rand1 = Math.random() * increments.length;
    let rand2 = Math.random() * increments.length;
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    let inc1 = increments[Math.floor(rand1) % increments.length]!;
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    let inc2 = increments[Math.floor(rand2) % increments.length]!;

    color = rand1 < 2.5 ? color.saturate(inc1) : color.desaturate(inc1);
    color = rand2 < 2.5 ? color.lighten(inc2) : color.darken(inc2);

    return color.rgb().string();
  }

  for (let [packageName, byVersion] of Object.entries(data)) {
    for (let [version, byTime] of Object.entries(byVersion)) {
      let color = colorFor(packageName, version);

      result.push({
        label: `v${version}`,
        backgroundColor: color,
        pointHoverBorderWidth: 5,
        hoverBorderWidth: 7,
        borderColor: color,
        data: sortByWeek(
          Object.entries(byTime).map(([week, count]) => {
            return { week, count };
          })
        ),
      });
    }
  }

  return result;
}

export function createChart(
  element: HTMLCanvasElement,
  data: ReshapedHistoricalData,
  updateTooltip: (context: IDC) => void
) {
  let textColor = colorScheme.current === 'dark' ? 'white' : 'black';
  let gridColor = colorScheme.current === 'dark' ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0,0,0,0.1)';

  let labels = sortLabels(data);
  let datasets = datasetsFor(data);

  console.log({ labels, datasets });

  return new Chart(element, {
    type: 'line',
    data: {
      labels,
      datasets,
    },
    options: {
      clip: 8,
      maintainAspectRatio: false,
      responsive: true,
      interaction: {
        intersect: false,
        mode: 'dataset',
      },
      elements: {
        line: {
          borderWidth: 3,
          hoverBorderWidth: 6,
        },
      },
      plugins: {
        tooltip: {
          external: updateTooltip,
          enabled: false,
          // ignored
          mode: 'index',
          intersect: false,
          position: 'nearest',
          padding: 8,
          bodyFont: {
            size: 16,
          },
          callbacks: {
            footer: (items) => {
              let sum = 0;

              items.forEach((item) => {
                sum += item.parsed.y;
              });

              return `Total: ${formatter.format(sum)}`;
            },
          },
        },
        legend: {
          labels: {
            color: textColor,
            font: {
              size: 16,
            },
          },
        },
      },
      parsing: {
        xAxisKey: 'week',
        yAxisKey: 'count',
      },
      scales: {
        y: {
          ticks: { color: textColor },
          grid: {
            color: gridColor,
          },
        },
        x: {
          type: 'category',
          grid: {
            color: gridColor,
          },
          ticks: {
            color: textColor,
          },
        },
      },
      transitions: {
        show: {
          animations: {
            y: {
              from: 0,
            },
          },
        },
      },
    },
  });
}
