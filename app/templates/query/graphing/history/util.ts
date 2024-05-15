export interface ReshapedHistoricalData {
  [packageName: string]: {
    [version: string]: {
      [yearWeek: string]: number; // downloadCount
    };
  };
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type  IDC = any;
