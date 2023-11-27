import './switch.css';

import { assert } from '@ember/debug';
import { on } from '@ember/modifier';

import { Switch as StylelessSwitch } from 'ember-primitives';

import type { TOC } from '@ember/component/template-only';

function submit(event: Event) {
  let input = event.target;

  assert(`[BUG], Unexpected dom change`, input instanceof HTMLInputElement);

  input.closest('form')?.requestSubmit();
}

export const Switch: TOC<{
  Element: HTMLInputElement;
  Blocks: {
    before: [];
    label: [];
    after: [];
  };
}> = <template>
  <StylelessSwitch class="fun-switch" as |s|>
    {{#if (has-block "before")}}
      <span class="secondary-label">{{yield to="before"}}</span>
    {{/if}}

    <span>
      <s.Control {{on "click" submit}} ...attributes />
      <s.Label>
        <span class="sr-only">
          {{yield to="label"}}
        </span>
      </s.Label>
    </span>

    {{#if (has-block "after")}}
      <span class="secondary-label">{{yield to="after"}}</span>
    {{/if}}
  </StylelessSwitch>
</template>;
