import Route from '@ember/routing/route';

let data: string[];

export default class Query extends Route {
  async model() {
    if (data) {
      return data;
    }

    const response = await fetch('/packages-with-history.json');
    const json = await response.json();

    data = json;

    return data;
  }
}
