import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { parseHTML } from 'linkedom';
import { build, prepareDocument, ROOT } from '../scripts/build.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';
import { discoverNoteFiles, encodeNotePath, noteIdentity, resolveNotePath, validateNotePath } from '../scripts/note-paths.mjs';
import { createNotebookFixture } from './fixtures.mjs';
import './typst-compiler.test.mjs';
import './typst-fonts.test.mjs';

test('heading anchors preserve references and remain unique for duplicate headings', () => {
  const document = prepareDocument('<html><head></head><body><h2 id="native">1 定理</h2><h2>2 重复</h2><h2>3 重复</h2><a href="#native">定理</a></body></html>');
  assert.deepEqual(document.toc.map(item => item.id), ['native', '重复', '重复-2']);
  assert.match(document.html, /href="#native"/);
});

test('filenames supply titles and parent folders supply notebook names without metadata', () => {
  assert.deepEqual(noteIdentity('代数/局部环.typ'), { title: '局部环', notebook: '代数' });
  assert.deepEqual(noteIdentity('随笔.typ'), { title: '随笔', notebook: '' });
  assert.equal(noteIdentity('数学/代数/局部环.typ').notebook, '代数');
});

test('the note template is validated in exported HTML without another compilation', () => {
  const marker = '<span hidden data-note-template=""></span>';
  const html = count => `<html><body>${marker.repeat(count)}<p>正文</p></body></html>`;
  assert.throws(() => prepareDocument(html(0), { filename: '缺少模板.typ' }), /必须且只能调用一次/);
  assert.throws(() => prepareDocument(html(2), { filename: '重复模板.typ' }), /必须且只能调用一次/);
  assert.ok(!prepareDocument(html(1), { filename: '笔记.typ' }).html.includes('data-note-template'));
});

test('display math stays in one row while explicit multiline tables remain intact', () => {
  const source = '<html><body><math display="block" id="sum"><mi>A</mi><mo>=</mo><munder><mo>⨁</mo><mi>n</mi></munder><msup><mi>A</mi><mi>n</mi></msup></math><math display="block" id="aligned"><mtable><mtr><mtd><mi>A</mi></mtd></mtr><mtr><mtd><mi>B</mi></mtd></mtr></mtable></math></body></html>';
  const { document } = parseHTML(`<html><body>${prepareDocument(source).html}</body></html>`);
  const sum = document.getElementById('sum');
  assert.equal(sum.children.length, 1);
  assert.deepEqual([...sum.firstElementChild.children].map(node => node.localName), ['mi', 'mo', 'munder', 'msup']);
  assert.equal(sum.firstElementChild.localName, 'mrow');
  assert.equal(sum.parentNode.className, 'math-block');
  assert.equal(document.querySelector('#aligned > mtable').children.length, 2);
});

test('ordinary tensor products and direct sums keep their natural size while explicit large operators remain large', () => {
  for (const symbol of ['⊗', '⊕']) {
    const source = `<html><body><math display="block"><mi>P</mi><msub><msup><mo>${symbol}</mo><mi>L</mi></msup><mi>k</mi></msub><mi>Q</mi><mo>=</mo><mi>P</mi><msub><mo lspace="0.22em" rspace="0.22em">${symbol}</mo><mi>k</mi></msub><mi>Q</mi><mo largeop="true">${symbol}</mo><mo>⨂</mo><mo>⨁</mo><mo>∑</mo></math></body></html>`;
    const { document } = parseHTML(`<html><body>${prepareDocument(source).html}</body></html>`);
    const operators = [...document.querySelectorAll('mo')].filter(node => node.textContent === symbol);
    assert.deepEqual(operators.map(node => node.getAttribute('largeop')), ['false', 'false', 'true']);
    assert.equal(operators[1].getAttribute('lspace'), '0.22em', 'binary spacing is preserved');
    assert.ok(document.querySelector('msub > msup > mo'), 'attached scripts are preserved');
    for (const node of document.querySelectorAll('mo')) {
      if (['⨂', '⨁', '∑'].includes(node.textContent)) assert.equal(node.getAttribute('largeop'), null);
    }
  }
});

