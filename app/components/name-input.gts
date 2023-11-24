import './name-input.css';

import type { TOC } from '@ember/component/template-only';

/**
 * Modified from:
 * https://codepen.io/enbee81/pen/GRJVgXj?editors=1100
 */
export const NameInput: TOC<{
  Args: {
    value?: string;
  };
}> = <template>
  <div class="input-group">
    <label class="input-group__label" for="packageNamesInput">Package Name</label>
    <input
      type="text"
      id="packageNamesInput"
      class="input-group__input"
      name="packageName"
      value={{@value}}
    />
  </div>


</template>;
