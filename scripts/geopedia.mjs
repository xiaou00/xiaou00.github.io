import { posix } from 'node:path';
import { discoverNoteFiles, noteUrl, validateNotePath } from './note-paths.mjs';

export function validateObjectTitle(title) {
  validateNotePath(title);
  if (!title.trim() || title.includes('/')) throw new Error('Encyclopedia titles cannot be blank or contain path separators.');
  return title.normalize('NFC');
}

export function objectIdentity(filename) {
  validateNotePath(filename);
  if (!filename.endsWith('.typ')) throw new Error(`${filename}: Encyclopedia files must use the .typ extension.`);
  return {
    collection: 'geopedia',
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
    if (titles.has(title)) throw new Error(`Duplicate encyclopedia title "${title}": ${titles.get(title)} and ${filename}. Titles must be globally unique.`);
    titles.set(title, filename);
  }
  return filenames;
}

export const objectUrl = (site, title) => `${site.base}geopedia/${encodeURIComponent(validateObjectTitle(title))}/`;
export const documentUrl = (site, entry) => entry.collection === 'geopedia' ? objectUrl(site, entry.title) : noteUrl(site, entry.slug);
