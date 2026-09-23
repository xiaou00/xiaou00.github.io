import { posix } from 'node:path';
import { compareNames, encodeNotePath, noteUrl } from '../scripts/note-paths.mjs';
import { documentTitle, documentUrl, objectGroups, objectUrl } from '../scripts/geopedia.mjs';

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
    <a class="wordmark" href="${href(site)}" aria-label="${e(site.title)} 首页">${e(site.title)}</a>
    <nav aria-label="主导航">
      <a href="${href(site)}" ${section === 'home' ? 'aria-current="page"' : ''}>首页</a>
      <a href="${href(site)}#writings" ${section === 'notes' ? 'aria-current="page"' : ''}>文稿</a>
      <a href="${href(site, 'geopedia/')}" ${section === 'geopedia' ? 'aria-current="page"' : ''}>GeoPedia</a>
    </nav>
  </div></header>`;
}

function footer(site) {
  return `<footer class="site-footer"><span>© ${new Date().getFullYear()} ${e(site.author)}</span><a href="#top" class="back-top">回到页首 ↑</a></footer>`;
}

function layout(site, { title, body, note = false, section = note ? 'notes' : 'home', path = '', dev = false }) {
  const canonical = site.url ? `<link rel="canonical" href="${e(new URL(href(site, path), site.url))}">` : '';
  return `<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${e(title ? `${title} - ${site.title}` : `${site.title} · 数学笔记`)}</title>
