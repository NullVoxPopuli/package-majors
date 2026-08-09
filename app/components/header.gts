import './header.css';

import { ExternalLink, ThemeToggle } from 'nvp.ui';

export const Header = <template>
  <header>
    <div class="left">
      <a href="/" aria-label="Home" title="Home">🏠</a>
      <ExternalLink class="github" href="https://github.com/NullVoxPopuli/package-majors">
        <img alt="" src="/images/github-logo.png" />
        GitHub
      </ExternalLink>
      <a href="/history-list">View history of...</a>
    </div>

    <div>
      <ThemeToggle />
    </div>
  </header>
</template>;
