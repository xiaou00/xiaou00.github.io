import { test, expect } from '@playwright/test';
import { mkdir, rm, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

test('assets images fit the reading width, preserve their proportions and update live', async ({ page, request }) => {
  const folder = resolve('assets/几何');
  const note = resolve('content/notes/assets-image-test.typ');
  const svg = (width, color) => `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="120"><rect width="${width}" height="120" fill="${color}"/></svg>`;
  const small = resolve(folder, '原图.svg');
  try {
    await mkdir(folder, { recursive: true });
    await writeFile(small, svg(180, 'red'));
    await writeFile(resolve(folder, '宽图.svg'), svg(1600, 'blue'));
    await writeFile(note, '#import "../template.typ": *\n#show: note\n#assets-image("几何/原图")\n#assets-image("几何/宽图.svg", alt: "宽图")');
    await expect.poll(async () => (await request.get('/notes/assets-image-test/')).status(), { timeout: 20000 }).toBe(200);
    for (const width of [1280, 390, 320]) {
      await page.setViewportSize({ width, height: 900 });
      await page.goto('/notes/assets-image-test/');
      const images = page.locator('.assets-image > img');
      await expect(images).toHaveCount(2);
      for (const image of await images.all()) {
        await image.scrollIntoViewIfNeeded();
        await expect.poll(() => image.evaluate(node => node.complete && node.naturalWidth > 0)).toBe(true);
        const geometry = await image.evaluate(node => {
          const rect = node.getBoundingClientRect();
          const parent = node.parentElement.getBoundingClientRect();
          return { width: rect.width, height: rect.height, available: parent.width,
            ratio: node.naturalHeight / node.naturalWidth,
            offset: Math.abs(rect.left + rect.width / 2 - parent.left - parent.width / 2) };
        });
        expect(geometry.width).toBeCloseTo(geometry.available * 0.75, 0);
        expect(Math.abs(geometry.height - geometry.width * geometry.ratio)).toBeLessThan(1);
        expect(geometry.offset).toBeLessThan(1);
      }
      const wide = page.locator('.assets-image').last();
      expect(await wide.evaluate(node => node.scrollWidth <= node.clientWidth + 1)).toBe(true);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    }
    const assetUrl = `/assets/${encodeURIComponent('几何')}/${encodeURIComponent('原图.svg')}`;
    const response = await request.get(assetUrl);
    expect(response.headers()['content-type']).toBe('image/svg+xml');
    expect(await response.text()).toBe(svg(180, 'red'));
    await writeFile(small, svg(180, 'green'));
    await expect.poll(async () => (await (await request.get(assetUrl)).text()), { timeout: 15000 }).toBe(svg(180, 'green'));
  } finally {
    await rm(note, { force: true });
    await rm(folder, { recursive: true, force: true });
    await expect.poll(async () => (await request.get('/notes/assets-image-test/')).status(), { timeout: 15000 }).toBe(404);
  }
});
