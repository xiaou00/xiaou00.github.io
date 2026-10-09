import { createHash } from 'node:crypto';
import { cp, mkdir, readFile, readdir, rename, rm, writeFile } from 'node:fs/promises';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { parseHTML } from 'linkedom';
import { resolveNoteLinks } from './note-links.mjs';
import { compareNames, discoverNoteFiles, noteIdentity } from './note-paths.mjs';
import { TypstCompiler } from './typst-compiler.mjs';
import { prepareTypstFonts } from './typst-fonts.mjs';
import { discoverObjectFiles, objectIdentity } from './geopedia.mjs';
import { discoverStickers, discoverAssetsImages, resolveStickers, resolveAssetsImages } from './images.mjs';

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
  if (filename !== undefined && templates.length !== 1) throw new Error(`${filename}: Each document must use the note template exactly once.`);
  for (const marker of templates) marker.remove();
  const styles = [...document.head.querySelectorAll('style')].map(style => style.textContent);
  for (const wrapper of document.body.querySelectorAll('[data-note-label]')) {
    const id = wrapper.getAttribute('data-note-label');
    const element = wrapper.firstElementChild;
    // Typst may place a referenced equation's native anchor on an ancestor.
    // Reuse it instead of assigning the same ID to the enclosed MathML.
    const existing = document.getElementById(id);
    if (existing && existing !== wrapper) {
      wrapper.replaceWith(...wrapper.childNodes);
    } else if (element && (!element.id || element.id === id)) {
      element.id = id;
      wrapper.replaceWith(...wrapper.childNodes);
    } else {
      wrapper.id = id;
      wrapper.removeAttribute('data-note-label');
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
  for (const environment of document.querySelectorAll('[data-env]')) {
    const figure = environment.closest('figure');
    if (!figure) continue;
    figure.classList.add('math-env', `env-${environment.dataset.env}`);
    if (environment.dataset.ruled === 'false') figure.classList.add('env-unruled');
    if (environment.dataset.style === 'remark') figure.classList.add('env-muted');
    environment.replaceWith(...environment.childNodes);
  }
  let diagramIndex = 0;
  for (const diagram of document.querySelectorAll('.diagram-scroll')) {
    diagram.closest('figure')?.classList.add('note-diagram');
    // Typst reuses glyph IDs across frames; each embedded SVG needs its own IDs.
    for (const svg of diagram.querySelectorAll(':scope > svg')) namespaceSvg(svg, `diagram-svg-${++diagramIndex}-`);
  }
  for (const operator of document.querySelectorAll('math mo')) {
    // Firefox can apply its legacy large-operator form to circled binary
    // operators in display math. Keep them at their natural size, while
    // preserving explicit large operators and n-ary ⨂ / ⨁ / ⨀.
    if (['⊗', '⊕', '⊙'].includes(operator.textContent) && !operator.hasAttribute('largeop')) {
      operator.setAttribute('largeop', 'false');
    }
  }
  // Combining tilde is not a horizontal operator in browser dictionaries.
  // Use its spacing equivalent so MathML can select a wide accent glyph.
  for (const accent of document.querySelectorAll('math mover[accent="true"] > mo:last-child')) {
    if (accent.textContent === '\u0303' && !accent.hasAttribute('stretchy')) {
      accent.textContent = '\u02dc';
      accent.setAttribute('form', 'postfix');
      accent.setAttribute('stretchy', 'true');
    }
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
    wrapper.setAttribute('aria-label', element.localName === 'table' ? 'Table, scroll horizontally' : 'Equation, scroll horizontally');
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
  if (!match || (Number(match[1]) === 0 && Number(match[2]) < 15)) throw new Error('Native MathML requires Typst >= 0.15.0; 0.15.1 is recommended.');
  const { default: config } = await import(`${pathToFileURL(join(ROOT, 'site.config.mjs')).href}?t=${Date.now()}`);
  const site = { ...config };
  if (typeof site.base !== 'string' || !/^\/(?:[a-zA-Z0-9_-]+\/)*$/.test(site.base)) throw new Error('site.base must be / or /repository-name/.');
  const { homePage, notesPage, notePage, geopediaPage, notFoundPage } = await import(`${pathToFileURL(join(ROOT, 'src/render.mjs')).href}?t=${Date.now()}`);
  const filenames = await discoverNoteFiles(join(contentRoot, 'notes'));
  const objectFiles = await discoverObjectFiles(join(contentRoot, 'geopedia'));
  const fontPath = await prepareTypstFonts(ROOT);
  await session.retain([...filenames.map(filename => join(contentRoot, 'notes', filename)),
    ...objectFiles.map(filename => join(contentRoot, 'geopedia', filename))]);
  const compilation = { cached: 0, incremental: 0, cold: 0 };
  async function compileCollection(collection, files, identity) {
    const entries = [];
    for (const filename of files) {
      const metadata = identity(filename);
      const flags = ['--features', 'html', '--root', contentRoot, '--ignore-system-fonts', '--font-path', fontPath,
        '--input', `note-title=${metadata.title}`];
      const compiled = await session.compile(join(contentRoot, collection, filename), flags, { fresh });
      compilation[compiled.cached ? 'cached' : compiled.incremental ? 'incremental' : 'cold']++;
      entries.push({ collection, filename, slug: filename.slice(0, -4), ...metadata, ...prepareDocument(compiled.html, { filename }) });
    }
    return entries;
  }
  const notes = await compileCollection('notes', filenames, noteIdentity);
  notes.sort((a, b) => compareNames(a.slug, b.slug));
  const objects = await compileCollection('geopedia', objectFiles, objectIdentity);
  objects.sort((a, b) => compareNames(a.title, b.title));
  resolveNoteLinks(notes, site, objects);
  const entries = [...notes, ...objects];
  const [stickerFiles, assetFiles] = await Promise.all([discoverStickers(ROOT), discoverAssetsImages(ROOT)]);
  const images = [...resolveStickers(entries, site, stickerFiles), ...resolveAssetsImages(entries, site, assetFiles)];
  const outputDir = join(ROOT, dev ? '.build/dev' : 'dist');
  const stage = join(ROOT, dev ? '.build/site-dev' : '.build/site');
  await rm(stage, { recursive: true, force: true });
  await mkdir(stage, { recursive: true });
  await cp(join(ROOT, 'public'), stage, { recursive: true });
  // Changing the URL when the icon changes avoids reusing an old browser favicon.
  const favicon = await readFile(join(stage, 'favicon.svg'));
  site.favicon = `favicon.${createHash('sha256').update(favicon).digest('hex').slice(0, 12)}.svg`;
  await writeFile(join(stage, site.favicon), favicon);
  for (const image of images) {
    await mkdir(dirname(join(stage, image.path)), { recursive: true });
    await cp(image.source, join(stage, image.path));
  }
  await cp(join(ROOT, 'src/style.css'), join(stage, 'style.css'));
  await cp(join(ROOT, 'src/client.js'), join(stage, 'client.js'));
  await cp(contentRoot, join(stage, 'sources'), { recursive: true, filter: source => !relative(contentRoot, source).split(/[\\/]/).some(part => part.startsWith('_') || part.startsWith('.')) });
  await writeFile(join(stage, 'typst.css'), [...new Set(entries.flatMap(note => note.styles))].join('\n'));
  await writeFile(join(stage, 'index.html'), homePage(site, dev));
  await writeFile(join(stage, '404.html'), notFoundPage(site, dev));
  await mkdir(join(stage, 'notes'), { recursive: true });
  await writeFile(join(stage, 'notes/index.html'), notesPage(site, notes, dev));
  await mkdir(join(stage, 'geopedia'), { recursive: true });
  await writeFile(join(stage, 'geopedia/index.html'), geopediaPage(site, objects, dev));
  for (const entry of entries) {
    const isObject = entry.collection === 'geopedia';
    const folder = join(stage, entry.collection, isObject ? entry.title : entry.slug);
    await mkdir(folder, { recursive: true });
    await writeFile(join(folder, 'index.html'), notePage(site, entry, isObject ? objects : notes, dev));
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
  console.log(`✓ Notes: ${notes.length}, encyclopedia entries: ${objects.length} → HTML + MathML · cached ${compilation.cached}, incremental ${compilation.incremental}, cold ${compilation.cold} · ${(performance.now() - start).toFixed(0)} ms`);
  return { site, notes, objects, outputDir, compilation, fingerprint };
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  build({ fresh: process.argv.includes('--no-cache') }).catch(error => { console.error(`\nBuild failed\n${error.message}`); process.exitCode = 1; });
}
