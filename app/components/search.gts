import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';

import { Form } from 'ember-primitives';
import { RemoteData } from 'ember-resources/util/remote-data';

import { NameInput } from './name-input';

import type { DownloadsResponse, ErrorResponse } from './types';
import type { TOC } from '@ember/component/template-only';

function handleSubmit(onChange: (data: SearchFormData) => void, data: unknown, eventType: string) {
    if (eventType !== 'submit') return;

  onChange(data as SearchFormData);
}

interface SearchFormData {
  packageName: string;
}

const SearchForm: TOC<{
  Args: {
    onChange: (data: SearchFormData) => void;
  }
}> =
<template>
  <Form @onChange={{fn handleSubmit @onChange}}>
    <NameInput />
  </Form>
</template>;

function urlFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`
}

function isDownloadsResponse(data: unknown): data is DownloadsResponse {
  if (typeof data !== 'object') return false;
  if (data === null) return false;

  if (!('package' in data && 'downloads' in data)) return false;

  if (typeof data.downloads !== 'object') return false;
  if (data.downloads === null) return false;

  return true;
}

function isError(data: unknown): data is ErrorResponse {
  if (typeof data !== 'object') return false;
  if (data === null) return false;

  return 'error' in data;
}

export class Search extends Component<{ Blocks: { default: [data: DownloadsResponse]}}> {
  <template>
    <SearchForm @onChange={{this.updateSearch}} />

    {{#if this.searchTerm}}
      {{#let (RemoteData (urlFor this.searchTerm)) as |request|}}
        {{#if request.isLoading}}
          Loading ...
        {{/if}}

        {{#if request.value}}

          {{#if (isDownloadsResponse request.value)}}
            {{yield request.value}}
          {{else if (isError request.value)}}
            Error: {{request.value.error}}
          {{else}}
            Unknown response:
            {{! @glint-expect-error }}
            {{request.value}}
          {{/if}}

        {{/if}}
      {{/let}}
    {{/if}}
  </template>;

  @tracked searchTerm = '';

  updateSearch = (data: SearchFormData) => {
    this.searchTerm = data.packageName;
  }
}
