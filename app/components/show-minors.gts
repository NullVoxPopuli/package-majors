import { StyledSwitch } from './switch';

import type { TOC } from '@ember/component/template-only';

export const ShowMinors: TOC<{
  Element: HTMLInputElement;
}> = <template>
  <StyledSwitch ...attributes name="showMinors">
    <:before>Majors</:before>
    <:after>Minors</:after>
    <:label>
      Toggle showing minors or majors
    </:label>
  </StyledSwitch>
</template>;
