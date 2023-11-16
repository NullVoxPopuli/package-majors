// @ts-expect-error this does not provide types yet
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

import { Layout } from '../components/layout';

export default Route(
  <template>
    {{pageTitle "PolarisStarter"}}

    <Layout />

    {{outlet}}
  </template>
);
