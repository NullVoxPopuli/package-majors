import { PACKAGES } from './packages.mts';
import { ensureDir } from 'fs-extra/esm';

import {
  checkErrors,
  tryGet,
  ensureDirs,
  storeSnapshot,
  ensureManifest,
  updateManifest,
} from './utils.mts';

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

for (let packageName of PACKAGES) {
  await tryGet(packageName, async () => {
    await ensureDirs(packageName);
    await ensureManifest(packageName);
    await storeSnapshot(packageName);
    await updateManifest(packageName);
  });
}

checkErrors();
