import { createHash, randomUUID } from 'node:crypto';
import { mkdir, readFile, rename, stat, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

// Typst needs OpenType files; reuse the exact fonts shipped to the browser.
// The content-addressed path also invalidates compiled diagrams on font edits.
export async function prepareTypstFonts(root) {
  const fonts = await Promise.all(['math', 'serif-cn'].map(async name => ({
    name, bytes: await readFile(join(root, 'public/fonts', `${name}.woff2`)),
  })));
  const hash = createHash('sha256').update('typst-fonts-v1');
  for (const { name, bytes } of fonts) hash.update(name).update(bytes);
  const directory = join(root, '.build/typst-fonts', hash.digest('hex'));
  await mkdir(directory, { recursive: true });
  for (const { name, bytes } of fonts) {
    const destination = join(directory, `${name}.otf`);
    try {
      if ((await stat(destination)).size > 0) continue;
    } catch (error) {
      if (error.code !== 'ENOENT') throw error;
    }
    const { default: decompress } = await import('wawoff2/decompress.js');
    const temporary = `${destination}.${randomUUID()}.tmp`;
    await writeFile(temporary, await decompress(bytes));
    await rename(temporary, destination);
  }
  return directory;
}
