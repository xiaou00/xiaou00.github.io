import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';

const dom = html => parseHTML(`<html><body>${html}</body></html>`).document;

test('Typst note references accept names, shorthand, labels and custom captions across collections', async () => {
  const root = await mkdtemp(join(tmpdir(), 'note-title-links-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    await mkdir(join(root, 'content/pedia'), { recursive: true });
    await mkdir(join(root, 'content/notes/Folder'), { recursive: true });
    for (const name of ['template.typ', 'abbrev.typ', 'refs.typ', 'function-plot.typ']) {
      await cp(resolve('content', name), join(root, 'content', name));
    }
    const input = join(root, 'content/pedia/Café Notes.typ');
    await writeFile(input, `#import "../template.typ": *
#show: note
#note-ref[café notes]
#note-ref("CAFE\u0301 NOTES", <result>)
#note-ref("Café Notes")[Read $X$]
#note-ref("Café Notes", <result>)[Proof $Y$]
#note-ref("Café Notes", target: <result>)[]
#note-ref("Café Notes", target: "result")
#note-ref("Café Notes", "Legacy caption")
#note-ref("Folder/Café Notes.typ")
#note-ref("")[Pending $Z$]
#note-ref[]
#note-ref[Not written yet]
`);
    const target = join(root, 'content/notes/Folder/Café Notes.typ');
    await writeFile(target, '#import "../../template.typ": *\n#show: note\n#theorem[A result.] <result>');
    const flags = ['--features', 'html', '--root', join(root, 'content')];
    const entry = { collection: 'pedia', title: 'Café Notes', slug: 'Café Notes',
      ...prepareDocument((await compiler.compile(input, flags)).html) };
    const note = { title: 'Café Notes', slug: 'Folder/Café Notes',
      ...prepareDocument((await compiler.compile(target, flags)).html) };
    resolveNoteLinks([note], { base: '/blog/' }, [entry]);
    const document = dom(entry.html);
    const links = [...document.querySelectorAll('a.note-reference')];
    const url = '/blog/notes/Folder/Caf%C3%A9%20Notes/';
    assert.equal(links.length, 8);
    assert.equal(links[0].getAttribute('href'), url);
    assert.equal(links[0].textContent, 'café notes');
    assert.ok(links[1].textContent.startsWith('CAFE\u0301 NOTES / Theorem'));
    for (const index of [1, 3, 4, 5]) assert.equal(links[index].getAttribute('href'), `${url}#result`);
    for (const index of [2, 3]) assert.ok(links[index].querySelector('math'));
    assert.ok(links[4].textContent.startsWith('Café Notes / Theorem'), 'empty captions use the automatic text');
    assert.equal(links[6].textContent, 'Legacy caption');
    assert.equal(links[7].getAttribute('href'), url, 'existing absolute paths still resolve');
    const missing = [...document.querySelectorAll('.note-reference-missing')];
    assert.deepEqual(missing.map(node => node.textContent), ['Pending 𝑍', '', 'Not written yet']);
    assert.ok(missing[0].querySelector('math'));
    assert.deepEqual(note.incoming, [entry]);
    assert.deepEqual(entry.outgoing, [note], 'repeated links produce one graph connection');
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});

test('cached name references follow folder moves, deletion, restoration and case changes', () => {
  const cache = new Map();
  const source = '<a data-note="café notes" data-note-auto="true"></a>';
  const pass = (slug, { title = 'Café Notes', base = '/' } = {}) => {
    const a = { slug: 'Other/Index', title: 'Index', html: source };
    const notes = [a];
    if (slug) notes.push({ slug, title, html: '<p>Target</p>' });
    resolveNoteLinks(notes, { base }, [], cache);
    return { a, b: notes[1], link: dom(a.html).querySelector('a') };
  };
  let result = pass('Folder/Café Notes');
  assert.equal(result.link.getAttribute('href'), '/notes/Folder/Caf%C3%A9%20Notes/');
  const record = cache.get('note:Other/Index');
  result = pass('Moved/CAFÉ Notes', { title: 'CAFÉ Notes', base: '/blog/' });
  assert.equal(cache.get('note:Other/Index'), record, 'moving the destination reuses parsed source');
  assert.equal(result.link.getAttribute('href'), '/blog/notes/Moved/CAF%C3%89%20Notes/');
  assert.equal(result.link.textContent, 'café notes');
  assert.deepEqual(result.b.incoming, [result.a]);
  assert.deepEqual(result.a.outgoing, [result.b]);
  assert.ok(!cache.has('note:Folder/Café Notes'));
  result = pass(null);
  assert.equal(result.link, null);
  assert.equal(dom(result.a.html).querySelector('.note-reference-missing').textContent, 'café notes');
  assert.deepEqual(result.a.outgoing, []);
  result = pass('Restored/Café Notes');
  assert.equal(result.link.getAttribute('href'), '/notes/Restored/Caf%C3%A9%20Notes/');
  assert.deepEqual(result.b.incoming, [result.a]);
});

test('ambiguous note names report candidates while explicit paths remain unambiguous', () => {
  const targets = () => [
    { slug: 'Algebra/Café', title: 'Café', html: '' },
    { slug: 'Geometry/CAFÉ', title: 'CAFÉ', html: '' },
  ];
  assert.throws(() => resolveNoteLinks([
    { slug: 'Index', title: 'Index', html: '<a data-note="café"></a>' }, ...targets(),
  ]), /Index.typ: Ambiguous note title.*Algebra\/Café.typ.*Geometry\/CAFÉ.typ/);
  const notes = [{ slug: 'Index', title: 'Index', html: '<a data-note="Algebra/Café" data-note-auto="true"></a>' }, ...targets()];
  resolveNoteLinks(notes);
  assert.equal(dom(notes[0].html).querySelector('a').getAttribute('href'), '/notes/Algebra/Caf%C3%A9/');
  assert.deepEqual(notes[0].outgoing, [notes[1]]);
});
