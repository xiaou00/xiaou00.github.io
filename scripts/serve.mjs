import { createServer } from 'node:http';
import { watch } from 'node:fs';
import { readFile, stat } from 'node:fs/promises';
import { extname, join, resolve, sep } from 'node:path';
import { build, ROOT } from './build.mjs';
import { TypstCompiler } from './typst-compiler.mjs';

const dev = process.argv.includes('--watch');
const arg = key => {
  const value = process.argv.find(value => value.startsWith(`${key}=`));
  if (value) return value.slice(key.length + 1);
  const index = process.argv.indexOf(key);
  return index !== -1 && process.argv[index + 1] && !process.argv[index + 1].startsWith('--') ? process.argv[index + 1] : undefined;
};
const port = Number(arg('--port') || process.env.PORT || 5173);
const host = arg('--host') || process.env.HOST || '127.0.0.1';
let ready = false;
let closing = false;
const compilerSession = new TypstCompiler({ cwd: ROOT, watch: dev, onChange: () => {
  if (ready && !closing) { clearTimeout(timer); timer = setTimeout(rebuild, 80); }
} });
let result;
let startupError = null;
try { result = await build({ dev, compilerSession }); }
catch (error) {
  if (!dev) { await compilerSession.close(); console.error(error.message); process.exit(1); }
  // Keep the last working preview and the incremental workers alive while the
  // author is fixing a syntax error, including errors present at startup.
  const { default: site } = await import('../site.config.mjs');
  result = { site };
  startupError = error.message;
  console.error(`${error.message}\n保留上次成功构建, 等待修正.`);
}
let base = result.site.base;
let revision = 0;
let latestError = startupError;
const clients = new Set();
const publish = () => {
  const message = `data: ${JSON.stringify({ revision, error: latestError })}\n\n`;
  for (const client of clients) client.write(message);
};
const mime = { '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.png': 'image/png', '.svg': 'image/svg+xml', '.webp': 'image/webp', '.woff': 'font/woff', '.woff2': 'font/woff2', '.json': 'application/json; charset=utf-8', '.typ': 'text/plain; charset=utf-8', '.txt': 'text/plain; charset=utf-8', '.bib': 'text/plain; charset=utf-8', '.pdf': 'application/pdf' };
const devClient = () => `(() => {
  let revision;
  const events = new EventSource(${JSON.stringify(`${base}__dev/events`)});
  events.onmessage = ({ data }) => {
    const state = JSON.parse(data);
    if (state.error) {
      let overlay = document.getElementById('typst-build-error');
      if (!overlay) {
        overlay = document.createElement('aside');
        overlay.id = 'typst-build-error';
        overlay.setAttribute('role', 'alert');
        overlay.style.cssText = 'position:fixed;inset:auto 16px 16px;max-height:60vh;overflow:auto;padding:24px;background:#2c2022;color:#fff3ed;border-top:3px solid #b02032;z-index:100;font:13px/1.6 monospace;white-space:pre-wrap;box-shadow:0 8px 40px #0003';
        document.body.append(overlay);
      }
      overlay.textContent = 'Typst 编译失败 · 修正后会自动恢复\\n\\n' + state.error;
    } else {
      document.getElementById('typst-build-error')?.remove();
      if (revision !== undefined && state.revision !== revision) location.reload();
    }
    revision = state.revision;
  };
  window.addEventListener('pagehide', () => events.close());
})();`;

const server = createServer(async (request, response) => {
  try {
    if (!['GET', 'HEAD'].includes(request.method)) { response.writeHead(405, { Allow: 'GET, HEAD' }); response.end(); return; }
    const url = new URL(request.url, 'http://localhost');
    let pathname;
    try { pathname = decodeURIComponent(url.pathname); } catch { response.writeHead(400); response.end('Bad request'); return; }
    if (base !== '/' && pathname === '/') { response.writeHead(302, { Location: base }); response.end(); return; }
    if (dev && pathname === `${base}__dev/events`) {
      response.writeHead(200, { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache', Connection: 'keep-alive' });
      clients.add(response);
      response.write(`data: ${JSON.stringify({ revision, error: latestError })}\n\n`);
      request.on('close', () => clients.delete(response));
      return;
    }
    if (dev && pathname === `${base}__dev/client.js`) { response.writeHead(200, { 'Content-Type': mime['.js'], 'Cache-Control': 'no-store' }); response.end(request.method === 'HEAD' ? undefined : devClient()); return; }
    const output = join(ROOT, dev ? '.build/dev' : 'dist');
    let file = pathname.startsWith(base) ? resolve(output, `.${sep}${pathname.slice(base.length)}`) : '';
    let status = 200;
    if (!file.startsWith(output + sep) && file !== output) { status = 404; file = join(output, '404.html'); }
    try {
      const info = await stat(file);
      if (info.isDirectory()) {
        if (!pathname.endsWith('/')) { response.writeHead(301, { Location: `${url.pathname}/${url.search}` }); response.end(); return; }
        file = join(file, 'index.html');
      }
      await stat(file);
    } catch { status = 404; file = join(output, '404.html'); }
    const bytes = await readFile(file);
    response.writeHead(status, { 'Content-Type': mime[extname(file)] || 'application/octet-stream', 'Content-Length': bytes.byteLength, 'Cache-Control': 'no-cache', 'X-Content-Type-Options': 'nosniff' });
    response.end(request.method === 'HEAD' ? undefined : bytes);
  } catch (error) {
    console.error(error.message);
    if (!response.headersSent) response.writeHead(500);
    response.end('页面暂时无法读取, 请刷新重试.');
  }
});
server.on('error', async error => { console.error(`无法启动预览: ${error.message}`); await shutdown(); process.exitCode = 1; });
server.listen(port, host, () => console.log(`\n  Liber 777\n  http://${host}:${port}${base}\n  ${dev ? '监听笔记, 引用, 模板与页面文件; 保存后自动编译.' : '静态站点预览'}\n`));

const watchers = [];
let timer;
let building = false;
let pending = false;
async function rebuild() {
  if (closing) return;
  if (building) { pending = true; return; }
  building = true;
  try {
    const output = await build({ dev: true, compilerSession });
    base = output.site.base;
    latestError = null;
    revision++;
  } catch (error) {
    latestError = error.message;
    console.error(`\n${latestError}\n保留上次成功构建, 等待修正.`);
  } finally {
    publish();
    building = false;
    if (pending) { pending = false; clearTimeout(timer); timer = setTimeout(rebuild, 80); }
  }
}
if (dev) {
  for (const folder of ['content', 'src', 'public']) watchers.push(watch(join(ROOT, folder), { recursive: true }, () => { clearTimeout(timer); timer = setTimeout(rebuild, 120); }));
  // Watch the directory so atomic-save editors can replace these files safely.
  watchers.push(watch(ROOT, (_, filename) => {
    if (['cover.png', 'site.config.mjs'].includes(filename)) { clearTimeout(timer); timer = setTimeout(rebuild, 120); }
  }));
}
ready = true;
async function shutdown() {
  closing = true;
  clearTimeout(timer);
  for (const watcher of watchers) watcher.close();
  for (const client of clients) client.end();
  server.close();
  await compilerSession.close();
}
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
