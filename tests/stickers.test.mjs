import test from 'node:test';
import assert from 'node:assert/strict';
import { copyFile, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { discoverStickers, resolveStickers } from '../scripts/stickers.mjs';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';

test('sticker names resolve from both folders, respect the site base and survive compilation caching', async () => {
  const root = await mkdtemp(join(tmpdir(), 'liber-stickers-'));
  const compiler = new TypstCompiler({ cwd: root });
  const input = join(root, 'note.typ');
  const image = '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="100"><rect width="200" height="100" fill="red"/></svg>';
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'function-plot.typ']) await copyFile(resolve('content', name), join(root, name));
    assert.deepEqual(await discoverStickers(root), []);
    await mkdir(join(root, 'stickers'));
    await writeFile(join(root, 'stickers/xiaou0_idle.svg'), image);
    await writeFile(join(root, 'stickers/思考 #?.svg'), image);
    await writeFile(input, '#import "template.typ": *\n#show: note\n前文.\n#sticker("xiaou0_idle")\n#sticker("思考 #?.svg", width: 150pt, alt: "思考中")\n后文.');
    const flags = ['--features', 'html', '--root', root];
    const compiled = await compiler.compile(input, flags);
    const entry = { ...prepareDocument(compiled.html, { filename: 'note.typ' }), filename: 'note.typ' };
    const files = await discoverStickers(root);
    const used = resolveStickers([entry], { base: '/math/' }, files);
    assert.equal(used.length, 2);
    const { document } = parseHTML(`<html><body>${entry.html}</body></html>`);
    const images = [...document.querySelectorAll('.note-sticker > img')];
    assert.equal(images.length, 2);
    assert.equal(images[0].getAttribute('src'), '/math/stickers/xiaou0_idle.svg');
    assert.equal(images[0].getAttribute('style'), 'width: 120pt');
    assert.equal(images[1].getAttribute('src'), `/math/stickers/${encodeURIComponent('思考 #?.svg')}`);
    assert.equal(images[1].getAttribute('alt'), '思考中');
    assert.equal(images[1].getAttribute('style'), 'width: 150pt');
    assert.equal(document.querySelector('[data-sticker]'), null);

    // A new preferred asset resolves even when Typst reuses its cached HTML.
    await mkdir(join(root, 'sticker'));
    await writeFile(join(root, 'sticker/xiaou0_idle.png'), Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=', 'base64'));
    const cached = await compiler.compile(input, flags);
    assert.equal(cached.cached, true);
    const refreshed = { ...prepareDocument(cached.html), filename: 'note.typ' };
    assert.equal(resolveStickers([refreshed], { base: '/' }, await discoverStickers(root))[0].path, 'sticker/xiaou0_idle.png');
    await rm(join(root, 'sticker/xiaou0_idle.png'));
    await rm(join(root, 'stickers/xiaou0_idle.svg'));
    assert.throws(() => resolveStickers([{ ...prepareDocument(cached.html), filename: 'note.typ' }], { base: '/' }, []), /note\.typ: sticker 图片 "xiaou0_idle" 不存在/);
    assert.throws(() => resolveStickers([{ html: '<img data-sticker="../cover.png">' }], { base: '/' }, files), /不存在/);

    for (const call of ['#sticker(1)', '#sticker("")', '#sticker("xiaou0_idle", width: -1pt)']) {
      await writeFile(input, `#import "template.typ": *\n#show: note\n${call}`);
      await assert.rejects(compiler.compile(input, flags), /sticker:/);
    }
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
