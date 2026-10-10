import { posix } from 'node:path';
import { discoverNoteFiles, noteUrl, validateNotePath } from './note-paths.mjs';

export function validateObjectTitle(title) {
  validateNotePath(title);
  if (!title.trim() || title.includes('/')) throw new Error('Encyclopedia titles cannot be blank or contain path separators.');
  return title.normalize('NFC');
}

// Keep the original title for display and URLs; only lookup ignores case.
export const objectTitleKey = title => validateObjectTitle(title).toLowerCase().normalize('NFC');

export function objectIdentity(filename) {
  validateNotePath(filename);
  if (!filename.endsWith('.typ')) throw new Error(`${filename}: Encyclopedia files must use the .typ extension.`);
  return {
    collection: 'pedia',
    title: validateObjectTitle(posix.basename(filename, '.typ')),
    slug: filename.slice(0, -4),
    filename,
  };
}

export async function discoverObjectFiles(root) {
  const filenames = await discoverNoteFiles(root);
  const titles = new Map();
  for (const filename of filenames) {
    const { title } = objectIdentity(filename);
    const key = objectTitleKey(title);
    if (titles.has(key)) throw new Error(`Duplicate encyclopedia title "${title}": ${titles.get(key)} and ${filename}. Titles must be globally unique, ignoring case.`);
    titles.set(key, filename);
  }
  return filenames;
}

export const objectUrl = (site, title) => `${site.base}pedia/${encodeURIComponent(validateObjectTitle(title))}/`;
export const documentUrl = (site, entry) => entry.collection === 'pedia' ? objectUrl(site, entry.title) : noteUrl(site, entry.slug);