test('real Typst source builds a linked static site with native MathML and references', async () => {
  const fixture = await createNotebookFixture();
  try {
    const { notes } = await build();
    assert.equal(notes.length >= 2, true);
    const specimen = notes.find(note => note.slug === fixture.specimen);
    assert.ok(specimen);
    const { document } = parseHTML(await readFile(join(ROOT, `dist/notes/${specimen.slug}/index.html`), 'utf8'));
    assert.ok(document.querySelectorAll('math').length > 40, 'real formulas were compiled');
    assert.equal(document.querySelector('math code'), null, 'no unevaluated math functions');
    const lines = document.querySelector('#math-lines');
    assert.equal(lines.querySelectorAll('mrow.math-underline').length, 8, 'underlines survive in inline, display, nested and subscript math');
    assert.equal(lines.querySelectorAll('mrow.math-overline').length, 7, 'overlines survive in inline, display and nested math');
    assert.ok(lines.querySelector('.math-overline .math-underline mfrac'), 'a nested fraction retains its native structure');
    assert.ok(lines.querySelector('msup .math-overline'));
    assert.ok(lines.querySelector('msub .math-underline'));
    assert.equal(lines.querySelector('.math-underline').textContent, 'Hom');
    assert.equal(lines.querySelector('svg, img, math math'), null, 'decorations remain part of the original MathML equation');
    assert.ok(document.querySelector('.env-theorem figcaption').textContent.includes('定理'));
    assert.ok(document.querySelector('.env-remark figcaption').textContent.includes('注'));
    const diagrams = [...document.querySelectorAll('.note-diagram .diagram-scroll > svg')];
    assert.equal(diagrams.length, 2, 'both Fletcher diagrams are exported alongside native MathML');
    for (const svg of diagrams) {
      assert.ok(svg.querySelectorAll('path').length > 4, 'the diagram contains vector geometry');
      for (const element of svg.querySelectorAll('[href], [xlink\\:href]')) {
        const target = element.getAttribute('href') || element.getAttribute('xlink:href');
        if (target.startsWith('#')) {
          assert.ok([...svg.querySelectorAll('[id]')].some(node => node.id === target.slice(1)), 'SVG glyph references stay within their own diagram');
        }
      }
    }
    assert.ok(document.getElementById('commutative-square').classList.contains('note-diagram'), 'diagrams preserve public reference anchors');
    for (const anchor of document.querySelectorAll('a[href^="#"]')) {
      assert.ok(document.getElementById(decodeURIComponent(anchor.getAttribute('href').slice(1))), `missing target: ${anchor.outerHTML}`);
    }
    const home = parseHTML(await readFile(join(ROOT, 'dist/index.html'), 'utf8')).document;
    assert.equal(home.querySelectorAll('.file-link').length, notes.length);
    const notebook = home.querySelector(`[data-directory="${fixture.folder}"] > .file-tree`);
    assert.deepEqual([...notebook.querySelectorAll('.file-name')].map(node => node.textContent), ['理想与除子', '算术几何笔记', '数学写作与排版']);
    assert.deepEqual([...notebook.querySelectorAll('.directory-name')].map(node => node.textContent), ['算术几何', '写作']);
    assert.equal(home.querySelector('.file-title'), null, 'the filename and title appear as one name');
    assert.equal(home.querySelector('[data-filter], [data-kind], .note-status, time'), null);
    assert.equal(home.querySelector('script[src*="__dev"]'), null, 'production output contains no development client');
    assert.equal(document.querySelector('script[src*="__dev"]'), null);
    assert.equal(await readFile(join(ROOT, `dist/sources/notes/${specimen.slug}.typ`), 'utf8'), await readFile(join(ROOT, `content/notes/${specimen.slug}.typ`), 'utf8'));
    const pages = new Map();
    for (const note of notes) pages.set(note.slug, parseHTML(await readFile(join(ROOT, `dist/notes/${note.slug}/index.html`), 'utf8')).document);
    assert.ok(pages.has(fixture.ideals), 'each file has its own note page');
    assert.equal(pages.get(fixture.index).querySelector('#dvr-dedekind'), null, 'the index does not embed another note');
    assert.ok(document.getElementById('theorems'), 'unreferenced labels remain valid external targets');
    for (const note of notes) {
      const page = pages.get(note.slug);
      assert.equal(page.querySelector('.article-header h1').textContent, note.slug.split('/').at(-1));
      assert.equal(page.querySelector('.article-notebook')?.textContent || '', note.slug.split('/').at(-2) || '');
      for (const field of ['date', 'tags', 'kind', 'status', 'order', 'subtitle', 'description']) assert.equal(field in note, false, `${field} was removed from note metadata`);
      assert.equal(page.querySelector('time, .article-status, .article-meta, .article-subtitle, .article-description'), null);
      const ids = [...page.querySelectorAll('[id]')].map(element => element.id);
      assert.equal(new Set(ids).size, ids.length, 'explicit labels must not duplicate native reference IDs');
      assert.equal(page.querySelector('[data-note], [data-note-label]'), null, 'all internal placeholders were resolved');
      for (const link of page.querySelectorAll('.note-reference')) {
        const url = new URL(link.getAttribute('href'), 'https://example.com');
        const destination = decodeURIComponent(url.pathname.slice('/notes/'.length, -1));
        assert.ok(pages.has(destination), link.outerHTML);
        if (url.hash) assert.ok(pages.get(destination).getElementById(decodeURIComponent(url.hash.slice(1))), link.outerHTML);
        if (destination !== note.slug) {
          assert.ok(notes.find(other => other.slug === destination).incoming.includes(note), 'backlink generated');
          assert.ok(note.outgoing.some(other => other.slug === destination), 'outgoing note indexed');
        }
      }
    }
  } finally {
    await fixture.cleanup();
    await build();
  }
});

