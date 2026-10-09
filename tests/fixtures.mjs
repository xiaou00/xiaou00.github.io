import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { randomUUID } from 'node:crypto';
import { ROOT } from '../scripts/build.mjs';

// Test content is independent of the author's notebooks and always cleaned up.
export async function createNotebookFixture() {
  const folder = `test-notebooks-${randomUUID()}`;
  const root = join(ROOT, 'content/notes', folder);
  const paths = ['算术几何/算术几何笔记', '算术几何/理想与除子', '写作/数学写作与排版'];
  const cleanup = () => rm(root, { recursive: true, force: true });
  try {
    for (const path of paths) {
      const destination = join(root, `${path}.typ`);
      await mkdir(dirname(destination), { recursive: true });
      await writeFile(destination, await readFile(new URL(`./fixtures/${path.split('/').at(-1)}.typ`, import.meta.url)));
    }
  } catch (error) { await cleanup(); throw error; }
  return { folder, index: `${folder}/${paths[0]}`, ideals: `${folder}/${paths[1]}`, specimen: `${folder}/${paths[2]}`, cleanup };
}
