import { parseHTML } from 'linkedom';
import { noteIdentity, resolveNotePath } from './note-paths.mjs';
import { documentTitle, documentUrl, validateObjectId } from './geopedia.mjs';

// All notes already exist here; resolving a cycle needs no recursive compilation.
export function resolveNoteLinks(notes, { base = '/' } = {}, objects = [], sections = []) {
  const entries = [...notes, ...objects, ...sections];
  const key = entry => entry.objectId ? `object:${entry.objectId}` : `${entry.book ? 'book' : 'note'}:${entry.slug}`;
  const registry = new Map(entries.map(entry => [key(entry), entry]));
  const documents = new Map(entries.map(entry => [key(entry), parseHTML(`<html><head></head><body>${entry.html}</body></html>`).document]));
  const outgoing = new Map(entries.map(entry => [key(entry), new Set()]));
  const incoming = new Map(entries.map(entry => [key(entry), new Set()]));

  for (const note of entries) {
    const document = documents.get(key(note));
    for (const link of document.querySelectorAll('a[data-note], a[data-object], a[data-book]')) {
      const isObject = link.hasAttribute('data-object');
      const isBook = link.hasAttribute('data-book');
      const kind = isObject ? 'object' : isBook ? 'book' : 'note';
      const name = isObject ? '对象' : isBook ? '章节' : '笔记';
      const file = link.getAttribute(`data-${kind}`);
      const fail = message => { throw new Error(`${note.filename || `${note.slug}.typ`}: ${message}`); };
      let slug;
      try {
        if (!isObject && /^\.\.?\//.test(file) && (isBook ? !note.book : note.book || note.objectId)) {
          throw new Error(`跨分区引用请从 ${isBook ? 'books' : 'notes'}/ 根目录填写路径.`);
        }
        slug = isObject ? validateObjectId(file) : resolveNotePath(file, note.slug);
      } catch (error) { fail(`无效的引用路径 "${file}". ${error.message}`); }
      const target = link.getAttribute('data-note-target') || '';
      const destinationKey = `${kind}:${slug}`;
      const destination = registry.get(destinationKey);
      if (!destination) {
        // A deleted note must not keep the entire site on its previous build.
        // Preserve the author's text; restoring the source restores the link.
        const text = document.createElement('span');
        text.className = 'note-reference-missing';
        text.title = `${name}不存在或未公开`;
        if (link.getAttribute('data-note-auto') === 'true') text.textContent = isObject ? slug : noteIdentity(`${slug}.typ`).title;
        else text.append(...link.childNodes);
        link.replaceWith(text);
        continue;
      }
      let caption = documentTitle(destination);
      if (target) {
        const anchor = documents.get(destinationKey).getElementById(target);
        if (!anchor) fail(`${name} "${file}" 中不存在标签 <${target}>.`);
        const label = anchor.matches('figure') ? anchor.querySelector('figcaption')?.textContent.trim() : /^H[1-6]$/.test(anchor.tagName) ? anchor.textContent.trim() : target;
        caption += ` / ${label || target}`;
      }
      link.setAttribute('href', `${documentUrl({ base }, destination)}${target ? `#${encodeURIComponent(target)}` : ''}`);
      if (link.getAttribute('data-note-auto') === 'true') link.textContent = caption;
      link.classList.add('note-reference');
      for (const attribute of ['data-note', 'data-object', 'data-book', 'data-note-target', 'data-note-auto']) link.removeAttribute(attribute);
      if (destination !== note) {
        outgoing.get(key(note)).add(destinationKey);
        incoming.get(destinationKey).add(key(note));
      }
    }
  }

  for (const note of entries) {
    const document = documents.get(key(note));
    note.html = document.body.innerHTML;
    note.text = document.body.textContent.replace(/\s+/g, ' ').trim();
    note.outgoing = entries.filter(other => outgoing.get(key(note)).has(key(other)));
    note.incoming = entries.filter(other => incoming.get(key(note)).has(key(other)));
  }
  return notes;
}
