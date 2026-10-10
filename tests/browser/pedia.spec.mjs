import { test, expect } from '@playwright/test';
import { mkdir, rename, rm, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

const title = 'Test 整数环 ℤ & #?';
const url = name => `/pedia/${encodeURIComponent(name)}/`;
const primary = `content/pedia/${title}.typ`;
const secondary = 'content/pedia/空白条目.typ';
const note = 'content/notes/pedia-test-note.typ';
const source = `#import "../template.typ": *
#show: note
= 自由章节 <definition>
正文关键词 $ZZ$.
#theorem[结论.] <result>
#note-ref("pedia-test-note", target: <claim>)
#fold[隐藏的证明.]
`;
const noteSource = name => `#import "../template.typ": *\n#show: note\n= 结论 <claim>\n#pedia(${JSON.stringify(name.toLowerCase())}, <definition>)`;
const paths = [primary, secondary, note];

test.beforeAll(async ({ request }) => {
  const index = await (await request.get('/pedia/')).text();
  expect(index).toContain('No entries yet.');
  for (const route of ['/books/', '/articles/', '/pedia/Ring0001/']) expect((await request.get(route)).status()).toBe(404);
  for (const [file, content] of [[primary, source], [secondary, '#import "../template.typ": *\n#show: note\n'], [note, noteSource(title)]]) {
    await writeFile(resolve(file), content, { flag: 'wx' });
  }
  await expect.poll(async () => (await (await request.get(url(title))).text()).includes('正文关键词'), { timeout: 25000 }).toBe(true);
});

test.afterAll(async ({ request }) => {
  for (const file of paths) await rm(resolve(file), { force: true });
  await expect.poll(async () => (await (await request.get('/pedia/')).text()).includes('No entries yet.'), { timeout: 15000 }).toBe(true);
});

test('only notes and encyclopedia remain; entries can be searched by title and free-form content', async ({ page }, testInfo) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto('/');
  const nav = page.getByRole('navigation', { name: 'Main navigation' });
  await expect(nav.getByRole('link')).toHaveText(['Home', 'Notes', 'Encyclopedia', 'Graph']);
  await nav.getByRole('link', { name: 'Encyclopedia' }).click();
  const rows = page.locator('.file-node:visible');
  await expect(rows).toHaveCount(2);
  await expect(page.locator('.object-id, .object-category-nav, .directory-node')).toHaveCount(0);
  await page.getByRole('searchbox').fill('整数环');
  await expect(rows).toHaveCount(1);
  await expect(rows).toContainText(title);
  await page.getByRole('searchbox').fill('正文关键词 Z');
  await expect(rows).toHaveCount(1);
  await rows.locator('a').click();
  await expect(page.locator('.article-header h1')).toHaveText(title);
  await expect(page).toHaveURL(new RegExp(`${encodeURIComponent(title).replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}/$`));
  await page.locator('.article-bottom a').click();
  await page.getByRole('searchbox').fill('不存在的条目');
  await expect(page.locator('.empty-state')).toBeVisible();
  await page.getByRole('button', { name: 'Show all entries' }).click();
  await expect(rows).toHaveCount(2);
  await page.screenshot({ path: testInfo.outputPath('pedia-desktop.png'), fullPage: true });
  expect(errors).toEqual([]);
});

test('blank entries, MathML, title links, sources and mobile reading work', async ({ page, request }, testInfo) => {
  await page.goto(url('空白条目'));
  await expect(page.locator('.article-header h1')).toHaveText('空白条目');
  await expect(page.locator('.typst-content')).toHaveText('');
  await expect(page.locator('.toc a')).toHaveCount(0);
  await page.goto(url(title));
  await expect(page.locator('.typst-content math')).toHaveCount(1);
  await expect(page.locator('.toc a[href="#definition"]')).toBeVisible();
  await expect(page.locator('.note-fold')).not.toHaveAttribute('open');
  await expect(page.locator('.note-connections [data-direction="incoming"]')).toContainText('pedia-test-note');
  await expect(page.locator('.note-pagination a')).toHaveAttribute('href', url('空白条目'));
  await page.locator('.typst-content a.note-reference').click();
  await expect(page).toHaveURL(/notes\/pedia-test-note\/#claim$/);
  await page.locator('.typst-content a.note-reference').click();
  await expect(page.locator('.article-header h1')).toHaveText(title);
  await expect(page.locator('.source-link')).toHaveAttribute('href', `/sources/pedia/${encodeURIComponent(title)}.typ`);
  expect(await (await request.get(`/sources/pedia/${encodeURIComponent(title)}.typ`)).text()).toBe(source);
  for (const route of ['/pedia/', url(title)]) {
    await page.setViewportSize({ width: 320, height: 740 });
    await page.goto(route);
    await page.evaluate(() => document.fonts.ready);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await expect(page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link', { name: 'Encyclopedia' })).toBeVisible();
    await page.screenshot({ path: testInfo.outputPath(route === '/pedia/' ? 'pedia-mobile.png' : 'entry-mobile.png'), fullPage: true });
  }
});

test('without JavaScript, entry browsing and free-form content remain accessible', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, reducedMotion: 'reduce', baseURL });
  try {
    const page = await context.newPage();
    await page.goto('/pedia/');
    await expect(page.locator('[data-directory-search]')).toBeHidden();
    await expect(page.locator('.file-link')).toHaveCount(2);
    await page.getByRole('link', { name: title, exact: true }).click();
    await page.locator('.note-fold summary').click();
    await expect(page.locator('.note-fold-body')).toBeVisible();
  } finally { await context.close(); }
});

