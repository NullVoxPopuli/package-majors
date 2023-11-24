import { on } from '@ember/modifier';

import { cell } from 'ember-resources';

const key = 'majors_nullvoxpopuli__hide_prompt';
const showPrompt = cell(localStorage.getItem(key) !== 'true');

function hide() {
  localStorage.setItem(key, 'true');
  showPrompt.current = false;
}

export const IntroText = <template>
  {{#if showPrompt.current}}
    <p>
      Reveal problems users are having with upgrading to the next major.
      <br />
      Search for a package to see if its ecosystem has an upgrading problem.

      <span>
        <button type="button" {{on "click" hide}}>Hide this</button>
      </span>
    </p>
  {{/if}}
</template>;
