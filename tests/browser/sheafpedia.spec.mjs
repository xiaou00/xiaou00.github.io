import { test, expect } from '@playwright/test';
import { mkdir, rename, rm, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';

const paths = [];
const objectSource = (name, options = '', content = '') => `#import "../../sheafpedia-template.typ": *
#encyclopedia(name: [${name}], definition: [定义关键词. ${content}], introduction: [几何对象测试.],
  aliases: ("test alias",), ${options})`;
const primary = 'content/sheafpedia/Schm/Schm8971.typ';
const secondary = 'content/sheafpedia/Schm/Schm8972.typ';
const note = 'content/notes/sheafpedia-test-note.typ';
const primarySource = objectSource('测试对象 $PP^1$', 'smooth: true, proper: false, dimension: 0, euler-characteristic: -2, extra-properties: ("特殊性质": true), numerical-invariants: ("测试数值": 1.5), invariants: ("群": [$ZZ$]), properties: [#fold[隐藏的证明.]],', '#note-ref("sheafpedia-test-note", target: <claim>)');

test.beforeAll(async ({ request }) => {
  const entries = [
    [primary, primarySource],
    [secondary, objectSource('测试对象二', 'smooth: false, proper: true, dimension: 2,')],
    ['content/sheafpedia/Stck/Stck8971.typ', objectSource('测试叠')],
    ['content/sheafpedia/Drvd/Drvd8971.typ', objectSource('测试导出对象')],
    ['content/sheafpedia/Spct/Spct8971.typ', objectSource('测试谱预层对象')],
    ['content/sheafpedia/Ring/Ring8971.typ', objectSource('测试环和代数', '', '#object-ref("Schm8971")')],
    [note, '#import "../template.typ": *\n#show: note\n= 结论 <claim>\n#object-ref("Schm8971", target: <properties>)'],
  ];
  for (const [file, source] of entries) {
    await mkdir(dirname(resolve(file)), { recursive: true });
    await writeFile(resolve(file), source, { flag: 'wx' });
    paths.push(resolve(file));
  }
  await expect.poll(async () => (await (await request.get('/sheafpedia/')).text()).includes('Ring8971'), { timeout: 25000 }).toBe(true);
});

test.afterAll(async ({ request }) => {
  for (const file of paths) await rm(file, { force: true });
  await expect.poll(async () => (await (await request.get('/sheafpedia/')).text()).includes('Schm8971'), { timeout: 15000 }).toBe(false);
});

test('browse, search, boolean/unknown filters, numerical ranges and query restoration', async ({ page }, testInfo) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto('/');
  await page.getByRole('navigation', { name: '主导航' }).getByRole('link', { name: 'sheafpedia' }).click();
  const rows = page.locator('[data-object-row]:visible');
  await expect(rows).toHaveCount(6);
  await expect(page.locator('.object-group h2 > span')).toHaveText(['Schm', 'Stck', 'Drvd', 'Spct', 'Ring']);
  await expect(page.locator('[data-object-row] .object-id')).toHaveText(['Schm8971', 'Schm8972', 'Stck8971', 'Drvd8971', 'Spct8971', 'Ring8971']);
  await page.locator('[name="category"]').selectOption('Ring');
  await expect(rows).toHaveCount(1);
  await expect(rows).toContainText('Ring8971');
  await rows.locator('a').click();
  await expect(page.locator('.article-header h1')).toHaveText('测试环和代数');
  await expect(page.locator('.typst-content .note-reference')).toHaveAttribute('href', '/sheafpedia/Schm8971/');
  await expect(page.locator('.source-link')).toHaveAttribute('href', '/sources/sheafpedia/Ring/Ring8971.typ');
  await page.locator('.article-bottom a').click();
  await page.locator('[name="category"]').selectOption('');
  await page.getByRole('searchbox').fill('TEST alias 定义关键词');
  await expect(rows).toHaveCount(6);
  await page.locator('[name="category"]').selectOption('Schm');
  await expect(rows).toHaveCount(2);
  await page.getByText('按性质与不变量筛选', { exact: true }).click();
  await page.locator('[name="property"]').selectOption('光滑');
  await page.locator('[name="value"]').selectOption('false');
  await expect(rows).toHaveCount(1);
  await expect(rows).toContainText('Schm8972');
  await page.locator('[name="category"]').selectOption('');
  await page.locator('[name="value"]').selectOption('unknown');
  await expect(rows).toHaveCount(4);
  await page.locator('[name="property"]').selectOption('特殊性质');
  await page.locator('[name="value"]').selectOption('true');
  await expect(rows).toHaveCount(1);
  await page.locator('[name="invariant"]').selectOption('维数');
  await page.locator('[name="min"]').fill('0');
  await page.locator('[name="max"]').fill('0');
  await expect(rows).toContainText('Schm8971');
  await page.locator('[name="invariant"]').selectOption('Euler 示性数');
  await page.locator('[name="min"]').fill('-2');
  await page.locator('[name="max"]').fill('-2');
  await expect(rows).toHaveCount(1);
  await rows.locator('a').click();
  await expect(page).toHaveURL(/sheafpedia\/Schm8971\/\?/);
  await page.locator('.article-bottom a').click();
  await expect(page.locator('[name="min"]')).toHaveValue('-2');
  await expect(page.locator('[name="value"]')).toHaveValue('true');
  await expect(rows).toHaveCount(1);
  await page.reload();
  await expect(rows).toHaveCount(1);
  await page.getByRole('button', { name: '清除筛选' }).click();
  await expect(rows).toHaveCount(6);
  await expect(page).toHaveURL(/\/sheafpedia\/$/);
  await page.getByRole('searchbox').fill('没有这个对象');
  await expect(page.locator('.object-no-results')).toBeVisible();
  await page.getByRole('button', { name: '清除筛选' }).click();
  await page.evaluate(() => { document.activeElement.blur(); window.scrollTo({ top: 0, behavior: 'instant' }); });
  await page.screenshot({ path: testInfo.outputPath('sheafpedia-desktop.png'), fullPage: true });
  expect(errors).toEqual([]);
});

