import { readdir } from 'node:fs/promises';
import { extname, join } from 'node:path';
import { parseHTML } from 'linkedom';

export const stickerFolders = ['sticker', 'stickers'];
const extensions = ['.png', '.webp', '.gif', '.jpg', '.jpeg', '.svg', '.avif'];

export async function discoverStickers(root) {
  const files = [];
  for (const folder of stickerFolders) {
    let entries;
    try { entries = await readdir(join(root, folder), { withFileTypes: true }); }
    catch (error) { if (error.code === 'ENOENT') continue; throw error; }
    entries.sort((a, b) => extensions.indexOf(extname(a.name).toLowerCase()) - extensions.indexOf(extname(b.name).toLowerCase())
      || a.name.localeCompare(b.name));
    for (const entry of entries) {
      const extension = extname(entry.name);
      if (!entry.isFile() || /^[._]/.test(entry.name) || !extensions.includes(extension.toLowerCase())) continue;
      files.push({ name: entry.name, stem: entry.name.slice(0, -extension.length),
        source: join(root, folder, entry.name), path: `${folder}/${entry.name}` });
    }
  }
  return files;
}

export function resolveStickers(entries, site, files) {
  const names = new Map();
  for (const file of files) {
    for (const name of [file.name, file.stem]) if (!names.has(name)) names.set(name, file);
  }
  const used = new Set();
  for (const entry of entries) {
    if (!entry.html.includes('data-sticker')) continue;
    const { document } = parseHTML(`<html><body>${entry.html}</body></html>`);
    for (const image of document.querySelectorAll('img[data-sticker]')) {
      const name = image.getAttribute('data-sticker');
      const file = names.get(name);
      if (!file) throw new Error(`${entry.filename || entry.slug}: sticker 图片 "${name}" 不存在. 请放入项目根目录的 sticker/ 或 stickers/ 中.`);
      image.setAttribute('src', `${site.base}${file.path.split('/').map(encodeURIComponent).join('/')}`);
      image.removeAttribute('data-sticker');
      used.add(file);
    }
    entry.html = document.body.innerHTML;
  }
  return [...used];
}
