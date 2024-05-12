import { pageTitle } from 'ember-page-title';
import Route from 'ember-route-template';

import type { QueryData } from 'package-majors/types';

export default Route<{
  Args: {
    queryData: QueryData
    histories: unknown;
  }
}>(
  <template>
    {{pageTitle "History"}}

    TODO
  </template>
);
