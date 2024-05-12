import { ensureDir } from 'fs-extra/esm';

let now = new Date();
let year = now.getUTCFullYear();

export function urlFor(packageName: string) {
  return `https://api.npmjs.org/versions/${encodeURIComponent(packageName)}/last-week`;
}

async function ensureDirs(packageName: string) {
  await ensureDir(`./public/history/${packageName}`);
}


// https://www.geeksforgeeks.org/calculate-current-week-number-in-javascript/
export function getWeek(date: Date): number {
    const currentDate =
        (typeof date === 'object') ? date : new Date();
    const januaryFirst =
        new Date(currentDate.getFullYear(), 0, 1);
    const daysToNextMonday =
        (januaryFirst.getDay() === 1) ? 0 :
        (7 - januaryFirst.getDay()) % 7;
    const nextMonday =
        new Date(currentDate.getFullYear(), 0,
        januaryFirst.getDate() + daysToNextMonday);

    return (currentDate < nextMonday) ? 52 :
    (currentDate > nextMonday ? Math.ceil(
    (currentDate - nextMonday) / (24 * 3600 * 1000) / 7) : 1);
}

let errors = [];

export async function tryGet(fn: () => Promise<void>) {
  try {
    await fn();
  } catch (e) {
     errors.push({ packageName, error: e });});
  }
}


export function checkErrors() {
if (errors.length) {
  console.error(errors);
  process.exit(1);
}
}
