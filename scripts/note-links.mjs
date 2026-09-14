import { parseHTML } from 'linkedom';
import { noteIdentity, noteUrl, resolveNotePath } from './note-paths.mjs';

// All notes already exist here; resolving a cycle needs no recursive compilation.
export function resolveNoteLinks(notes, { base = '/' } = {}) {
  const registry = new Map(notes.map(note => [note.slug, note]));
  const documents = new Map(notes.map(note => [note.slug, parseHTML(`<html><head></head><body>${note.html}</body></html>`).document]));
  const outgoing = new Map(notes.map(note => [note.slug, new Set()]));
  const incoming = new Map(notes.map(note => [note.slug, new Set()]));

  for (const note of notes) {
    const document = documents.get(note.slug);
    for (const link of document.querySelectorAll('a[data-note]')) {
      const file = link.getAttribute('data-note');
      const fail = message => { throw new Error(`${note.slug}.typ: ${message}`); };
      let slug;
      try { slug = resolveNotePath(file, note.slug); } catch (error) { fail(`无效的引用路径 "${file}". ${error.message}`); }
      const target = link.getAttribute('data-note-target') || '';
      const destination = registry.get(slug);
      if (!destination) {
        // A deleted note must not keep the entire site on its previous build.
        // Preserve the author's text; restoring the source restores the link.
        const text = document.createElement('span');
        text.className = 'note-reference-missing';
        text.title = '笔记不存在或未公开';
        if (link.getAttribute('data-note-auto') === 'true') text.textContent = noteIdentity(`${slug}.typ`).title;
        else text.append(...link.childNodes);
        link.replaceWith(text);
        continue;
      }
      let caption = destination.title;
      if (target) {
        const anchor = documents.get(slug).getElementById(target);
        if (!anchor) fail(`笔记 "${file}" 中不存在标签 <${target}>.`);
        const label = anchor.matches('figure') ? anchor.querySelector('figcaption')?.textContent.trim() : /^H[1-6]$/.test(anchor.tagName) ? anchor.textContent.trim() : target;
        caption += ` / ${label || target}`;
      }
      link.setAttribute('href', `${noteUrl({ base }, destination.slug)}${target ? `#${encodeURIComponent(target)}` : ''}`);
      if (link.getAttribute('data-note-auto') === 'true') link.textContent = caption;
      link.classList.add('note-reference');
      for (const attribute of ['data-note', 'data-note-target', 'data-note-auto']) link.removeAttribute(attribute);
      if (destination !== note) {
        outgoing.get(note.slug).add(destination.slug);
        incoming.get(destination.slug).add(note.slug);
      }
    }
  }

  for (const note of notes) {
    const document = documents.get(note.slug);
    note.html = document.body.innerHTML;
    note.text = document.body.textContent.replace(/\s+/g, ' ').trim();
    note.outgoing = notes.filter(other => outgoing.get(note.slug).has(other.slug));
    note.incoming = notes.filter(other => incoming.get(note.slug).has(other.slug));
  }
  return notes;
}
