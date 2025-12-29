export interface VersionRecord {
  [version: string]: number;
}

export interface DownloadsResponse {
  package: string;
  downloads: VersionRecord;
}
export interface StatsForWeek {
  total: number;
  downloads: VersionRecord;
  package: string;
}

export interface ErrorResponse {
  error: string;
  statusCode: number;
}

export type DownloadsByMajor = [major: number, downloads: number][];

export interface PackageManifest {
  // Date timestamp
  lastUpdated: string;
  // urls
  snapshots: string[];
}

export type Histories = Record<string, PackageManifest | null>;

/**
 * Used by /q/?packages=...
 * (the index)
 *
 * Represents the data for the "Current" week graph
 */
export interface QueryData {
  packages: string[];
  stats: StatsForWeek[];
  histories: Histories;
}

export interface HistoryData {
  current: { [packageName: string]: DownloadsResponse };
  history: { [packageName: string]: HistoryResponse[] };
  totals?: { [packageName: string]: TotalDownloadsResponse };
}

export interface HistoryResponse {
  week: number;
  year: number;
  timestamp: string;
  response: DownloadsResponse;
}

export interface TotalDownloadsResponse {
  downloads: { day: string; downloads: number }[];
  start: string;
  end: string;
  package: string;
}
