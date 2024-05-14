import { tracked } from '@glimmer/tracking';
import Service, { service } from '@ember/service';

import type RouterService from '@ember/routing/router-service';

type QPs = Record<string, string | number | undefined>;

export const HAS_HISTORY = Symbol('HISTORY');

const stringOr = <T, O>(x: T, y: O | undefined = undefined) => (x ? String(x) : y);

export default class Settings extends Service {
  @service declare router: RouterService;

  @tracked hasHistory = true;

  get queryParams(): QPs {
    return (this.router.currentRoute?.queryParams ?? {}) as QPs;
  }

  get packages() {
    return stringOr(this.queryParams['packages'], '');
  }

  get minors() {
    return stringOr(this.queryParams['minors']) === 'on';
  }

  get old() {
    return stringOr(this.queryParams['old']) === 'on';
  }

  get weeklyHistory() {
    return this.queryParams['weeklyHistory'] === 'on';
  }

  updateQPs(qps: QPs) {
    for (let [key, value] of Object.entries(qps)) {
      this.#setQP({ [key]: value });
    }
  }

  /**
   * Allows batching QP updates
   */
  #frame?: number;
  #qps?: QPs;
  #setQP = (qps: QPs) => {
    if (this.#frame) cancelAnimationFrame(this.#frame);

    this.#qps = {
      ...this.queryParams,
      ...this.#qps,
      ...qps,
    };

    this.#frame = requestAnimationFrame(() => {
      this.router.transitionTo({
        queryParams: this.#qps,
      });
    });
  };
}
