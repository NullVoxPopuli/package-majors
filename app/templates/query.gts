import { pageTitle } from 'ember-page-title';
import Route from 'ember-route-template';

import { IntroText } from '../components/intro-text';
import { Search } from '../components/search';

import type { QueryData } from 'package-majors/types';

function toTitle(packages: string[]) {
  return packages.join(', ');
}

export default Route<{
  Args: {
    model: QueryData
  }
}>(
  <template>
    {{pageTitle (toTitle @model.packages)}}

    <Search />

    {{outlet}}

    <IntroText />
  </template>
);
