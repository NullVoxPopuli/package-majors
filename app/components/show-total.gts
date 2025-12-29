import { Switch } from './switch';

import type { TOC } from '@ember/component/template-only';

export const ShowTotal: TOC<{
  Element: HTMLInputElement;
}> = <template>
  <Switch ...attributes name="showTotal">
    <:before>Hide Total</:before>
    <:after>Show Total</:after>
    <:label>
      Toggle showing the total downloads line
    </:label>
  </Switch>
</template>;
