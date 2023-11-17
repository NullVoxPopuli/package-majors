// @ts-expect-error this does not provide types yet
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

import { Header } from '../components/header';
import { Search } from '../components/search';

export default Route(
  <template>
    {{pageTitle "Downloads by Major"}}

    <div class="layout">
      <Header />

      <main>
        <Search />

        {{outlet}}
      </main>
    </div>
  </template>
);
