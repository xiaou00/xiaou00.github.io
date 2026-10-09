import test from 'node:test';
import assert from 'node:assert/strict';
import { copyFile, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { discoverAssetsImages, resolveAssetsImages } from '../scripts/images.mjs';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';

test('assets-image resolves nested image paths without specifying a display size', async () => {
  const root = await mkdtemp(join(tmpdir(), 'liber-assets-image-'));
  const compiler = new TypstCompiler({ cwd: root });
  const input = join(root, 'note.typ');
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'function-plot.typ']) await copyFile(resolve('content', name), join(root, name));
    assert.deepEqual(await discoverAssetsImages(root), []);
    const folder = join(root, 'assets/几何');
    await mkdir(folder, { recursive: true });
    const svg = '<svg xmlns="http://www.w3.org/2000/svg" width="900" height="450"><rect width="900" height="450" fill="red"/></svg>';
    await writeFile(join(folder, '示意 #?.svg'), svg);
    await writeFile(join(folder, '_草稿.svg'), svg);
    await writeFile(join(folder, '说明.txt'), '不发布');
    await writeFile(input, '#import "template.typ": *\n#show: note\n前文.\n#assets-image("几何/示意 #?")\n#assets-image("几何/示意 #?.svg", alt: "几何示意图")\n后文.');
    const flags = ['--features', 'html', '--root', root];
    const compiled = await compiler.compile(input, flags);
    const entry = { ...prepareDocument(compiled.html, { filename: 'note.typ' }), filename: 'note.typ' };
    const files = await discoverAssetsImages(root);
    assert.equal(files.length, 1);
    assert.equal(resolveAssetsImages([entry], { base: '/math/' }, files).length, 1, 'repeated references share one asset');
    const { document } = parseHTML(`<html><body>${entry.html}</body></html>`);
    const images = [...document.querySelectorAll('.assets-image > img')];
    assert.equal(images.length, 2);
    for (const image of images) {
      assert.equal(image.getAttribute('src'), `/math/assets/${encodeURIComponent('几何')}/${encodeURIComponent('示意 #?.svg')}`);
      assert.equal(image.hasAttribute('width') || image.hasAttribute('height') || image.hasAttribute('style'), false);
    }
    assert.equal(images[1].getAttribute('alt'), '几何示意图');
    assert.equal(document.querySelector('[data-assets-image]'), null);
    assert.equal((await compiler.compile(input, flags)).cached, true);
    assert.throws(() => resolveAssetsImages([{ ...prepareDocument(compiled.html), filename: 'note.typ' }], { base: '/' }, []), /note\.typ: assets-image image.*was not found/);
    assert.throws(() => resolveAssetsImages([{ html: '<img data-assets-image="../outside.png">' }], { base: '/' }, files), /was not found/);
    for (const call of ['#assets-image(1)', '#assets-image("")', '#assets-image("示意图", alt: 1)']) {
      await writeFile(input, `#import "template.typ": *\n#show: note\n${call}`);
      await assert.rejects(compiler.compile(input, flags), /assets-image:/);
    }
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
