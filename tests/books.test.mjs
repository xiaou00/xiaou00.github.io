import test from 'node:test';
import assert from 'node:assert/strict';
import { copyFile, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { sectionIdentity, discoverBookFiles, groupBooks } from '../scripts/books.mjs';
import { prepareDocument } from '../scripts/build.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';
import { bookPage, bookChapterPage, booksPage, notePage } from '../src/render.mjs';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareTypstFonts } from '../scripts/typst-fonts.mjs';

const first = '书籍示例/01 基础/01.1 群.typ';
const second = '书籍示例/01 基础/01.2 进一步讨论.typ';
const later = '书籍示例/01 基础/01.10 补充.typ';
const nextChapter = '书籍示例/02 应用/02.1 例子.typ';

test('books discover chapters and naturally ordered sections, omit drafts and reject conflicting numbers', async () => {
  assert.equal(sectionIdentity(first).chapterNumber, 1);
  assert.equal(sectionIdentity(first).sectionNumber, 1);
  for (const file of ['书/01 基础.typ', '书/01 基础/02.1 错误.typ', '书/01 基础/01.0 错误.typ', '书/01 基础/01.1  .typ']) {
    assert.throws(() => sectionIdentity(file));
  }
  const root = await mkdtemp(join(tmpdir(), 'liber-book-paths-'));
  const put = async file => { await mkdir(join(root, file, '..'), { recursive: true }); await writeFile(join(root, file), ''); };
  try {
    for (const file of [later, second, nextChapter, first, '书籍示例/01 基础/_草稿.typ', '_草稿/任意.typ']) await put(file);
    const files = await discoverBookFiles(root);
    assert.deepEqual(files, [first, second, later, nextChapter]);
    const book = groupBooks(files.reverse().map(sectionIdentity))[0];
    assert.deepEqual(book.chapters.map(chapter => chapter.number), [1, 2]);
    assert.deepEqual(book.chapters[0].sections.map(section => section.sectionNumber), [1, 2, 10]);
    const duplicate = '书籍示例/01 基础/01.2 重复.typ';
    await put(duplicate);
    await assert.rejects(discoverBookFiles(root), /小节编号不能重复/);
    await rm(join(root, duplicate));
    await put('书籍示例/01 重复章/01.3 另一节.typ');
    await assert.rejects(discoverBookFiles(root), /章号不能重复/);
  } finally { await rm(root, { recursive: true, force: true }); }
});

