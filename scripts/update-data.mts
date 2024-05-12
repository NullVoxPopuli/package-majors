import { PACKAGES } from './packages.mts';
import { ensureDir } from 'fs-extra/esm';

import { checkErrors, getWeek, tryGet, urlFor, ensureDirs } from './utils.mts';

/**
 * Requirements: Node 22
 * ------------------------------
 *
 * This script generates json files (snapshots the npm response)
 * in the following format:
 *
 * Manifest per package, which is updated weekly:
 *   ./public/history/{packageName}/manifest.json
 *
 * Each historical record:
 *   ./public/history/{packageName}/{year}/{weekNumber}.json
 *
 * The runtime knows about this convention, and can graph accordingly.
 *
 * Additionally, a GH Workflow will PR updates to this repo and automatically merge them.
 *
 * The only changes should ever be to the public folder
 * (no runnable code), so it should be safe.
 */

async function snapshotFor(packageName: string) {
  await ensureDirs(packageName);
}

for (let packageName of PACKAGES) {
  await tryGet(() => snapshotFor(packageName));
}

checkErrors();
