import { LinkTo } from '@ember/routing';

import Route from 'ember-route-template';
import { hasHistory } from 'package-majors/utils';
import { on } from '@ember/modifier'

import { Data } from './graphing/current';

import type { QueryData } from 'package-majors/types';

function addWeek() {
  // TODO do something to change the week here
}

export default Route<{
  Args: {
    model: QueryData;
  };
}>(
  <template>
    <Data @data={{@model}} />

    {{#if (hasHistory @model.histories)}}
      {{!-- todo clean this up a bit, obviously --}}
      <button {{on 'click' addWeek}}> Add week </button>
      <LinkTo @route="query.history" class="history-toggle">View History Chart</LinkTo>
    {{/if}}
  </template>
);
