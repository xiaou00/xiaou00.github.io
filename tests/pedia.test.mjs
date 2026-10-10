import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdir, mkdtemp, readFile, rename, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';
import { createObject } from '../scripts/new-object.mjs';
import { createNote } from '../scripts/new-note.mjs';
import { discoverObjectFiles, objectIdentity, objectUrl, validateObjectTitle } from '../scripts/pedia.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';
import { notePage, pediaPage } from '../src/render.mjs';

const site = { base: '/blog/', url: 'https://example.com', title: '测试站', author: 'author', description: '' };
const dom = html => parseHTML(`<html><body>${html}</body></html>`).document;

test('encyclopedia titles are globally unique across folders and normalize equivalent Unicode', async () => {
  const root = await mkdtemp(join(tmpdir(), 'pedia-create-'));
  const directory = join(root, 'content/pedia');
  try {
    const title = '整数环 ℤ "引号" # & % ?';
    const filename = await createObject(root, `代数/${title}`);
    assert.equal(objectIdentity(`代数/${title}.typ`).title, title);
    assert.equal(objectUrl(site, title), `/blog/pedia/${encodeURIComponent(title)}/`);
    assert.equal(await readFile(join(root, filename), 'utf8'), '#import "../../template.typ": *\n\n#show: note\n\n');
    await assert.rejects(createObject(root, title), /Duplicate encyclopedia title/);
    await assert.rejects(createObject(root, `其他/${title}`), /Duplicate encyclopedia title/);
    await assert.rejects(createObject(root, '../越界'), /paths/);
    await assert.rejects(createObject(root, '   '), /titles cannot be blank/);
    await assert.rejects(createObject(root, '_草稿'), /drafts/);
    for (const invalid of ['', '.', '..', '目录/标题', 'a\\b', '\0', '\ud800']) assert.throws(() => validateObjectTitle(invalid));
    await writeFile(join(directory, '_draft.typ'), 'ignored');
    await mkdir(join(directory, '.hidden'));
    await writeFile(join(directory, '.hidden', `${title}.typ`), 'ignored');
    assert.deepEqual(await discoverObjectFiles(directory), [`代数/${title}.typ`]);
    await writeFile(join(directory, `${title}.typ`), 'duplicate');
    await assert.rejects(discoverObjectFiles(directory), /Duplicate encyclopedia title/);
    await rm(join(directory, `${title}.typ`));
    await createObject(root, 'Café');
    await assert.rejects(createObject(root, 'Cafe\u0301'), /Duplicate encyclopedia title/);
    await assert.rejects(createObject(root, 'Other/CAFE\u0301'), /Duplicate encyclopedia title/);
    await writeFile(join(directory, 'CAFÉ.typ'), 'duplicate');
    await assert.rejects(discoverObjectFiles(directory), /Duplicate encyclopedia title/);
    await rm(join(directory, 'CAFÉ.typ'));
    await writeFile(join(directory, 'Cafe\u0301.typ'), 'duplicate');
    await assert.rejects(discoverObjectFiles(directory), /Duplicate encyclopedia title/);
    const note = await createNote(root, title);
    await assert.rejects(createNote(root, title), { code: 'EEXIST' });
    assert.equal(await readFile(join(root, note), 'utf8'), '#import "../template.typ": *\n\n#show: note\n\n');
  } finally { await rm(root, { recursive: true, force: true }); }
  assert.deepEqual(await discoverObjectFiles(directory), []);
});

