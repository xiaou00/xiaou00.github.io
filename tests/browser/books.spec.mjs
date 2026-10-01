import { test, expect } from '@playwright/test';
import { mkdir, rename, rm, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { encodeNotePath } from '../../scripts/note-paths.mjs';

const book = '书籍测试 & 几何';
const other = '另一本书';
const chapter = '01 基本概念';
const a = `${chapter}/01.1 群`;
const b = `${chapter}/01.2 进一步讨论`;
const c = `${chapter}/01.10 补充`;
const d = '02 应用/02.1 例子';
const route = (path = '') => `/books/${encodeNotePath(book)}/${path ? `${encodeNotePath(path)}/` : ''}`;
const sourcePath = section => resolve(`content/books/${book}/${section}.typ`);
const source = body => `#import "../../../template.typ": *\n#show: note\n${body}`;
const firstSource = source('= 概念 <concept>\n#definition[首节定义.]\n#theorem[首节结论.] <result>\n== 范例 <examples>\n小节正文.\n#book-ref("./01.2 进一步讨论.typ", target: <result>)');
const entries = [
  [sourcePath(a), firstSource],
  [sourcePath(b), source('= 讨论\n#definition[定义内容.]\n#theorem[第二节结论.] <result>\n#book-ref("./01.1 群.typ", target: <result>)\n#note-ref("books-reference")')],
  [sourcePath(c), source('#theorem[第十节结论.]')],
  [sourcePath(d), source('= 例子\n#theorem[新章结论.]')],
  [resolve(`content/books/${other}/01 开篇/01.1 引言.typ`), source('#theorem[另一本书的第一条定理.]')],
  [sourcePath(`${chapter}/_草稿`), '不会编译的草稿'],
  [resolve('content/notes/books-reference.typ'), `#import "../template.typ": *\n#show: note\n#theorem[笔记仍从 1 编号.]\n#book-ref("${book}/${b}", target: <result>)`],
];

test.beforeAll(async ({ request }) => {
  for (const [file, text] of entries) {
    await mkdir(dirname(file), { recursive: true });
    await writeFile(file, text, { flag: 'wx' });
  }
  await expect.poll(async () => (await (await request.get('/books/')).text()).includes('01.10 补充'), { timeout: 25000 }).toBe(true);
});

test.afterAll(async ({ request }) => {
  for (const folder of [book, other]) await rm(resolve('content/books', folder), { recursive: true, force: true });
  await rm(resolve('content/notes/books-reference.typ'), { force: true });
  await expect.poll(async () => (await (await request.get('/books/')).text()).includes('01.10 补充'), { timeout: 15000 }).toBe(false);
});

test('books browse a collapsed book/chapter/section tree with natural ordering and search', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('.file-node')).toHaveCount(1);
  await expect(page.locator('[data-directory]')).toHaveCount(0);
  await page.getByRole('navigation', { name: '主导航' }).getByRole('link', { name: '书籍', exact: true }).click();
  await expect(page).toHaveURL(/\/books\/$/);
  await expect(page.locator('details[data-directory][open]')).toHaveCount(0);
  await expect(page.locator('.file-link:visible')).toHaveCount(0);
  await expect(page.locator('.file-link')).toHaveCount(5);
  await page.getByRole('searchbox').fill('第二节结论');
  await expect(page.locator('.file-link:visible')).toHaveCount(1);
  await expect(page.locator('[data-file-count]')).toHaveText('1 / 5 节');
  await page.getByRole('searchbox').fill('不存在');
  await expect(page.locator('.empty-state')).toBeVisible();
  await page.getByRole('button', { name: '查看全部小节' }).click();
  await expect(page.locator('details[data-directory][open]')).toHaveCount(0);
  await page.locator('summary').filter({ hasText: book }).click();
  await expect(page.locator('.file-link:visible')).toHaveCount(0);
  await page.locator('summary').filter({ hasText: chapter }).click();
  await expect(page.locator('.file-link:visible .file-name')).toHaveText(['01.1 群', '01.2 进一步讨论', '01.10 补充']);
  await page.locator('.file-link:visible').first().click();
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 1.1');
});

test('sections share chapter counters, link across files and navigate across chapter boundaries', async ({ page, request }) => {
  await page.goto(route(b));
  await expect(page.locator('.env-definition figcaption')).toHaveText('定义 1.2');
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 1.2');
  await expect(page.locator('.book-toc [aria-current="page"]')).toHaveText('01.2 进一步讨论');
  await expect(page.locator('.book-toc a')).toHaveText(['01.1 群', '01.2 进一步讨论', '01.10 补充', '02.1 例子']);
  await expect(page.locator('.typst-content .note-reference').first()).toContainText('定理 1.1');
  await expect(page.locator('.note-connections [data-direction="incoming"]')).toContainText('books-reference');
  const download = await request.get(await page.locator('.source-link').getAttribute('href'));
  expect(await download.text()).toContain('../../../template.typ');
  await page.locator('.note-pagination [rel="next"]').click();
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 1.3');
  await page.locator('.note-pagination [rel="next"]').click();
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 2.1');
  await expect(page.locator('.note-pagination [rel="next"]')).toHaveCount(0);
  await page.locator('.article-bottom a').click();
  await expect(page).toHaveURL(route());
  await expect(page.getByRole('heading', { level: 1 })).toHaveText(book);
  await expect(page.locator('.chapter-outline > summary .file-name')).toHaveText(['01 基本概念', '02 应用']);
  await page.goto('/notes/books-reference/');
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 1');
  await page.locator('.typst-content .note-reference').click();
  await expect(page.locator('.article-header h1')).toHaveText('01.2 进一步讨论');
});

