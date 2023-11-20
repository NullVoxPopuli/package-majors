// @ts-expect-error this does not provide types yet
import pageTitle from 'ember-page-title/helpers/page-title';
import { colorScheme } from 'ember-primitives/color-scheme';
import Route from 'ember-route-template';

import { Header } from '../components/header';
import { Search } from '../components/search';

function syncColorScheme() {
  if (colorScheme.current === 'dark') {
    document.body.classList.remove('theme-light');
    document.body.classList.add('theme-dark');
  } else {
    document.body.classList.remove('theme-dark');
    document.body.classList.add('theme-light');
  }
}

export default Route(
  <template>
    {{pageTitle "Downloads by Major"}}
    {{ (syncColorScheme) }}

    <div class="layout">
      <Header />

      <main>
        <Search />

        <p>
          Reveal problems users are having with upgrading to the next major. <br>
          Search for a package to see if its ecosystem has an upgrading problem.
        </p>

        {{outlet}}
      </main>
    </div>
  </template>
);
