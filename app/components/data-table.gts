import type { Grouped } from './utils';
import type { TOC } from '@ember/component/template-only';

export const DataTable: TOC<{ Args: {
  data: Grouped;
}}> = <template>
  <table>
    <thead>
      <tr>
        <th>Major</th>
        <th>Downloads</th>
      </tr>
    </thead>
    <tbody>
      {{#each @data as |group|}}
        <tr>
          <td>
            {{group.major}}
          </td>
          <td>
            {{group.downloadCount}}
          </td>
        </tr>
      {{/each}}
    </tbody>
  </table>
</template>;
