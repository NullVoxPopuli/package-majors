import fs from "node:fs/promises";
import path from "node:path";

import { ensureDir, pathExists } from "fs-extra/esm";

import type { DownloadResponse } from "../app/types.ts";

export const IGNORED_TAG_PREFIXES = ["alpha", "dev", "beta", "next", "rc", "unstable", "canary", "experimental", "insiders"];

let now = new Date();
let year = now.getUTCFullYear();
let week = getWeek(now);

export function urlFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`;
}

/**
 * Some libraries create a *ton* of in-progress versions.
 * (every commit, for example)
 */
export async function scrubIgnoredTags(snapshot: DownloadResponse) {
  for (let version of Object.keys(snapshot.downloads)) {
    let isIgnored = IGNORED_TAG_PREFIXES.some((tag) => version.includes(`-${tag}.`));

    if (isIgnored) {
      delete snapshot.downloads[version];
    }
  }

  return snapshot;
}

export async function getStats(packageName: string): Promise<DownloadResponse> {
  // eslint-disable-next-line n/no-unsupported-features/node-builtins
  let result = await fetch(urlFor(packageName)).then((response) => response.json());

  result = scrubIgnoredTags(result);

  return Object.freeze(result);
}

export async function storeSnapshot(packageName: string) {
  let snapshotPath = snapshotPathFor(packageName);

  let stats = await getStats(packageName);

  await fs.writeFile(
    snapshotPath,
    JSON.stringify({
      timestamp: now,
      year: year,
      week: week,
      response: stats,
    }),
  );
}

function snapshotPathFor(packageName: string) {
  return `./public/history/${packageName}/${year}/${week}.json`;
}

export async function updateManifest(packageName: string) {
  let snapshots = await getSnapshotPaths(packageName);
  let manifestPath = manifestPathFor(packageName);

  await fs.writeFile(
    manifestPath,
    JSON.stringify({
      lastUpdated: now,
      snapshots,
    }),
  );
}

async function getSnapshotPaths(packageName: string) {
  let paths = [];

  // eslint-disable-next-line n/no-unsupported-features/node-builtins
  for await (let entry of fs.glob("**/*.json", { cwd: `./public/history/${packageName}/` })) {
    paths.push(entry);
  }

  let snapshots = paths
    .filter((p) => !p.endsWith("manifest.json"))
    .map((p) => path.join(`/history/${packageName}/`, p));

  return snapshots;
}

/**
 * The files to generate
 *   ./public/history/{packageName}/manifest.json
 *   ./public/history/{packageName}/{year}/{weekNumber}.json
 */
export async function ensureDirs(packageName: string) {
  await ensureDir(`./public/history/${packageName}/${year}`);
}

export function manifestPathFor(packageName: string) {
  return `./public/history/${packageName}/manifest.json`;
}

export async function ensureManifest(packageName: string) {
  let manifest = manifestPathFor(packageName);

  if (await pathExists(manifest)) {
    return;
  }

  await fs.writeFile(manifest, "{}");
}

// https://www.geeksforgeeks.org/calculate-current-week-number-in-javascript/
export function getWeek(currentDate: Date): number {
  const januaryFirst = new Date(currentDate.getFullYear(), 0, 1);

  const daysToNextMonday = januaryFirst.getDay() === 1 ? 0 : (7 - januaryFirst.getDay()) % 7;

  const nextMonday = new Date(
    currentDate.getFullYear(),
    0,
    januaryFirst.getDate() + daysToNextMonday,
  );

  return currentDate < nextMonday
    ? 52
    : currentDate > nextMonday
      ? Math.ceil((currentDate - nextMonday) / (24 * 3600 * 1000) / 7)
      : 1;
}

let errors = [];

export async function tryGet(packageName: string, fn: () => Promise<void>) {
  try {
    await fn();
  } catch (e) {
    errors.push({ packageName, error: e });
  }
}

export function checkErrors() {
  if (errors.length) {
    console.error(errors);
    // eslint-disable-next-line n/no-process-exit
    process.exit(1);
  }
}
