import { posix } from 'node:path';
import { compareNames, encodeNotePath, noteUrl } from '../scripts/note-paths.mjs';
import { documentTitle, documentUrl, objectUrl } from '../scripts/sheafpedia.mjs';

export function escapeHtml(value = '') {
  return String(value).replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
}

const e = escapeHtml;
export const star = '<svg viewBox="0 0 24 32" fill="currentColor" aria-hidden="true"><path d="M12 0l2.4 12.8L24 15l-9.6 2.2L12 32 9.6 17.2 0 15l9.6-2.2z"/></svg>';
const arrow = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M4 12h15M13 5l7 7-7 7" stroke="currentColor" stroke-width="1.2"/></svg>';
const searchIcon = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><circle cx="10.5" cy="10.5" r="6.5" stroke="currentColor" stroke-width="1.4"/><path d="m16 16 5 5" stroke="currentColor" stroke-width="1.4"/></svg>';
const folderIcon = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M3 7V5.5A1.5 1.5 0 0 1 4.5 4H9l2 3h8.5A1.5 1.5 0 0 1 21 8.5v10a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 3 18.5V7Z" stroke="currentColor" stroke-width="1.2"/><path d="M3 8h18" stroke="currentColor" stroke-width="1.2"/></svg>';
const fileIcon = '<svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M14 3H6a1 1 0 0 0-1 1v16a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V8l-5-5Z" stroke="currentColor" stroke-width="1.2"/><path d="M14 3v5h5M8 12h8M8 16h5" stroke="currentColor" stroke-width="1.2"/></svg>';
const chevron = '<svg class="directory-chevron" viewBox="0 0 16 16" fill="none" aria-hidden="true"><path d="m6 3 5 5-5 5" stroke="currentColor" stroke-width="1.2"/></svg>';
const pad = value => String(value).padStart(2, '0');
const href = (site, path = '') => `${site.base}${path}`;

function header(site, section) {
  return `<header class="site-header"><div class="header-inner">
    <a class="wordmark" href="${href(site)}" aria-label="${e(site.title)} 首页"><span class="brand-star">${star}</span><span>${e(site.title)}</span></a>
    <nav aria-label="主导航">
      <a href="${href(site)}" ${section === 'home' ? 'aria-current="page"' : ''}>首页</a>
      <a href="${href(site)}#writings" ${section === 'notes' ? 'aria-current="page"' : ''}>文稿</a>
      <a href="${href(site, 'sheafpedia/')}" ${section === 'sheafpedia' ? 'aria-current="page"' : ''}>sheafpedia</a>
    </nav><span class="header-author">${e(site.author)}<span class="tiny-star">${star}</span></span>
  </div></header>`;
}

function footer(site) {
  return `<footer class="site-footer"><a class="footer-brand" href="${href(site)}">${star}<span>${e(site.title)}</span></a><p>数学笔记 · 持续生长</p><span>© ${new Date().getFullYear()} ${e(site.author)}</span><a href="#top" class="back-top">回到页首 <span aria-hidden="true">↑</span></a></footer>`;
}

