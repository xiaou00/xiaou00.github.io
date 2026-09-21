import { parseHTML } from 'linkedom';
import { discoverNoteFiles, noteUrl } from './note-paths.mjs';

export function objectIdentity(filename) {
  const match = /^(Schm|Stck|Drvd|Spct|Ring)\/((Schm|Stck|Drvd|Spct|Ring)(\d{4}))\.typ$/.exec(filename);
  if (!match || match[1] !== match[3] || match[4] === '0000') {
    throw new Error(`${filename}: 对象文件应形如 Schm/Schm0001.typ, 类别与目录一致, 编号为 0001..9999.`);
  }
  return { objectId: match[2], category: match[1], number: Number(match[4]), filename };
}

export function validateObjectId(id) {
  if (typeof id !== 'string' || !/^(Schm|Stck|Drvd|Spct|Ring)(?!0000)\d{4}$/.test(id)) {
    throw new Error(`无效的对象编号 "${id}", 请使用 Schm/Stck/Drvd/Spct/Ring + 四位编号 0001..9999.`);
  }
  return id;
}

export async function discoverObjectFiles(root) {
  const filenames = await discoverNoteFiles(root);
  filenames.forEach(objectIdentity);
  return filenames;
}

// Prefixes with the same display name share a single browsing section.
export function objectGroups({ categories }) {
  const groups = new Map();
  for (const [prefix, name] of Object.entries(categories)) {
    if (!groups.has(name)) groups.set(name, { id: prefix, name, prefixes: [] });
    groups.get(name).prefixes.push(prefix);
  }
  return [...groups.values()];
}

export const objectUrl = (site, id) => `${site.base}geopedia/${id}/`;
export const documentUrl = (site, entry) => entry.objectId ? objectUrl(site, entry.objectId) : noteUrl(site, entry.slug);
export const documentTitle = entry => entry.objectId ? `${entry.objectId} ${entry.title}` : entry.title;

// Parse compiled metadata, without evaluating Typst a second time.
export function objectMetadata(html, filename) {
  const { document } = parseHTML(`<html><body>${html}</body></html>`);
  const markers = [...document.querySelectorAll('[data-object-template]')];
  if (markers.length !== 1) throw new Error(`${filename}: 每个对象必须且只能调用一次 encyclopedia 模板.`);
  const marker = markers[0];
  const aliases = [...marker.querySelectorAll('[data-object-alias]')].map(alias => alias.textContent.replace(/\s+/g, ' ').trim());
  const title = marker.querySelector('[data-object-name]')?.textContent.trim();
  if (!title) throw new Error(`${filename}: 对象名称不能为空.`);
  return { aliases, title };
}

export function finishObject(entry) {
  const { document } = parseHTML(`<html><body>${entry.html}</body></html>`);
  const marker = document.querySelector('[data-object-template]');
  const name = marker.querySelector('[data-object-name]');
  // Typst may wrap an inline content argument in a paragraph.
  for (const paragraph of name.querySelectorAll(':scope > p')) paragraph.replaceWith(...paragraph.childNodes);
  entry.nameHtml = name.innerHTML;
  entry.introductionHtml = marker.querySelector('[data-object-introduction]').innerHTML;
  entry.aliases = [...marker.querySelectorAll('[data-object-alias]')].map(alias => alias.textContent.replace(/\s+/g, ' ').trim());
  entry.text = document.body.textContent.replace(/\s+/g, ' ').trim();
  marker.remove();
  entry.html = document.body.innerHTML;
}
