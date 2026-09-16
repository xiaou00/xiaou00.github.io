import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdir, mkdtemp, rm, stat, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareTypstFonts } from '../scripts/typst-fonts.mjs';

test('diagram fonts work without system fonts, are reused and invalidate on replacement', async () => {
  const root = await mkdtemp(join(tmpdir(), 'typst-fonts-test-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    await mkdir(join(root, 'public/fonts'), { recursive: true });
    for (const name of ['math', 'serif-cn']) {
      await cp(resolve('public/fonts', `${name}.woff2`), join(root, 'public/fonts', `${name}.woff2`));
    }
    for (const name of ['template.typ', 'abbrev.typ']) await cp(resolve('content', name), join(root, name));
    const fontPath = await prepareTypstFonts(root);
    const modified = (await stat(join(fontPath, 'serif-cn.otf'))).mtimeMs;
    assert.equal(await prepareTypstFonts(root), fontPath);
    assert.equal((await stat(join(fontPath, 'serif-cn.otf'))).mtimeMs, modified, 'unchanged fonts are not decoded again');
    const fonts = await compiler.run(['fonts', '--ignore-system-fonts', '--font-path', fontPath]);
    assert.match(fonts, /^Libertinus Math$/m);
    assert.match(fonts, /^Source Han Serif$/m);
    const input = join(root, 'note.typ');
    await writeFile(input, `#import "template.typ": *
#import "@preview/fletcher:0.5.8": *
#show: note
#web-diagram(diagram({
  node((0, 0), [$cal(C)$ 中文])
  node((1, 0), [$Ani(cal(C))$])
  edge((0, 0), (1, 0), "->", $yo$)
}))
// Explicit font samples to verify the actual outlines selected inside Fletcher.
#html.frame([
  #text(font: "Source Han Serif", size: 11pt)[中文]
  #text(font: "Source Han Serif", size: 9.9pt)[よ]
  #{
    show math.equation: set text(font: "Libertinus Math")
    $cal(C)$
  }
])`);
    const flags = ['--features', 'html', '--root', root, '--ignore-system-fonts', '--font-path', fontPath];
    const compiled = await compiler.compile(input, flags);
    const { document } = parseHTML(compiled.html);
    const outlines = svg => [...svg.querySelectorAll('symbol path')].map(path => path.getAttribute('d'));
    const diagram = outlines(document.querySelector('.diagram-scroll > svg'));
    const samples = outlines(document.querySelectorAll('svg')[1]);
    assert.equal(samples.length, 4);
    assert.deepEqual(samples.map(path => diagram.includes(path)), [true, true, true, true], 'CJK, Yoneda and math use the bundled font outlines');
    assert.ok((await compiler.compile(input, flags)).cached, 'diagrams still use the HTML cache');
    await cp(resolve('public/fonts/display.woff2'), join(root, 'public/fonts/math.woff2'));
    assert.notEqual(await prepareTypstFonts(root), fontPath, 'replacing a font changes the compiler flags and cache key');
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
