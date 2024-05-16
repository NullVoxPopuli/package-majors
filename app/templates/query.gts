import { pageTitle } from 'ember-page-title';
import Route from 'ember-route-template';

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

    {{outlet}}
  </template>
);
