import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';
import { createObject } from '../scripts/new-object.mjs';
import { discoverObjectFiles, finishObject, objectIdentity, objectMetadata, validateObjectId } from '../scripts/sheafpedia.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';
import { objectPage, sheafpediaPage } from '../src/render.mjs';

test('object IDs, category directories, drafts and exclusive creation follow the filename convention', async () => {
  for (const category of ['Schm', 'Stck', 'Drvd', 'Spct', 'Ring']) {
    assert.equal(objectIdentity(`${category}/${category}0001.typ`).number, 1);
    assert.equal(validateObjectId(`${category}9999`), `${category}9999`);
  }
  for (const filename of ['Schm/Schm0000.typ', 'Schm/Schm001.typ', 'Schm/Stck0001.typ', 'Other/Other0001.typ', 'Schm/sub/Schm0001.typ', 'Schm0001.typ', 'Ring/Ring0000.typ', 'Schm/Ring0001.typ', 'Ring/Schm0001.typ']) {
    assert.throws(() => objectIdentity(filename));
  }
  const root = await mkdtemp(join(tmpdir(), 'sheafpedia-create-'));
  try {
    const filename = await createObject(root, 'Schm0001', '名称 "引号" #include("secret")');
    assert.match(await readFile(join(root, filename), 'utf8'), /name: \[#"名称 \\"引号\\" #include\(\\"secret\\"\)"\]/);
    await assert.rejects(createObject(root, 'Schm0001'), { code: 'EEXIST' });
    await assert.rejects(createObject(root, '../Schm0002'), /无效的对象编号/);
    await writeFile(join(root, 'content/sheafpedia/Schm/_draft.typ'), 'ignored');
    assert.equal(await createObject(root, 'Ring0001', '环和代数'), 'content/sheafpedia/Ring/Ring0001.typ');
    assert.deepEqual(await discoverObjectFiles(join(root, 'content/sheafpedia')), ['Ring/Ring0001.typ', 'Schm/Schm0001.typ']);
    await writeFile(join(root, 'content/sheafpedia/Schm/Stck0001.typ'), 'invalid');
    await assert.rejects(discoverObjectFiles(join(root, 'content/sheafpedia')), /类别与目录一致/);
  } finally { await rm(root, { recursive: true, force: true }); }
});

test('real encyclopedia compilation preserves booleans, zero, content, references, URLs and cached dependencies', async () => {
  const root = await mkdtemp(join(tmpdir(), 'sheafpedia-compile-'));
  const compiler = new TypstCompiler({ cwd: root });
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'sheafpedia-template.typ', 'sheafpedia-schema.json']) await cp(resolve('content', name), join(root, name));
    const flags = ['--features', 'html', '--root', root];
    const input = join(root, 'entry.typ');
    const source = `#import "sheafpedia-template.typ": *
#encyclopedia(
  name: [测试 $PP^1$], aliases: ("projective",), introduction: [简介 $x$],
  base: [在指定的基域上.],
  definition: [正文关键词. #theorem[一个结论.] <result>],
  smooth: true, proper: false, separated: none, dimension: 0,
  euler-characteristic: -2, extra-properties: ("特殊性质": false),
  numerical-invariants: ("测试数值": 1.5),
  invariants: ("群": [$ZZ$]),
  properties: [#fold[补充证明.] #note-ref("Schm0001", target: <claim>)],
)`;
    await writeFile(input, source);
    const compiled = await compiler.compile(input, flags);
    const prepared = prepareDocument(compiled.html, { filename: 'Schm/Schm0001.typ', object: true });
    const entry = { ...objectIdentity('Schm/Schm0001.typ'), ...prepared, ...objectMetadata(prepared.html, input) };
    assert.equal(entry.properties['光滑'], true);
    assert.equal(entry.properties['紧合'], false);
    assert.equal(entry.properties['分离'], null);
    assert.equal(entry.properties['特殊性质'], false);
    assert.equal(entry.numbers['维数'], 0);
    assert.equal(entry.numbers['Euler 示性数'], -2);
    assert.equal(entry.numbers['测试数值'], 1.5);
    assert.deepEqual(entry.toc.map(item => item.id), ['construction', 'properties', 'invariants']);
    const note = { slug: 'Schm0001', title: '同名笔记', html: '<h2 id="claim">结论</h2><a data-object="Schm0001" data-note-target="result" data-note-auto="true"></a>' };
    resolveNoteLinks([note], { base: '/blog/' }, [entry]);
    assert.match(note.html, /href="\/blog\/sheafpedia\/Schm0001\/#result"/);
    assert.match(note.html, /Schm0001 测试 ℙ1 \/ 定理/);
    assert.match(entry.html, /href="\/blog\/notes\/Schm0001\/#claim"/);
    assert.deepEqual(note.incoming, [entry]);
    assert.deepEqual(entry.incoming, [note]);
    finishObject(entry);
    assert.match(entry.nameHtml, /<math>/);
    assert.match(entry.introductionHtml, /<math>/);
    assert.ok(!entry.html.includes('data-object-template'));
    const content = parseHTML(`<html><body>${entry.html}</body></html>`).document;
    assert.equal(content.querySelectorAll('.fact-no').length, 2);
    assert.equal(content.querySelector('.note-fold').hasAttribute('open'), false);
    assert.ok(content.querySelector('.object-facts math'));
    const schema = JSON.parse(await readFile(join(root, 'sheafpedia-schema.json'), 'utf8'));
    const site = { base: '/blog/', title: '测试站', author: 'author', description: '' };
    const next = { ...entry, ...objectIdentity('Schm/Schm0002.typ') };
    const other = { ...entry, ...objectIdentity('Stck/Stck0001.typ') };
    const page = parseHTML(objectPage(site, entry, [next, other, entry], schema, false)).document;
    assert.equal(page.querySelector('[rel="next"]').getAttribute('href'), '/blog/sheafpedia/Schm0002/');
    assert.equal(page.querySelector('[rel="prev"]'), null);
    assert.ok(page.querySelector('h1 math'));
    assert.equal(page.querySelector('.source-link').getAttribute('href'), '/blog/sources/sheafpedia/Schm/Schm0001.typ');
    assert.equal(page.querySelector('.site-header [aria-current]').textContent, 'sheafpedia');
    const index = parseHTML(sheafpediaPage(site, [entry], schema)).document;
    assert.equal(index.querySelector('[data-object-link]').getAttribute('href'), '/blog/sheafpedia/Schm0001/');
    assert.ok(index.querySelector('[data-object-row]').dataset.search.includes('projective'));
    assert.ok((await compiler.compile(input, flags)).cached, 'unchanged objects reuse the existing cache');
    schema.properties.smooth = '光滑性';
    await writeFile(join(root, 'sheafpedia-schema.json'), JSON.stringify(schema));
    const changed = await compiler.compile(input, flags);
    assert.equal(changed.cached, false, 'the parameter schema is a compiler dependency');
    assert.match(changed.html, /光滑性/);
    for (const [argument, message] of [['smooth: "true"', /只接受 true/], ['dimension: [一]', /只接受数值/], ['dimension: float.inf', /必须是有限数值/], ['smoth: true', /未知的 encyclopedia 参数/]]) {
      await writeFile(input, `#import "sheafpedia-template.typ": *\n#encyclopedia(name: [测试], definition: [定义], ${argument})`);
      await assert.rejects(compiler.compile(input, flags), message);
    }
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
