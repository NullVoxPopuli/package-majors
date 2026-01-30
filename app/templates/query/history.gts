import { LinkTo } from '@ember/routing';

import { pageTitle } from 'ember-page-title';

import { Data } from './graphing/history';

import type { TOC } from '@ember/component/template-only';
import type { HistoryData } from '#app/types.ts';

<template>
  {{pageTitle "History"}}

  <Data @data={{@model}} />

  <LinkTo @route="query" class="history-toggle">Back</LinkTo>
</template> satisfies TOC<{
  Args: {
    model: HistoryData;
  };
}>;
