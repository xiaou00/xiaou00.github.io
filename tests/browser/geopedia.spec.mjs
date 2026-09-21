import { test, expect } from '@playwright/test';
import { mkdir, rename, rm, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';

const paths = [];
const objectSource = (name, options = '', content = '') => `#import "../../geopedia-template.typ": *
#encyclopedia(name: [${name}], definition: [定义关键词. ${content}], introduction: [几何对象测试.],
  aliases: ([test alias], [几何别名 $A$]), ${options})`;
const primary = 'content/geopedia/Schm/Schm8971.typ';
const secondary = 'content/geopedia/Schm/Schm8972.typ';
const note = 'content/notes/geopedia-test-note.typ';
const primarySource = objectSource('测试对象 $PP^1$', 'properties: ([光滑 $X$], [非紧合], [由作者自由填写.], [待补充]), invariants: (([维数], 0), ([Euler 示性数], -2), ([测试数值], 1.5), ([群 $G$], [$ZZ$])), content: [一般讨论关键词. $x + y$ #fold[隐藏的证明.]],', '#note-ref("geopedia-test-note", target: <claim>)');

test.beforeAll(async ({ request }) => {
  const entries = [
    [primary, primarySource],
    [secondary, objectSource('测试对象二', 'properties: ([紧合],), invariants: (([维数], 2),) ,')],
    ['content/geopedia/Stck/Stck8971.typ', objectSource('测试叠')],
    ['content/geopedia/Drvd/Drvd8971.typ', objectSource('测试导出对象')],
    ['content/geopedia/Spct/Spct8971.typ', objectSource('测试谱预层对象')],
    ['content/geopedia/Ring/Ring8971.typ', objectSource('测试环和代数', '', '#object-ref("Schm8971")')],
    [note, '#import "../template.typ": *\n#show: note\n= 结论 <claim>\n#geopedia("Schm8971", target: <properties>)'],
  ];
  for (const [file, source] of entries) {
    await mkdir(dirname(resolve(file)), { recursive: true });
    await writeFile(resolve(file), source, { flag: 'wx' });
    paths.push(resolve(file));
  }
  await expect.poll(async () => (await (await request.get('/geopedia/')).text()).includes('Ring8971'), { timeout: 25000 }).toBe(true);
});

test.afterAll(async ({ request }) => {
  for (const file of paths) await rm(file, { force: true });
  await expect.poll(async () => (await (await request.get('/geopedia/')).text()).includes('Schm8971'), { timeout: 15000 }).toBe(false);
});

test('GeoPedia browses Ring first and supports keyword search without filter controls', async ({ page }, testInfo) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto('/');
  await page.getByRole('navigation', { name: '主导航' }).getByRole('link', { name: 'GeoPedia' }).click();
  await expect(page).toHaveURL(/\/geopedia\/$/);
  const rows = page.locator('[data-object-row]:visible');
  await expect(rows).toHaveCount(6);
  await expect(page.locator('.object-controls select, .object-controls details, input[type="number"], [data-properties], [data-numbers]')).toHaveCount(0);
  await expect(page.locator('.object-group h2 > span')).toHaveText(['Ring', 'Schm', 'Stck', 'Drvd / Spct']);
  await expect(page.locator('.object-category-nav a')).toHaveCount(4);
  await expect(page.locator('#category-Drvd h2')).toHaveText('Drvd / Spct高阶对象2');
  await expect(page.locator('#category-Drvd .object-id')).toHaveText(['Drvd8971', 'Spct8971']);
  await expect(page.locator('[data-object-row] .object-id')).toHaveText(['Ring8971', 'Schm8971', 'Schm8972', 'Stck8971', 'Drvd8971', 'Spct8971']);
  await rows.first().locator('a').click();
  await expect(page.locator('.article-header h1')).toHaveText('测试环和代数');
  await expect(page.locator('.typst-content .note-reference')).toHaveAttribute('href', '/geopedia/Schm8971/');
  await expect(page.locator('.source-link')).toHaveAttribute('href', '/sources/geopedia/Ring/Ring8971.typ');
  await page.locator('.article-bottom a').click();
  await page.getByRole('searchbox').fill('TEST alias 定义关键词');
  await expect(rows).toHaveCount(6);
  await page.getByRole('searchbox').fill('几何别名 A');
  await expect(rows).toHaveCount(6);
  await page.getByRole('searchbox').fill('一般讨论关键词');
  await expect(rows).toHaveCount(1);
  await page.getByRole('searchbox').fill('高阶对象');
  await expect(rows).toHaveCount(2);
  await page.getByRole('searchbox').fill('Drvd');
  await expect(rows).toHaveCount(1);
  await expect(rows).toContainText('Drvd8971');
  await rows.locator('a').click();
  await expect(page.locator('.breadcrumb')).toContainText('高阶对象 / Drvd8971');
  await page.locator('.note-pagination [rel="next"]').click();
  await expect(page).toHaveURL(/\/geopedia\/Spct8971\/\?q=Drvd$/);
  await expect(page.locator('.breadcrumb')).toContainText('高阶对象 / Spct8971');
  await expect(page.locator('.note-pagination [rel="prev"]')).toHaveAttribute('href', /\/geopedia\/Drvd8971\/\?q=Drvd$/);
  await page.locator('.article-bottom a').click();
  await page.getByRole('searchbox').fill('由作者自由填写');
  await expect(rows).toHaveCount(1);
  await expect(rows).toContainText('Schm8971');
  await rows.locator('a').click();
  await expect(page).toHaveURL(/geopedia\/Schm8971\/\?q=/);
  await page.locator('.article-bottom a').click();
  await expect(page.getByRole('searchbox')).toHaveValue('由作者自由填写');
  await page.reload();
  await expect(rows).toHaveCount(1);
  await page.getByRole('button', { name: '清除搜索' }).click();
  await expect(rows).toHaveCount(6);
  await expect(page).toHaveURL(/\/geopedia\/$/);
  await page.getByRole('searchbox').fill('没有这个对象');
  await expect(page.locator('.object-no-results')).toBeVisible();
  await page.getByRole('button', { name: '清除搜索' }).click();
  await page.goto('/geopedia/?category=Schm&property=光滑&value=true&min=5');
  await expect(rows).toHaveCount(6);
  await expect(page).toHaveURL(/\/geopedia\/$/);
  await page.evaluate(() => { document.activeElement.blur(); window.scrollTo({ top: 0, behavior: 'instant' }); });
  await page.screenshot({ path: testInfo.outputPath('geopedia-desktop.png'), fullPage: true });
  expect(errors).toEqual([]);
});

