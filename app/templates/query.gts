// @ts-expect-error this does not provide types yet
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

import { Data } from '../components/data';

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
