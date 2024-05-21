import validate from "validate-npm-package-name";

export const PACKAGES = `
###############
# Angular
###############
@angular/core

###############
# Ember
###############

# Official
ember-source
ember-data
ember-cli
@ember/test-helpers
@ember/test-waiters

# Community
ember-resources
ember-concurrency
@embroider/core
ember-intl
ember-bootstrap
ember-sortable
ember-electron

# we want people to stop using these
@ember/render-modifiers
ember-cli-mirage

###############
# Generic JS
###############
eslint
execa
npm
pnpm
rollup
typescript
vite
@yarnpkg/core
yarn
webpack

###############
# React
###############
react
next

###############
# Solid
###############
solid-js

###############
# Svelte
###############
svelte
@sveltejs/kit

###############
# Vue
###############
vue
nuxt

`
  .split("\n")
  .map((x) => x.trim())
  .filter(isPackage);

function isPackage(line) {
  if (!line) return false;
  if (line.startsWith("#")) return false;

  let result = validate(line);

  let hasProblem = result.errors || result.warnings;

  if (!hasProblem) return true;

  let problems = [...(result.errors || []), ...(result.warnings || [])];

  throw new Error(`Invalid package: ${line}\n${problems.join("\n")}`);
}