test('object MathML, properties, note references, sources, pagination and mobile layout', async ({ page, request }, testInfo) => {
  await page.goto('/sheafpedia/Schm8971/');
  await expect(page.locator('.article-header h1 math')).toBeVisible();
  await expect(page.locator('.object-facts dt')).toHaveText(['光滑', '紧合', '特殊性质', '维数', 'Euler 示性数', '测试数值', '群']);
  await expect(page.locator('.object-facts dd')).toHaveText(['是', '否', '是', '0', '−2', '1.5', 'ℤ']);
  await expect(page.locator('.note-fold')).not.toHaveAttribute('open');
  await expect(page.locator('.note-pagination [rel="next"]')).toHaveAttribute('href', /\/sheafpedia\/Schm8972\/$/);
  await expect(page.locator('.note-pagination [rel="prev"]')).toHaveCount(0);
  await expect(page.locator('.note-connections [data-direction="incoming"]')).toContainText('sheafpedia-test-note');
  await page.locator('.typst-content a.note-reference').click();
  await expect(page).toHaveURL(/notes\/sheafpedia-test-note\/#claim$/);
  await page.locator('.typst-content a.note-reference').click();
  await expect(page).toHaveURL(/sheafpedia\/Schm8971\/#properties$/);
  const source = await request.get('/sources/sheafpedia/Schm/Schm8971.typ');
  expect(await source.text()).toContain('smooth: true');
  expect((await request.get('/sources/sheafpedia-template.typ')).status()).toBe(200);
  expect((await request.get('/sources/sheafpedia-schema.json')).status()).toBe(200);
  for (const route of ['/sheafpedia/', '/sheafpedia/Schm8971/']) {
    await page.setViewportSize({ width: 320, height: 740 });
    await page.goto(route);
    await page.evaluate(() => document.fonts.ready);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    const nav = page.getByRole('navigation', { name: '主导航' });
    await expect(nav.getByRole('link', { name: 'sheafpedia' })).toBeVisible();
    await page.screenshot({ path: testInfo.outputPath(route.endsWith('Schm8971/') ? 'object-mobile.png' : 'sheafpedia-mobile.png'), fullPage: true });
  }
});

test('without JavaScript the categories, objects, contents and folds remain accessible', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, reducedMotion: 'reduce', baseURL });
  try {
    const page = await context.newPage();
    await page.goto('/sheafpedia/');
    await expect(page.locator('.object-controls')).toBeHidden();
    await expect(page.locator('[data-object-row]:visible')).toHaveCount(6);
    await page.locator('[data-object-link]').first().click();
    await expect(page.locator('.typst-content')).toBeVisible();
    await page.locator('.note-fold summary').click();
    await expect(page.locator('.note-fold-body')).toBeVisible();
  } finally { await context.close(); }
});

test('renaming content, deletion, draft conversion and restoration update pages and references', async ({ request }) => {
  const index = async () => (await request.get('/sheafpedia/')).text();
  const noteHtml = async () => (await request.get('/notes/sheafpedia-test-note/')).text();
  try {
    await writeFile(resolve(primary), primarySource.replace('测试对象 $PP^1$', '更名后的对象 $PP^1$'));
    await expect.poll(async () => (await noteHtml()).includes('Schm8971 更名后的对象'), { timeout: 15000 }).toBe(true);
    expect((await request.get('/sheafpedia/Schm8971/')).status()).toBe(200);
    await rm(resolve(primary));
    await expect.poll(async () => (await index()).includes('href="/sheafpedia/Schm8971/"'), { timeout: 15000 }).toBe(false);
    expect((await request.get('/sheafpedia/Schm8971/')).status()).toBe(404);
    expect((await request.get('/sources/sheafpedia/Schm/Schm8971.typ')).status()).toBe(404);
    expect(await noteHtml()).toContain('note-reference-missing');
    await writeFile(resolve(primary), primarySource);
    await expect.poll(async () => (await noteHtml()).includes('Schm8971 测试对象'), { timeout: 15000 }).toBe(true);
    await rename(resolve(secondary), resolve(secondary.replace('Schm8972.typ', '_Schm8972.typ')));
    await expect.poll(async () => (await index()).includes('Schm8972'), { timeout: 15000 }).toBe(false);
    expect((await request.get('/sources/sheafpedia/Schm/_Schm8972.typ')).status()).toBe(404);
  } finally {
    await writeFile(resolve(primary), primarySource);
    try { await rename(resolve(secondary.replace('Schm8972.typ', '_Schm8972.typ')), resolve(secondary)); } catch (error) { if (error.code !== 'ENOENT') throw error; }
  }
});