<meta name="description" content="${e(site.description)}"><meta name="theme-color" content="#ffffff">
<meta property="og:title" content="${e(title || site.title)}"><meta property="og:description" content="${e(site.description)}"><meta property="og:type" content="${note ? 'article' : 'website'}">
${canonical}<link rel="icon" type="image/svg+xml" href="${href(site, 'favicon.svg')}">
<link rel="preload" href="${href(site, 'fonts/serif-cn.woff2')}" as="font" type="font/woff2" crossorigin>
<link rel="stylesheet" href="${href(site, 'typst.css')}"><link rel="stylesheet" href="${href(site, 'style.css')}"><script src="${href(site, 'client.js')}" defer></script>
</head><body id="top" class="${note ? 'reading-page' : 'home-page'}"><a class="skip-link" href="#main">跳至正文</a>
${header(site, section)}${body}${footer(site)}${dev ? `<script src="${href(site, '__dev/client.js')}" defer></script>` : ''}</body></html>`;
}

function fileTree(site, notes) {
  const root = { directories: new Map(), files: [] };
  for (const note of notes) {
    const parts = note.slug.split('/');
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
  const render = directory => `<ul class="file-tree">${[...directory.directories.values()].sort((a, b) => compareNames(a.name, b.name)).map(child => `<li class="directory-node"><details data-directory="${e(child.path)}"><summary>${chevron}<span class="directory-name">${e(child.name)}</span></summary>${render(child)}</details></li>`).join('')}${directory.files.sort((a, b) => compareNames(a.title, b.title)).map(note => `<li class="file-node" data-file="${e(note.slug)}.typ" data-search="${e(`${note.slug}.typ ${note.text}`.toLocaleLowerCase())}"><a class="file-link" href="${noteUrl(site, note.slug)}"><span class="file-name">${e(note.title)}</span><span class="file-arrow">${arrow}</span></a></li>`).join('')}</ul>`;
  return render(root);
}

export function homePage(site, notes, dev) {
  return layout(site, { dev, body: `<main id="main">
    <section class="hero" aria-labelledby="hero-title">
      <div class="cover-wrap"><img src="${href(site, 'cover.png')}" width="1448" height="1086" alt="白发角色倚在白色沙发上读书的插画" fetchpriority="high" class="cover-image"></div>
      <div class="hero-intro">
        <h1 id="hero-title">${e(site.title)}</h1><p class="hero-description">数学笔记与思考 · ${e(site.author)}</p>
      </div>
    </section>
    <section id="writings" class="writings content-width" aria-labelledby="writings-title">
      <div class="directory-browser"><div class="directory-toolbar"><h2 id="writings-title">笔记目录</h2>
        <label class="search-field" data-directory-search hidden>${searchIcon}<input type="search" id="note-search" placeholder="查找笔记..." aria-label="搜索笔记" autocomplete="off"><kbd>/</kbd></label></div>
        <p id="search-status" class="sr-only" role="status" aria-live="polite"></p><nav aria-label="笔记文件目录">${fileTree(site, notes)}</nav>
        ${notes.length ? '<div class="empty-state" hidden><h3>没有找到笔记</h3><p>试试其他关键词, 或清除搜索.</p><button id="clear-search">查看全部笔记 ' + arrow + '</button></div>' : '<div class="directory-empty">这里还没有笔记.</div>'}
        <div class="directory-footer"><span data-file-count>${notes.length} 篇笔记</span><div class="directory-actions" hidden><button data-expand-all>全部展开</button><span aria-hidden="true">/</span><button data-collapse-all>全部折叠</button></div></div>
      </div>
    </section>
  </main>` });
}

export function notePage(site, note, notes, dev, schema = null) {
  const isObject = Boolean(note.objectId);
  const folder = isObject ? note.category : posix.dirname(note.slug);
  const prefixes = isObject ? objectGroups(schema).find(group => group.prefixes.includes(folder)).prefixes : [];
  const siblings = isObject ? notes.filter(other => prefixes.includes(other.category))
    .sort((a, b) => prefixes.indexOf(a.category) - prefixes.indexOf(b.category) || a.number - b.number)
    : notes.filter(other => posix.dirname(other.slug) === folder).sort((a, b) => compareNames(a.title, b.title));
  const index = siblings.indexOf(note);
  const previous = siblings[index - 1];
  const next = siblings[index + 1];
  const returnUrl = isObject ? href(site, 'geopedia/') : `${href(site)}#writings`;
  const returnTitle = isObject ? 'GeoPedia' : '笔记目录';
  const returnAttribute = isObject ? 'data-geopedia-return' : '';
  const paginationAttribute = isObject ? 'data-object-link' : '';
  const path = isObject ? `geopedia/${note.objectId}/` : `notes/${encodeNotePath(note.slug)}/`;
  const sourcePath = isObject ? `geopedia/${note.filename}` : `notes/${encodeNotePath(note.slug)}.typ`;
  const references = [
    { title: '本文引用', direction: 'outgoing', notes: note.outgoing },
    { title: '引用本文', direction: 'incoming', notes: note.incoming },
  ].filter(group => group.notes.length);
  return layout(site, { title: documentTitle(note), note: true, section: isObject ? 'geopedia' : 'notes', dev, path, body: `
  <div class="reading-progress" aria-hidden="true"><span></span></div><main id="main" class="reading-main content-width">
    <div class="breadcrumb"><a ${returnAttribute} href="${returnUrl}">${returnTitle}</a><span>/</span><span>${e(isObject ? `${schema.categories[note.category]} / ${note.objectId}` : note.slug.split('/').join(' / '))}</span></div>
    <header class="article-header">${isObject ? `<div class="article-notebook object-id">${e(note.objectId)}</div>` : note.notebook ? `<div class="article-notebook">${folderIcon}<span>${e(note.notebook)}</span></div>` : ''}
      <h1 class="${isObject ? 'object-name' : ''}">${isObject ? note.nameHtml : e(note.title)}</h1>
      ${isObject && note.introductionHtml ? `<div class="object-introduction">${note.introductionHtml}</div>` : ''}
    </header>
    <div class="reading-grid"><aside class="toc-aside"><details class="toc" open><summary>本篇目录</summary><nav aria-label="笔记目录"><ol>${note.toc.map(item => `<li class="toc-level-${item.level}"><a href="#${e(item.id)}">${e(item.text)}</a></li>`).join('')}</ol></nav></details>
      <a class="source-link" href="${href(site, `sources/${sourcePath}`)}" download><span>Typst 源文件</span><span aria-hidden="true">↓</span></a><button class="print-button" hidden>打印 / 保存 PDF <span aria-hidden="true">↗</span></button>
    </aside><div class="article-column"><article class="typst-content" aria-label="${e(note.title)}">${note.html}</article>
      <div class="article-bottom"><a ${returnAttribute} href="${returnUrl}">← 返回${returnTitle}</a></div>
      ${references.length ? `<section class="note-connections" aria-label="文稿与对象之间的引用">${references.map(group => `<div class="connection-group" data-direction="${group.direction}"><h2>${group.title}<span>${group.notes.length}</span></h2><ul>${group.notes.map(other => `<li><a href="${documentUrl(site, other)}"><span>${e(documentTitle(other))}</span>${arrow}</a></li>`).join('')}</ul></div>`).join('')}</section>` : ''}
      ${previous || next ? `<nav class="note-pagination" aria-label="${isObject ? '同类的相邻对象' : '同一笔记本的相邻笔记'}">
        ${previous ? `<a ${paginationAttribute} rel="prev" href="${documentUrl(site, previous)}"><span class="note-pagination-label">← 上一${isObject ? '个' : '篇'}</span><span>${e(documentTitle(previous))}</span></a>` : ''}
        ${next ? `<a ${paginationAttribute} rel="next" href="${documentUrl(site, next)}"><span class="note-pagination-label">下一${isObject ? '个' : '篇'} →</span><span>${e(documentTitle(next))}</span></a>` : ''}
      </nav>` : ''}
    </div></div>
  </main>` });
}

