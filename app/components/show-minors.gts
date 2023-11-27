import { Switch } from './switch';

import type { TOC } from '@ember/component/template-only';

export const ShowMinors: TOC<{
  Element: HTMLInputElement;
}> = <template>
  <Switch ...attributes name="showMinors" as |s|>
    <:before>Majors</:before>
    <:after>Minors</:after>
    <:label>
      Toggle showing minors or majors
    </:label>
  </Switch>
</template>;
