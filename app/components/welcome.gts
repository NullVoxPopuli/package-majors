import { TOC } from '@ember/component/template-only';

import { modifier } from 'ember-modifier';

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

  Information here

  What you can do

  New features

  Resources

  Docs (RFCs atm)
</template>

export default Welcome;
