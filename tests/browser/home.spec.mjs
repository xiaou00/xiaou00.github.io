import { test, expect } from '@playwright/test';
import { readFile, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

test('personal home, independent directories, English navigation, and no cover dependency', async ({ page, request }, testInfo) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto('/');
  await expect(page.locator('html')).toHaveAttribute('lang', 'en');
  await expect(page.locator('h1')).toHaveText('xiaou0');
  await expect(page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link')).toHaveText(['Home', 'Notes', 'Encyclopedia', 'Graph']);
  await expect(page.locator('.profile-section h2')).toHaveText(['About', 'Interests', 'Explore', 'Elsewhere']);
  await expect(page.locator('img, .directory-browser')).toHaveCount(0);
  expect((await request.get('/cover.png')).status()).toBe(404);
  await page.locator('.profile-explore').getByRole('link', { name: /^Notes/ }).click();
  await expect(page).toHaveURL(/\/notes\/$/);
  await expect(page.locator('h1')).toHaveText('Notes');
  await expect(page.locator('.directory-empty')).toHaveText('No notes yet.');
  await page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link', { name: 'Home', exact: true }).click();
  await expect(page.locator('h1')).toHaveText('xiaou0');
  await page.locator('.profile-explore').getByRole('link', { name: /^Encyclopedia/ }).click();
  await expect(page).toHaveURL(/\/pedia\/$/);
  for (const width of [1440, 768, 390, 320]) {
    await page.setViewportSize({ width, height: 900 });
    for (const route of ['/', '/notes/', '/pedia/', '/graph/']) {
      await page.goto(route);
      await page.evaluate(() => document.fonts.ready);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${route} at ${width}px`).toBe(true);
      expect(await page.locator('body').innerText()).not.toMatch(/\p{Script=Han}/u);
    }
    await page.goto('/');
    if (width === 1440 || width === 320) await page.screenshot({ path: testInfo.outputPath(`home-${width}.png`), fullPage: true });
  }
  expect(errors).toEqual([]);
});

test('profile edits rebuild the homepage and the template works without JavaScript', async ({ browser, baseURL, request }) => {
  const config = resolve('site.config.mjs');
  const original = await readFile(config, 'utf8');
  const originalHtml = await (await request.get('/')).text();
  const { default: settings } = await import(pathToFileURL(config).href);
  const context = await browser.newContext({ javaScriptEnabled: false, baseURL });
  try {
    const updated = { ...settings, profile: { ...settings.profile, role: 'An updated profile role.' } };
    await writeFile(config, `export default ${JSON.stringify(updated, null, 2)};\n`);
    await expect.poll(async () => (await (await request.get('/')).text()).includes('An updated profile role.'), { timeout: 15000 }).toBe(true);
    const page = await context.newPage();
    await page.goto('/');
    await expect(page.locator('.profile-role')).toHaveText('An updated profile role.');
    await page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link', { name: 'Notes', exact: true }).click();
    await expect(page.locator('h1')).toHaveText('Notes');
    await expect(page.locator('[data-directory-search]')).toBeHidden();
  } finally {
    await context.close();
    await writeFile(config, original);
    await expect.poll(async () => (await request.get('/')).text(), { timeout: 15000 }).toBe(originalHtml);
  }
});
