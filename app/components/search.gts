import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

import { Form } from 'ember-primitives';

import { NameInput } from './name-input';
import { ShowMinors } from './show-minors';
import { ShowOld } from './show-old';

import type RouterService from '@ember/routing/router-service';
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

      <div style="display: grid; gap: 0.5rem;">
        <ShowMinors checked={{this.last.minors}} />
        <ShowOld checked={{this.last.old}} />
      </div>
    </Form>
  </template>

  @service declare router: RouterService;

  get last() {
    let qps = this.router.currentRoute?.queryParams;
    let minors = qps?.['minors'];
    let packages = qps?.['packages'];
    let old = qps?.['old'];

    return {
      packages: packages ? `${packages}` : '',
      minors: minors ? `${minors}` : undefined,
      old: old ? `${old}` : undefined,
    };
  }

  updateSearch = (data: SearchFormData) => {
    let { packageName: packages, showMinors: minors, showOld: old } = data;

    this.router.transitionTo('query', {
      queryParams: {
        packages,
        minors,
        old,
      },
    });
  };
}