test('directory discovery includes nested files and omits drafts and hidden folders', async () => {
  const root = await mkdtemp(join(tmpdir(), 'ain-soph-files-'));
  try {
    for (const path of ['algebra', 'analysis', '_drafts', '.hidden', '代数']) await mkdir(join(root, path));
    for (const path of ['root.typ', 'algebra/note2.typ', 'algebra/note10.typ', 'analysis/note2.typ', '代数/理想.typ', '_draft.typ', '_drafts/private.typ', '.hidden/private.typ', 'algebra/_draft.typ', 'algebra/readme.md']) await writeFile(join(root, path), '');
    const files = await discoverNoteFiles(root);
    assert.equal(files.length, 5);
    assert.ok(files.includes('代数/理想.typ'));
    assert.ok(files.includes('analysis/note2.typ'));
    assert.ok(files.indexOf('algebra/note2.typ') < files.indexOf('algebra/note10.typ'));
    assert.ok(files.every(path => !path.includes('private') && !path.includes('_draft')));
  } finally { await rm(root, { recursive: true, force: true }); }
  assert.deepEqual(await discoverNoteFiles(root), [], 'a deleted notes folder is an empty collection');
});

test('nested note references resolve relative paths, distinguish equal filenames and encode URLs', () => {
  const notes = [
    { slug: 'algebra/entry', title: 'A', html: '<a data-note="../analysis/entry.typ" data-note-auto="true"></a><a data-note="代数/理想 笔记.typ" data-note-auto="true"></a>' },
    { slug: 'analysis/entry', title: 'B', html: '<a data-note="../algebra/entry.typ" data-note-auto="true"></a>' },
    { slug: '代数/理想 笔记', title: '理想笔记', html: '<h2>正文</h2>' },
  ];
  resolveNoteLinks(notes, { base: '/blog/' });
  const { document } = parseHTML(`<html><head></head><body>${notes[0].html}</body></html>`);
  assert.equal(document.querySelector('a').getAttribute('href'), '/blog/notes/analysis/entry/');
  assert.equal(document.querySelectorAll('a')[1].getAttribute('href'), `/blog/notes/${encodeNotePath('代数/理想 笔记')}/`);
  assert.deepEqual(notes[1].incoming.map(note => note.slug), ['algebra/entry']);
  assert.equal(resolveNotePath('./entry.typ', 'algebra/another'), 'algebra/entry');
  assert.equal(resolveNotePath('/analysis/entry.typ', 'algebra/another'), 'analysis/entry');
  assert.throws(() => resolveNotePath('../../outside.typ', 'algebra/entry'), /笔记路径/);
  assert.throws(() => validateNotePath('../outside'), /笔记路径/);
});

