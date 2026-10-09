import { test, expect } from '@playwright/test';
import { mkdir, rm, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

test('stickers load, center on narrow screens and update when image files change', async ({ page, request }, testInfo) => {
  const folder = resolve('sticker');
  const note = resolve('content/notes/sticker-test.typ');
  const asset = resolve(folder, 'test-sticker.svg');
  const svg = color => `<svg xmlns="http://www.w3.org/2000/svg" width="600" height="300"><rect width="600" height="300" fill="${color}"/></svg>`;
  const gif = Buffer.from('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7', 'base64');
  try {
    // Create the folder after the preview starts to exercise watcher discovery.
    await mkdir(folder, { recursive: true });
    await writeFile(asset, svg('red'));
    await writeFile(resolve(folder, 'test-animation.gif'), gif);
    await writeFile(note, '#import "../template.typ": *\n#show: note\n#sticker("test-sticker")\n#sticker("test-sticker", width: 600pt, alt: "宽贴纸")\n#sticker("test-animation.gif")');
    await expect.poll(async () => (await request.get('/notes/sticker-test/')).status(), { timeout: 20000 }).toBe(200);
    for (const width of [1280, 390, 320]) {
      await page.setViewportSize({ width, height: 900 });
      await page.goto('/notes/sticker-test/');
      const images = page.locator('.note-sticker > img');
      await expect(images).toHaveCount(3);
      for (const image of await images.all()) {
        await image.scrollIntoViewIfNeeded();
        await expect.poll(() => image.evaluate(node => node.complete && node.naturalWidth > 0)).toBe(true);
        const geometry = await image.evaluate(node => {
          const box = node.getBoundingClientRect();
          const parent = node.parentElement.getBoundingClientRect();
          return { width: box.width, height: box.height, available: parent.width,
            offset: Math.abs(box.left + box.width / 2 - parent.left - parent.width / 2) };
        });
        expect(geometry.offset).toBeLessThan(1);
        expect(geometry.width).toBeLessThanOrEqual(geometry.available + 1);
      }
      expect((await images.first().boundingBox()).width).toBeCloseTo(160, 0);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    }
    await page.screenshot({ path: testInfo.outputPath('stickers-mobile.png'), fullPage: true });
    const animated = await request.get('/sticker/test-animation.gif');
    expect(animated.headers()['content-type']).toBe('image/gif');
    expect(await animated.body()).toEqual(gif);
    await writeFile(asset, svg('blue'));
    await expect.poll(async () => (await (await request.get('/sticker/test-sticker.svg')).text()), { timeout: 15000 }).toBe(svg('blue'));
    await rm(asset);
    await expect(page.locator('#typst-build-error')).toContainText('test-sticker', { timeout: 15000 });
    await writeFile(asset, svg('green'));
    await expect.poll(async () => (await (await request.get('/sticker/test-sticker.svg')).text()), { timeout: 15000 }).toBe(svg('green'));
    await expect(page.locator('#typst-build-error')).toHaveCount(0);
  } finally {
    await rm(note, { force: true });
    await rm(folder, { recursive: true, force: true });
    await expect.poll(async () => (await request.get('/notes/sticker-test/')).status(), { timeout: 15000 }).toBe(404);
  }
});
