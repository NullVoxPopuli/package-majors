import './header.css';

import { ThemeToggle } from '@universal-ember/preem';
import { ExternalLink } from 'ember-primitives';

import { Arrow } from './icons/fa/external-link';

export const Header = <template>
  <header>
    <div class="left">
      <ExternalLink class="github" href="https://github.com/NullVoxPopuli/package-majors">
        <img alt="" src="/images/github-logo.png" />
        GitHub
        <Arrow />
      </ExternalLink>
      <a href="/history-list">View history of...</a>
    </div>

    <div>
      <ThemeToggle />
    </div>
  </header>
</template>;
