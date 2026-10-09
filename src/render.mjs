import { posix } from 'node:path';
import { compareNames, encodeNotePath } from '../scripts/note-paths.mjs';
import { documentUrl } from '../scripts/geopedia.mjs';

export function escapeHtml(value = '') {
  return String(value).replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
}

const e = escapeHtml;
const arrow = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M4 12h15M13 5l7 7-7 7" stroke="currentColor" stroke-width="1.2"/></svg>';
const searchIcon = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><circle cx="10.5" cy="10.5" r="6.5" stroke="currentColor" stroke-width="1.4"/><path d="m16 16 5 5" stroke="currentColor" stroke-width="1.4"/></svg>';
const folderIcon = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M3 7V5.5A1.5 1.5 0 0 1 4.5 4H9l2 3h8.5A1.5 1.5 0 0 1 21 8.5v10a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 3 18.5V7Z" stroke="currentColor" stroke-width="1.2"/><path d="M3 8h18" stroke="currentColor" stroke-width="1.2"/></svg>';
const chevron = '<svg class="directory-chevron" viewBox="0 0 16 16" fill="none" aria-hidden="true"><path d="m6 3 5 5-5 5" stroke="currentColor" stroke-width="1.2"/></svg>';
const href = (site, path = '') => `${site.base}${path}`;

function header(site, section) {
  return `<header class="site-header"><div class="header-inner">
    <a class="wordmark" href="${href(site)}" aria-label="${e(site.title)} home">${e(site.title)}</a>
    <nav aria-label="Main navigation">
      <a href="${href(site)}" ${section === 'home' ? 'aria-current="page"' : ''}>Home</a>
      <a href="${href(site, 'notes/')}" ${section === 'notes' ? 'aria-current="page"' : ''}>Notes</a>
      <a href="${href(site, 'geopedia/')}" ${section === 'geopedia' ? 'aria-current="page"' : ''}>Encyclopedia</a>
    </nav>
  </div></header>`;
}

function footer(site) {
  return `<footer class="site-footer"><span>© ${new Date().getFullYear()} ${e(site.author)}</span><a href="#top" class="back-top">Back to top ↑</a></footer>`;
}

