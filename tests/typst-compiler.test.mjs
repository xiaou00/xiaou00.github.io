import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, readdir, rm, stat, utimes, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';

test('disk cache follows real dependencies, survives restarts and rejects stale or corrupt entries', async () => {
  const root = await mkdtemp(join(tmpdir(), 'typst-cache-test-'));
  const input = join(root, 'note.typ');
  const shared = join(root, 'shared.typ');
  const flags = ['--features', 'html', '--root', root];
  const options = { cwd: root, cacheDir: join(root, 'cache') };
  let compiler = new TypstCompiler(options);
  try {
    await writeFile(input, '#include "shared.typ"\n#sys.inputs.at("title", default: "Default")');
    await writeFile(shared, 'First value');
    const first = await compiler.compile(input, flags);
    assert.equal(first.cached, false);
    await compiler.close();
    compiler = new TypstCompiler(options);
    const restored = await compiler.compile(input, flags);
    assert.equal(restored.cached, true, 'another compiler instance reuses the disk cache');
    assert.equal(restored.html, first.html);
    await writeFile(join(root, 'unrelated.typ'), 'unrelated edit');
    assert.equal((await compiler.compile(input, flags)).cached, true);
    const times = await stat(shared);
    await writeFile(shared, 'Other value');
    await utimes(shared, times.atime, times.mtime);
    const edited = await compiler.compile(input, flags);
    assert.equal(edited.cached, false, 'dependency content is checked even when its timestamp is unchanged');
    assert.ok(edited.html.includes('Other value'));
    const renamed = await compiler.compile(input, [...flags, '--input', 'title=Renamed']);
    assert.equal(renamed.cached, false, 'compiler inputs are part of the cache key');
    assert.ok(renamed.html.includes('Renamed'));
    for (const file of await readdir(options.cacheDir)) await writeFile(join(options.cacheDir, file), '{broken');
    assert.equal((await compiler.compile(input, flags)).cached, false, 'a damaged cache rebuilds cleanly');
    await rm(shared);
    await assert.rejects(compiler.compile(input, flags), /file not found/);
    await writeFile(shared, 'Restored dependency');
    assert.ok((await compiler.compile(input, flags)).html.includes('Restored dependency'));
    await writeFile(input, 'Independent note');
    assert.ok((await compiler.compile(input, flags)).html.includes('Independent note'));
    await writeFile(shared, 'No longer imported');
    assert.equal((await compiler.compile(input, flags)).cached, true);
    assert.equal((await compiler.compile(input, flags, { fresh: true })).cached, false);
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});

test('watch compiler reuses Fletcher frames, updates dependencies and recovers from errors', { timeout: 120000 }, async () => {
  const root = await mkdtemp(join(tmpdir(), 'typst-watch-test-'));
  const input = join(root, 'note.typ');
  const shared = join(root, 'shared.typ');
  const flags = ['--features', 'html', '--root', root];
  const compiler = new TypstCompiler({ cwd: root, watch: true });
  const source = `#import "@preview/fletcher:0.5.8": *
#import "shared.typ": diagram-label
Original paragraph.
#html.frame(diagram({
  node((0, 0), diagram-label)
  node((1, 0), $B$)
  edge((0, 0), (1, 0), "->", $f$)
}))
`;
  const svg = html => parseHTML(html).document.querySelector('svg').outerHTML;
  try {
    await writeFile(shared, '#let diagram-label = $A$');
    await writeFile(input, source);
    const cold = await compiler.compile(input, flags);
    assert.equal(cold.cached, false);
    assert.equal(cold.incremental, false);
    const child = compiler.workers.get(input).child;
    assert.equal((await compiler.compile(input, flags)).cached, true, 'unchanged notes need no compilation');
    await writeFile(input, source.replace('Original paragraph.', 'Edited paragraph.'));
    const warm = await compiler.compile(input, flags);
    assert.equal(warm.incremental, true);
    assert.ok(warm.html.includes('Edited paragraph.'));
    assert.equal(svg(warm.html), svg(cold.html), 'editing prose preserves the diagram');
    assert.equal(compiler.workers.get(input).child, child, 'the native compiler and its layout cache stay alive');
    console.log(`Fletcher: cold ${cold.milliseconds} ms, prose edit ${warm.milliseconds} ms`);
    await writeFile(shared, '#let diagram-label = $Z$');
    const diagramEdit = await compiler.compile(input, flags);
    assert.notEqual(svg(diagramEdit.html), svg(cold.html), 'an imported label change redraws the diagram');
    await writeFile(input, '#missing-variable');
    await assert.rejects(compiler.compile(input, flags), /unknown variable/);
    await writeFile(input, source);
    assert.ok((await compiler.compile(input, flags)).html.includes('Original paragraph.'));
    await writeFile(input, 'Dependency removed.');
    assert.ok((await compiler.compile(input, flags)).html.includes('Dependency removed.'));
    await writeFile(input, 'First quick edit.');
    await writeFile(input, 'Latest quick edit.');
    assert.ok((await compiler.compile(input, flags)).html.includes('Latest quick edit.'));
    await compiler.retain([]);
    assert.equal(compiler.workers.size, 0);
    assert.ok(child.exitCode !== null || child.signalCode !== null, 'deleted notes release their compiler process');
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});

test('Chinese source and imported text edits match a clean compile and never cache corrupted text', async () => {
  const root = await mkdtemp(join(tmpdir(), 'typst-unicode-test-'));
  const input = join(root, 'note.typ');
  const shared = join(root, 'shared.typ');
  const flags = ['--features', 'html', '--root', root];
  const watcher = new TypstCompiler({ cwd: root, watch: true });
  const batch = new TypstCompiler({ cwd: root });
  const source = '#include "shared.typ"\n#html.elem("a", attrs: ("data-note": "./子目录/目标 笔记.typ"), [])';
  try {
    await writeFile(shared, '笔记');
    await writeFile(input, source);
    await watcher.compile(input, flags);
    await writeFile(input, source.replace('目标 笔记.typ', '目标标题已更新.typ'));
    const renamed = await watcher.compile(input, flags);
    assert.ok(renamed.html.includes('目标标题已更新.typ'));
    assert.equal(renamed.html, (await batch.compile(input, flags, { fresh: true })).html);
    await writeFile(shared, '已更新');
    const imported = await watcher.compile(input, flags);
    assert.ok(imported.html.includes('已更新'));
    assert.equal(imported.html, (await batch.compile(input, flags, { fresh: true })).html);
    assert.equal((await batch.compile(input, flags)).html, imported.html);
  } finally {
    await watcher.close();
    await batch.close();
    await rm(root, { recursive: true, force: true });
  }
});
