export interface ReshapedHistoricalData {
  [packageName: string]: {
    [version: string]: {
      [yearWeek: string]: number; // downloadCount
    };
  };
}
