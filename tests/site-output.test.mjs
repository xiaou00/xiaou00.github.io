import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, readFile, rm, stat, utimes, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { SiteOutput } from '../scripts/site-output.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';

test('staging reuses unchanged files without changing published output and detects same-size asset edits', async () => {
  const root = await mkdtemp(join(tmpdir(), 'site-output-test-'));
  const source = join(root, 'image.svg');
  const previous = join(root, 'published');
  const stage = join(root, 'stage');
  try {
    await writeFile(source, 'original');
    const first = new SiteOutput(previous, join(root, 'absent'));
    await first.write('index.html', 'first page');
    await first.write('deleted/index.html', 'removed later');
    await first.copy(source, 'image.svg');
    const second = new SiteOutput(stage, previous, first.snapshot());
    await second.write('index.html', 'first page');
    await second.copy(source, 'image.svg');
    assert.equal(second.stats.reused, 2);
    assert.equal(second.stats.written, 0);
    await second.write('index.html', 'changed page');
    assert.equal(await readFile(join(previous, 'index.html'), 'utf8'), 'first page', 'overriding a reused file cannot overwrite the published hard link');
    assert.equal(await readFile(join(stage, 'index.html'), 'utf8'), 'changed page');
    await assert.rejects(stat(join(stage, 'deleted/index.html')), { code: 'ENOENT' });
    const times = await stat(source);
    await writeFile(source, 'modified');
    await utimes(source, times.atime, times.mtime);
    await second.copy(source, 'image.svg');
    assert.equal(await readFile(join(stage, 'image.svg'), 'utf8'), 'modified');
    assert.equal(await readFile(join(previous, 'image.svg'), 'utf8'), 'original');
    assert.notEqual(second.fingerprint(), first.fingerprint());
    const third = new SiteOutput(join(root, 'next'), stage, second.snapshot());
    await third.copy(source, 'image.svg');
    await third.write('index.html', 'changed page');
    assert.equal(third.fingerprint(), second.fingerprint(), 'unchanged saves and output ordering do not trigger a reload');
    assert.equal(third.stats.written, 0);
  } finally { await rm(root, { recursive: true, force: true }); }
});

test('cached link resolution tracks target captions, deletion, restoration, backlinks and deployment base', () => {
  const cache = new Map();
  const source = '<a data-note="b" data-note-target="definition" data-note-auto="true"></a>';
  const pass = (caption, { base = '/', deleted = false, linked = true } = {}) => {
    const entries = [{ slug: 'a', title: 'A', html: linked ? source : '<p>Independent</p>' }];
    if (!deleted) entries.push({ slug: 'b', title: 'B', html: `<h2 id="definition">${caption}</h2>` });
    resolveNoteLinks(entries, { base }, [], cache);
    return entries;
  };
  let [a, b] = pass('Original');
  assert.ok(a.html.includes('b / Original'));
  assert.deepEqual(b.incoming, [a]);
  const originalRecord = cache.get('note:a');
  [a, b] = pass('Updated');
  assert.equal(cache.get('note:a'), originalRecord, 'source parsing is reused when only the target changes');
  assert.ok(a.html.includes('b / Updated'));
  assert.deepEqual(b.incoming, [a]);
  assert.ok(pass('Updated', { base: '/blog/' })[0].html.includes('/blog/notes/b/#definition'));
  assert.ok(pass('Updated', { deleted: true })[0].html.includes('note-reference-missing'));
  [a, b] = pass('Restored');
  assert.ok(a.html.includes('b / Restored'));
  assert.deepEqual(a.outgoing, [b]);
  assert.deepEqual(pass('Restored', { linked: false })[1].incoming, []);
  assert.throws(() => resolveNoteLinks([
    { slug: 'a', title: 'A', html: source }, { slug: 'b', title: 'B', html: '<h2 id="new">Renamed label</h2>' },
  ], { base: '/' }, [], cache), /no label/);
});
