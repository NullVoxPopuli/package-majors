import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';

import { Form } from 'ember-primitives';
import { RemoteData } from 'ember-resources/util/remote-data';
import { isDownloadsResponse, isError } from 'package-majors/utils';

import { NameInput } from './name-input';

import type { TOC } from '@ember/component/template-only';
import type { DownloadsResponse, } from 'package-majors/types';

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
