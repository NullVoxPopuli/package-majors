import { pageTitle } from 'ember-page-title';
import Route from 'ember-route-template';

import { Data } from '../components/data/index';

import type { DownloadsResponse } from 'package-majors/types';

function toTitle(packages: string[]) {
  return packages.join(', ');
}

export default Route<{
  Args: {
    model: {
      packages: string[];
      stats: DownloadsResponse[];
    }
  }
}>(
  <template>
    {{pageTitle (toTitle @model.packages)}}

    <Data @data={{@model}} />
  </template>
);