function layout(site, { title, body, note = false, section = note ? 'notes' : 'home', path = '', dev = false }) {
  const canonical = site.url ? `<link rel="canonical" href="${e(new URL(href(site, path), site.url))}">` : '';
  return `<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${e(title ? `${title} - ${site.title}` : `${site.title} · 数学笔记`)}</title>
<meta name="description" content="${e(site.description)}"><meta name="theme-color" content="#f8f5ef">
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
  const render = directory => `<ul class="file-tree">${[...directory.directories.values()].sort((a, b) => compareNames(a.name, b.name)).map(child => `<li class="directory-node"><details data-directory="${e(child.path)}"><summary>${chevron}${folderIcon}<span class="directory-name">${e(child.name)}</span></summary>${render(child)}</details></li>`).join('')}${directory.files.sort((a, b) => compareNames(a.title, b.title)).map(note => `<li class="file-node" data-file="${e(note.slug)}.typ" data-search="${e(`${note.slug}.typ ${note.text}`.toLocaleLowerCase())}"><a class="file-link" href="${noteUrl(site, note.slug)}">${fileIcon}<span class="file-name">${e(note.title)}</span><span class="file-arrow">${arrow}</span></a></li>`).join('')}</ul>`;
  return render(root);
}

export function homePage(site, notes, dev) {
  return layout(site, { dev, body: `<main id="main">
    <section class="hero" aria-labelledby="hero-title">
      <div class="cover-wrap"><img src="${href(site, 'cover.png')}" width="2048" height="1153" alt="象牙白的哥特式拱廊, 石像与深红色星纹旗帜" fetchpriority="high" class="cover-image">
        <div class="cover-frame" aria-hidden="true"></div><div class="cover-label"><span>THE MATHEMATICAL NOTEBOOK</span></div>
      </div>
      <div class="hero-intro"><span class="intro-star">${star}</span><p class="eyebrow">A PERSONAL COLLECTION OF MATHEMATICAL WRITINGS</p>
        <h1 id="hero-title">${e(site.title)}</h1><p class="hero-chinese">于抽象之中, 寻找结构与联系.</p>
        <div class="hero-byline"><span class="short-rule"></span><span>数学笔记与思考</span><span class="byline-dot">·</span><span class="serif-italic">by ${e(site.author)}</span><span class="short-rule"></span></div>
      </div>
    </section>
    <section id="writings" class="writings content-width" aria-labelledby="writings-title">
      <div class="section-aside"><span class="eyebrow crimson">THE NOTEBOOKS</span><h2 id="writings-title">笔记目录<span class="index-dot">.</span></h2><p>展开一本笔记本.<br>从感兴趣的一篇开始阅读.</p><span class="aside-rule"></span><span class="collection-count">${pad(notes.length)} <span>篇笔记</span></span></div>
      <div class="directory-browser"><div class="directory-toolbar"><span class="directory-root">${folderIcon}<span>笔记本</span></span>
        <label class="search-field" data-directory-search hidden>${searchIcon}<input type="search" id="note-search" placeholder="查找笔记..." aria-label="搜索笔记" autocomplete="off"><kbd>/</kbd></label></div>
        <p id="search-status" class="sr-only" role="status" aria-live="polite"></p><nav aria-label="笔记文件目录">${fileTree(site, notes)}</nav>
        ${notes.length ? '<div class="empty-state" hidden><span>' + star + '</span><h3>没有找到笔记</h3><p>试试其他关键词, 或清除搜索.</p><button id="clear-search">查看全部笔记 ' + arrow + '</button></div>' : '<div class="directory-empty">这里还没有笔记.</div>'}
        <div class="directory-footer"><span data-file-count>${notes.length} 篇笔记</span><div class="directory-actions" hidden><button data-expand-all>全部展开</button><span aria-hidden="true">/</span><button data-collapse-all>全部折叠</button></div></div>
      </div>
    </section>
  </main>` });
}

export function notePage(site, note, notes, dev, schema = null) {
  const isObject = Boolean(note.objectId);
  const folder = isObject ? note.category : posix.dirname(note.slug);
  const siblings = isObject ? notes.filter(other => other.category === folder).sort((a, b) => a.number - b.number)
    : notes.filter(other => posix.dirname(other.slug) === folder).sort((a, b) => compareNames(a.title, b.title));
  const index = siblings.indexOf(note);
  const previous = siblings[index - 1];
  const next = siblings[index + 1];
  const returnUrl = isObject ? href(site, 'sheafpedia/') : `${href(site)}#writings`;
  const returnTitle = isObject ? '几何对象手册' : '笔记目录';
  const returnAttribute = isObject ? 'data-sheafpedia-return' : '';
  const paginationAttribute = isObject ? 'data-object-link' : '';
  const path = isObject ? `sheafpedia/${note.objectId}/` : `notes/${encodeNotePath(note.slug)}/`;
  const sourcePath = isObject ? `sheafpedia/${note.filename}` : `notes/${encodeNotePath(note.slug)}.typ`;
  const references = [
    { title: '本文引用', direction: 'outgoing', notes: note.outgoing },
    { title: '引用本文', direction: 'incoming', notes: note.incoming },
  ].filter(group => group.notes.length);
  return layout(site, { title: documentTitle(note), note: true, section: isObject ? 'sheafpedia' : 'notes', dev, path, body: `
  <div class="reading-progress" aria-hidden="true"><span></span></div><main id="main" class="reading-main content-width">
    <div class="breadcrumb"><a ${returnAttribute} href="${returnUrl}">${returnTitle}</a><span>/</span><span>${e(isObject ? `${schema.categories[note.category]} / ${note.objectId}` : note.slug.split('/').join(' / '))}</span></div>
    <header class="article-header">${isObject ? `<div class="article-notebook object-id">${e(note.objectId)}</div>` : note.notebook ? `<div class="article-notebook">${folderIcon}<span>${e(note.notebook)}</span></div>` : ''}
      <h1 class="${isObject ? 'object-name' : ''}">${isObject ? note.nameHtml : e(note.title)}</h1>
      ${isObject && note.introductionHtml ? `<div class="object-introduction">${note.introductionHtml}</div>` : ''}
      <div class="accent-divider"><span></span>${star}</div>
    </header>
    <div class="reading-grid"><aside class="toc-aside"><details class="toc" open><summary>本篇目录<span>CONTENTS</span></summary><nav aria-label="笔记目录"><ol>${note.toc.map(item => `<li class="toc-level-${item.level}"><a href="#${e(item.id)}">${e(item.text)}</a></li>`).join('')}</ol></nav></details>
      <a class="source-link" href="${href(site, `sources/${sourcePath}`)}" download>${e('{ }')} <span>Typst 源文件</span><span aria-hidden="true">↓</span></a><button class="print-button" hidden>打印 / 保存 PDF <span aria-hidden="true">↗</span></button>
    </aside><div class="article-column"><article class="typst-content" aria-label="${e(note.title)}">${note.html}</article>
      <div class="article-end"><span></span>${star}<span></span></div><div class="article-bottom"><a ${returnAttribute} href="${returnUrl}">← 返回${returnTitle}</a></div>
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

export function sheafpediaPage(site, objects, schema, dev) {
  const categories = Object.entries(schema.categories);
  const propertyNames = [...new Set([...Object.values(schema.properties), ...objects.flatMap(object => Object.keys(object.properties))])];
  const numberNames = [...new Set([...Object.values(schema.numbers), ...objects.flatMap(object => Object.keys(object.numbers))])];
  const options = names => names.map(name => `<option value="${e(name)}">${e(name)}</option>`).join('');
  return layout(site, { title: 'sheafpedia · 几何对象手册', section: 'sheafpedia', path: 'sheafpedia/', dev, body: `
    <main id="main" class="sheafpedia content-width">
      <header class="sheafpedia-heading"><span class="eyebrow crimson">SHEAFPEDIA</span><h1>几何对象手册<span class="index-dot">.</span></h1><p>定义, 构造, 性质与不变量.</p></header>
      <div class="object-browser">
        <form class="object-controls" hidden role="search" aria-label="检索几何对象">
          <div class="object-search-row"><label class="search-field">${searchIcon}<input type="search" name="q" placeholder="编号, 名称或关键词..." aria-label="搜索几何对象" autocomplete="off"></label>
            <label>类别<select name="category"><option value="">全部类别</option>${categories.map(([code, name]) => `<option value="${code}">${code} · ${name}</option>`).join('')}</select></label></div>
          <details class="object-filter-details"><summary>按性质与不变量筛选</summary><div class="object-filters">
            <fieldset><legend>基本性质</legend><label>性质<select name="property"><option value="">不限性质</option>${options(propertyNames)}</select></label><label>取值<select name="value"><option value="">不限</option><option value="true">是</option><option value="false">否</option><option value="unknown">未记录</option></select></label></fieldset>
            <fieldset><legend>数值不变量</legend><label>不变量<select name="invariant"><option value="">不限不变量</option>${options(numberNames)}</select></label><div class="invariant-range"><label>最小值<input type="number" step="any" name="min" placeholder="不限"></label><label>最大值<input type="number" step="any" name="max" placeholder="不限"></label></div></fieldset>
          </div><p class="object-filter-hint">未记录的性质不会视为否. 数值筛选仅匹配已记录的数值, 范围包含端点.</p></details>
          <div class="object-results-bar"><span data-object-count role="status" aria-live="polite">${objects.length} 个对象</span><button type="reset">清除筛选</button></div>
        </form>
        <nav class="object-category-nav" aria-label="按类别浏览">${categories.map(([code, name]) => `<a href="#category-${code}"><span>${code}</span> ${name}<small>${objects.filter(object => object.category === code).length}</small></a>`).join('')}</nav>
        <div class="object-groups">${categories.map(([code, name]) => {
          const group = objects.filter(object => object.category === code);
          return `<section class="object-group" id="category-${code}" data-category="${code}" aria-labelledby="heading-${code}"><h2 id="heading-${code}"><span>${code}</span>${name}<small>${group.length}</small></h2>
            ${group.length ? `<ul>${group.map(object => `<li data-object-row data-properties="${e(JSON.stringify(object.properties))}" data-numbers="${e(JSON.stringify(object.numbers))}" data-search="${e(`${object.objectId} ${code} ${name} ${object.title} ${object.aliases.join(' ')} ${object.text}`.toLocaleLowerCase())}"><a data-object-link href="${objectUrl(site, object.objectId)}"><span class="object-id">${object.objectId}</span><span class="object-name">${object.nameHtml}</span>${arrow}</a></li>`).join('')}</ul>` : '<p class="object-category-empty">尚未收录对象.</p>'}</section>`;
        }).join('')}</div>
        <div class="object-no-results" hidden>没有找到符合条件的对象. 可以调整关键词或筛选条件.</div>
      </div>
    </main>` });
}

export function notFoundPage(site, dev) {
  return layout(site, { title: '未找到文稿', dev, body: `<main id="main" class="not-found"><span class="intro-star">${star}</span><p class="eyebrow">404 / A MISSING PAGE</p><h1>这一页, 尚未写下.</h1><p>文稿可能已移动, 或这个地址并不存在.</p><a href="${href(site)}#writings">回到笔记目录 ${arrow}</a></main>` });
}
