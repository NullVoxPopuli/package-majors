import './date-cutoff.css';

import type { TOC } from '@ember/component/template-only';

/**
 * Component for selecting the historical date cutoff.
 * Defaults to 1 year ago from today.
 */
export const DateCutoff: TOC<{
  Args: {
    value?: string;
  };
}> = <template>
  <div class="date-cutoff">
    <label class="date-cutoff__label" for="dateCutoffInput">History Since</label>
    <input
      type="date"
      id="dateCutoffInput"
      class="date-cutoff__input"
      name="dateCutoff"
      value={{@value}}
    />
  </div>
</template>;
