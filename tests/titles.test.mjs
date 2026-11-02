import test from 'node:test';
import assert from 'node:assert/strict';
import { cp, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareDocument } from '../scripts/build.mjs';
import { resolveNoteLinks } from '../scripts/note-links.mjs';
import { graphPage, notePage, notesPage, pediaPage } from '../src/render.mjs';

const dom = html => parseHTML(html).document;
const site = { base: '/blog/', title: 'Title test', author: 'Author' };

test('Typst title math survives headings, directories, references, navigation and cached compilation', async () => {
  const root = await mkdtemp('/tmp/liber-title-test-');
  const compiler = new TypstCompiler({ cwd: root });
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'refs.typ', 'function-plot.typ']) {
      await cp(resolve('content', name), join(root, name));
    }
    const prefix = '#import "template.typ": *\n#show: note\n';
    const compile = async (file, title, source) => {
      const input = join(root, file);
      await writeFile(input, prefix + source);
      const flags = ['--features', 'html', '--root', root, '--input', `note-title=${title}`];
      const result = await compiler.compile(input, flags);
      assert.equal((await compiler.compile(input, flags)).cached, true);
      return prepareDocument(result.html, { filename: file });
    };
    const note = { collection: 'notes', slug: 'Folder/Notes on $KK$', title: 'Notes on $KK$',
      ...await compile('note.typ', 'Notes on $KK$', `
#pedia("milnor $K_n$-theory")
#pedia("Milnor $K_n$-theory", <definition>)
#pedia("Milnor $K_n$-theory")[Custom $X$]
#pedia("Future $ZZ$")
#note-ref("Folder/Notes on $KK$.typ")
#note-ref("Folder/Unwritten $K_1$.typ")
`) };
    const entry = { collection: 'pedia', slug: 'Milnor $K_n$-theory', title: 'Milnor $K_n$-theory',
      ...await compile('entry.typ', 'Milnor $K_n$-theory', '= Definition <definition>\nA definition.') };
    resolveNoteLinks([note], site, [entry]);
    assert.equal(note.titleText, 'Notes on 𝕂');
    assert.equal(note.html.includes('data-document-title'), false);
    assert.deepEqual(entry.incoming, [note]);
    const body = dom(`<html><body>${note.html}</body></html>`);
    const links = [...body.querySelectorAll('.note-reference')];
    assert.equal(links[0].textContent, 'milnor 𝐾𝑛-theory');
    assert.ok(links[0].querySelector('math msub'));
    assert.equal(links[0].getAttribute('href'), '/blog/pedia/Milnor%20%24K_n%24-theory/');
    assert.equal(links[1].textContent, 'Milnor 𝐾𝑛-theory / 1 Definition');
    assert.ok(links[1].getAttribute('href').endsWith('#definition'));
    assert.equal(links[2].textContent, 'Custom 𝑋');
    assert.equal(links[3].textContent, 'Notes on 𝕂');
    assert.equal(body.querySelectorAll('.note-reference-missing math').length, 2);
    assert.equal(body.querySelectorAll('[data-note-caption], [data-note-path-caption]').length, 0);

    const page = dom(notePage(site, note, [note], false, { next: entry }));
    for (const selector of ['.article-header h1', '.breadcrumb', '.note-connections', '.note-pagination']) {
      assert.ok(page.querySelector(`${selector} math`), selector);
    }
    assert.equal(page.title, 'Notes on 𝕂 - Title test');
    assert.equal(page.querySelector('meta[property="og:title"]').content, 'Notes on 𝕂');
    assert.ok(dom(notesPage(site, [note])).querySelector('.file-name math'));
    const directory = dom(pediaPage(site, [entry]));
    assert.ok(directory.querySelector('.file-name math msub'));
    assert.ok(directory.querySelector('[data-search]').dataset.search.includes('kn'));
    const graph = dom(graphPage(site, [note, entry]));
    assert.equal(graph.querySelectorAll('.graph-directory math').length, 2);
    const data = JSON.parse(graph.getElementById('graph-data').textContent);
    assert.equal(data.nodes[0].title, note.title);
    assert.equal(data.nodes[0].titleText, note.titleText);
    assert.equal(data.nodes[0].titleHtml, note.titleHtml);

    const literal = await compile('literal.typ', '<img src=x> *literal* #undefined $5', 'Body.');
    assert.equal(literal.titleText, '<img src=x> *literal* #undefined $5');
    assert.equal(dom(`<html><body>${literal.titleHtml}</body></html>`).querySelector('img, strong, math'), null);
    const fraction = await compile('fraction.typ', '$ frac(1,2) $ and $overline(x)$', 'Body.');
    const math = dom(`<html><body>${fraction.titleHtml}</body></html>`);
    assert.equal(math.querySelectorAll('math').length, 2);
    assert.equal(math.querySelector('math[display="block"]'), null);
    assert.ok(math.querySelector('mfrac'));
    assert.ok(math.querySelector('.math-overline'));
    await assert.rejects(compile('invalid.typ', '$undefined-title-variable$', 'Body.'), /unknown variable/);
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
