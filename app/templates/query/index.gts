import { LinkTo } from '@ember/routing';

import Route from 'ember-route-template';
import { hasHistory } from 'package-majors/utils';

import { Data } from './graphing/current';

import type { QueryData } from 'package-majors/types';

export default Route<{
  Args: {
    model: QueryData;
  };
}>(
  <template>
    <Data @data={{@model}} />

    {{#if (hasHistory @model.histories)}}
      <LinkTo @route="query.history" class="history-toggle">View History</LinkTo>
    {{/if}}
  </template>
);
