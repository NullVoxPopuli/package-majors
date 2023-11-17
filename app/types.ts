export interface DownloadsResponse {
  package: string;
  downloads: {
    [version: string]: number
  }
}

export interface ErrorResponse {
  error: string;
  statusCode: number;
}

export type DownloadsByMajor = [major: number, downloads: number][];
