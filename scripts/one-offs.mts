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

/**
 * Some packages spam npm with pre-releases every commit,
 * for the sake of keeping git storage low, we remove this information
 * because it's not actually used in any of the calculations.
 */
export async function removePrereleases() {
  let toUpdate = [];

  for await (let entry of fs.glob('public/history/**/*.json')) {
    if (entry.endsWith("manifest.json")) continue;
    toUpdate.push(entry);
  }

  console.log("Will update", toUpdate);
  await confirm();

  const { scrubIgnoredTags } = await import("./utils.mjs");

  for (let entry of toUpdate) {
    let content = await fs.readFile(entry, "utf8");
    let file = content.toString();
    let json = JSON.parse(file);

    scrubIgnoredTags(json);

    let data = JSON.stringify(json);

    await fs.writeFile(entry, data);
  }
}

//await removeWeek19();
await removePrereleases();
