import { module, test } from 'qunit';

import { sortByWeek } from 'package-majors/templates/query/graphing/history/chart';

module('Unit | sortByWeek', () => {
  test('handles 1, 10, 2', (assert) => {
    let result = sortByWeek([
      { week: '2025, week 1' },
      { week: '2025, week 10' },
      { week: '2025, week 2' },
    ]);

    assert.deepEqual(result, [
      { week: '2025, week 1' },
      { week: '2025, week 2' },
      { week: '2025, week 10' },
    ]);
  });

  test('multiple years', (assert) => {
    let result = sortByWeek([
      { week: '2025, week 1' },
      { week: '2025, week 10' },
      { week: '2025, week 2' },
      { week: '2024, week 2' },
      { week: '2024, week 10' },
    ]);

    assert.deepEqual(result, [
      { week: '2024, week 2' },
      { week: '2024, week 10' },
      { week: '2025, week 1' },
      { week: '2025, week 2' },
      { week: '2025, week 10' },
    ]);
  });

  test('handles YYYY-MM-DD', (assert) => {
    let result = sortByWeek([
      { week: '2025, week 1' },
      { week: '2025-02-24' },
      { week: '2025, week 2' },
    ]);

    assert.deepEqual(result, [
      { week: '2025, week 1' },
      { week: '2025, week 2' },
      { week: '2025-02-24' },
    ]);
  });
});
