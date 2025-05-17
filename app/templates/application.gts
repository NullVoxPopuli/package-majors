import { pageTitle } from 'ember-page-title';
import { colorScheme } from 'ember-primitives/color-scheme';
import { PortalTargets } from 'ember-primitives/components/portal-targets';

import { Header } from '../components/header';

function syncColorScheme() {
  if (colorScheme.current === 'dark') {
    document.body.classList.remove('theme-light');
    document.body.classList.add('theme-dark');
  } else {
    document.body.classList.remove('theme-dark');
    document.body.classList.add('theme-light');
  }
}

  <template>
    {{pageTitle "Downloads by Major"}}
    {{ (syncColorScheme) }}

    <div class="layout">
      <Header />

      <main>

        {{outlet}}

      </main>
    </div>
    <PortalTargets />
  </template>
