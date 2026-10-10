import { test, expect } from '@playwright/test';
import { rm, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { parseHTML } from 'linkedom';

const prefix = '#import "../template.typ": *\n#show: note\n';
const note = 'content/notes/Graph note.typ';
const entry = 'content/pedia/Graph entry.typ';
const isolated = 'content/notes/Isolated note.typ';
const draft = 'content/pedia/_Graph draft.typ';
const future = 'content/pedia/Graph future.typ';
const noteSource = prefix + '#pedia[graph entry]\n#pedia("Graph entry", <result>)\n#pedia[Unwritten entry]\n';
const entrySource = prefix + '#theorem[A result.] <result>\n#note-ref("Graph note")\n';
const data = async request => JSON.parse(parseHTML(await (await request.get('/graph/')).text()).document.getElementById('graph-data').textContent);
const graphNode = (page, title, kind) => page.locator(`.graph-node[aria-label="${title} — ${kind}"]`);

test.beforeAll(async ({ request }) => {
  expect(await data(request)).toEqual({ nodes: [], links: [] });
  for (const [path, text] of [[note, noteSource], [entry, entrySource], [isolated, prefix + 'No connections.'], [draft, 'This draft must not compile. #unknown']]) {
    await writeFile(resolve(path), text, { flag: 'wx' });
  }
  await expect.poll(async () => (await data(request)).nodes.length, { timeout: 15000 }).toBe(3);
});
test.afterAll(async ({ request }) => {
  for (const path of [note, entry, isolated, draft, future]) await rm(resolve(path), { force: true });
  await expect.poll(async () => (await data(request)).nodes.length, { timeout: 15000 }).toBe(0);
});

test('graph shows both collections, supports drag, pan, zoom, search and native page links', async ({ page }, testInfo) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto('/');
  await page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link', { name: 'Graph', exact: true }).click();
  const svg = page.locator('.graph-canvas');
  const layer = page.locator('.graph-layer');
  await expect(svg).toHaveAttribute('data-ready', 'true');
  await expect(page.locator('.graph-node')).toHaveCount(3);
  await expect(page.locator('.graph-edge')).toHaveCount(1);
  await expect(page.locator('.graph-footer')).toContainText('3 pages · 1 connection');
  await expect(graphNode(page, 'Isolated note', 'Note')).toHaveAttribute('href', '/notes/Isolated%20note/');
  await page.screenshot({ path: testInfo.outputPath('graph-desktop.png'), fullPage: true });

  const node = graphNode(page, 'Graph note', 'Note');
  const original = await node.getAttribute('transform');
  const dot = await node.locator('.graph-dot').boundingBox();
  const point = { x: dot.x + dot.width / 2, y: dot.y + dot.height / 2 };
  await page.mouse.move(point.x, point.y);
  await page.mouse.down();
  await page.mouse.move(point.x + 55, point.y + 35, { steps: 8 });
  await page.mouse.up();
  await expect(page).toHaveURL(/\/graph\/$/);
  expect(await node.getAttribute('transform')).not.toBe(original);

  const box = await svg.boundingBox();
  const transform = await layer.getAttribute('transform');
  await page.mouse.move(box.x + 4, box.y + 4);
  await page.mouse.down();
  await page.mouse.move(box.x + 34, box.y + 24, { steps: 5 });
  await page.mouse.up();
  expect(await layer.getAttribute('transform')).not.toBe(transform);
  const panned = await layer.getAttribute('transform');
  await page.getByRole('button', { name: 'Zoom in', exact: true }).click();
  expect(await layer.getAttribute('transform')).not.toBe(panned);
  const zoomed = await layer.getAttribute('transform');
  await page.mouse.move(box.x + 5, box.y + 5);
  await page.mouse.wheel(0, 100);
  await expect.poll(() => layer.getAttribute('transform')).not.toBe(zoomed);
  await page.getByRole('button', { name: 'Fit view' }).click();

  const search = page.getByRole('searchbox', { name: 'Find a page' });
  await search.fill('No such page');
  await expect(page.locator('[data-graph-no-results]')).toBeVisible();
  await search.fill('GRAPH ENTRY');
  await expect(page.locator('.graph-directory li:visible')).toHaveCount(1);
  await expect(graphNode(page, 'Graph entry', 'Encyclopedia')).toHaveClass(/is-active/);
  await graphNode(page, 'Graph entry', 'Encyclopedia').locator('.graph-dot').click();
  await expect(page).toHaveURL(/\/pedia\/Graph%20entry\/$/);
  await expect(page.locator('h1')).toHaveText('Graph entry');

  await page.goto('/graph/');
  await graphNode(page, 'Graph note', 'Note').focus();
  await page.keyboard.press('Enter');
  await expect(page).toHaveURL(/\/notes\/Graph%20note\/$/);
  expect(errors).toEqual([]);
});

