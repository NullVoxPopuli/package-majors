// @ts-expect-error this does not provide types yet
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

import Welcome from '../components/welcome';

export default Route(
  <template>
    {{pageTitle "PolarisStarter"}}

    <Welcome />

    {{outlet}}
  </template>
);
