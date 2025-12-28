export interface ReshapedHistoricalData {
  [packageName: string]: {
    [version: string]: {
      [yearWeek: string]: number; // downloadCount
    };
  };
}

export interface TotalsByTime {
  [packageName: string]: {
    [yearWeek: string]: number; // total downloadCount
  };
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type IDC = any;
