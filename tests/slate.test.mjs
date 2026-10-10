import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { prepareDocument } from '../scripts/build.mjs';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareTypstFonts } from '../scripts/typst-fonts.mjs';

test('SLATE chapter counters, equation numbers, heading anchors and native references agree', async () => {
  const root = await mkdtemp(join(tmpdir(), 'slate-test-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    for (const name of ['template.typ', 'print-template.typ', 'abbrev.typ', 'refs.typ', 'function-plot.typ']) {
      await cp(resolve('content', name), join(root, name));
    }
    const specimen = await readFile(new URL('./fixtures/Slate.typ', import.meta.url), 'utf8');
    const input = join(root, 'sample.typ');
    await writeFile(input, specimen);
    const fontPath = await prepareTypstFonts(resolve('.'));
    const flags = ['--root', root, '--ignore-system-fonts', '--font-path', fontPath];
    const compiled = await compiler.compile(input, ['--features', 'html', ...flags]);
    const prepared = prepareDocument(compiled.html);
    const { document } = parseHTML(`<html><body>${prepared.html}</body></html>`);
    const text = selector => [...document.querySelectorAll(selector)].map(node => node.textContent.replace(/\s+/g, ' ').trim());
    assert.deepEqual(text('.env-label'), ['Definition 1.1', 'Theorem 1.1', 'Lemma 1.2', 'Proposition 1.3', 'Corollary 1.4', 'Remark 1.1', 'Example 1.1', 'Construction 1.1', 'Claim 1.1', 'Question 1.1', 'Answer 1.1', 'Exercise 1.1', 'Theorem 2.1', 'Theorem 2.2']);
    assert.deepEqual(text('.equation-number'), ['(1.1)', '(2.1)', '(2.2)']);
    assert.equal(document.querySelectorAll('math[display="block"]').length, 4, 'unlabeled equations remain visible without consuming a number');
    assert.deepEqual(text('.chapter-label'), []);
    assert.deepEqual(text('.heading-number'), ['1', '1.1', '1.1.1', '2']);
    assert.deepEqual(prepared.toc.filter(item => item.level === 1).map(item => item.text), ['1 Foundations', '2 A new chapter', 'Afterword']);
    assert.deepEqual(text('.env-unruled .env-label'), ['Remark 1.1', 'Example 1.1', 'Construction 1.1']);
    assert.deepEqual(text('.env-target'), ['(to Question 1.1)']);
    assert.ok(document.getElementById('unreferenced-equation'), 'unreferenced equations can be linked from other pages');
    const ids = [...document.querySelectorAll('[id]')].map(node => node.id);
    assert.equal(new Set(ids).size, ids.length);
    for (const link of document.querySelectorAll('a[href^="#"]')) {
      assert.ok(document.getElementById(decodeURIComponent(link.getAttribute('href').slice(1))), link.outerHTML);
    }
    assert.ok(prepared.toc.some(item => item.id === 'foundations'));
    assert.ok(text('a').includes('Equation (2.1)'));
    assert.ok(text('a').includes('Section 1'));
    assert.deepEqual([...document.querySelectorAll('a[href^="https://"]')].map(link => [
      link.textContent, link.getAttribute('href'),
    ]), [
      ['[Stacks, Tag 0385]', 'https://stacks.math.columbia.edu/tag/0385'],
      ['[Stacks, Tag 01IQ]', 'https://stacks.math.columbia.edu/tag/01IQ'],
      ['[HA, Corollary 1.1.3.4]', 'https://www.math.ias.edu/~lurie/papers/HA.pdf'],
      ['[HA]', 'https://www.math.ias.edu/~lurie/papers/HA.pdf'],
      ['[HTT]', 'https://www.math.ias.edu/~lurie/papers/HTT.pdf'],
      ['[HTT, Theorem 6.1.0.6]', 'https://www.math.ias.edu/~lurie/papers/HTT.pdf'],
      ['[Kerodon, Tag 0003]', 'https://kerodon.net/tag/0003'],
    ]);
    assert.equal(document.querySelector('a[href$="HTT.pdf"] em').textContent, 'Theorem', 'reference locators preserve rich content');
    // The same authoring content must also compile using the actual print
    // template, including labels, all statement kinds and `to:` references.
    await writeFile(input, specimen.replace('"/template.typ"', '"/print-template.typ"'));
    const pdf = join(root, 'sample.pdf');
    await compiler.run(['compile', ...flags, input, pdf]);
    assert.equal((await readFile(pdf)).subarray(0, 4).toString(), '%PDF');
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
