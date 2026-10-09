import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { validateNotePath } from './note-paths.mjs';
import { discoverObjectFiles, objectIdentity } from './geopedia.mjs';

export async function createNote(root, input, collection = 'notes') {
  const slug = validateNotePath(input.replace(/\.typ$/, ''));
  if (slug.split('/').some(part => part.startsWith('_') || part.startsWith('.'))) {
    throw new Error('New files and directories cannot start with _ or .; these names are reserved for unpublished drafts.');
  }
  if (collection === 'geopedia') {
    const { title } = objectIdentity(`${slug}.typ`);
    const files = await discoverObjectFiles(join(root, 'content/geopedia'));
    const existing = files.find(filename => objectIdentity(filename).title === title);
    if (existing) throw new Error(`Duplicate encyclopedia title "${title}": ${existing}. The existing file was not overwritten.`);
  }
  const template = `${'../'.repeat(slug.split('/').length)}template.typ`;
  const filename = `content/${collection}/${slug}.typ`;
  await mkdir(dirname(join(root, filename)), { recursive: true });
  await writeFile(join(root, filename), `#import "${template}": *\n\n#show: note\n\n`, { flag: 'wx' });
  return filename;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    const [input, ...extra] = process.argv.slice(2);
    if (!input || extra.length) throw new Error('Usage: npm run new:note -- "Notebook/Note title".');
    const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
    console.log(`Created ${await createNote(root, input)}; save to update the notes directory.`);
  } catch (error) {
    console.error(error.code === 'EEXIST' ? 'The note already exists and was not overwritten.' : error.message);
    process.exitCode = 1;
  }
}
