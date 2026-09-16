import { createHash } from 'node:crypto';
import { cp, mkdir, readFile, readdir, rename, rm, writeFile } from 'node:fs/promises';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { parseHTML } from 'linkedom';
import { resolveNoteLinks } from './note-links.mjs';
import { compareNames, discoverNoteFiles, noteIdentity } from './note-paths.mjs';
import { TypstCompiler } from './typst-compiler.mjs';
import { prepareTypstFonts } from './typst-fonts.mjs';

export const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const contentRoot = join(ROOT, 'content');

async function outputFingerprint(root) {
  const hash = createHash('sha256');
  async function visit(folder) {
    const entries = await readdir(join(root, folder), { withFileTypes: true });
    entries.sort((a, b) => a.name < b.name ? -1 : a.name > b.name ? 1 : 0);
    for (const entry of entries) {
      const path = join(folder, entry.name);
      if (entry.isDirectory()) await visit(path);
      else {
        const bytes = await readFile(join(root, path));
        hash.update(JSON.stringify([path, bytes.length]));
        hash.update(bytes);
      }
    }
  }
  await visit('');
  return hash.digest('hex');
}

function namespaceSvg(svg, prefix) {
  const ids = new Map([...svg.querySelectorAll('[id]')].map(element => [element.id, `${prefix}${element.id}`]));
  const rewriteUrls = value => value.replace(/url\(\s*(['"]?)#([^)'"\s]+)\1\s*\)/g,
    (match, quote, id) => ids.has(id) ? `url(#${ids.get(id)})` : match);
  for (const element of [svg, ...svg.querySelectorAll('*')]) {
    if (ids.has(element.id)) element.id = ids.get(element.id);
    for (const attribute of [...element.attributes]) {
      let value = rewriteUrls(attribute.value);
      if (['href', 'xlink:href'].includes(attribute.name) && value.startsWith('#') && ids.has(value.slice(1))) {
        value = `#${ids.get(value.slice(1))}`;
      }
      if (value !== attribute.value) element.setAttribute(attribute.name, value);
    }
    if (element.localName === 'style') element.textContent = rewriteUrls(element.textContent);
  }
}

export function prepareDocument(source, { filename } = {}) {
  const { document } = parseHTML(source);
  const templates = [...document.querySelectorAll('[data-note-template]')];
  if (filename !== undefined && templates.length !== 1) throw new Error(`${filename}: 每篇文稿必须且只能调用一次 note 模板.`);
  for (const marker of templates) marker.remove();
  const styles = [...document.head.querySelectorAll('style')].map(style => style.textContent);
  for (const wrapper of document.body.querySelectorAll('[data-note-label]')) {
    const id = wrapper.getAttribute('data-note-label');
    const element = wrapper.firstElementChild;
    if (element && (!element.id || element.id === id)) {
      element.id = id;
      wrapper.replaceWith(...wrapper.childNodes);
    } else if (!document.getElementById(id)) {
      wrapper.id = id;
      wrapper.removeAttribute('data-note-label');
    } else {
      wrapper.replaceWith(...wrapper.childNodes);
    }
  }
  const ids = new Set([...document.querySelectorAll('[id]')].map(element => element.id));
  const toc = [...document.body.querySelectorAll('h2, h3, h4, h5, h6')].map(heading => {
    const text = heading.textContent.trim();
    if (!heading.id) {
      const stem = text.replace(/^[\d.]+\s*/, '').toLocaleLowerCase().replace(/[^\p{L}\p{N}]+/gu, '-').replace(/^-|-$/g, '') || 'section';
      let id = stem;
      for (let index = 2; ids.has(id); index++) id = `${stem}-${index}`;
      heading.id = id;
      ids.add(id);
    }
    return { id: heading.id, text, level: Number(heading.tagName.slice(1)) - 1 };
  });
  for (const body of document.querySelectorAll('.env-body[data-env]')) {
    const figure = body.closest('figure');
    if (figure) {
      figure.classList.add('math-env', `env-${body.dataset.env}`);
      const caption = figure.querySelector('figcaption');
      if (caption) {
        // Normalize Typst's automatic spacing between the label and title.
        for (const child of caption.childNodes) {
          if (child.nodeType === 3) child.textContent = child.textContent.replace(/[\u00a0\u2003]/g, ' ');
        }
        figure.insertBefore(caption, figure.firstChild);
        const first = [...body.childNodes].find(child => child.nodeType === 1 || (child.nodeType === 3 && child.textContent.trim()));
        const paragraph = first?.localName === 'p';
        const inline = first?.nodeType === 3 || ['a', 'span', 'em', 'strong', 'code', 'sub', 'sup'].includes(first?.localName)
          || (first?.localName === 'math' && first.getAttribute('display') !== 'block');
        if (paragraph || inline) {
          figure.classList.add('env-inline');
          if (paragraph) first.classList.add('env-first-paragraph');
          caption.after(document.createTextNode(' '));
        }
      }
    }
  }
  let diagramIndex = 0;
  for (const diagram of document.querySelectorAll('.diagram-scroll')) {
    diagram.closest('figure')?.classList.add('note-diagram');
    // Typst reuses glyph IDs across frames; each embedded SVG needs its own IDs.
    for (const svg of diagram.querySelectorAll(':scope > svg')) namespaceSvg(svg, `diagram-svg-${++diagramIndex}-`);
  }
  for (const element of document.querySelectorAll('math[display="block"], table')) {
    // Firefox can line-break between direct children of <math> when its
    // available width changes. Keep each equation in one explicit row;
    // intentional multiline equations retain their existing <mtable>.
    if (element.localName === 'math' && element.children.length > 1) {
      const row = document.createElementNS('http://www.w3.org/1998/Math/MathML', 'mrow');
      row.append(...element.childNodes);
      element.append(row);
    }
    const wrapper = document.createElement('div');
    wrapper.className = element.localName === 'table' ? 'table-scroll' : 'math-block';
    wrapper.setAttribute('tabindex', '0');
    wrapper.setAttribute('role', 'region');
    wrapper.setAttribute('aria-label', element.localName === 'table' ? '表格, 可横向滚动' : '公式, 可横向滚动');
    element.replaceWith(wrapper);
    wrapper.append(element);
  }
  const text = document.body.textContent.replace(/\s+/g, ' ').trim();
  return { html: document.body.innerHTML, text, toc, styles };
}

export async function build({ dev = false, compilerSession = null, fresh = false } = {}) {
  const session = compilerSession || new TypstCompiler({ cwd: ROOT });
  try { return await buildSite({ dev, session, fresh }); }
  finally { if (!compilerSession) await session.close(); }
}

async function buildSite({ dev, session, fresh }) {
  const start = performance.now();
  const version = await session.version();
  const match = version.match(/typst (\d+)\.(\d+)\.(\d+)/);
  if (!match || (Number(match[1]) === 0 && Number(match[2]) < 15)) throw new Error('原生 MathML 输出需要 Typst >= 0.15.0, 推荐 0.15.1.');
  const { default: config } = await import(`${pathToFileURL(join(ROOT, 'site.config.mjs')).href}?t=${Date.now()}`);
  const site = { ...config };
  if (typeof site.base !== 'string' || !/^\/(?:[a-zA-Z0-9_-]+\/)*$/.test(site.base)) throw new Error('site.base 必须形如 / 或 /repository-name/.');
  const { homePage, notePage, notFoundPage } = await import(`${pathToFileURL(join(ROOT, 'src/render.mjs')).href}?t=${Date.now()}`);
  const filenames = await discoverNoteFiles(join(contentRoot, 'notes'));
  const fontPath = await prepareTypstFonts(ROOT);
  await session.retain(filenames.map(filename => join(contentRoot, 'notes', filename)));
  const notes = [];
  const compilation = { cached: 0, incremental: 0, cold: 0 };
  for (const filename of filenames) {
    const slug = filename.slice(0, -4);
    const input = join(contentRoot, 'notes', filename);
    const flags = ['--features', 'html', '--root', contentRoot, '--ignore-system-fonts', '--font-path', fontPath, '--input', `note-title=${noteIdentity(filename).title}`];
    const compiled = await session.compile(input, flags, { fresh });
    compilation[compiled.cached ? 'cached' : compiled.incremental ? 'incremental' : 'cold']++;
    notes.push({ ...noteIdentity(filename), slug, ...prepareDocument(compiled.html, { filename }) });
  }
  notes.sort((a, b) => compareNames(a.slug, b.slug));
  resolveNoteLinks(notes, site);
  const outputDir = join(ROOT, dev ? '.build/dev' : 'dist');
  const stage = join(ROOT, dev ? '.build/site-dev' : '.build/site');
  await rm(stage, { recursive: true, force: true });
  await mkdir(stage, { recursive: true });
  await cp(join(ROOT, 'public'), stage, { recursive: true });
  await cp(join(ROOT, 'cover.png'), join(stage, 'cover.png'));
  await cp(join(ROOT, 'src/style.css'), join(stage, 'style.css'));
  await cp(join(ROOT, 'src/client.js'), join(stage, 'client.js'));
  await cp(contentRoot, join(stage, 'sources'), { recursive: true, filter: source => !relative(contentRoot, source).split(/[\\/]/).some(part => part.startsWith('_') || part.startsWith('.')) });
  await writeFile(join(stage, 'typst.css'), [...new Set(notes.flatMap(note => note.styles))].join('\n'));
  await writeFile(join(stage, 'index.html'), homePage(site, notes, dev));
  await writeFile(join(stage, '404.html'), notFoundPage(site, dev));
  for (const note of notes) {
    const folder = join(stage, 'notes', note.slug);
    await mkdir(folder, { recursive: true });
    await writeFile(join(folder, 'index.html'), notePage(site, note, notes, dev));
  }
  // File watchers and Typst can both report the same save. Compare output
  // bytes, including assets and downloads, rather than rebuilding timestamps.
  const fingerprint = dev ? await outputFingerprint(stage) : null;
  // Only replace the last working site after every note has compiled successfully.
  const previous = join(ROOT, dev ? '.build/previous-dev' : '.build/previous');
  await rm(previous, { recursive: true, force: true });
  try { await rename(outputDir, previous); } catch (error) { if (error.code !== 'ENOENT') throw error; }
  try { await rename(stage, outputDir); } catch (error) {
    await rename(previous, outputDir).catch(() => {});
    throw error;
  }
  await rm(previous, { recursive: true, force: true });
  console.log(`✓ ${notes.length} 篇文稿 → HTML + MathML · 缓存 ${compilation.cached}, 增量 ${compilation.incremental}, 首次编译 ${compilation.cold} · ${(performance.now() - start).toFixed(0)} ms`);
  return { site, notes, outputDir, compilation, fingerprint };
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  build({ fresh: process.argv.includes('--no-cache') }).catch(error => { console.error(`\n构建失败\n${error.message}`); process.exitCode = 1; });
}
