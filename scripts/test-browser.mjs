import { spawn } from 'node:child_process';
import { cp, mkdir, mkdtemp, rm, symlink } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { createServer } from 'node:net';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const workspace = await mkdtemp(join(tmpdir(), 'liber-browser-tests-'));
const require = createRequire(import.meta.url);
try {
  for (const path of ['scripts', 'src', 'tests', 'public', 'cover.png', 'site.config.mjs', 'package.json', 'playwright.config.mjs']) {
    await cp(join(root, path), join(workspace, path), { recursive: true });
  }
  // Snapshot shared Typst helpers, but use only the test suite's own notes.
  await cp(join(root, 'content'), join(workspace, 'content'), {
    recursive: true, filter: source => !['notes', 'geopedia'].some(folder => source === join(root, 'content', folder)),
  });
  await mkdir(join(workspace, 'content/notes'), { recursive: true });
  await mkdir(join(workspace, 'content/geopedia'), { recursive: true });
  await symlink(join(root, 'node_modules'), join(workspace, 'node_modules'), 'junction');

  const socket = createServer();
  await new Promise((resolve, reject) => { socket.once('error', reject); socket.listen(0, '127.0.0.1', resolve); });
  const port = socket.address().port;
  await new Promise(resolve => socket.close(resolve));
  console.log('浏览器测试使用独立临时目录和端口, 测试报告保存在 test-results/.');
  const child = spawn(process.execPath, [require.resolve('@playwright/test/cli'), 'test',
    '--output', join(root, 'test-results'), ...process.argv.slice(2)], {
    cwd: workspace, stdio: 'inherit',
    env: { ...process.env, TEST_PREVIEW_PORT: String(port) },
  });
  const interrupt = () => child.kill('SIGINT');
  const terminate = () => child.kill('SIGTERM');
  process.on('SIGINT', interrupt);
  process.on('SIGTERM', terminate);
  try {
    process.exitCode = await new Promise((resolve, reject) => {
      child.once('error', reject);
      child.once('exit', code => resolve(code ?? 1));
    });
  } finally {
    process.off('SIGINT', interrupt);
    process.off('SIGTERM', terminate);
  }
} finally {
  await rm(workspace, { recursive: true, force: true });
}