test('blank encyclopedia entries use the note template and free-form content supports title references', async () => {
  const root = await mkdtemp(join(tmpdir(), 'pedia-compile-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    await mkdir(join(root, 'content'));
    for (const name of ['template.typ', 'abbrev.typ', 'refs.typ', 'function-plot.typ']) await cp(resolve('content', name), join(root, 'content', name));
    const title = '整数环 ℤ & #?';
    const filename = await createObject(root, `代数/${title}`);
    const input = join(root, filename);
    const flags = ['--features', 'html', '--root', join(root, 'content'), '--input', `note-title=${title}`];
    const blank = prepareDocument((await compiler.compile(input, flags)).html, { filename });
    assert.equal(blank.text, '');
    assert.deepEqual(blank.toc, []);
    const source = await readFile(input, 'utf8');
    await writeFile(input, `${source}= 自由标题 <definition>\n正文关键词 $ZZ$.\n#theorem[结论.] <result>\n#note-ref("同名笔记", target: <claim>)\n#pedia("空白条目")\n#fold[自由讨论.]\n`);
    const entry = { ...objectIdentity(`代数/${title}.typ`), ...prepareDocument((await compiler.compile(input, flags)).html, { filename }) };
    const emptyFile = await createObject(root, '空白条目');
    const empty = { ...objectIdentity('空白条目.typ'), ...prepareDocument((await compiler.compile(join(root, emptyFile), flags)).html) };
    const noteInput = join(root, await createNote(root, '同名笔记'));
    const quotedTitle = JSON.stringify(title);
    await writeFile(noteInput, `#import "../template.typ": *
#show: note
= 结论 <claim>
#pedia(${quotedTitle}, target: <result>)
#pedia(${quotedTitle})[$X$]
#pedia[空白条目]
#pedia(${quotedTitle}, <result>)
#pedia(${quotedTitle}, <result>)[See $X$]
#pedia(${quotedTitle}, <result>)[]
#pedia(${quotedTitle}, target: "result")
#pedia(${quotedTitle}, <future>)
#pedia(${quotedTitle}, <future>)[Later $Y$]
#pedia("")[Pending $Z$]
#pedia[]
#pedia(${quotedTitle})[]
#pedia("Not written yet")
#pedia(${quotedTitle}, "Legacy caption")
`);
    const note = { slug: '同名笔记', title: '同名笔记', ...prepareDocument((await compiler.compile(noteInput, flags)).html) };
    resolveNoteLinks([note], site, [entry, empty]);
    const links = [...dom(note.html).querySelectorAll('a.note-reference')];
    assert.equal(links[0].getAttribute('href'), `${objectUrl(site, title)}#result`);
    assert.match(links[0].textContent, /整数环 ℤ & #\? \/ Theorem/);
    assert.ok(links[1].querySelector('math'), 'custom link captions keep MathML');
    assert.equal(links.length, 9);
    assert.equal(links[2].getAttribute('href'), objectUrl(site, empty.title), 'the content-block shorthand uses the title');
    for (const link of links.slice(3, 7)) assert.equal(link.getAttribute('href'), `${objectUrl(site, title)}#result`);
    assert.ok(links[4].querySelector('math'), 'positional targets support custom mathematical captions');
    assert.equal(links[5].textContent, links[0].textContent, 'an empty caption uses the target caption');
    assert.equal(links[7].textContent, title);
    assert.equal(links[8].textContent, 'Legacy caption', 'existing positional string captions remain valid');
    const placeholders = [...dom(note.html).querySelectorAll('.note-reference-missing')];
    assert.deepEqual(placeholders.map(node => node.textContent), [`${title} / future`, 'Later 𝑌', 'Pending 𝑍', '', 'Not written yet']);
    assert.ok(placeholders[1].querySelector('math'));
    assert.ok(placeholders[2].querySelector('math'));
    assert.ok(dom(entry.html).querySelector('math'));
    assert.deepEqual(entry.incoming, [note]);
    assert.deepEqual(note.incoming, [entry]);
    assert.deepEqual(empty.incoming, [note, entry]);
    const page = parseHTML(notePage(site, entry, [entry, empty])).document;
    assert.equal(page.querySelector('h1').textContent, title);
    assert.equal(page.querySelector('.source-link').getAttribute('href'), `/blog/sources/pedia/${encodeURIComponent('代数')}/${encodeURIComponent(title)}.typ`);
    assert.equal(page.querySelector('link[rel=canonical]').getAttribute('href'), `https://example.com${objectUrl(site, title)}`);
    assert.equal(page.querySelector('.site-header [aria-current]').textContent, 'Encyclopedia');
    assert.ok(page.querySelector('.note-pagination a'));
    const index = parseHTML(pediaPage(site, [entry, empty])).document;
    assert.equal(index.querySelector('.directory-node, .object-category-nav, .object-id'), null);
    assert.equal(index.querySelectorAll('.file-link').length, 2);
    assert.ok([...index.querySelectorAll('[data-search]')].some(row => row.dataset.search.includes('正文关键词')));
    assert.deepEqual([...index.querySelectorAll('.site-header nav a')].map(link => link.textContent), ['Home', 'Notes', 'Encyclopedia', 'Graph']);
    const emptyIndex = parseHTML(pediaPage(site, [])).document;
    assert.equal(emptyIndex.querySelectorAll('.file-link').length, 0);
    assert.match(emptyIndex.querySelector('.directory-empty').textContent, /No entries yet/);
    assert.ok((await compiler.compile(input, flags)).cached);
    const moved = join(root, 'content/pedia', `${title}.typ`);
    await rename(input, moved);
    await writeFile(moved, (await readFile(moved, 'utf8')).replace('../../template.typ', '../template.typ'));
    assert.equal(objectUrl(site, objectIdentity(`${title}.typ`).title), objectUrl(site, entry.title));
    assert.match((await compiler.compile(moved, flags)).html, /正文关键词/);
  } finally { await compiler.close(); await rm(root, { recursive: true, force: true }); }
});

test('deleted and renamed titles preserve reference text; anchors and cross-collection paths are checked', () => {
  const html = '<a data-object="整数环" data-note-auto="true" data-note-target="definition"></a><a data-object="整数环"><math><mi>X</mi></math></a>';
  const note = { slug: '整数环', title: '整数环', html };
  resolveNoteLinks([note]);
  assert.equal(dom(note.html).querySelectorAll('.note-reference-missing').length, 2);
  assert.ok(dom(note.html).querySelector('math'));
  const entry = { ...objectIdentity('整数环.typ'), html: '<h2 id="definition">定义</h2><a data-note="整数环" data-note-auto="true"></a>' };
  note.html = html;
  resolveNoteLinks([note], {}, [entry]);
  assert.equal(dom(note.html).querySelector('a').getAttribute('href'), `${objectUrl({ base: '/' }, '整数环')}#definition`);
  assert.deepEqual(entry.incoming, [note], 'a note and an entry can share a title');
  assert.deepEqual(note.incoming, [entry]);
  const pending = { ...note, html: '<a data-object="整数环" data-note-target="missing" data-note-auto="true"></a>' };
  resolveNoteLinks([pending], {}, [entry]);
  assert.equal(dom(pending.html).querySelector('.note-reference-missing').textContent, '整数环 / missing');
  assert.throws(() => resolveNoteLinks([], {}, [{ ...entry, html: '<a data-note="./整数环"></a>' }]), /Cross-collection/);
  assert.throws(() => resolveNoteLinks([{ ...note, html: '<a data-object="代数/整数环"></a>' }]), /path separators/);
  note.html = html;
  resolveNoteLinks([note], {}, [{ ...entry, title: '整数' }]);
  assert.equal(dom(note.html).querySelectorAll('.note-reference-missing').length, 2);
  note.html = '<a data-object="整数" data-note-auto="true"></a>';
  resolveNoteLinks([note], {}, [{ ...entry, title: '整数' }]);
  assert.equal(dom(note.html).querySelector('a').textContent, '整数');
});

test('pedia placeholders track missing labels, restoration and backlinks without recompiling the source', () => {
  const cache = new Map();
  const source = '<a data-object="connectivity" data-note-target="result" data-note-auto="true"></a>'
    + '<a data-object="CONNECTIVITY" data-note-target="result">See <math><mi>X</mi></math></a>'
    + '<a data-object="">To be linked</a>';
  const pass = (caption, { published = true, base = '/blog/', title = 'Connectivity' } = {}) => {
    const note = { slug: 'A', title: 'A', html: source };
    const entry = { ...objectIdentity(`${title}.typ`), html: caption ? `<figure id="result"><figcaption>${caption}</figcaption></figure>` : '<p>Work in progress.</p>' };
    resolveNoteLinks([note], { base }, published ? [entry] : [], cache);
    return { note, entry, document: dom(note.html) };
  };
  let result = pass(null);
  const originalRecord = cache.get('note:A');
  assert.equal(result.document.querySelectorAll('a').length, 0);
  assert.equal(result.document.querySelector('.note-reference-missing').textContent, 'connectivity / result');
  assert.deepEqual(result.note.outgoing, []);
  assert.deepEqual(result.entry.incoming, []);
  result = pass('Proposition 1.1');
  assert.equal(cache.get('note:A'), originalRecord);
  assert.equal(result.document.querySelectorAll('a[href="/blog/pedia/Connectivity/#result"]').length, 2);
  assert.equal(result.document.querySelector('a').textContent, 'connectivity / Proposition 1.1');
  assert.ok(result.document.querySelector('a math'));
  assert.equal(result.document.querySelector('.note-reference-missing').textContent, 'To be linked');
  assert.deepEqual(result.note.outgoing, [result.entry]);
  assert.deepEqual(result.entry.incoming, [result.note]);
  result = pass(null);
  assert.equal(result.document.querySelectorAll('a').length, 0);
  assert.deepEqual(result.entry.incoming, []);
  assert.ok(result.document.querySelector('.note-reference-missing math'));
  assert.equal(pass(null, { published: false }).document.querySelectorAll('a').length, 0);
  result = pass('Proposition 2.1', { base: '/' });
  assert.equal(result.document.querySelector('a').getAttribute('href'), '/pedia/Connectivity/#result');
  assert.equal(result.document.querySelector('a').textContent, 'connectivity / Proposition 2.1');
  assert.deepEqual(result.entry.incoming, [result.note]);
  result = pass('Proposition 2.1', { title: 'CONNECTIVITY' });
  assert.equal(result.document.querySelector('a').getAttribute('href'), '/blog/pedia/CONNECTIVITY/#result', 'a case-only file rename updates the canonical URL');
  assert.equal(result.document.querySelector('a').textContent, 'connectivity / Proposition 2.1', 'a case-only file rename preserves the spelling supplied in the reference');
  assert.deepEqual(result.entry.incoming, [result.note]);
});
