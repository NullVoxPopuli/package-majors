import { TOC } from '@ember/component/template-only';
import { TrackedObject } from 'tracked-built-ins';

import { modifier } from 'ember-modifier';
import { resource } from 'ember-resources';

const Clock = resource(({ on }) => {
  let time = new TrackedObject({ current: new Date() });
  let interval = setInterval(() => {
    time.current = new Date();
  }, 1000);

  on.cleanup(() => clearInterval(interval));

  let formatter = new Intl.DateTimeFormat('en-US', {
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric',
    hour12: false,
  });

  return () => formatter.format(time.current);
});

const textEffect = modifier(element => {
  console.log('TODO: a visual fancyness!');
});

const FancyText: TOC<{
  Blocks: {
    default: [];
  }
}> =
  <template>
    <span {{textEffect}}>{{yield}}</span>
  </template>;

const Welcome: TOC<{}> = <template>
  <header>
    <img src='/images/logo.png' width='50' height='50' alt='logo' />
    <h1>Welcome to <FancyText>Polaris</FancyText></h1>
  </header>
  <main>
    <div class='title'>
      <h2>Learning Resources</h2>
      <aside>The time is <span>{{Clock}}</span></aside>
    </div>
    <ul>
      <li>
        <a href="https://tutorial.glimdown.com">gjs Tutorial</a>
          <span>Get familiar with Ember's new file format, programming patterns, paradigms, and new way of thinking about reactivity</span>
      </li>
      <li>
      <a href="https://github.com/NullVoxPopuli/ember-resources/tree/main/docs/docs">Docs: Resources</a>
        <span>Learn about the new reactivity primitive</span>
        </li>
      <li>
        <a href="https://github.com/jmurphyau/ember-truth-helpers">ember-truth-helpers</a>
          <span>Additional template helpers (coming soon to Ember.js)</span>
      </li>
      <li>
        <a href="https://typescript.org">TypeScript</a><span>TypeScript always enabled, always optional</span>
      </li>
      <li>
        <a href="https://vitejs.dev/">Vite</a><span>* Coming soon by default</span>
      </li>
      <li>
        <a href="https://stackblitz.com/github/nullVoxPopuli/polaris-starter/tree/main"> StackBlitz </a>
        <span> Try it on StackBlitz</span>
      </li>

      <li>
        <a href="https://stackblitz.com/github/nullVoxPopuli/polaris-starter/tree/monorepo"> StackBlitz (mono-repo) </a>
        <span> Try the mono-repo version on StackBlitz</span>
      </li>

      <li>
        <a href="https://discord.gg/emberjs">Discord</a>
        <span>Join the community Discord</span>
      </li>
    </ul>

    <div class='footer'>
      <a href="https://github.com/NullVoxPopuli/polaris-starter/tree/main" class='github'>Fork Starter Project on GitHub</a>
    </div>
  </main>
</template>

export default Welcome;