test('mutual references, custom MathML link text, self-links and subdirectory deployments resolve', () => {
  const notes = [
    { slug: 'a', title: '笔记 A', html: '<h2 id="section">1 开始</h2><a data-note="b.typ" data-note-target="theorem" data-note-auto="true"></a><a data-note="b"><math><mi>x</mi></math></a><a data-note="a" data-note-auto="true"></a>' },
    { slug: 'b', title: '笔记 B', html: '<figure id="theorem"><figcaption>定理 1 (测试)</figcaption></figure><a data-note="a.typ" data-note-auto="true"></a>' },
  ];
  resolveNoteLinks(notes, { base: '/math/' });
  const document = parseHTML(`<html><head></head><body>${notes[0].html}</body></html>`).document;
  assert.equal(document.querySelector('a').getAttribute('href'), '/math/notes/b/#theorem');
  assert.equal(document.querySelector('a').textContent, '笔记 B / 定理 1 (测试)');
  assert.ok(document.querySelector('a math'), 'custom mathematical link text is preserved');
  assert.deepEqual(notes[0].outgoing.map(note => note.slug), ['b'], 'repeated and self references do not duplicate relationships');
  assert.deepEqual(notes[0].incoming.map(note => note.slug), ['b']);
  assert.deepEqual(notes[1].incoming.map(note => note.slug), ['a']);
});

test('deleted notes become plain text and restoring them restores links and backlinks', () => {
  const source = '<a data-note="代数/被删除的笔记.typ" data-note-auto="true" data-note-target="theorem"></a><a data-note="代数/被删除的笔记.typ">原来的说明 <math><mi>x</mi></math></a>';
  const note = { slug: 'a', title: 'A', html: source };
  resolveNoteLinks([note]);
  const document = parseHTML(`<html><body>${note.html}</body></html>`).document;
  assert.equal(document.querySelector('a'), null);
  assert.equal(document.querySelector('.note-reference-missing').textContent, '被删除的笔记');
  assert.ok(document.querySelector('.note-reference-missing math'), 'custom mathematical text survives deletion');
  assert.ok(document.body.textContent.includes('原来的说明'));
  assert.deepEqual(note.outgoing, []);
  assert.deepEqual(note.incoming, []);
  note.html = source;
  const restored = { slug: '代数/被删除的笔记', title: '被删除的笔记', html: '<h2 id="theorem">1 定理</h2>' };
  resolveNoteLinks([note, restored]);
  assert.ok(note.html.includes('class="note-reference"'));
  assert.ok(!note.html.includes('note-reference-missing'));
  assert.deepEqual(note.outgoing, [restored]);
  assert.deepEqual(restored.incoming, [note]);
});

test('invalid paths and unknown anchors still fail with the referencing filename', () => {
  assert.throws(() => resolveNoteLinks([{ slug: 'a', title: 'A', html: '<a data-note="../../outside.typ"></a>' }]), /a.typ:.*outside.typ/);
  assert.throws(() => resolveNoteLinks([
    { slug: 'a', title: 'A', html: '<a data-note="b.typ" data-note-target="missing-label"></a>' },
    { slug: 'b', title: 'B', html: '<h2 id="existing">Existing</h2>' },
  ]), /a.typ:.*missing-label/);
});
