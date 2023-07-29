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
    <img src='/images/logo.png' width=50 height=50 />
    <h1>Welcome to <FancyText>Polaris</FancyText></h1>
    <aside>The time is <span>{{Clock}}</span></aside>
  </header>

  <h2>Learning Resources</h2>
  <ul>
    <li>
      <a href="https://tutorial.glimdown.com">gjs tutorial</a>
        <span>get familiar with Ember's new file format, programming patters, paradigms, and new way of thinking about reactivity.</span>
    </li>
    <li>
    <a href="https://github.com/NullVoxPopuli/ember-resources/tree/main/docs/docs">Docs: Resources</a>
      <span>learn about the new reactivity primitive</span>
      </li>
    <li>
      <a href="https://github.com/jmurphyau/ember-truth-helpers">ember-truth-helpers</a>
        <span>additional built in helpers coming to Ember.js</span>
    </li>
    <li>
      <a href="https://typescript.org">TypeScript</a><span>TypeScript always enabled, always optional</span>
    </li>
    <li>
      <a href="https://vitejs.dev/">Vite</a><span> Coming soon by default.</span>
    </li>
    <li>
      <a href="https://stackblitz.com/github/nullVoxPopuli/polaris-starter/tree/main"> StackBlitz </a>
      <span> Try it on StackBlitz</span>
    </li>

    <li>
      <a href="https://stackblitz.com/github/nullVoxPopuli/polaris-starter/tree/monorepo"> StackBlitz (mono-repo) </a>
      <span> Try the mono-repo version on StackBlitz</span>
    </li>
  </ul>

  <a href="https://github.com/NullVoxPopuli/polaris-starter/tree/main" class='github'>Fork Starter Project on GitHub</a>

</template>

export default Welcome;
