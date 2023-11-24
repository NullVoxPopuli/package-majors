import './show-minors.css';

import { assert } from '@ember/debug';
import { on } from '@ember/modifier';

import { Switch } from 'ember-primitives';

function submit(event: Event) {
  let input = event.target;

  assert(`[BUG], Unexpected dom change`, input instanceof HTMLInputElement);

  input.closest('form')?.requestSubmit();
}

export const ShowMinors = <template>
  <Switch class="fun-switch" as |s|>
    <span class="secondary-label">Majors</span>

    <span>
      <s.Control name="showMinors" {{on "click" submit}} />
      <s.Label>
        <span class="sr-only">
          Toggle showing minors or majors
        </span>
      </s.Label>
    </span>

    <span class="secondary-label">Minors</span>
  </Switch>
</template>;
