import Service, { service } from '@ember/service';

import { normalizeDateString } from 'package-majors/utils';

import type RouterService from '@ember/routing/router-service';

type QPs = Record<string, string | number | undefined>;

export const HAS_HISTORY = Symbol('HISTORY');

const stringOr = <T, O>(x: T, y: O | undefined = undefined) => (x ? String(x) : y);
const stringToBoolean = (x: unknown) => x === 'on' || x === 'true' || x === 'yes' || x === '1';

export default class Settings extends Service {
  @service declare router: RouterService;

  get queryParams(): QPs {
    return (this.router.currentRoute?.queryParams ?? {}) as QPs;
  }

  get packages() {
    return stringOr(this.queryParams['packages'], '');
  }

  get minors() {
    return stringToBoolean(stringOr(this.queryParams['minors']));
  }

  get old() {
    return stringToBoolean(stringOr(this.queryParams['old']));
  }

  get showTotal() {
    return stringToBoolean(stringOr(this.queryParams['showTotal']));
  }

  get dateCutoff() {
    const value = this.queryParams['dateCutoff'];

    return normalizeDateString(value as string | undefined);
  }

  updateQPs(qps: QPs) {
    for (const [key, value] of Object.entries(qps)) {
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