function layout(site, { title, body, note = false, section = note ? 'notes' : 'home', path = '', dev = false }) {
  const canonical = site.url ? `<link rel="canonical" href="${e(new URL(href(site, path), site.url))}">` : '';
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${e(title ? `${title} - ${site.title}` : `${site.title} · Personal website`)}</title>
<meta name="description" content="${e(site.description)}"><meta name="theme-color" content="#ffffff">
<meta property="og:title" content="${e(title || site.title)}"><meta property="og:description" content="${e(site.description)}"><meta property="og:type" content="${note ? 'article' : 'website'}">
${canonical}<link rel="icon" type="image/svg+xml" href="${e(href(site, site.favicon || 'favicon.svg'))}">
<link rel="preload" href="${href(site, 'fonts/serif.woff2')}" as="font" type="font/woff2" crossorigin>
<link rel="stylesheet" href="${href(site, 'typst.css')}"><link rel="stylesheet" href="${href(site, 'style.css')}"><script src="${href(site, 'client.js')}" defer></script>
</head><body id="top" class="${note ? 'reading-page' : 'home-page'}"><a class="skip-link" href="#main">Skip to content</a>
${header(site, section)}${body}${footer(site)}${dev ? `<script src="${href(site, '__dev/client.js')}" defer></script>` : ''}</body></html>`;
}

function fileTree(site, notes, { flat = false } = {}) {
  const root = { directories: new Map(), files: [] };
  for (const note of notes) {
    const parts = flat ? [] : note.slug.split('/');
    parts.pop();
    let current = root;
    let path = '';
    for (const part of parts) {
      path = path ? `${path}/${part}` : part;
      if (!current.directories.has(part)) current.directories.set(part, { name: part, path, directories: new Map(), files: [] });
      current = current.directories.get(part);
    }
    current.files.push(note);
  }
  const renderFile = note => `<li class="file-node" data-file="${e(`${note.slug}.typ`)}" data-search="${e(`${note.title} ${note.slug}.typ ${note.text || ''}`.normalize('NFKC').toLocaleLowerCase())}"><a class="file-link" href="${e(documentUrl(site, note))}"><span class="file-name">${e(note.title)}</span><span class="file-arrow">${arrow}</span></a></li>`;
  const render = directory => `<ul class="file-tree">${[...directory.directories.values()].sort((a, b) => compareNames(a.name, b.name)).map(child => `<li class="directory-node"><details data-directory="${e(child.path)}"><summary>${chevron}<span class="directory-name">${e(child.name)}</span></summary>${render(child)}</details></li>`).join('')}${directory.files.sort((a, b) => compareNames(a.title, b.title)).map(renderFile).join('')}</ul>`;
  return render(root);
}

function directoryBrowser(site, entries, { encyclopedia = false } = {}) {
  const unit = encyclopedia ? 'entries' : 'notes';
  const singular = encyclopedia ? 'entry' : 'note';
  const name = encyclopedia ? 'Encyclopedia' : 'Notes';
  return `<div class="directory-browser" data-file-unit="${unit}" data-file-singular="${singular}"><div class="directory-toolbar"><h2>All ${unit}</h2>
    <label class="search-field" data-directory-search hidden>${searchIcon}<input type="search" id="note-search" placeholder="Search ${unit}..." aria-label="Search ${unit}" autocomplete="off"><kbd>/</kbd></label></div>
    <p id="search-status" class="sr-only" role="status" aria-live="polite"></p><nav aria-label="${name} directory">${fileTree(site, entries, { flat: encyclopedia })}</nav>
    ${entries.length ? `<div class="empty-state" hidden><h3>No ${unit} found</h3><p>Try another keyword or clear your search.</p><button id="clear-search">Show all ${unit} ${arrow}</button></div>` : `<div class="directory-empty">No ${unit} yet.</div>`}
    <div class="directory-footer"><span data-file-count>${entries.length} ${entries.length === 1 ? singular : unit}</span><div class="directory-actions" hidden><button data-expand-all>Expand all</button><span aria-hidden="true">/</span><button data-collapse-all>Collapse all</button></div></div>
  </div>`;
}

export function homePage(site, dev) {
  const profile = site.profile || {};
  return layout(site, { dev, body: `<main id="main" class="profile content-width">
    <header class="profile-intro">
      <p class="eyebrow">Personal website</p>
      <h1>${e(profile.name || site.author)}</h1>
      ${profile.role ? `<p class="profile-role">${e(profile.role)}</p>` : ''}
    </header>
    ${profile.about?.length ? `<section class="profile-section" aria-labelledby="about-title"><h2 id="about-title">About</h2><div class="profile-prose">${profile.about.map(paragraph => `<p>${e(paragraph)}</p>`).join('')}</div></section>` : ''}
    ${profile.interests?.length ? `<section class="profile-section" aria-labelledby="interests-title"><h2 id="interests-title">Interests</h2><ul class="profile-interests">${profile.interests.map(interest => `<li>${e(interest)}</li>`).join('')}</ul></section>` : ''}
    <section class="profile-section" aria-labelledby="explore-title"><h2 id="explore-title">Explore</h2><div class="profile-explore">
      <a href="${href(site, 'notes/')}"><h3>Notes</h3>${arrow}</a>
      <a href="${href(site, 'geopedia/')}"><h3>Encyclopedia</h3>${arrow}</a>
    </div></section>
    ${profile.links?.length ? `<section class="profile-section" aria-labelledby="links-title"><h2 id="links-title">Elsewhere</h2><ul class="profile-links">${profile.links.map(link => `<li><a href="${e(link.url)}">${e(link.label)} <span aria-hidden="true">↗</span></a></li>`).join('')}</ul></section>` : ''}
  </main>` });
}

export function notesPage(site, notes, dev) {
  return layout(site, { title: 'Notes', section: 'notes', path: 'notes/', dev, body: `
    <main id="main" class="collection content-width">
      <header class="collection-heading"><h1>Notes</h1></header>
      ${directoryBrowser(site, notes)}
    </main>` });
}

export function notePage(site, note, notes, dev) {
  const isObject = note.collection === 'geopedia';
  const folder = posix.dirname(note.slug);
  const siblings = notes.filter(other => isObject || posix.dirname(other.slug) === folder)
    .sort((a, b) => compareNames(a.title, b.title));
  const index = siblings.indexOf(note);
  const previous = siblings[index - 1];
  const next = siblings[index + 1];
  const returnUrl = isObject ? href(site, 'geopedia/') : href(site, 'notes/');
  const returnTitle = isObject ? 'encyclopedia' : 'notes';
  const path = isObject ? `geopedia/${encodeURIComponent(note.title)}/` : `notes/${encodeNotePath(note.slug)}/`;
  const sourcePath = `${isObject ? 'geopedia' : 'notes'}/${encodeNotePath(note.slug)}.typ`;
  const references = [
    { title: 'References', direction: 'outgoing', notes: note.outgoing },
    { title: 'Referenced by', direction: 'incoming', notes: note.incoming },
  ].filter(group => group.notes.length);
  return layout(site, { title: note.title, note: true, section: isObject ? 'geopedia' : 'notes', dev, path, body: `
  <div class="reading-progress" aria-hidden="true"><span></span></div><main id="main" class="reading-main content-width">
    <div class="breadcrumb"><a href="${returnUrl}">${returnTitle}</a><span>/</span><span>${e(isObject ? note.title : note.slug.split('/').join(' / '))}</span></div>
    <header class="article-header">${note.notebook ? `<div class="article-notebook">${folderIcon}<span>${e(note.notebook)}</span></div>` : ''}
      <h1>${e(note.title)}</h1>
    </header>
    <div class="reading-grid"><aside class="toc-aside"><details class="toc" open><summary>On this page</summary><nav aria-label="Table of contents"><ol>${note.toc.map(item => `<li class="toc-level-${item.level}"><a href="#${e(item.id)}">${e(item.text)}</a></li>`).join('')}</ol></nav></details>
      <a class="source-link" href="${href(site, `sources/${sourcePath}`)}" download><span>Typst source</span><span aria-hidden="true">↓</span></a><button class="print-button" hidden>Print / Save PDF <span aria-hidden="true">↗</span></button>
    </aside><div class="article-column"><article class="typst-content" aria-label="${e(note.title)}">${note.html}</article>
      <div class="article-bottom"><a href="${returnUrl}">← Back to ${returnTitle}</a></div>
      ${references.length ? `<section class="note-connections" aria-label="Connections">${references.map(group => `<div class="connection-group" data-direction="${group.direction}"><h2>${group.title}<span>${group.notes.length}</span></h2><ul>${group.notes.map(other => `<li><a href="${e(documentUrl(site, other))}"><span>${e(other.title)}</span>${arrow}</a></li>`).join('')}</ul></div>`).join('')}</section>` : ''}
      ${previous || next ? `<nav class="note-pagination" aria-label="${isObject ? 'Adjacent encyclopedia entries' : 'Adjacent notes'}">
        ${previous ? `<a rel="prev" href="${e(documentUrl(site, previous))}"><span class="note-pagination-label">← Previous</span><span>${e(previous.title)}</span></a>` : ''}
        ${next ? `<a rel="next" href="${e(documentUrl(site, next))}"><span class="note-pagination-label">Next →</span><span>${e(next.title)}</span></a>` : ''}
      </nav>` : ''}
    </div></div>
  </main>` });
}

export function geopediaPage(site, objects, dev) {
  return layout(site, { title: 'Encyclopedia', section: 'geopedia', path: 'geopedia/', dev, body: `
    <main id="main" class="collection content-width">
      <header class="collection-heading"><h1>Encyclopedia</h1></header>
      ${directoryBrowser(site, objects, { encyclopedia: true })}
    </main>` });
}

export function notFoundPage(site, dev) {
  return layout(site, { title: 'Page not found', dev, body: `<main id="main" class="not-found"><p class="eyebrow">404</p><h1>This page has not been written yet.</h1><p>The page may have moved, or the address may be incorrect.</p><a href="${href(site, 'notes/')}">Back to notes ${arrow}</a></main>` });
}
