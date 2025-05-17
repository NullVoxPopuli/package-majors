import { pageTitle } from 'ember-page-title';

import { IntroText } from '../components/intro-text';
import { Search } from '../components/search';

import type { TOC } from '@ember/component/template-only';
import type { QueryData } from 'package-majors/types';

function toTitle(packages: string[]) {
  return packages.join(', ');
}

  <template>
    {{pageTitle (toTitle @model.packages)}}

    <Search />

    {{outlet}}

    <IntroText />
  </template> satisfies TOC<{

  Args: {
    model: QueryData
  }
}>
