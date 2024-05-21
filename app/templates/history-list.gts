import { pageTitle } from 'ember-page-title';
import { ExternalLink } from 'ember-primitives/components/external-link';
import Route from 'ember-route-template';

const ExamplePR = <template>
  <ExternalLink href="https://github.com/NullVoxPopuli/package-majors/pull/24">
 
  this example PR.
  </ExternalLink>
</template>;

export default Route<{
  Args: {
    model: string[]
  }
}>(
  <template>
    {{pageTitle "Currently tracked packages"}}

    <p>
      History for each packages is currently tracked manually in a cronjob.

      If you'd like to see a package's history tracked, please open a PR similar to <ExamplePR />.
    </p>

    <h2>Currently tracked packages</h2>

    <ul>
    {{#each @model as |packageName|}}
      <li>
        <a href="/q/h?packages={{packageName}}">{{packageName}}</a>
      </li>
    {{/each}}
    </ul>
  </template>
);
