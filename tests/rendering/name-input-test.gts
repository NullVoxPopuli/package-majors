import { tracked } from '@glimmer/tracking';
import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { NameInput } from 'package-majors/components/name-input';

module('Rendering | <NameInput>', function (hooks) {
  setupRenderingTest(hooks);

  class TestContext {
    @tracked value = 'initial value';
  }

  test('with an initial value', async function (assert) {
    const value = 'initial value';

    await render(<template><NameInput @value={{value}} /></template>);

    assert.dom('input').hasValue(value);
  });

  test('with a changing value', async function (assert) {
    const context = new TestContext();

    await render(<template><NameInput @value={{context.value}} /></template>);

    assert.dom('input').hasValue(context.value);

    context.value = 'changed';

    await settled();

    assert.dom('input').hasValue('changed');
  });
});
