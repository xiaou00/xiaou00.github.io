import { parseHTML } from 'linkedom';
import { noteIdentity, resolveNotePath } from './note-paths.mjs';
import { documentUrl, objectTitleKey, validateObjectTitle } from './pedia.mjs';

const noteTitleKey = title => title.normalize('NFC').toLowerCase().normalize('NFC');

function inspectLinks(html) {
  const { document } = parseHTML(`<html><head></head><body>${html}</body></html>`);
  const anchors = new Map([...document.querySelectorAll('[id]')].map(anchor => [anchor.id,
    anchor.matches('figure') ? anchor.querySelector('figcaption')?.textContent.trim() || anchor.id
      : /^H[1-6]$/.test(anchor.tagName) ? anchor.textContent.trim() || anchor.id : anchor.id]));
  const references = [...document.querySelectorAll('a[data-note], a[data-object]')].map(link => {
    const isObject = link.hasAttribute('data-object');
    return { isObject, file: link.getAttribute(isObject ? 'data-object' : 'data-note'),
      target: link.getAttribute('data-note-target') || '', auto: link.getAttribute('data-note-auto') === 'true' };
  });
  return { source: html, html: document.body.innerHTML, text: document.body.textContent.replace(/\s+/g, ' ').trim(), anchors, references };
}

// Cache immutable source data, not resolved links: changing/deleting a target
// must still update captions, missing references and backlinks in other notes.
export function resolveNoteLinks(notes, { base = '/' } = {}, objects = [], cache = new Map()) {
  const entries = [...notes, ...objects];
  const key = entry => entry.collection === 'pedia' ? `object:${objectTitleKey(entry.title)}` : `note:${entry.slug}`;
  const registry = new Map(entries.map(entry => [key(entry), entry]));
  const noteTitles = new Map();
  for (const note of notes) {
    const title = noteTitleKey(note.title);
    if (!noteTitles.has(title)) noteTitles.set(title, []);
    noteTitles.get(title).push(note);
  }
  for (const id of cache.keys()) if (!registry.has(id)) cache.delete(id);
  for (const entry of entries) {
    if (cache.get(key(entry))?.source !== entry.html) cache.set(key(entry), inspectLinks(entry.html));
  }
  const outgoing = new Map(entries.map(entry => [key(entry), new Set()]));
  const incoming = new Map(entries.map(entry => [key(entry), new Set()]));

  for (const note of entries) {
    const record = cache.get(key(note));
    const resolutions = record.references.map(({ isObject, file, target, auto }) => {
      const kind = isObject ? 'object' : 'note';
      const name = isObject ? 'Encyclopedia entry' : 'Note';
      const fail = message => { throw new Error(`${note.filename || `${note.slug}.typ`}: ${message}`); };
      if (!file.trim()) {
        return { missing: true, auto, caption: '', message: `${name} reference has no destination` };
      }
      let slug;
      let namedNote = false;
      // A bare name searches all notebooks; explicit paths keep their old meaning.
      const matches = !isObject && !file.includes('/') ? noteTitles.get(noteTitleKey(file)) : undefined;
      if (matches?.length > 1) {
        fail(`Ambiguous note title "${file}": ${matches.map(entry => entry.filename || `${entry.slug}.typ`).join(', ')}. Use an explicit path to choose a note.`);
      }
      try {
        if (!isObject && /^\.\.?\//.test(file) && note.collection === 'pedia') {
          throw new Error('Cross-collection references must use a path from the notes/ root.');
        }
        if (matches?.length) {
          slug = matches[0].slug;
          namedNote = true;
        } else {
          slug = isObject ? validateObjectTitle(file) : resolveNotePath(file, note.slug);
        }
      } catch (error) { fail(`Invalid reference path "${file}". ${error.message}`); }
      const destinationKey = `${kind}:${isObject ? objectTitleKey(slug) : slug}`;
      const destination = registry.get(destinationKey);
      if (!destination) {
        return { missing: true, auto, caption: isObject ? file : noteIdentity(`${slug}.typ`).title,
          message: `${name} does not exist or is unpublished` };
      }
      let caption = isObject || namedNote ? file : destination.title;
      if (target) {
        const label = cache.get(destinationKey).anchors.get(target);
        if (label === undefined) {
          if (isObject) return { missing: true, auto, caption: `${caption} / ${target}`,
            message: `${name} "${file}" has no label <${target}>` };
          fail(`${name} "${file}" has no label <${target}>.`);
        }
        caption += ` / ${label}`;
      }
      if (destination !== note) {
        outgoing.get(key(note)).add(destinationKey);
        incoming.get(destinationKey).add(key(note));
      }
      return { href: `${documentUrl({ base }, destination)}${target ? `#${encodeURIComponent(target)}` : ''}`, auto, caption };
    });
    const signature = JSON.stringify(resolutions);
    if (record.signature !== signature) {
      if (!resolutions.length) record.resolved = { html: record.html, text: record.text };
      else {
        const { document } = parseHTML(`<html><body>${record.html}</body></html>`);
        const links = [...document.querySelectorAll('a[data-note], a[data-object]')];
        resolutions.forEach((result, index) => {
          const link = links[index];
          if (result.missing) {
            const text = document.createElement('span');
            text.className = 'note-reference-missing';
            text.title = result.message;
            if (result.auto) text.textContent = result.caption;
            else text.append(...link.childNodes);
            link.replaceWith(text);
          } else {
            link.setAttribute('href', result.href);
            if (result.auto) link.textContent = result.caption;
            link.classList.add('note-reference');
            for (const attribute of ['data-note', 'data-object', 'data-note-target', 'data-note-auto']) link.removeAttribute(attribute);
          }
        });
        record.resolved = { html: document.body.innerHTML, text: document.body.textContent.replace(/\s+/g, ' ').trim() };
      }
      record.signature = signature;
    }
    Object.assign(note, record.resolved);
  }

  const order = new Map(entries.map((entry, index) => [key(entry), index]));
  const connected = keys => [...keys].sort((a, b) => order.get(a) - order.get(b)).map(id => registry.get(id));
  for (const note of entries) {
    note.outgoing = connected(outgoing.get(key(note)));
    note.incoming = connected(incoming.get(key(note)));
  }
  return notes;
}
