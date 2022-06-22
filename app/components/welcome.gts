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
  <h1>Welcome to <FancyText>Polaris</FancyText></h1>

  Now: {{Clock}}<br>

  Information here

  What you can do

  New features

  Resources

  Docs (RFCs atm)
</template>

export default Welcome;