test('compact pedia links and placeholders recover when a proposition is added or removed', async ({ page, request }) => {
  const noteHtml = async () => (await request.get('/notes/pedia-test-note/')).text();
  try {
    await writeFile(resolve(note), `${noteSource(title)}
#pedia[空白条目]
#pedia(${JSON.stringify(title.toUpperCase())}, <future>)[A future proposition]
#pedia("")[Pending destination]
`);
    await expect.poll(async () => (await noteHtml()).includes('Pending destination'), { timeout: 15000 }).toBe(true);
    await page.goto('/notes/pedia-test-note/');
    await expect(page.locator('a.note-reference', { hasText: '空白条目' })).toHaveAttribute('href', url('空白条目'));
    await expect(page.locator('span.note-reference-missing', { hasText: 'A future proposition' })).toBeVisible();
    await expect(page.locator('span.note-reference-missing', { hasText: 'Pending destination' })).toBeVisible();
    await expect(page.locator('#typst-build-error')).toHaveCount(0);
    await writeFile(resolve(primary), `${source}\n#proposition[Added later.] <future>\n`);
    const link = page.locator('a.note-reference', { hasText: 'A future proposition' });
    await expect(link).toHaveAttribute('href', `${url(title)}#future`, { timeout: 15000 });
    await link.click();
    await expect(page).toHaveURL(/#future$/);
    await expect(page.locator('#future')).toContainText('Added later.');
    await writeFile(resolve(primary), source);
    await expect.poll(async () => !(await noteHtml()).includes(`href="${url(title)}#future"`), { timeout: 15000 }).toBe(true);
    await page.goto('/notes/pedia-test-note/');
    await expect(page.locator('span.note-reference-missing', { hasText: 'A future proposition' })).toBeVisible();
    await expect(page.locator('#typst-build-error')).toHaveCount(0);
  } finally {
    await writeFile(resolve(primary), source);
    await writeFile(resolve(note), noteSource(title));
    await expect.poll(async () => !(await noteHtml()).includes('Pending destination'), { timeout: 15000 }).toBe(true);
  }
});

test('moving, duplicate titles, renaming, drafts and deletion update the preview safely', async ({ page, request }) => {
  const moved = `content/pedia/整理/${title}.typ`;
  const renamedTitle = '更名后的整数环';
  const renamed = `content/pedia/${renamedTitle}.typ`;
  const draft = 'content/pedia/_空白条目.typ';
  paths.push(moved, renamed, draft);
  const noteHtml = async () => (await request.get('/notes/pedia-test-note/')).text();
  try {
    await mkdir(resolve('content/pedia/整理'), { recursive: true });
    await rename(resolve(primary), resolve(moved));
    await writeFile(resolve(moved), source.replace('../template.typ', '../../template.typ'));
    await expect.poll(async () => (await (await request.get(url(title))).text()).includes(`/sources/pedia/${encodeURIComponent('整理')}/`), { timeout: 15000 }).toBe(true);
    expect(await noteHtml()).toContain(`href="${url(title)}#definition"`);
    await page.goto('/pedia/');
    await writeFile(resolve(primary), source);
    await expect(page.locator('#typst-build-error')).toContainText('Duplicate encyclopedia title', { timeout: 15000 });
    expect((await request.get(url(title))).status()).toBe(200);
    await rm(resolve(primary));
    await expect(page.locator('#typst-build-error')).toHaveCount(0, { timeout: 15000 });
    await rename(resolve(moved), resolve(renamed));
    await writeFile(resolve(renamed), source);
    await expect.poll(async () => (await request.get(url(renamedTitle))).status(), { timeout: 15000 }).toBe(200);
    expect((await request.get(url(title))).status()).toBe(404);
    expect(await noteHtml()).toContain('note-reference-missing');
    await writeFile(resolve(note), noteSource(renamedTitle));
    await expect.poll(async () => (await noteHtml()).includes(`href="${url(renamedTitle)}#definition"`), { timeout: 15000 }).toBe(true);
    await rename(resolve(secondary), resolve(draft));
    await expect.poll(async () => (await request.get(url('空白条目'))).status(), { timeout: 15000 }).toBe(404);
    expect((await request.get(`/sources/pedia/${encodeURIComponent('_空白条目')}.typ`)).status()).toBe(404);
    await rm(resolve(renamed));
    await expect.poll(async () => (await noteHtml()).includes('note-reference-missing'), { timeout: 15000 }).toBe(true);
    expect((await request.get(url(renamedTitle))).status()).toBe(404);
    expect((await request.get(`/sources/pedia/${encodeURIComponent(renamedTitle)}.typ`)).status()).toBe(404);
    await writeFile(resolve(renamed), source);
    await expect.poll(async () => (await noteHtml()).includes(`href="${url(renamedTitle)}#definition"`), { timeout: 15000 }).toBe(true);
  } finally {
    for (const file of [moved, renamed, draft]) await rm(resolve(file), { force: true });
    await writeFile(resolve(primary), source);
    await writeFile(resolve(secondary), '#import "../template.typ": *\n#show: note\n');
    await writeFile(resolve(note), noteSource(title));
    await rm(resolve('content/pedia/整理'), { recursive: true, force: true });
  }
});
