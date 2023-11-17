import { ExternalLink } from 'ember-primitives';

import { Arrow } from './icons/fa/external-link';

export const Header = <template>
  <header>
    <ExternalLink class="github" href="https://github.com/NullVoxPopuli/package-majors">
      <img alt="" src="/images/github-logo.png" />
      GitHub
      <Arrow />
    </ExternalLink>

    <h1>Packages by Major</h1>
  </header>

  <style>
    header {
      display: flex;
      justify-content: space-between;
      background: rgb(40,40,40);
      font-size: 0.8rem;
      padding: 0.5rem;

      h1 {
        margin: 0;
        color: white;
      }
    }

    a.github {
      align-items: center;
      color: var(--github-font);
      background: var(--github-bg);
      padding: 0.25rem 1rem;
      border-radius: 0.25rem;
      border: 1px solid var(--github-border);
      display: grid;
      grid-auto-flow: column;
      gap: 0.5rem;
    }

    a.github img {
      mix-blend-mode: difference;
      max-height: 1.2rem;
    }

    a.github:hover {
      background: var(--github-hover);
    }
  </style>
</template>;
