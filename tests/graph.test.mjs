import test from 'node:test';
import assert from 'node:assert/strict';
import { parseHTML } from 'linkedom';
import { graphData, graphPage, homePage } from '../src/render.mjs';

const site = { base: '/blog/', url: 'https://example.com', title: 'Graph test', author: 'Author' };

test('graph data includes isolated pages, separates collections and merges repeated reciprocal references', () => {
  const note = { slug: 'Folder/Shared', title: 'Shared', collection: 'notes' };
  const entry = { slug: 'Algebra/Shared', title: 'Shared', collection: 'pedia' };
  const isolated = { slug: 'No links #?', title: 'No links #?', collection: 'notes' };
  note.outgoing = [entry, entry, note, { slug: 'unpublished' }];
  entry.outgoing = [note];
  const data = graphData(site, [note, entry, isolated]);
  assert.deepEqual(data.nodes.map(node => [node.title, node.collection, node.url]), [
    ['Shared', 'notes', '/blog/notes/Folder/Shared/'],
    ['Shared', 'pedia', '/blog/pedia/Shared/'],
    ['No links #?', 'notes', '/blog/notes/No%20links%20%23%3F/'],
  ]);
  assert.deepEqual(data.links, [{ source: 0, target: 1 }]);
});

test('graph page safely embeds titles, uses the deployment base and has a no-JavaScript directory', () => {
  const title = '</script><img src=x onerror=alert(1)> & "quotes"';
  const page = parseHTML(graphPage(site, [{ slug: 'Safe', title, collection: 'notes' }])).document;
  assert.equal(page.querySelector('img'), null);
  assert.equal(JSON.parse(page.getElementById('graph-data').textContent).nodes[0].title, title);
  assert.equal(page.querySelector('.graph-directory a').textContent, title);
  assert.equal(page.querySelector('.graph-directory a').getAttribute('href'), '/blog/notes/Safe/');
  assert.ok(page.querySelector('.graph-directory[open]'));
  assert.equal(page.querySelector('.site-header [aria-current]').textContent, 'Graph');
  assert.equal(page.querySelector('link[rel=canonical]').getAttribute('href'), 'https://example.com/blog/graph/');
  assert.ok(page.querySelector('script[src="/blog/graph.js"]'));
  assert.equal(parseHTML(homePage(site)).document.querySelector('script[src$="graph.js"]'), null);
  const empty = parseHTML(graphPage(site, [])).document;
  assert.equal(empty.querySelector('.graph-empty').textContent, 'No notes or encyclopedia entries yet.');
  assert.deepEqual(JSON.parse(empty.getElementById('graph-data').textContent), { nodes: [], links: [] });
});
