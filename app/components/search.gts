import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

import { Form } from 'ember-primitives';

import { NameInput } from './name-input';

import type RouterService from '@ember/routing/router-service';
import type { DownloadsResponse, } from 'package-majors/types';

function handleSubmit(onChange: (data: SearchFormData) => void, data: unknown, eventType: string) {
    if (eventType !== 'submit') return;

  onChange(data as SearchFormData);
}

interface SearchFormData {
  packageName: string;
}

export class Search extends Component<{ Blocks: { default: [data: DownloadsResponse]}}> {
  <template>
    <Form @onChange={{fn handleSubmit this.updateSearch}}>
      <NameInput @value={{this.lastSubmitted}} />
    </Form>
  </template>;

  @service declare router: RouterService;

  get lastSubmitted() {
    return this.router.currentRoute?.queryParams?.[ 'packages' ] || '';
  }

  updateSearch = (data: SearchFormData) => {
    let packageNames = data.packageName;

    this.router.transitionTo('query', {
      queryParams: {
        packages: packageNames,
      }
    });
  }
}