export function objectPage(site, object, objects, schema, dev) {
  return notePage(site, object, objects, dev, schema);
}

export function geopediaPage(site, objects, schema, dev) {
  const categories = objectGroups(schema).map(group => ({ ...group, objects: objects.filter(object => group.prefixes.includes(object.category)) }));
  return layout(site, { title: 'GeoPedia · 几何对象手册', section: 'geopedia', path: 'geopedia/', dev, body: `
    <main id="main" class="geopedia content-width">
      <header class="geopedia-heading"><h1>GeoPedia</h1><p>几何对象手册</p></header>
      <div class="object-browser">
        <form class="object-controls" hidden role="search" aria-label="检索几何对象">
          <label class="search-field">${searchIcon}<input type="search" name="q" placeholder="编号, 名称或关键词..." aria-label="搜索几何对象" autocomplete="off"></label>
          <div class="object-results-bar"><span data-object-count role="status" aria-live="polite">${objects.length} 个对象</span><button type="reset">清除搜索</button></div>
        </form>
        <nav class="object-category-nav" aria-label="按类别浏览">${categories.map(({ id, name, prefixes, objects }) => `<a href="#category-${id}"><span>${e(prefixes.join(' / '))}</span> ${e(name)}<small>${objects.length}</small></a>`).join('')}</nav>
        <div class="object-groups">${categories.map(({ id: code, name, prefixes, objects: group }) => {
          return `<section class="object-group" id="category-${code}" data-category="${code}" aria-labelledby="heading-${code}"><h2 id="heading-${code}"><span>${e(prefixes.join(' / '))}</span>${e(name)}<small>${group.length}</small></h2>
            ${group.length ? `<ul>${group.map(object => `<li data-object-row data-search="${e(`${object.objectId} ${object.category} ${name} ${object.title} ${object.aliases.join(' ')} ${object.text}`.normalize('NFKC').toLocaleLowerCase())}"><a data-object-link href="${objectUrl(site, object.objectId)}"><span class="object-id">${object.objectId}</span><span class="object-name">${object.nameHtml}</span>${arrow}</a></li>`).join('')}</ul>` : '<p class="object-category-empty">尚未收录对象.</p>'}</section>`;
        }).join('')}</div>
        <div class="object-no-results" hidden>没有找到对象. 试试其他关键词, 或清除搜索.</div>
      </div>
    </main>` });
}

export function notFoundPage(site, dev) {
  return layout(site, { title: '未找到文稿', dev, body: `<main id="main" class="not-found"><p class="eyebrow">404</p><h1>这一页, 尚未写下.</h1><p>文稿可能已移动, 或这个地址并不存在.</p><a href="${href(site)}#writings">回到笔记目录 ${arrow}</a></main>` });
}
