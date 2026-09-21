import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';
import { createObject } from '../scripts/new-object.mjs';
import { discoverObjectFiles, finishObject, objectIdentity, objectMetadata, validateObjectId } from '../scripts/geopedia.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';
import { objectPage, geopediaPage } from '../src/render.mjs';

test('object IDs, category directories, drafts and exclusive creation follow the filename convention', async () => {
  for (const category of ['Schm', 'Stck', 'Drvd', 'Spct', 'Ring']) {
    assert.equal(objectIdentity(`${category}/${category}0001.typ`).number, 1);
    assert.equal(validateObjectId(`${category}9999`), `${category}9999`);
  }
  for (const filename of ['Schm/Schm0000.typ', 'Schm/Schm001.typ', 'Schm/Stck0001.typ', 'Other/Other0001.typ', 'Schm/sub/Schm0001.typ', 'Schm0001.typ', 'Ring/Ring0000.typ', 'Schm/Ring0001.typ', 'Ring/Schm0001.typ']) {
    assert.throws(() => objectIdentity(filename));
  }
  const root = await mkdtemp(join(tmpdir(), 'geopedia-create-'));
  try {
    const filename = await createObject(root, 'Schm0001', '名称 "引号" #include("secret")');
    assert.match(await readFile(join(root, filename), 'utf8'), /name: \[#"名称 \\"引号\\" #include\(\\"secret\\"\)"\]/);
    await assert.rejects(createObject(root, 'Schm0001'), { code: 'EEXIST' });
    await assert.rejects(createObject(root, '../Schm0002'), /无效的对象编号/);
    await writeFile(join(root, 'content/geopedia/Schm/_draft.typ'), 'ignored');
    assert.equal(await createObject(root, 'Ring0001', '环和代数'), 'content/geopedia/Ring/Ring0001.typ');
    assert.deepEqual(await discoverObjectFiles(join(root, 'content/geopedia')), ['Ring/Ring0001.typ', 'Schm/Schm0001.typ']);
    await writeFile(join(root, 'content/geopedia/Schm/Stck0001.typ'), 'invalid');
    await assert.rejects(discoverObjectFiles(join(root, 'content/geopedia')), /类别与目录一致/);
  } finally { await rm(root, { recursive: true, force: true }); }
});

test('encyclopedia property tags and invariant pairs preserve content, references and caching', async () => {
  const root = await mkdtemp(join(tmpdir(), 'geopedia-compile-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'geopedia-template.typ', 'geopedia-schema.json']) await cp(resolve('content', name), join(root, name));
    const flags = ['--features', 'html', '--root', root];
    const input = join(root, 'entry.typ');
    const source = `#import "geopedia-template.typ": *
#encyclopedia(
  name: [测试 $PP^1$], aliases: ([projective $PP^1$], [别名 *强调*]), introduction: [简介 $x$],
  base: [在指定的基域上.],
  definition: [正文关键词. #theorem[一个结论.] <result>],
  properties: (
    [自定义性质], [光滑 $X$], [非紧合], [分离],
  ),
  invariants: (
    ([示例成立], true), ([示例不成立], false), ([示例未记录], none),
    ([维数], 0), ([测试数值], 1.5), ([Euler 示性数], -2), ([群 $G$], [$ZZ$]),
  ),
  content: [
    一般讨论关键词.

    == 更多细节 <discussion-details>
    这里可以写公式 $x + y$ 和 #note-ref("Schm0001", target: <claim>).
    #fold[补充证明.]
  ],
)`;
    await writeFile(input, source);
    const compiled = await compiler.compile(input, flags);
    const prepared = prepareDocument(compiled.html, { filename: 'Schm/Schm0001.typ', object: true });
    const entry = { ...objectIdentity('Schm/Schm0001.typ'), ...prepared, ...objectMetadata(prepared.html, input) };
    assert.equal('properties' in entry, false, 'properties no longer have a separate filter index');
    assert.equal('numbers' in entry, false);
    assert.deepEqual(entry.toc.map(item => item.id), ['construction', 'properties', 'invariants', 'discussion', 'discussion-details']);
    assert.deepEqual(entry.aliases, ['projective ℙ1', '别名 强调']);
    assert.ok(parseHTML(`<html><body>${prepared.html}</body></html>`).document.querySelector('[data-object-alias] math'));
    const noteInput = join(root, 'note.typ');
    await writeFile(noteInput, `#import "template.typ": *
#show: note
= 结论 <claim>
#geopedia("Schm0001", target: <result>)
#geopedia("Schm0001")
#geopedia("Schm0001")[$X$]
`);
    const note = { slug: 'Schm0001', title: '同名笔记', ...prepareDocument((await compiler.compile(noteInput, flags)).html) };
    resolveNoteLinks([note], { base: '/blog/' }, [entry]);
    assert.match(note.html, /href="\/blog\/geopedia\/Schm0001\/#result"/);
    assert.match(note.html, /Schm0001 测试 ℙ1 \/ 定理/);
    const noteLinks = [...parseHTML(note.html).document.querySelectorAll('.note-reference')];
    assert.deepEqual(noteLinks.map(link => link.getAttribute('href')), ['/blog/geopedia/Schm0001/#result', '/blog/geopedia/Schm0001/', '/blog/geopedia/Schm0001/']);
    assert.equal(noteLinks[1].textContent, 'Schm0001 测试 ℙ1');
    assert.ok(noteLinks[2].querySelector('math'), 'custom geopedia link text preserves MathML');
    assert.match(entry.html, /href="\/blog\/notes\/Schm0001\/#claim"/);
    assert.deepEqual(note.incoming, [entry]);
    assert.deepEqual(entry.incoming, [note]);
    finishObject(entry);
    assert.match(entry.nameHtml, /<math>/);
    assert.match(entry.introductionHtml, /<math>/);
    assert.ok(!entry.html.includes('data-object-template'));
    const content = parseHTML(`<html><body>${entry.html}</body></html>`).document;
    assert.deepEqual([...content.querySelectorAll('.object-properties > li')].map(node => node.textContent), ['自定义性质', '光滑 𝑋', '非紧合', '分离']);
    assert.ok(content.querySelector('.object-properties math'));
    assert.deepEqual([...content.querySelectorAll('.object-facts dt')].map(node => node.textContent), ['示例成立', '示例不成立', '示例未记录', '维数', '测试数值', 'Euler 示性数', '群 𝐺']);
    assert.deepEqual([...content.querySelectorAll('.object-facts dd')].slice(0, 5).map(node => node.textContent), ['是', '否', '未记录', '0', '1.5']);
    assert.equal(content.querySelector('.note-fold').hasAttribute('open'), false);
    assert.ok(content.querySelector('.object-facts dt math'));
    assert.ok(content.querySelector('.object-facts dd math'));
    assert.ok(content.getElementById('discussion-details'));
    assert.ok(entry.text.includes('一般讨论关键词'));
    const schema = JSON.parse(await readFile(join(root, 'geopedia-schema.json'), 'utf8'));
    const site = { base: '/blog/', title: '测试站', author: 'author', description: '' };
    const next = { ...entry, ...objectIdentity('Schm/Schm0002.typ') };
    const other = { ...entry, ...objectIdentity('Stck/Stck0001.typ') };
    const page = parseHTML(objectPage(site, entry, [next, other, entry], schema, false)).document;
    assert.equal(page.querySelector('[rel="next"]').getAttribute('href'), '/blog/geopedia/Schm0002/');
    assert.equal(page.querySelector('[rel="prev"]'), null);
    assert.ok(page.querySelector('h1 math'));
    assert.equal(page.querySelector('.source-link').getAttribute('href'), '/blog/sources/geopedia/Schm/Schm0001.typ');
    assert.equal(page.querySelector('.site-header [aria-current]').textContent, 'GeoPedia');
    const index = parseHTML(geopediaPage(site, [entry], schema)).document;
    assert.equal(index.querySelector('[data-object-link]').getAttribute('href'), '/blog/geopedia/Schm0001/');
    assert.ok(index.querySelector('[data-object-row]').dataset.search.includes('projective'));
    assert.ok(index.querySelector('[data-object-row]').dataset.search.includes('光滑 x'));
    assert.equal(index.querySelector('select, input[type=number], [data-properties], [data-numbers]'), null);
    assert.ok((await compiler.compile(input, flags)).cached, 'unchanged objects reuse the existing cache');
    const template = join(root, 'geopedia-template.typ');
    await writeFile(template, (await readFile(template, 'utf8')).replace('[是]', '[成立]'));
    const changed = await compiler.compile(input, flags);
    assert.equal(changed.cached, false, 'shared template edits invalidate the compilation cache');
    assert.match(changed.html, /成立/);
    for (const argument of ['properties: [正文]', 'properties: ("字符串",)', 'properties: (([名称], [内容]),)', 'properties: ("旧键名": [内容])', 'invariants: (1, 2)']) {
      await writeFile(input, `#import "geopedia-template.typ": *\n#encyclopedia(name: [测试], definition: [定义], ${argument})`);
      await assert.rejects(compiler.compile(input, flags), /请填写|每一项应为/);
    }
    await writeFile(input, '#import "geopedia-template.typ": *\n#encyclopedia(name: [测试], definition: [定义], properties: (), invariants: ("旧键名": [仍可读取]), aliases: ("旧别名",), content: [])');
    const minimal = await compiler.compile(input, flags);
    assert.ok(!minimal.html.includes('object-properties'), 'empty properties do not create an empty tag list');
    assert.ok(!prepareDocument(minimal.html).toc.some(item => item.id === 'discussion'), 'empty content does not create a discussion section');
    await writeFile(input, '#import "geopedia-template.typ": *\n#encyclopedia(name: [测试], definition: [定义], properties: ([唯一性质],))');
    const single = await compiler.compile(input, flags);
    assert.deepEqual([...parseHTML(single.html).document.querySelectorAll('.object-properties > li')].map(node => node.textContent), ['唯一性质']);
  } finally { await compiler.close(); await rm(root, { recursive: true, force: true }); }
});

test('object deletion and restoration retain reference text and invalid IDs or anchors fail clearly', () => {
  const html = '<a data-object="Schm0001" data-note-auto="true" data-note-target="properties"></a><a data-object="Schm0001"><math><mi>X</mi></math></a>';
  const note = { slug: 'note', title: '笔记', html };
  resolveNoteLinks([note]);
  assert.match(note.html, /note-reference-missing/);
  assert.match(note.html, /Schm0001/);
  assert.match(note.html, /<math>/);
  const entry = { objectId: 'Schm0001', title: '新名称', html: '<h2 id="properties">基本性质</h2>' };
  note.html = html;
  resolveNoteLinks([note], {}, [entry]);
  assert.match(note.html, /Schm0001 新名称/);
  assert.deepEqual(entry.incoming, [note]);
  assert.throws(() => resolveNoteLinks([{ ...note, html: '<a data-object="Schm001"></a>' }]), /无效的对象编号/);
  assert.throws(() => resolveNoteLinks([{ ...note, html: '<a data-object="Schm0001" data-note-target="missing"></a>' }], {}, [entry]), /不存在标签/);
  assert.throws(() => objectMetadata('<p>内容</p>', 'Schm/Schm0001.typ'), /encyclopedia 模板/);
});
