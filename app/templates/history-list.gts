import { pageTitle } from 'ember-page-title';
import { ExternalLink } from 'ember-primitives/components/external-link';

import type { TOC } from '@ember/component/template-only';

const ExamplePR = <template>
  <ExternalLink href="https://github.com/NullVoxPopuli/package-majors/pull/24">

  this example PR.
  </ExternalLink>
</template>;

const sort = (x: string[]) => [...x].sort();

  <template>
    {{pageTitle "Currently tracked packages"}}

    <p style="max-width: 400px; margin: 0 auto;">
      History for each packages is currently tracked manually in a cronjob.

      If you'd like to see a package's history tracked, please open a PR similar to <ExamplePR />
    </p>

    <div class="margin: 0 auto; text-align: center">
      <h2>Currently tracked packages</h2>

      <ul>
        {{#each (sort @model) as |packageName|}}
          <li>
            <a href="/q/h?packages={{packageName}}">{{packageName}}</a>
          </li>
        {{/each}}
      </ul>
    </div>
  </template> satisfies TOC<{
  Args: {
    model: string[]
  }
}>;
