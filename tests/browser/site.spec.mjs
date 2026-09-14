import { test, expect } from '@playwright/test';
import { mkdir, readFile, rename, rm, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { randomUUID } from 'node:crypto';
import { discoverNoteFiles, encodeNotePath } from '../../scripts/note-paths.mjs';
import { createNotebookFixture } from '../fixtures.mjs';

const noteRoute = slug => `/notes/${encodeNotePath(slug)}/`;
let fixture;
let specimen;
let ideals;
let noteCount;

test.beforeAll(async ({ request }) => {
  // Compiling the complete math and diagram fixture can take over 15 seconds.
  test.setTimeout(45000);
  fixture = await createNotebookFixture();
  ({ specimen, ideals } = fixture);
  noteCount = (await discoverNoteFiles(resolve('content/notes'))).length;
  await expect.poll(async () => (await (await request.get('/')).text()).includes(`data-directory="${fixture.folder}"`), { timeout: 30000 }).toBe(true);
});

test.afterAll(async ({ request }) => {
  if (!fixture) return;
  await fixture.cleanup();
  await expect.poll(async () => (await (await request.get('/')).text()).includes(`data-directory="${fixture.folder}"`), { timeout: 15000 }).toBe(false);
});

test('file directory, filename search and reading navigation work without metadata', async ({ page, baseURL }) => {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto('/');
  await expect(page.locator('h1')).toHaveText('Liber 777');
  await expect(page.getByRole('navigation', { name: '笔记文件目录' })).toBeVisible();
  await expect(page.locator('details[data-directory][open]')).toHaveCount(0);
  await expect(page.locator('.file-link:visible')).toHaveCount(0);
  await expect(page.locator('[data-filter], [data-kind], time')).toHaveCount(0);
  await page.keyboard.press('/');
  await expect(page.getByRole('searchbox')).toBeFocused();
  await page.getByRole('searchbox').fill(`${ideals}.typ`);
  await expect(page.locator('.file-link:visible')).toHaveCount(1);
  await expect(page.locator('.file-link:visible .file-name')).toHaveText('理想与除子');
  await page.getByRole('searchbox').fill('不存在的文稿');
  await expect(page.locator('.empty-state')).toBeVisible();
  await page.getByRole('button', { name: '查看全部笔记' }).click();
  await expect(page.locator('.file-link:visible')).toHaveCount(0);
  await page.getByRole('button', { name: '全部展开' }).click();
  await expect(page.locator('.file-link:visible')).toHaveCount(noteCount);
  await page.getByRole('searchbox').fill(`${fixture.folder} 一致化参数`);
  await expect(page.locator('.file-link:visible')).toHaveCount(1);
  await page.locator('.file-link:visible').click();
  await expect(page).toHaveURL(`${baseURL}${noteRoute(specimen)}`);
  await expect(page.locator('.typst-content math').first()).toBeVisible();
  await expect(page.locator('time, .article-meta, .article-status')).toHaveCount(0);
  expect(errors).toEqual([]);
});

test('MathML, TOC, theorem links, source downloads and 404 work', async ({ page, request }) => {
  await page.goto(noteRoute(specimen));
  const math = await page.locator('.typst-content math').evaluateAll(nodes => nodes.map(node => ({ namespace: node.namespaceURI, width: node.getBoundingClientRect().width, height: node.getBoundingClientRect().height })));
  expect(math.length).toBeGreaterThan(40);
  expect(math.every(node => node.namespace === 'http://www.w3.org/1998/Math/MathML' && node.width > 0 && node.height > 0)).toBe(true);
  await page.locator('.toc a').filter({ hasText: '定理与证明' }).click();
  await expect(page.locator('.toc a.active')).toContainText('定理与证明');
  await page.locator('.typst-content a[href="#prop-factorization"]').click();
  await expect(page).toHaveURL(/#prop-factorization$/);
  const source = await request.get(`/sources/notes/${encodeNotePath(specimen)}.typ`);
  expect(source.status()).toBe(200);
  expect(await source.text()).toContain('#show: note\n');
  const missing = await request.get('/notes/does-not-exist/');
  expect(missing.status()).toBe(404);
  expect(await missing.text()).toContain('这一页, 尚未写下.');
});

test('display operators stay on one line, wide formulas scroll and explicit lines remain', async ({ page }) => {
  for (const width of [1440, 390, 320]) {
    await page.setViewportSize({ width, height: 900 });
    await page.goto(noteRoute(specimen));
    await page.evaluate(() => document.fonts.ready);
    const region = page.locator('#math-operators');
    const sum = region.locator('math').first();
    expect(await sum.evaluate(math => {
      const row = math.firstElementChild;
      const first = row.firstElementChild.getBoundingClientRect();
      const last = row.lastElementChild.firstElementChild.getBoundingClientRect();
      return {
        grouped: math.children.length === 1 && row.localName === 'mrow',
        aligned: Math.abs(first.y - last.y) < 1,
        ordered: last.left > first.right,
      };
    })).toEqual({ grouped: true, aligned: true, ordered: true });
    await expect(region.locator('math > mtable > mtr')).toHaveCount(2);
    if (width <= 390) {
      const wide = region.locator('.math-block').nth(3);
      expect(await wide.evaluate(node => node.scrollWidth > node.clientWidth)).toBe(true);
      await wide.evaluate(node => { node.scrollLeft = 100; });
      expect(await wide.evaluate(node => node.scrollLeft)).toBeGreaterThan(0);
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await region.screenshot({ path: `/tmp/ain-soph-math-operators-${width}.png` });
  }
});

test('math overlines and underlines stretch with their content and preserve nesting', async ({ page }) => {
  for (const width of [1440, 390]) {
    await page.setViewportSize({ width, height: 900 });
    await page.goto(noteRoute(specimen));
    await page.evaluate(() => document.fonts.ready);
    const region = page.locator('#math-lines');
    const lines = region.locator('.math-underline, .math-overline');
    await expect(lines).toHaveCount(15);
    const layout = await lines.evaluateAll(nodes => nodes.map(node => {
      const body = node.firstElementChild.getBoundingClientRect();
      const box = node.getBoundingClientRect();
      const style = getComputedStyle(node);
      const over = node.classList.contains('math-overline');
      return {
        namespace: node.namespaceURI,
        fullWidth: box.width >= body.width - 1,
        visible: parseFloat(over ? style.borderTopWidth : style.borderBottomWidth) > 0,
        correctSide: over ? box.top < body.top : box.bottom > body.bottom,
      };
    }));
    for (const line of layout) expect(line).toEqual({
      namespace: 'http://www.w3.org/1998/Math/MathML',
      fullWidth: true, visible: true, correctSide: true,
    });
    const widths = await lines.evaluateAll(nodes => nodes.map(node => node.getBoundingClientRect().width));
    expect(Math.max(...widths)).toBeGreaterThan(Math.min(...widths) * 2);
    const textLines = await region.locator('span[style*="text-decoration"]').evaluateAll(nodes => nodes.map(node => getComputedStyle(node).textDecorationLine));
    expect(textLines).toEqual(['underline', 'overline']);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await region.screenshot({ path: `/tmp/ain-soph-math-lines-${width}.png` });
  }
});

test('environment titles lead into the first paragraph while display formulas stay separate', async ({ page }) => {
  for (const width of [1440, 390]) {
    await page.setViewportSize({ width, height: 900 });
    for (const [slug, selector] of [[specimen, '.env-definition'], [fixture.index, '.env-remark']]) {
      await page.goto(noteRoute(slug));
      await page.evaluate(() => document.fonts.ready);
      const environment = page.locator(selector).first();
      const layout = await environment.evaluate(figure => {
        const caption = figure.querySelector('figcaption');
        const body = figure.querySelector('.env-body');
        const walker = document.createTreeWalker(body, NodeFilter.SHOW_TEXT);
        let text;
        while ((text = walker.nextNode()) && !text.textContent.trim()) {}
        const range = document.createRange();
        const start = text.textContent.search(/\S/);
        range.setStart(text, start);
        range.setEnd(text, start + 1);
        const first = range.getBoundingClientRect();
        const heading = [...caption.getClientRects()].at(-1);
        const formula = body.querySelector('.math-block')?.getBoundingClientRect();
        return {
          sameLine: Math.min(first.bottom, heading.bottom) > Math.max(first.top, heading.top),
          followsTitle: first.left >= heading.right,
          formulaBelow: !formula || formula.top >= first.bottom,
        };
      });
      expect(layout).toEqual({ sameLine: true, followsTitle: true, formulaBelow: true });
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
      await environment.screenshot({ path: `/tmp/ain-soph-inline-${selector.slice(1)}-${width}.png` });
    }
  }
});

test('Fletcher diagrams render at their natural size, center, scroll and retain references', async ({ page }) => {
  await page.goto(noteRoute(specimen));
  await page.evaluate(() => document.fonts.ready);
  const diagrams = page.locator('.note-diagram .diagram-scroll > svg');
  await expect(diagrams).toHaveCount(2);
  const sizes = await diagrams.evaluateAll(nodes => nodes.map(svg => ({
    namespace: svg.namespaceURI,
    width: svg.getBoundingClientRect().width,
    height: svg.getBoundingClientRect().height,
    ratio: svg.viewBox.baseVal.width / svg.viewBox.baseVal.height,
    geometry: svg.getBBox().width,
  })));
  for (const size of sizes) {
    expect(size.namespace).toBe('http://www.w3.org/2000/svg');
    expect(size.width).toBeGreaterThan(50);
    expect(size.height).toBeGreaterThan(20);
    expect(size.geometry).toBeGreaterThan(0);
    expect(size.width / size.height).toBeCloseTo(size.ratio, 2);
  }
  const square = page.locator('#commutative-square');
  expect(await square.locator('.diagram-scroll').evaluate(region => {
    const outer = region.getBoundingClientRect();
    const inner = region.querySelector('svg').getBoundingClientRect();
    return Math.abs((inner.left - outer.left) - (outer.right - inner.right));
  })).toBeLessThan(2);
  await page.locator('.typst-content a[href="#commutative-square"]').click();
  await expect(square).toBeInViewport();
  await square.screenshot({ path: '/tmp/ain-soph-fletcher-desktop.png' });
  await page.setViewportSize({ width: 320, height: 900 });
  const wide = page.locator('#long-diagram .diagram-scroll');
  expect(await wide.evaluate(region => region.scrollWidth > region.clientWidth)).toBe(true);
  await wide.evaluate(region => { region.scrollLeft = 100; });
  expect(await wide.evaluate(region => region.scrollLeft)).toBeGreaterThan(0);
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
  await square.screenshot({ path: '/tmp/ain-soph-fletcher-mobile.png' });
});

test('desktop and mobile have no horizontal page overflow or missing assets', async ({ page }) => {
  const failures = [];
  page.on('response', response => { if (response.status() >= 400) failures.push(response.url()); });
  for (const width of [1440, 768, 390, 320]) {
    await page.setViewportSize({ width, height: 900 });
    for (const route of ['/', ...[fixture.index, ideals, specimen].map(noteRoute)]) {
      await page.goto(route);
      await page.evaluate(() => document.fonts.ready);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${route} at ${width}px`).toBe(true);
      await expect(page.locator('h1')).toBeVisible();
    }
  }
  expect(failures).toEqual([]);
  await page.setViewportSize({ width: 1440, height: 1000 });
  await page.goto('/');
  await page.screenshot({ path: '/tmp/ain-soph-home-desktop.png', fullPage: true });
  await page.goto(noteRoute(specimen));
  await page.screenshot({ path: '/tmp/ain-soph-note-desktop.png', fullPage: true });
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('/');
  await page.screenshot({ path: '/tmp/ain-soph-home-mobile.png', fullPage: true });
  await page.goto(noteRoute(specimen));
  await page.screenshot({ path: '/tmp/ain-soph-note-mobile.png', fullPage: true });
});

test('content is readable without JavaScript', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await page.goto(`${baseURL}/`);
  await expect(page.locator('.file-link')).toHaveCount(noteCount);
  await page.locator(`[data-directory="${fixture.folder}"] > summary`).click();
  await page.locator(`[data-directory="${fixture.folder}/写作"] > summary`).click();
  await page.locator(`.file-link[href="${noteRoute(specimen)}"]`).click();
  await expect(page.locator('.typst-content math').first()).toBeVisible();
  await expect(page.locator('.toc a').first()).toBeVisible();
  await page.locator(`.typst-content a[href="${noteRoute(ideals)}"]`).click();
  await expect(page.locator('.article-header h1')).toHaveText('理想与除子');
  await expect(page.locator(`[data-direction="incoming"] a[href="${noteRoute(specimen)}"]`)).toBeVisible();
  await context.close();
});

test('nested notebooks, filename and folder renames, references and live changes work', async ({ page, request, baseURL }) => {
  test.setTimeout(60000);
  const folder = `browser-fixture-${randomUUID()}`;
  const movedFolder = `${folder}-改名后的笔记本`;
  const slug = `${folder}/自动编译验证`;
  const fixture = resolve(`content/notes/${slug}.typ`);
  let targetSlug = `${folder}/子目录/目标 笔记`;
  let targetFile = resolve(`content/notes/${targetSlug}.typ`);
  const output = resolve(`.build/dev/notes/${slug}/index.html`);
  let valid = '#import "../../template.typ": *\n#show: note\n= 本篇正文\n$ x^2 + y^2 = z^2 $\n#note-ref("./子目录/目标 笔记.typ", target: <external-only>)\n';
  const targetSource = '#import "../../../template.typ": *\n#show: note\n= 独立主题\n#theorem(title: "被其他笔记引用")[目标笔记独有的正文.] <external-only>\n#note-ref("../自动编译验证.typ")\n';
  try {
    await page.goto('/');
    await mkdir(resolve(`content/notes/${folder}/子目录`), { recursive: true });
    await writeFile(targetFile, targetSource);
    await writeFile(fixture, valid);
    const entry = page.locator('.file-link').filter({ hasText: '自动编译验证' });
    await expect(entry).toHaveCount(1, { timeout: 15000 });
    await expect(entry).not.toBeVisible();
    await page.getByRole('button', { name: '全部展开' }).click();
    await expect(entry).toBeVisible();
    await page.getByRole('button', { name: '全部折叠' }).click();
    await expect(entry).not.toBeVisible();
    await page.getByRole('searchbox').fill(`${slug}.typ`);
    await expect(entry).toBeVisible();
    await expect(page.locator('.file-link:visible')).toHaveCount(1);
    await page.getByRole('searchbox').fill('');
    await expect(entry).not.toBeVisible();
    await page.getByRole('button', { name: '全部展开' }).click();
    await expect(entry).toBeVisible();
    const noJsContext = await page.context().browser().newContext({ javaScriptEnabled: false });
    const noJsPage = await noJsContext.newPage();
    await noJsPage.bringToFront();
    await noJsPage.goto(`${baseURL}/`);
    await expect(noJsPage.locator('.file-link').filter({ hasText: '自动编译验证' })).not.toBeVisible();
    await noJsPage.locator(`[data-directory="${folder}"] > summary`).click();
    await expect(noJsPage.locator('.file-link').filter({ hasText: '自动编译验证' })).toBeVisible();
    await noJsPage.locator(`[data-directory="${folder}"] > summary`).click();
    await expect(noJsPage.locator('.file-link').filter({ hasText: '自动编译验证' })).not.toBeVisible();
    await noJsContext.close();
    await page.bringToFront();
    await page.setViewportSize({ width: 320, height: 900 });
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await page.setViewportSize({ width: 1280, height: 900 });
    await entry.click();
    await expect(page.locator('.typst-content')).not.toContainText('目标笔记独有的正文');
    await expect(page.locator('.article-header h1')).toHaveText('自动编译验证');
    await expect(page.locator('.article-notebook')).toHaveText(folder);
    await expect(page.locator('.note-reference')).toContainText('目标 笔记 / 定理');
    await page.locator('.note-reference').click();
    await expect(page).toHaveURL(`${baseURL}/notes/${encodeNotePath(targetSlug)}/#external-only`);
    await expect(page.locator('.article-header h1')).toHaveText('目标 笔记');
    await expect(page.locator('.article-notebook')).toHaveText('子目录');
    await expect(page.locator('#external-only')).toBeInViewport();
    expect((await request.get(`/sources/notes/${encodeNotePath(targetSlug)}.typ`)).status()).toBe(200);
    await page.locator('[data-direction="incoming"] a').click();
    await expect(page).toHaveURL(`${baseURL}${noteRoute(slug)}`);
    const oldTargetSlug = targetSlug;
    targetSlug = `${folder}/子目录/目标标题已更新`;
    const renamedFile = resolve(`content/notes/${targetSlug}.typ`);
    await rename(targetFile, renamedFile);
    targetFile = renamedFile;
    valid = valid.replace('目标 笔记.typ', '目标标题已更新.typ');
    await writeFile(fixture, valid);
    await expect(page.locator('.note-reference')).toContainText('目标标题已更新', { timeout: 15000 });
    await expect(page.locator('.note-reference')).toHaveAttribute('href', `${noteRoute(targetSlug)}#external-only`);
    expect((await request.get(noteRoute(oldTargetSlug))).status()).toBe(404);
    const lastGood = await readFile(output, 'utf8');
    await writeFile(fixture, valid.replace('<external-only>', '<missing-label>'));
    await expect(page.locator('#typst-build-error')).toContainText('missing-label', { timeout: 15000 });
    expect(await readFile(output, 'utf8')).toEqual(lastGood);
    await writeFile(fixture, valid + '\n#unknown-function()');
    await expect(page.locator('#typst-build-error')).toContainText('unknown variable', { timeout: 15000 });
    expect(await readFile(output, 'utf8')).toEqual(lastGood);
    await writeFile(fixture, valid);
    await expect(page.locator('#typst-build-error')).toHaveCount(0, { timeout: 15000 });
    await expect(page.locator('.typst-content math')).toBeVisible();
    // Delete just one end of a mutual reference while its page is open.
    await page.locator('.note-reference').click();
    await expect(page.locator('.article-header h1')).toHaveText('目标标题已更新');
    await rm(targetFile);
    await expect(page.locator('h1')).toHaveText('这一页, 尚未写下.', { timeout: 15000 });
    expect((await request.get(noteRoute(targetSlug))).status()).toBe(404);
    expect((await request.get(`/sources/notes/${encodeNotePath(targetSlug)}.typ`)).status()).toBe(404);
    await page.goto(noteRoute(slug));
    await expect(page.locator('.note-reference-missing')).toHaveText('目标标题已更新');
    await expect(page.locator('.note-reference, .note-connections, #typst-build-error')).toHaveCount(0);
    expect(await readFile(fixture, 'utf8')).toBe(valid);
    await page.goto('/');
    await expect(page.locator(`.file-link[href="${noteRoute(slug)}"]`)).toHaveCount(1);
    await expect(page.locator(`.file-link[href="${noteRoute(targetSlug)}"], [data-directory="${folder}/子目录"]`)).toHaveCount(0);
    // Restoring the file restores automatic link text and backlinks.
    await page.goto(noteRoute(slug));
    await writeFile(targetFile, targetSource);
    await expect(page.locator('.note-reference')).toHaveText(/目标标题已更新 \/ 定理/, { timeout: 15000 });
    await expect(page.locator('.note-reference-missing')).toHaveCount(0);
    await expect(page.locator('[data-direction="incoming"] a')).toHaveCount(1);
    await page.goto('/');
    // Moving a notebook preserves its internal relative references.
    await rename(resolve(`content/notes/${folder}`), resolve(`content/notes/${movedFolder}`));
    await expect(page.locator(`[data-directory="${movedFolder}"] > summary .directory-name`)).toHaveText(movedFolder, { timeout: 15000 });
    await expect(page.locator(`[data-directory="${folder}"]`)).toHaveCount(0);
    await page.locator(`[data-directory="${movedFolder}"] > summary`).click();
    await entry.click();
    await expect(page.locator('.article-header h1')).toHaveText('自动编译验证');
    await expect(page.locator('.article-notebook')).toHaveText(movedFolder);
    await expect(page.locator('.note-reference')).toHaveAttribute('href', `${noteRoute(targetSlug.replace(folder, movedFolder))}#external-only`);
    await page.goto('/');
    await rm(resolve(`content/notes/${movedFolder}`), { recursive: true });
    await expect(page.locator('.file-link').filter({ hasText: '自动编译验证' })).toHaveCount(0, { timeout: 15000 });
    for (const path of [slug, targetSlug, slug.replace(folder, movedFolder), targetSlug.replace(folder, movedFolder)]) {
      expect((await request.get(noteRoute(path))).status()).toBe(404);
    }
  } finally {
    await rm(resolve(`content/notes/${folder}`), { recursive: true, force: true });
    await rm(resolve(`content/notes/${movedFolder}`), { recursive: true, force: true });
  }
});

test('a save with unchanged output preserves expanded folders and search without reloading', async ({ page }) => {
  await page.goto('/');
  const search = page.getByRole('searchbox');
  await search.fill(fixture.folder);
  const folder = page.locator(`details[data-directory="${fixture.folder}"]`);
  await expect(folder).toHaveAttribute('open', '');
  await page.evaluate(() => {
    window.testBuildEvents = [];
    window.testBuildStream = new EventSource('/__dev/events');
    window.testBuildStream.onmessage = ({ data }) => window.testBuildEvents.push(JSON.parse(data));
  });
  try {
    await expect.poll(() => page.evaluate(() => window.testBuildEvents?.length || 0)).toBeGreaterThan(0);
    const revision = await page.evaluate(() => window.testBuildEvents[0].revision);
    const input = resolve(`content/notes/${specimen}.typ`);
    await writeFile(input, await readFile(input));
    // Wait for the actual rebuild event, instead of a fixed delay or a retry.
    await expect.poll(() => page.evaluate(() => window.testBuildEvents?.length || 0), { timeout: 15000 }).toBeGreaterThan(1);
    expect(await page.evaluate(() => window.testBuildEvents.map(event => event.revision))).toEqual(expect.arrayContaining([revision, revision]));
    expect(await page.evaluate(() => window.testBuildEvents.every(event => event.revision === window.testBuildEvents[0].revision))).toBe(true);
    await expect(search).toHaveValue(fixture.folder);
    await expect(folder).toHaveAttribute('open', '');
  } finally {
    await page.evaluate(() => window.testBuildStream?.close());
  }
});
