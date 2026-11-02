import { test, expect } from '@playwright/test';
import { rm, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

const prefix = '#import "../template.typ": *\n#show: note\n';
const note = 'Notes on $KK$';
const entry = 'Milnor $K_n$-theory';
const notePath = resolve(`content/notes/${note}.typ`);
const entryPath = resolve(`content/pedia/${entry}.typ`);
const noteUrl = `/notes/${encodeURIComponent(note)}/`;
const entryUrl = `/pedia/${encodeURIComponent(entry)}/`;

test.beforeAll(async ({ request }) => {
  await writeFile(entryPath, prefix + '= Definition <definition>\nA short definition.', { flag: 'wx' });
  await writeFile(notePath, prefix + '#pedia("milnor $K_n$-theory", <definition>)\n#pedia("Future $ZZ$")', { flag: 'wx' });
  await expect.poll(async () => (await request.get(noteUrl)).status(), { timeout: 15000 }).toBe(200);
});

test.afterAll(async ({ request }) => {
  await rm(notePath, { force: true });
  await rm(entryPath, { force: true });
  await expect.poll(async () => (await request.get(noteUrl)).status(), { timeout: 15000 }).toBe(404);
});

test('title formulas display in pages, search, references and the interactive graph', async ({ page }, testInfo) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(noteUrl);
  await expect(page.locator('h1 math')).toHaveText('𝕂');
  await expect(page).toHaveTitle('Notes on 𝕂 - Liber 777');
  expect(await page.locator('h1 math').evaluate(el => getComputedStyle(el).fontFamily)).toContain('Libertinus Math');
  await expect(page.locator('.note-reference math msub')).toBeVisible();
  await expect(page.locator('.note-reference-missing math')).toHaveText('ℤ');
  await page.screenshot({ path: testInfo.outputPath('title-desktop.png'), fullPage: true });

  await page.setViewportSize({ width: 320, height: 740 });
  await page.goto(entryUrl);
  await expect(page.locator('h1 math msub')).toBeVisible();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
  await page.screenshot({ path: testInfo.outputPath('title-mobile.png'), fullPage: true });

  await page.goto('/pedia/');
  await page.getByRole('searchbox').fill('kn');
  await expect(page.locator('.file-node:visible')).toHaveCount(1);
  await expect(page.locator('.file-name math')).toBeVisible();
  await page.locator('.file-link').click();
  await expect(page).toHaveURL(new RegExp('/pedia/Milnor%20%24K_n%24-theory/$'));

  await page.setViewportSize({ width: 1200, height: 800 });
  await page.goto('/graph/');
  await expect(page.locator('.graph-canvas')).toHaveAttribute('data-ready', 'true');
  await expect(page.locator('.graph-label-html math')).toHaveCount(2);
  await expect(page.locator('.graph-directory math')).toHaveCount(2);
  await expect(page.locator('.graph-label-html math').first()).toBeVisible();
  await page.screenshot({ path: testInfo.outputPath('title-graph.png'), fullPage: true });
  await page.locator(`.graph-node[href="${entryUrl}"] .graph-dot`).click();
  await expect(page.locator('h1 math msub')).toBeVisible();
  expect(errors).toEqual([]);
});

test('title formulas work without JavaScript', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ baseURL, javaScriptEnabled: false });
  try {
    const page = await context.newPage();
    await page.goto('/notes/');
    await expect(page.locator('.file-name math')).toBeVisible();
    await page.locator('.file-link').click();
    await expect(page.locator('h1 math')).toHaveText('𝕂');
    await page.locator('.note-reference').click();
    await expect(page.locator('h1 math msub')).toBeVisible();
  } finally { await context.close(); }
});
