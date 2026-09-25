import test from 'node:test';
import assert from 'node:assert/strict';
import { copyFile, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareTypstFonts } from '../scripts/typst-fonts.mjs';

test('Young tableaux export SVG, reuse disk and incremental caches, and validate input', { timeout: 120000 }, async () => {
  const root = await mkdtemp(join(tmpdir(), 'typst-young-test-'));
  const input = join(root, 'note.typ');
  const shape = join(root, 'shape.typ');
  let compiler = new TypstCompiler({ cwd: root });
  const watcher = new TypstCompiler({ cwd: root, watch: true });
  const diagrams = html => [...parseHTML(html).document.querySelectorAll('.diagram-scroll > svg')];
  const borders = svg => [...svg.querySelectorAll('path[stroke]')].map(path => path.outerHTML);
  const source = `#import "template.typ": *
#import "shape.typ": partition, labels
#show: note
Original paragraph. $a + b$
#diagram-row[
  #young(..partition)
  #young(..partition, labels: labels)
]
#young(2, 1, labels: ($a_1$, $a_2$, [中文]))
#young(1, labels: (1,))
#young(2, 2)
`;
  try {
    for (const name of ['template.typ', 'abbrev.typ']) await copyFile(resolve('content', name), join(root, name));
    const fontPath = await prepareTypstFonts(resolve('.'));
    const flags = ['--features', 'html', '--root', root, '--ignore-system-fonts', '--font-path', fontPath];
    await writeFile(shape, '#let partition = (3, 2)\n#let labels = (1, 2, 3, 4, 5)');
    await writeFile(input, source);
    const first = await compiler.compile(input, flags);
    assert.equal(first.cached, false);
    const svgs = diagrams(first.html);
    assert.equal(svgs.length, 5);
    assert.equal(svgs[0].getAttribute('viewBox'), '0 0 55 37', 'three columns and two rows, with room for the outer border');
    assert.equal(borders(svgs[0]).length, 15, 'five cells share their internal borders and leave the lower right corner empty');
    assert.deepEqual(borders(svgs[1]), borders(svgs[0]), 'filling cells preserves the Young diagram');
    assert.equal(svgs[0].querySelectorAll('use').length, 0);
    assert.equal(svgs[1].querySelectorAll('use').length, 5, 'all five labels become SVG glyphs');
    assert.equal(svgs[2].querySelectorAll('use').length, 6, 'math subscripts and Chinese labels render without system fonts');
    assert.ok(Number(svgs[2].getAttribute('viewBox').split(' ')[2]) > 37, 'wide labels expand square cells instead of wrapping or overflowing');
    assert.equal(svgs[3].getAttribute('viewBox'), '0 0 19 19', 'a single cell is supported');
    assert.equal(svgs[4].getAttribute('viewBox'), '0 0 37 37', 'equal row lengths are supported');
    assert.equal(parseHTML(first.html).document.querySelector('math figure, math svg, table'), null);
    assert.ok(parseHTML(first.html).document.querySelector('math'), 'surrounding equations remain MathML');

    await compiler.close();
    compiler = new TypstCompiler({ cwd: root });
    const restored = await compiler.compile(input, flags);
    assert.equal(restored.cached, true, 'SVG output is restored from disk after restarting the compiler');
    assert.equal(restored.html, first.html);

    await watcher.compile(input, flags);
    await writeFile(input, source.replace('Original paragraph.', 'Edited paragraph.'));
    const proseEdit = await watcher.compile(input, flags);
    assert.equal(proseEdit.incremental, true);
    assert.deepEqual(diagrams(proseEdit.html).map(svg => svg.outerHTML), svgs.map(svg => svg.outerHTML), 'editing prose preserves SVG output');
    await writeFile(shape, '#let partition = (4, 1)\n#let labels = (5, 4, 3, 2, 1)');
    const shapeEdit = await watcher.compile(input, flags);
    assert.notEqual(diagrams(shapeEdit.html)[0].outerHTML, svgs[0].outerHTML, 'changing an imported partition redraws the SVG');
    assert.notEqual(diagrams(shapeEdit.html)[1].outerHTML, svgs[1].outerHTML, 'changing labels redraws the filled tableau');
    assert.equal((await compiler.compile(input, flags)).html, shapeEdit.html, 'updated SVG output also reaches the disk cache');
    await watcher.close();

    for (const [call, message] of [
      ['#young()', /请指定各行格数/],
      ['#young(2, 0)', /各行格数必须是正整数/],
      ['#young(1, 2)', /各行格数必须从上到下不递增/],
      ['#young(2, labels: (1,))', /标签数量必须等于格子总数 2/],
      ['#young(1, labels: [1])', /labels 必须是数组/],
      ['$young(3, 2)$', /请在正文中调用/],
    ]) {
      await writeFile(input, `#import "template.typ": *\n#show: note\n${call}`);
      await assert.rejects(compiler.compile(input, flags), message);
    }
  } finally {
    await watcher.close();
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
