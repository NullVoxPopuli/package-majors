import Route from '@ember/routing/route';

let data: string[];

export default class Query extends Route {
  async model() {
    if (data) { return data; }

    let response = await fetch('/packages-with-history.json');
    let json = await response.json();

    data = json;

    return data;
  }
}
