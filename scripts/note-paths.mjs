import { readdir } from 'node:fs/promises';
import { join, posix } from 'node:path';

export const compareNames = new Intl.Collator('zh-CN', { numeric: true }).compare;

export function noteIdentity(filename) {
  const parent = posix.dirname(filename);
  return {
    title: posix.basename(filename, '.typ'),
    notebook: parent === '.' ? '' : posix.basename(parent),
  };
}

export function validateNotePath(slug) {
  if (typeof slug !== 'string' || !slug.split('/').every(part => /^[\p{L}\p{N}][\p{L}\p{N} ._-]*$/u.test(part))) {
    throw new Error('笔记路径请使用中文或英文字母, 数字, 空格, 点, 下划线或连字符, 用 / 分隔文件夹.');
  }
  return slug;
}

export function encodeNotePath(path) {
  return path.split('/').map(encodeURIComponent).join('/');
}

export function noteUrl(site, slug) {
  return `${site.base}notes/${encodeNotePath(slug)}/`;
}

export function resolveNotePath(file, from) {
  const path = file.replace(/\.typ$/, '');
  const relative = path.startsWith('./') || path.startsWith('../');
  const normalized = posix.normalize(relative ? posix.join(posix.dirname(from), path) : path.replace(/^\//, ''));
  return validateNotePath(normalized);
}

export async function discoverNoteFiles(root, prefix = '') {
  const files = [];
  let entries;
  try { entries = await readdir(join(root, prefix), { withFileTypes: true }); }
  catch (error) { if (error.code === 'ENOENT') return files; throw error; }
  for (const entry of entries.sort((a, b) => compareNames(a.name, b.name))) {
    if (entry.name.startsWith('_') || entry.name.startsWith('.')) continue;
    const path = prefix ? `${prefix}/${entry.name}` : entry.name;
    if (entry.isDirectory()) files.push(...await discoverNoteFiles(root, path));
    else if (entry.isFile() && entry.name.endsWith('.typ')) {
      validateNotePath(path.slice(0, -4));
      files.push(path);
    }
  }
  return files;
}
