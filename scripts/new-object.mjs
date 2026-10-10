import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createNote } from './new-note.mjs';

export const createObject = (root, title) => createNote(root, title, 'pedia');

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    const [title, ...extra] = process.argv.slice(2);
    if (!title || extra.length) throw new Error('Usage: npm run new:object -- "Entry title".');
    const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
    console.log(`Created ${await createObject(root, title)}; save to update the encyclopedia.`);
  } catch (error) {
    console.error(error.code === 'EEXIST' ? 'The entry already exists and was not overwritten.' : error.message);
    process.exitCode = 1;
  }
}
