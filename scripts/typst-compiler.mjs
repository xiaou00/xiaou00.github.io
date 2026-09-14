import { execFile, spawn } from 'node:child_process';
import { createHash, randomUUID } from 'node:crypto';
import { mkdir, readFile, rename, rm, stat, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { createInterface } from 'node:readline';
import { promisify } from 'node:util';

const exec = promisify(execFile);
const digest = value => createHash('sha256').update(value).digest('hex');
const notice = /warning: html export is under active development and incomplete\n(?: = hint:.*\n)*/g;
const diagnostics = value => value.replace(notice, '').trim();

async function contents(files) {
  return Object.fromEntries(await Promise.all(files.map(async file => {
    try { return [file, await readFile(file)]; }
    catch (error) { if (error.code === 'ENOENT') return [file, null]; throw error; }
  })));
}

const hashes = files => Object.fromEntries(Object.entries(files).map(([file, bytes]) => [file, bytes === null ? null : digest(bytes)]));
const snapshot = async files => hashes(await contents(files));
const unchanged = (before, after) => Object.entries(before).every(([file, hash]) => hash === after[file]);

// Typst 0.15.1 rounds a shared byte suffix in the wrong direction when it
// starts inside a UTF-8 character (e.g. changing 笔记 to 已更新). Restart only
// for these edits, so corrupted incremental output never reaches the cache.
// https://github.com/typst/typst/blob/v0.15.1/crates/typst-syntax/src/lines.rs#L175
function unsafeUnicodeEdit(before, after) {
  if (!before || !after || before.equals(after)) return false;
  let suffix = 0;
  const length = Math.min(before.length, after.length);
  while (suffix < length && before[before.length - suffix - 1] === after[after.length - suffix - 1]) suffix++;
  const continuation = (bytes, index) => index < bytes.length && (bytes[index] & 0xc0) === 0x80;
  return continuation(before, before.length - suffix) || continuation(after, after.length - suffix);
}

// A persistent CLI process keeps Typst's own memoized function/layout results,
// including Fletcher/CeTZ frames. File dependencies come from Typst, not regexes.
export class TypstCompiler {
  constructor({ cwd, cacheDir = join(cwd, '.build/typst-cache'), watch = false, onChange = () => {} }) {
    this.cwd = cwd;
    this.cacheDir = cacheDir;
    this.watch = watch;
    this.onChange = onChange;
    this.binary = process.env.TYPST_BIN || 'typst';
    this.workers = new Map();
    this.tempDir = join(cwd, '.build/typst-workers', randomUUID());
  }

  async run(args) {
    try {
      const { stdout, stderr } = await exec(this.binary, args, { cwd: this.cwd, maxBuffer: 24 * 1024 * 1024 });
      const message = diagnostics(stderr);
      if (message) process.stderr.write(`${message}\n`);
      return stdout;
    } catch (error) {
      if (error.code === 'ENOENT') throw new Error('未找到 Typst. 请安装 Typst 0.15.1 或更新版本, 或设置 TYPST_BIN.');
      throw new Error(diagnostics(error.stderr || error.message));
    }
  }

  version() { return this.versionPromise ??= this.run(['--version']); }

  async key(input, flags) {
    return digest(JSON.stringify([
      2, this.binary, await this.version(), this.cwd, input, flags,
      // Time-dependent documents must not reuse yesterday's output.
      new Date().toISOString().slice(0, 10),
      ...['TYPST_FONT_PATHS', 'TYPST_IGNORE_SYSTEM_FONTS', 'TYPST_PACKAGE_PATH', 'TYPST_PACKAGE_CACHE_PATH', 'SOURCE_DATE_EPOCH'].map(key => process.env[key] || ''),
    ]));
  }

  async dependencies(path, input) {
    const deps = JSON.parse(await readFile(path, 'utf8'));
    return [...new Set([input, ...deps.inputs.map(file => resolve(this.cwd, file))])].sort();
  }

  async cached(key) {
    try {
      const record = JSON.parse(await readFile(join(this.cacheDir, `${key}.json`), 'utf8'));
      if (record.key !== key || typeof record.html !== 'string' || !record.dependencies || !Object.keys(record.dependencies).length) return null;
      if (Object.values(record.dependencies).some(hash => typeof hash !== 'string')) return null;
      return unchanged(record.dependencies, await snapshot(Object.keys(record.dependencies))) ? record : null;
    } catch (error) {
      if (error.code === 'ENOENT' || error instanceof SyntaxError) return null;
      throw error;
    }
  }

  async save(key, html, dependencies) {
    if (Object.values(dependencies).some(hash => hash === null)) return;
    await mkdir(this.cacheDir, { recursive: true });
    const file = join(this.cacheDir, `${key}.json`);
    const temporary = `${file}.${randomUUID()}.tmp`;
    await writeFile(temporary, JSON.stringify({ key, html, dependencies }));
    await rename(temporary, file);
  }

  async compile(input, flags, { fresh = false } = {}) {
    input = resolve(input);
    const key = await this.key(input, flags);
    if (this.watch) return this.compileWatching(input, flags, key);
    if (!fresh) {
      const cached = await this.cached(key);
      if (cached) return { html: cached.html, cached: true, incremental: false };
    }
    await mkdir(this.tempDir, { recursive: true });
    const depsPath = join(this.tempDir, `${key}.deps.json`);
    // Check known dependencies on both sides, so edits during a compile cannot
    // poison the cache with an output for a different source revision.
    let known = [input];
    try { known = Object.keys(JSON.parse(await readFile(join(this.cacheDir, `${key}.json`), 'utf8')).dependencies); } catch {}
    const before = await snapshot(known);
    const started = Date.now();
    const html = await this.run(['compile', ...flags, '--format', 'html', '--deps', depsPath, input, '-']);
    const dependencies = await snapshot(await this.dependencies(depsPath, input));
    const newFiles = Object.keys(dependencies).filter(file => !(file in before));
    const stableNewFiles = (await Promise.all(newFiles.map(async file => {
      try { return (await stat(file)).ctimeMs <= started; } catch { return false; }
    }))).every(Boolean);
    if (stableNewFiles && unchanged(before, await snapshot(Object.keys(before)))) await this.save(key, html, dependencies);
    return { html, cached: false, incremental: false };
  }

  async compileWatching(input, flags, key) {
    let worker = this.workers.get(input);
    if (worker && (worker.key !== key || worker.closed)) {
      await worker.stop();
      this.workers.delete(input);
      worker = null;
    }
    if (!worker) {
      await mkdir(this.tempDir, { recursive: true });
      worker = this.startWorker(input, flags, key);
      this.workers.set(input, worker);
    }
    for (;;) {
      if (worker.restart) {
        await worker.stop();
        this.workers.delete(input);
        return this.compileWatching(input, flags, key);
      }
      const revision = worker.revision;
      const result = worker.result;
      if (!worker.compiling && result && unchanged(result.dependencies, await snapshot(Object.keys(result.dependencies)))) {
        if (revision !== worker.revision || worker.compiling) continue;
        if (result.error) throw result.error;
        const cached = worker.consumed === revision;
        worker.consumed = revision;
        return { html: result.html, cached, incremental: !cached && revision > 1, milliseconds: result.milliseconds };
      }
      if (worker.closed) throw new Error(`Typst 编译进程已退出: ${input}`);
      if (revision !== worker.revision) continue;
      await new Promise((resolve, reject) => {
        const wake = () => { clearTimeout(timer); worker.waiters.delete(wake); resolve(); };
        const timer = setTimeout(() => {
          worker.waiters.delete(wake);
          reject(new Error(`等待 Typst 增量编译超时: ${input}`));
        }, 120000);
        worker.waiters.add(wake);
      });
    }
  }

  startWorker(input, flags, key) {
    const htmlPath = join(this.tempDir, `${key}.html`);
    const depsPath = join(this.tempDir, `${key}.deps.json`);
    const child = spawn(this.binary, ['watch', ...flags, '--format', 'html', '--no-serve', '--no-reload', '--deps', depsPath, input, htmlPath], {
      cwd: this.cwd, stdio: ['ignore', 'pipe', 'pipe'], env: { ...process.env, NO_COLOR: '1' },
    });
    const worker = { key, child, revision: 0, consumed: 0, compiling: true, closed: false, waiters: new Set(), result: null };
    const wake = () => { for (const waiter of [...worker.waiters]) waiter(); };
    let text = '';
    let epoch = 0;
    let sourceBytes = contents([input]);
    let before = sourceBytes.then(hashes);
    let completion = Promise.resolve();
    const finish = (failed, milliseconds, finishedEpoch, initial) => {
      completion = completion.then(async () => {
        // The CLI writes diagnostics immediately after its completion line.
        await new Promise(resolve => setTimeout(resolve, 20));
        if (worker.closed || epoch !== finishedEpoch) return;
        let files = Object.keys(worker.result?.dependencies || { [input]: null });
        try { files = await this.dependencies(depsPath, input); } catch (error) { if (!failed) throw error; }
        const bytes = await contents(files);
        const dependencies = hashes(bytes);
        const previousBytes = await sourceBytes;
        if (Object.entries(bytes).some(([file, current]) => unsafeUnicodeEdit(previousBytes[file], current))) worker.restart = true;
        if (worker.restart) {
          worker.compiling = false;
          worker.revision++;
          wake();
          this.onChange(input);
          return;
        }
        const initialDependencies = await initial;
        if (!unchanged(initialDependencies, await snapshot(Object.keys(initialDependencies)))) return;
        const message = diagnostics(text);
        const html = failed ? null : await readFile(htmlPath, 'utf8');
        if (epoch !== finishedEpoch || worker.closed) return;
        worker.compiling = false;
        worker.revision++;
        sourceBytes = Promise.resolve(bytes);
        worker.result = { html, dependencies, milliseconds, error: failed ? new Error(message || `Typst 编译失败: ${input}`) : null };
        if (!failed) {
          if (message) process.stderr.write(`${message}\n`);
          await this.save(key, html, dependencies);
        }
        wake();
        this.onChange(input);
      }).catch(error => {
        worker.compiling = false;
        worker.revision++;
        worker.result = { error, dependencies: {} };
        wake();
        this.onChange(input);
      });
    };
    const readers = [child.stdout, child.stderr].map(stream => createInterface({ input: stream }));
    for (const reader of readers) reader.on('line', line => {
      line = line.replace(/\x1b\[[0-9;]*[A-Za-z]/g, '');
      if (/\] compiling \.\.\./.test(line)) {
        // Rapid saves can skip an intermediate result. Its source may have
        // triggered the Unicode bug, so discard that process conservatively.
        if (epoch > 0 && worker.compiling) worker.restart = true;
        epoch++;
        worker.compiling = true;
        text = '';
        before = snapshot(Object.keys(worker.result?.dependencies || { [input]: null }));
      } else if (/\] compiled (successfully|with warnings|with errors)/.test(line)) {
        const timing = line.match(/in ([\d.]+) (ms|s)/);
        const milliseconds = timing ? Number(timing[1]) * (timing[2] === 's' ? 1000 : 1) : null;
        finish(line.includes('with errors'), milliseconds, epoch, before);
      } else if (!/^(watching |writing to )/.test(line)) {
        text += `${line}\n`;
      }
    });
    const exited = new Promise(resolve => child.once('exit', resolve));
    child.on('error', error => {
      worker.compiling = false;
      worker.closed = true;
      worker.result = { error, dependencies: {} };
      wake();
    });
    child.on('exit', () => { worker.closed = true; wake(); });
    worker.stop = async () => {
      if (!worker.closed) {
        worker.closed = true;
        child.kill('SIGTERM');
        const timer = setTimeout(() => child.kill('SIGKILL'), 1000);
        await exited;
        clearTimeout(timer);
      }
      for (const reader of readers) reader.close();
      wake();
      await completion;
    };
    return worker;
  }

  async retain(inputs) {
    const active = new Set(inputs.map(input => resolve(input)));
    for (const [input, worker] of this.workers) if (!active.has(input)) {
      await worker.stop();
      this.workers.delete(input);
    }
  }

  async close() {
    await Promise.all([...this.workers.values()].map(worker => worker.stop()));
    this.workers.clear();
    await rm(this.tempDir, { recursive: true, force: true });
  }
}