test('object MathML, properties, note references, sources, pagination and mobile layout', async ({ page, request }, testInfo) => {
  await page.goto('/geopedia/Schm8971/');
  await expect(page.locator('.article-header h1 math')).toBeVisible();
  await expect(page.locator('.object-properties > li')).toHaveText(['光滑 𝑋', '非紧合', '由作者自由填写.', '待补充']);
  await expect(page.locator('.object-properties math')).toBeVisible();
  await expect(page.locator('.object-facts dt')).toHaveText(['维数', 'Euler 示性数', '测试数值', '群 𝐺']);
  await expect(page.locator('.object-facts dd')).toHaveText(['0', '−2', '1.5', 'ℤ']);
  await expect(page.locator('.object-facts dt math')).toHaveCount(1);
  await expect(page.locator('.toc a[href="#discussion"]')).toBeVisible();
  await expect(page.locator('#discussion')).toHaveText('讨论');
  await expect(page.locator('.typst-content')).toContainText('一般讨论关键词.');
  await expect(page.locator('.note-fold')).not.toHaveAttribute('open');
  await expect(page.locator('.note-pagination [rel="next"]')).toHaveAttribute('href', /\/geopedia\/Schm8972\/$/);
  await expect(page.locator('.note-pagination [rel="prev"]')).toHaveCount(0);
  await expect(page.locator('.note-connections [data-direction="incoming"]')).toContainText('geopedia-test-note');
  await page.locator('.typst-content a.note-reference').click();
  await expect(page).toHaveURL(/notes\/geopedia-test-note\/#claim$/);
  await page.locator('.typst-content a.note-reference').click();
  await expect(page).toHaveURL(/geopedia\/Schm8971\/#properties$/);
  const source = await request.get('/sources/geopedia/Schm/Schm8971.typ');
  expect(await source.text()).toContain('properties: ([光滑 $X$], [非紧合]');
  expect((await request.get('/sources/geopedia-template.typ')).status()).toBe(200);
  expect((await request.get('/sources/geopedia-schema.json')).status()).toBe(200);
  for (const route of ['/geopedia/', '/geopedia/Schm8971/']) {
    await page.setViewportSize({ width: 320, height: 740 });
    await page.goto(route);
    await page.evaluate(() => document.fonts.ready);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    const nav = page.getByRole('navigation', { name: '主导航' });
    await expect(nav.getByRole('link', { name: 'GeoPedia' })).toBeVisible();
    await page.screenshot({ path: testInfo.outputPath(route.endsWith('Schm8971/') ? 'object-mobile.png' : 'geopedia-mobile.png'), fullPage: true });
  }
});

test('without JavaScript the categories, objects, contents and folds remain accessible', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, reducedMotion: 'reduce', baseURL });
  try {
    const page = await context.newPage();
    await page.goto('/geopedia/');
    await expect(page.locator('.object-controls')).toBeHidden();
    await expect(page.locator('[data-object-row]:visible')).toHaveCount(6);
    await page.locator('[data-object-link][href="/geopedia/Schm8971/"]').click();
    await expect(page.locator('.typst-content')).toBeVisible();
    await page.locator('.note-fold summary').click();
    await expect(page.locator('.note-fold-body')).toBeVisible();
  } finally { await context.close(); }
});

