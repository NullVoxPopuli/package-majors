import Color from 'color';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Chart, colors } from '../setup-chart';

import type { IDC, ReshapedHistoricalData, TotalsByTime } from './util';

/**
 * Labels for the X-axis (time)
 */
function sortLabels(data: ReshapedHistoricalData) {
  const labels = new Set<string>();

  for (const byVersion of Object.values(data)) {
    for (const timeSeries of Object.values(byVersion)) {
      const keys = Object.keys(timeSeries);

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

    const aParts = a.week.split(', week ');
    const bParts = b.week.split(', week ');

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

    const year = parseInt(aParts[0], 10) - parseInt(bParts[0], 10);

    if (year === 0) {
      return parseInt(aParts[1], 10) - parseInt(bParts[1], 10);
    }

    return year;
  });
}

const increments = [0.1, 0.2, 0.3, 0.4, 0.5];

function datasetsFor(data: ReshapedHistoricalData) {
  const result = [];
  const packageNames = Object.keys(data);
  const numPackages = packageNames.length;

  function colorFor(packageName: string, version: string) {
    if (numPackages === 1) {
      const versions = Object.keys(data[packageName] || {});

      const i = versions.indexOf(version);
      const chosen = colors[i % colors.length];

      return new Color(chosen).rgb().string();
    }

    const i = packageNames.indexOf(packageName);
    const baseColor = colors[i % colors.length];

    let color = new Color(baseColor);

    const rand1 = Math.random() * increments.length;
    const rand2 = Math.random() * increments.length;
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const inc1 = increments[Math.floor(rand1) % increments.length]!;
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const inc2 = increments[Math.floor(rand2) % increments.length]!;

    color = rand1 < 2.5 ? color.saturate(inc1) : color.desaturate(inc1);
    color = rand2 < 2.5 ? color.lighten(inc2) : color.darken(inc2);

    return color.rgb().string();
  }

  for (const [packageName, byVersion] of Object.entries(data)) {
    for (const [version, byTime] of Object.entries(byVersion)) {
      const color = colorFor(packageName, version);

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

const formatter = new Intl.NumberFormat('en-US');

export function createChart(
  element: HTMLCanvasElement,
  data: ReshapedHistoricalData,
  totals: TotalsByTime,
  updateTooltip: (context: IDC) => void,
  showTotal: boolean = true
) {
  const textColor = colorScheme.current === 'dark' ? 'white' : 'black';
  const gridColor = colorScheme.current === 'dark' ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0,0,0,0.1)';
  const annotationColor =
    colorScheme.current === 'dark' ? 'rgba(255, 255, 255, 0.5)' : 'rgba(0, 0, 0, 0.5)';

  const labels = sortLabels(data);
  const datasets = datasetsFor(data);

  // Add a line annotation for each package's total downloads
  if (showTotal) {
    const packageNames = Object.keys(totals);

    for (const packageName of packageNames) {
      const packageTotals = totals[packageName];

      if (!packageTotals) continue;

      // Create data points for the total line
      const totalPoints = sortByWeek(
        Object.entries(packageTotals).map(([week, count]) => {
          return { week, count };
        })
      );

      // Add the total as a dataset instead of annotation for better interactivity
      datasets.push({
        label: `total`,
        backgroundColor: 'rgba(128, 128, 128, 0.2)',
        borderColor: annotationColor,
        // @ts-expect-error this exists
        borderWidth: 2,
        borderDash: [10, 5],
        pointRadius: 0,
        pointHoverRadius: 4,
        pointHoverBorderWidth: 2,
        data: totalPoints,
        order: -1, // Draw on top
      });
    }
  }

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
              if (showTotal) return;

              let sum = 0;

              items.forEach((item) => {
                if (item.dataset.label?.includes('total')) return;

                sum += item.parsed.y ?? 0;
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