test('book counters continue across sections, reset per chapter, and keep links and caches correct', { timeout: 60000 }, async () => {
  const root = await mkdtemp(join(tmpdir(), 'liber-book-numbering-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'function-plot.typ']) await copyFile(resolve('content', name), join(root, name));
    const fontPath = await prepareTypstFonts(resolve('.'));
    const flags = ['--features', 'html', '--root', root, '--ignore-system-fonts', '--font-path', fontPath];
    const sources = [
      [first, `= 概念 <section>
#theorem[结论.] <result>
#definition[定义.]
#lemma[引理.]
#proposition[命题.]
#corollary[推论.]
#axiom[公理.]
#exercise[练习.]
#construction[构造.]
#claim[断言.]
#remark[注记.]
#proof[证明.]
== 范例
#theorem[第二个结论.] <second>
@result, @second.
#figure(table(columns: 1, [表]), caption: [测试表格])
#function-plot(calc.sin, caption: [测试函数图])`],
      [second, '= 讨论\n#theorem[接续结论.] <result>\n#lemma[接续引理.]\n#book-ref("./01.1 群.typ", target: <result>)\n#note-ref("书籍示例/01 基础/01.1 群")'],
      [later, '#definition[中间小节未出现定义时, 仍接续上一个定义.]'],
      [nextChapter, '#theorem[新章结论.]'],
    ];
    for (const [filename, body] of sources) {
      const input = join(root, 'books', filename);
      await mkdir(join(input, '..'), { recursive: true });
      await writeFile(input, `#import "../../../template.typ": *\n#show: note\n${body}`);
    }
    const compileSection = async (filename, counters = {}) => {
      const identity = sectionIdentity(filename);
      const result = await compiler.compile(join(root, 'books', filename), [...flags,
        '--input', `book-chapter=${identity.chapterNumber}`, '--input', `book-section=${identity.sectionNumber}`,
        '--input', `book-counters=${JSON.stringify(counters)}`]);
      return { ...identity, ...prepareDocument(result.html, { filename }), cached: result.cached };
    };
    const a = await compileSection(first);
    const b = await compileSection(second, a.bookCounters);
    const c = await compileSection(later, b.bookCounters);
    const d = await compileSection(nextChapter);
    const captions = section => {
      const { document } = parseHTML(`<html><body>${section.html}</body></html>`);
      return [...document.querySelectorAll('figcaption')].map(node => node.textContent.replaceAll('\u00a0', ' ').trim());
    };
    for (const name of ['定理', '定义', '引理', '命题', '推论', '公理', '练习', '构造', '断言']) assert.ok(captions(a).includes(`${name} 1.1`));
    assert.ok(captions(a).includes('定理 1.2'));
    assert.ok(captions(a).includes('注'));
    assert.ok(captions(a).some(text => /1\.1/.test(text) && text.includes('测试表格')));
    assert.ok(captions(a).some(text => /1\.1/.test(text) && text.includes('测试函数图')));
    assert.ok(a.toc[0].text.startsWith('1.1.1'));
    assert.deepEqual(captions(b), ['定理 1.3', '引理 1.2']);
    assert.deepEqual(captions(c), ['定义 1.2']);
    assert.deepEqual(captions(d), ['定理 2.1']);
    assert.ok(!a.html.includes('data-book-counters'));
    assert.equal((await compileSection(second, a.bookCounters)).cached, true);

    // Changing an earlier section's count invalidates only the affected inputs.
    const input = join(root, 'books', first);
    await writeFile(input, `#import "../../../template.typ": *\n#show: note\n${sources[0][1]}\n#theorem[新增结论.]`);
    const updated = await compileSection(first);
    const following = await compileSection(second, updated.bookCounters);
    assert.equal(following.cached, false);
    assert.ok(captions(following).includes('定理 1.4'));
    assert.deepEqual(captions(await compileSection(second)), ['定理 1.1', '引理 1.1'], 'deleting the preceding section resets its successor');

    // Notes and sections can share an exact path, with separate references.
    const sections = [a, b, c, d];
    const note = { slug: a.slug, title: '独立笔记', html: `<a data-book="${b.slug}" data-note-auto="true"></a>` };
    const site = { base: '/math/', title: 'Test', author: '作者' };
    resolveNoteLinks([note], site, [], sections);
    assert.ok(b.html.includes('/math/books/') && b.html.includes('/math/notes/'));
    assert.ok(b.html.includes('定理 1.1'));
    assert.equal(a.incoming[0], b);
    const book = groupBooks(sections)[0];
    assert.ok(booksPage(site, sections).includes('4 节'));
    const landing = bookPage(site, book);
    assert.ok(landing.indexOf('01 基础') < landing.indexOf('02 应用'));
    assert.ok(bookChapterPage(site, book, book.chapters[0]).includes('01.10 补充'));
    const { document } = parseHTML(notePage(site, c, sections));
    assert.equal(document.querySelector('.book-toc [aria-current="page"]').textContent, '01.10 补充');
    assert.match(document.querySelector('.source-link').getAttribute('href'), /^\/math\/sources\/books\//);
    assert.ok(document.querySelector('.note-pagination [rel="next"]').getAttribute('href').includes(encodeURIComponent('02 应用')));
    resolveNoteLinks([], site, [], [{ ...b, html: '<a data-book="./01.1 群" data-note-auto="true"></a>' }]);

    const ordinary = await compiler.compile(input, flags);
    const { document: plain } = parseHTML(ordinary.html);
    assert.match(plain.querySelector('figcaption').textContent.trim(), /定理\s+1$/);
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
