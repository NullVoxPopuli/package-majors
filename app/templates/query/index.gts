import { LinkTo } from '@ember/routing';

import { hasHistory } from 'package-majors/utils';

import { Data } from './graphing/current';

import type { TOC } from '@ember/component/template-only';
import type { QueryData } from 'package-majors/types';

<template>
  <Data @data={{@model}} />

  {{#if (hasHistory @model.histories)}}
    <LinkTo @route="query.history" class="history-toggle">View History</LinkTo>
  {{/if}}
</template> satisfies TOC<{
  Args: {
    model: QueryData;
  };
}>;
