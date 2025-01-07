import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

import { Form } from 'ember-primitives/components/form';

import { NameInput } from './name-input';
import { ShowMinors } from './show-minors';
import { ShowOld } from './show-old';

import type RouterService from '@ember/routing/router-service';
import type Settings from 'package-majors/services/settings';
import type { DownloadsResponse } from 'package-majors/types';

/**
 * This is triggered on every value change,
 * which we don't need for this app.
 * The early return makes it a normal submit,
 * so the <Form> abstraction is basically just doing the
 * `FormData` conversion for us.
 */
function handleSubmit(onChange: (data: SearchFormData) => void, data: unknown, eventType: string) {
  if (eventType !== 'submit') return;

  onChange(data as SearchFormData);
}

interface SearchFormData {
  packageName: string;
  showMinors?: 'on';
  showOld?: 'on';
}

export class Search extends Component<{
  Blocks: { default: [data: DownloadsResponse] };
}> {
  <template>
    <Form @onChange={{fn handleSubmit this.updateSearch}}>
      <NameInput @value={{this.last.packages}} />

      {{#if this.isNotViewingHistory}}
        <div style="display: grid; gap: 0.5rem;">
          <ShowMinors checked={{this.last.minors}} />
          <ShowOld checked={{this.last.old}} />
        </div>
      {{/if}}
    </Form>
  </template>

  @service declare settings: Settings;
  @service declare router: RouterService;

  get isNotViewingHistory() {
    return !this.router.currentRouteName?.includes('history');
  }

  // For the initial form values
  get last() {
    let { minors, packages, old } = this.settings;

    return {
      packages,
      minors,
      old,
    };
  }

  // keys don't match the form names 1:1
  // so that searching and debugging are a smidge easier.
  updateSearch = (data: SearchFormData) => {
    let { packageName: packages, showMinors: minors, showOld: old } = data;

    this.settings.updateQPs({
      packages,
      minors,
      old,
    });
  };
}