test('the force layout moves into place and then stops animating', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'no-preference' });
  await page.goto('/graph/');
  const node = graphNode(page, 'Graph note', 'Note');
  const initial = await node.getAttribute('transform');
  await expect.poll(() => node.getAttribute('transform')).not.toBe(initial);
  let previous, stable = 0;
  await expect.poll(async () => {
    const transform = await node.getAttribute('transform');
    stable = transform === previous ? stable + 1 : 0;
    previous = transform;
    return stable;
  }, { intervals: [400], timeout: 8000 }).toBeGreaterThanOrEqual(2);
});

test('editing references and adding or deleting their targets updates the open graph', async ({ page, request }) => {
  try {
    await page.goto('/graph/');
    await writeFile(resolve(note), prefix + '#pedia[Graph future]\n');
    await writeFile(resolve(entry), prefix + '#theorem[A result.] <result>\n');
    await expect(page.locator('.graph-edge')).toHaveCount(0, { timeout: 15000 });
    await writeFile(resolve(future), prefix + 'A new page.');
    await expect(page.locator('.graph-node')).toHaveCount(4, { timeout: 15000 });
    await expect(page.locator('.graph-edge')).toHaveCount(1);
    await rm(resolve(future));
    await expect(page.locator('.graph-node')).toHaveCount(3, { timeout: 15000 });
    await expect(page.locator('.graph-edge')).toHaveCount(0);
    await expect(page.locator('#typst-build-error')).toHaveCount(0);
  } finally {
    await rm(resolve(future), { force: true });
    await writeFile(resolve(note), noteSource);
    await writeFile(resolve(entry), entrySource);
    await expect.poll(async () => (await data(request)).links.length, { timeout: 15000 }).toBe(1);
  }
});

test('graph fits a phone, supports touch zoom and opens a node by tapping', async ({ browser, baseURL }, testInfo) => {
  const context = await browser.newContext({ baseURL, viewport: { width: 320, height: 740 }, isMobile: true, hasTouch: true, reducedMotion: 'reduce' });
  try {
    const page = await context.newPage();
    await page.goto('/graph/');
    await expect(page.locator('.graph-canvas')).toHaveAttribute('data-ready', 'true');
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await expect(page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link', { name: 'Graph' })).toBeVisible();
    await page.screenshot({ path: testInfo.outputPath('graph-mobile.png'), fullPage: true });
    const box = await page.locator('.graph-canvas').boundingBox();
    const before = await page.locator('.graph-layer').getAttribute('transform');
    const cdp = await context.newCDPSession(page);
    const touchPoints = gap => [{ x: box.x + box.width / 2 - gap, y: box.y + 100 }, { x: box.x + box.width / 2 + gap, y: box.y + 100 }];
    await cdp.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: touchPoints(25) });
    await cdp.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: touchPoints(60) });
    await cdp.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
    expect(await page.locator('.graph-layer').getAttribute('transform')).not.toBe(before);
    await page.getByRole('searchbox').fill('Graph entry');
    await graphNode(page, 'Graph entry', 'Encyclopedia').locator('.graph-dot').tap();
    await expect(page).toHaveURL(/\/pedia\/Graph%20entry\/$/);
  } finally { await context.close(); }
});

test('all graph pages remain reachable without JavaScript', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, baseURL });
  try {
    const page = await context.newPage();
    await page.goto('/graph/');
    await expect(page.locator('.graph-stage')).toBeHidden();
    await expect(page.locator('.graph-directory a')).toHaveCount(3);
    await page.locator('.graph-directory').getByRole('link', { name: 'Isolated note' }).click();
    await expect(page.locator('h1')).toHaveText('Isolated note');
  } finally { await context.close(); }
});
