import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

import { Form } from 'ember-primitives';

import { NameInput } from './name-input';
import { ShowMinors } from './show-minors';

import type RouterService from '@ember/routing/router-service';
import type { DownloadsResponse } from 'package-majors/types';

function handleSubmit(onChange: (data: SearchFormData) => void, data: unknown, eventType: string) {
  if (eventType !== 'submit') return;

  onChange(data as SearchFormData);
}

interface SearchFormData {
  packageName: string;
  showMinors?: 'on';
}

export class Search extends Component<{ Blocks: { default: [data: DownloadsResponse] } }> {
  <template>
    <Form @onChange={{fn handleSubmit this.updateSearch}}>
      <NameInput @value={{this.lastSubmitted}} />

      <ShowMinors checked={{this.lastShowingMinors}} />
    </Form>
  </template>

  @service declare router: RouterService;

  get lastShowingMinors() {
    let minors = this.router.currentRoute?.queryParams?.['minors'];

    if (!minors) return;

    return `${minors}`;
  }

  get lastSubmitted() {
    let packages = this.router.currentRoute?.queryParams?.['packages'];

    return packages ? `${packages}` : '';
  }

  updateSearch = (data: SearchFormData) => {
    let { packageName: packages, showMinors: minors } = data;

    this.router.transitionTo('query', {
      queryParams: {
        packages,
        minors,
      },
    });
  };
}
