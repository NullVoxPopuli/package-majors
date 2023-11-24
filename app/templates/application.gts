// @ts-expect-error this does not provide types yet
import pageTitle from 'ember-page-title/helpers/page-title';
import { colorScheme } from 'ember-primitives/color-scheme';
import Route from 'ember-route-template';

import { Header } from '../components/header';
import { IntroText } from '../components/intro-text';
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
        <IntroText />

        {{outlet}}
      </main>
    </div>
  </template>
);