test('chapter and section outlines expand on mobile and work without JavaScript', async ({ page, browser, baseURL }, testInfo) => {
  for (const width of [1280, 390, 320]) {
    await page.setViewportSize({ width, height: 800 });
    await page.goto(route());
    const outline = page.locator('.chapter-outline').first();
    await expect(outline).not.toHaveAttribute('open');
    await outline.locator('summary').focus();
    await page.keyboard.press('Enter');
    await expect(outline.locator('.chapter-sections a')).toHaveText(['01.1 群', '01.2 进一步讨论', '01.10 补充']);
    await page.evaluate(() => document.fonts.ready);
    await page.screenshot({ path: testInfo.outputPath(`book-${width}.png`), fullPage: true });
    await outline.locator('summary a').click();
    await expect(page).toHaveURL(route(chapter));
    const section = page.locator('.section-outline').first();
    await expect(section).not.toHaveAttribute('open');
    await section.locator('.directory-chevron').click();
    await expect(section.locator('.chapter-sections a')).toHaveText(['1.1.1 概念', '1.1.1.1 范例']);
    await section.locator('.chapter-sections a').last().click();
    await expect(page).toHaveURL(`${route(a)}#examples`);
    await expect(page.locator('#examples')).toBeInViewport();
    await page.screenshot({ path: testInfo.outputPath(`section-${width}.png`), fullPage: true });
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await expect(page.getByRole('navigation', { name: '主导航' }).getByRole('link', { name: '书籍', exact: true })).toBeVisible();
  }
  const context = await browser.newContext({ javaScriptEnabled: false });
  try {
    const plain = await context.newPage();
    await plain.goto(`${baseURL}${route()}`);
    const outline = plain.locator('.chapter-outline').first();
    await outline.locator('.directory-chevron').click();
    await outline.locator('.chapter-sections a').first().click();
    await expect(plain.locator('.env-theorem')).toContainText('定理 1.1');
    await plain.locator('.article-bottom a').click();
    await plain.locator('.chapter-outline').first().locator('summary a').click();
    await expect(plain).toHaveURL(`${baseURL}${route(chapter)}`);
    await plain.locator('.section-outline').first().locator('summary a').click();
    await expect(plain).toHaveURL(`${baseURL}${route(a)}`);
  } finally { await context.close(); }
});

test('earlier edits and deletion update later numbers; renamed sections update pages and downloads', async ({ page, request }) => {
  await writeFile(sourcePath(a), firstSource + '\n#theorem[新增结论.]');
  await expect.poll(async () => (await (await request.get(route(b))).text()).includes('定理 1.3'), { timeout: 20000 }).toBe(true);
  await rm(sourcePath(a));
  await expect.poll(async () => (await request.get(route(a))).status(), { timeout: 20000 }).toBe(404);
  await page.goto(route(b));
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 1.1');
  await expect(page.locator('.note-reference-missing')).toBeVisible();
  await writeFile(sourcePath(a), firstSource);
  await expect.poll(async () => (await (await request.get(route(b))).text()).includes('定理 1.2'), { timeout: 20000 }).toBe(true);
  const renamed = `${chapter}/01.3 新节名`;
  await rename(sourcePath(b), sourcePath(renamed));
  await expect.poll(async () => (await request.get(route(renamed))).status(), { timeout: 20000 }).toBe(200);
  await page.goto(route(renamed));
  await expect(page.locator('.env-theorem figcaption')).toHaveText('定理 1.2');
  await expect(page.locator('.typst-content h2')).toHaveText('1.3.1 讨论');
  expect((await request.get(route(b))).status()).toBe(404);
  await page.goto(route(a));
  await expect(page.locator('.note-reference-missing')).toBeVisible();
  await expect(page.locator('.note-pagination [rel="next"]')).toHaveAttribute('href', route(renamed));
  const download = `/sources/books/${encodeNotePath(book)}/${encodeNotePath(renamed)}.typ`;
  await rm(sourcePath(renamed));
  await expect.poll(async () => (await request.get(route(renamed))).status(), { timeout: 20000 }).toBe(404);
  expect((await request.get(download)).status()).toBe(404);
  await page.reload();
  await expect(page.locator('.note-pagination [rel="next"]')).toHaveAttribute('href', route(c));
});
