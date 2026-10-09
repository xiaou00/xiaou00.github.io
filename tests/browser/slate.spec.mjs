import { test, expect } from '@playwright/test';
import { cp, rm } from 'node:fs/promises';
import { resolve } from 'node:path';

const filename = resolve('content/notes/Slate specimen.typ');
const route = '/notes/Slate%20specimen/';
test.beforeAll(async ({ request }) => {
  await cp(resolve('tests/fixtures/Slate.typ'), filename);
  await expect.poll(async () => (await request.get(route)).status(), { timeout: 15000 }).toBe(200);
});
test.afterAll(async () => { await rm(filename, { force: true }); });

test('blog typography keeps headings proportional, the contents compact, and math readable across screen sizes', async ({ page }, testInfo) => {
  for (const width of [1440, 768, 390, 320]) {
    await page.setViewportSize({ width, height: 1000 });
    await page.goto(route);
    await page.evaluate(() => document.fonts.ready);
    await expect(page.locator('.equation-number')).toHaveText(['(1.1)', '(2.1)', '(2.2)']);
    await expect(page.locator('.chapter-label')).toHaveCount(0);
    await expect(page.locator('.toc-level-1 a')).toHaveText(['1 Foundations', '2 A new chapter', 'Afterword']);
    await expect(page.locator('.env-lemma .env-label')).toHaveText('Lemma 1.2');
    const style = await page.locator('.typst-content').evaluate(article => {
      const css = element => getComputedStyle(element);
      const heading = article.querySelector('h2');
      const label = article.querySelector('.env-label');
      return {
        bodyFont: css(article).fontFamily, bodySize: parseFloat(css(article).fontSize),
        color: css(article).color, sectionSize: parseFloat(css(heading).fontSize),
        titleSize: parseFloat(css(document.querySelector('h1')).fontSize),
        subheadingSize: parseFloat(css(article.querySelector('h3')).fontSize),
        paragraphAlign: css(article.querySelector('p')).textAlign,
        labelFont: css(label).fontFamily, labelWeight: css(label).fontWeight,
        codeFont: css(article.querySelector('code')).fontFamily,
        italic: css(article.querySelector('.proof-label')).fontStyle,
        fontsLoaded: ['11pt "Libertinus Serif"', '600 11pt "Noto Sans"', '11pt "Libertinus Math"', '11pt "Liberation Mono"'].every(font => document.fonts.check(font)),
      };
    });
    expect(style.bodyFont).toContain('Libertinus Serif');
    expect(style.bodySize).toBeGreaterThanOrEqual(16);
    expect(style.bodySize).toBeLessThanOrEqual(18);
    expect(style.color).toBe('rgb(41, 50, 59)');
    expect(style.titleSize).toBeGreaterThan(style.sectionSize);
    expect(style.titleSize).toBeLessThanOrEqual(style.bodySize * 2);
    expect(style.sectionSize).toBeGreaterThan(style.subheadingSize);
    expect(style.sectionSize).toBeLessThanOrEqual(style.bodySize * 1.5);
    expect(style.subheadingSize).toBeGreaterThan(style.bodySize);
    expect(style.paragraphAlign).toBe('left');
    expect(style.labelFont).toContain('Noto Sans');
    expect(style.labelWeight).toBe('600');
    expect(style.codeFont).toContain('Liberation Mono');
    expect(style.italic).toBe('italic');
    expect(style.fontsLoaded).toBe(true);
    for (const equation of await page.locator('.numbered-equation').all()) {
      const layout = await equation.evaluate(node => {
        const math = node.querySelector('.math-block').getBoundingClientRect();
        const number = node.querySelector('.equation-number').getBoundingClientRect();
        return number.left >= math.right && number.right <= node.getBoundingClientRect().right + 1;
      });
      expect(layout).toBe(true);
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    if (width === 1440 || width === 320) await page.screenshot({ path: testInfo.outputPath(`blog-${width}.png`), fullPage: true });
  }
  await page.locator('.typst-content a[href="#square"]').first().click();
  await expect(page.locator('#square')).toBeInViewport();
  await page.emulateMedia({ media: 'print' });
  await expect(page.locator('.site-header')).toBeHidden();
  await expect(page.locator('.equation-number').first()).toBeVisible();
});
