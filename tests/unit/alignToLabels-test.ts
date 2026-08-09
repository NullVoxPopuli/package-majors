import { module, test } from 'qunit';

import { alignToLabels } from 'package-majors/templates/query/graphing/history/chart';

const labels = ['2025, week 1', '2025, week 2', '2025, week 3', '2025-01-20'];

module('Unit | alignToLabels', () => {
  test('a version present for every label', (assert) => {
    const result = alignToLabels(
      {
        '2025, week 1': 1,
        '2025, week 2': 2,
        '2025, week 3': 3,
        '2025-01-20': 4,
      },
      labels
    );

    assert.deepEqual(result, [
      { week: '2025, week 1', count: 1 },
      { week: '2025, week 2', count: 2 },
      { week: '2025, week 3', count: 3 },
      { week: '2025-01-20', count: 4 },
    ]);
  });

  test('a version that appears late still lines up with the labels', (assert) => {
    const result = alignToLabels({ '2025, week 3': 3, '2025-01-20': 4 }, labels);

    assert.deepEqual(result, [
      { week: '2025, week 1', count: null },
      { week: '2025, week 2', count: null },
      { week: '2025, week 3', count: 3 },
      { week: '2025-01-20', count: 4 },
    ]);
  });

  test('a version that drops in and out keeps its gaps', (assert) => {
    const result = alignToLabels({ '2025, week 1': 1, '2025, week 3': 3 }, labels);

    assert.deepEqual(result, [
      { week: '2025, week 1', count: 1 },
      { week: '2025, week 2', count: null },
      { week: '2025, week 3', count: 3 },
      { week: '2025-01-20', count: null },
    ]);
  });

  test('a count of 0 is kept', (assert) => {
    const result = alignToLabels({ '2025, week 2': 0 }, ['2025, week 2']);

    assert.deepEqual(result, [{ week: '2025, week 2', count: 0 }]);
  });
});
