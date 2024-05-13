export interface DownloadsResponse {
  package: string;
  downloads: {
    [version: string]: number;
  };
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

export interface QueryData {
  packages: string[];
  stats: DownloadsResponse[];
  histories: Histories;
}

export interface HistoryData {
  current: { [packageName: string]: DownloadsResponse; }
  history: { [packageName: string]: HistoryResponse[]; }
}

export interface HistoryResponse {
  week: number;
  year: number;
  timestamp: string;
  response: DownloadsResponse;
}
