import { ExternalLink } from 'ember-primitives';

export const Header = <template>
  <header>
    <ExternalLink class="github" href="https://github.com/NullVoxPopuli/package-majors">
      <img alt="" src="/images/github-logo.png" />
      GitHub
    </ExternalLink>

    <h1>Packages by Major</h1>

  </header>
  <style>

    header {
      display: flex;
      justify-content: space-between;
      position: fixed;
      background: white;
      top: 0;
      left: 0;
      right: 0;
      padding: 0.5rem;

      h1 {
        margin: 0;
        color: var(--github-font);
      }
    }

    a.github {
      align-items: center;
      color: var(--github-font);
      background: var(--github-bg);
      padding: 0.75rem 1rem;
      border-radius: 0.25rem;
      border: 1px solid var(--github-border);
      padding-right: 1rem;
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
