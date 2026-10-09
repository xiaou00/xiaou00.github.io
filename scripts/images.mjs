import { readdir } from 'node:fs/promises';
import { extname, join } from 'node:path';
import { parseHTML } from 'linkedom';

const stickerFolders = ['sticker', 'stickers'];
const assetsFolders = ['assets'];
export const imageFolders = [...stickerFolders, ...assetsFolders];
const extensions = ['.png', '.webp', '.gif', '.jpg', '.jpeg', '.svg', '.avif'];

async function discoverImages(root, folders) {
  const files = [];
  async function visit(folder, prefix = '') {
    let entries;
    try { entries = await readdir(join(root, folder, prefix), { withFileTypes: true }); }
    catch (error) { if (error.code === 'ENOENT') return; throw error; }
    entries.sort((a, b) => extensions.indexOf(extname(a.name).toLowerCase()) - extensions.indexOf(extname(b.name).toLowerCase())
      || a.name.localeCompare(b.name));
    for (const entry of entries) {
      if (/^[._]/.test(entry.name)) continue;
      const name = prefix ? `${prefix}/${entry.name}` : entry.name;
      if (entry.isDirectory()) { await visit(folder, name); continue; }
      const extension = extname(entry.name);
      if (!entry.isFile() || !extensions.includes(extension.toLowerCase())) continue;
      files.push({ name, stem: name.slice(0, -extension.length),
        source: join(root, folder, name), path: `${folder}/${name}` });
    }
  }
  for (const folder of folders) await visit(folder);
  return files;
}

export const discoverStickers = root => discoverImages(root, stickerFolders);
export const discoverAssetsImages = root => discoverImages(root, assetsFolders);

function resolveImages(entries, site, files, kind, folders) {
  const attribute = `data-${kind}`;
  const names = new Map();
  for (const file of files) {
    for (const name of [file.name, file.stem]) if (!names.has(name)) names.set(name, file);
  }
  const used = new Set();
  for (const entry of entries) {
    if (!entry.html.includes(attribute)) continue;
    const { document } = parseHTML(`<html><body>${entry.html}</body></html>`);
    for (const image of document.querySelectorAll(`img[${attribute}]`)) {
      const name = image.getAttribute(attribute);
      const file = names.get(name);
      if (!file) throw new Error(`${entry.filename || entry.slug}: ${kind} image "${name}" was not found. Place it in ${folders.map(folder => `${folder}/`).join(' or ')} at the project root.`);
      image.setAttribute('src', `${site.base}${file.path.split('/').map(encodeURIComponent).join('/')}`);
      image.removeAttribute(attribute);
      used.add(file);
    }
    entry.html = document.body.innerHTML;
  }
  return [...used];
}

export const resolveStickers = (entries, site, files) => resolveImages(entries, site, files, 'sticker', stickerFolders);
export const resolveAssetsImages = (entries, site, files) => resolveImages(entries, site, files, 'assets-image', assetsFolders);
