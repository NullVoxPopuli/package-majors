/* eslint-disable no-console, n/no-unsupported-features/node-builtins */
import fs from "node:fs/promises";
import path from "node:path";

import { confirm } from "node-confirm";

/**
 * Week 19 was mislabeled and is actually week 20
 * and week 20 is the same data as week 19
 */
async function removeWeek19() {
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
}

await removeWeek19();
