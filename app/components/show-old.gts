import { StyledSwitch } from './switch';

import type { TOC } from '@ember/component/template-only';

export const ShowOld: TOC<{
  Element: HTMLInputElement;
}> = <template>
  <StyledSwitch ...attributes name="showOld">
    <:before>Hide &lt;1%</:before>
    <:after>Show &lt;1%</:after>
    <:label>
      Toggle showing versions with less than 1% of the total downloads.
    </:label>
  </StyledSwitch>
</template>;