test('renaming content, deletion, draft conversion and restoration update pages and references', async ({ request }) => {
  const index = async () => (await request.get('/geopedia/')).text();
  const noteHtml = async () => (await request.get('/notes/geopedia-test-note/')).text();
  try {
    await writeFile(resolve(primary), primarySource.replace('测试对象 $PP^1$', '更名后的对象 $PP^1$'));
    await expect.poll(async () => (await noteHtml()).includes('Schm8971 更名后的对象'), { timeout: 15000 }).toBe(true);
    expect((await request.get('/geopedia/Schm8971/')).status()).toBe(200);
    await rm(resolve(primary));
    await expect.poll(async () => (await index()).includes('href="/geopedia/Schm8971/"'), { timeout: 15000 }).toBe(false);
    expect((await request.get('/geopedia/Schm8971/')).status()).toBe(404);
    expect((await request.get('/sources/geopedia/Schm/Schm8971.typ')).status()).toBe(404);
    expect(await noteHtml()).toContain('note-reference-missing');
    await writeFile(resolve(primary), primarySource);
    await expect.poll(async () => (await noteHtml()).includes('Schm8971 测试对象'), { timeout: 15000 }).toBe(true);
    await rename(resolve(secondary), resolve(secondary.replace('Schm8972.typ', '_Schm8972.typ')));
    await expect.poll(async () => (await index()).includes('Schm8972'), { timeout: 15000 }).toBe(false);
    expect((await request.get('/sources/geopedia/Schm/_Schm8972.typ')).status()).toBe(404);
  } finally {
    await writeFile(resolve(primary), primarySource);
    try { await rename(resolve(secondary.replace('Schm8972.typ', '_Schm8972.typ')), resolve(secondary)); } catch (error) { if (error.code !== 'ENOENT') throw error; }
  }
});
