/* eslint-disable no-console, n/no-unsupported-features/node-builtins */
import fs from "node:fs/promises";
import path from "node:path";

import { confirm } from "node-confirm";

async function updateManifests() {
  let { PACKAGES } = await import("./packages.mjs");
  let { updateManifest } = await import("./utils.mjs");

  for (let packageName of PACKAGES) {
    await updateManifest(packageName);
  }
}

/**
 * Week 19 was mislabeled and is actually week 20
 * and week 20 is the same data as week 19
 */
export async function removeWeek19() {
  let history = "public/history";

  let toRemove = [];

  for await (let entry of fs.glob("**/19.json", { cwd: history })) {
    let full = path.join(history, entry);

    toRemove.push(full);
  }

  console.log("Will delete", toRemove);

  await confirm();

  for (let entry of toRemove) {
    await fs.rm(entry);
  }

  await updateManifests();
}

//await removeWeek19();
let { updateList } = await import("./utils.mjs");

await updateList();
