import { LinkTo } from '@ember/routing';

import { pageTitle } from 'ember-page-title';
import Route from 'ember-route-template';

import { Data } from './graphing/history';

import type { HistoryData } from 'package-majors/types';

export default Route<{
  Args: {
    model: HistoryData;
  };
}>(
  <template>
    {{pageTitle "History"}}

    <Data @data={{@model}} />

    <LinkTo @route="query">Back</LinkTo>
  </template>
);
