import { createHash } from 'node:crypto';
import { copyFile, link, mkdir, readFile, readdir, rm, stat, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';

const digest = bytes => createHash('sha256').update(bytes).digest('hex');

// Build a complete staging directory while reusing unchanged output files.
// Reused files are never overwritten: publishing still swaps whole directories.
export class SiteOutput {
  constructor(stage, previous, { files = new Map(), sources = new Map() } = {}) {
    this.stage = stage;
    this.previous = previous;
    this.previousFiles = files;
    this.sources = sources;
    this.files = new Map();
    this.usedSources = new Set();
    this.stats = { written: 0, reused: 0 };
  }

  async emit(path, hash, write) {
    const target = join(this.stage, path);
    await mkdir(dirname(target), { recursive: true });
    // A public file can be overridden by generated output at the same path.
    // Unlink first so a hard link cannot modify the last successful build.
    await rm(target, { force: true });
    let reused = false;
    if (this.previousFiles.get(path) === hash) {
      try { await link(join(this.previous, path), target); reused = true; }
      catch (error) { if (!['ENOENT', 'EXDEV', 'EPERM', 'ENOTSUP'].includes(error.code)) throw error; }
    }
    if (!reused) await write(target);
    this.files.set(path, hash);
    this.stats[reused ? 'reused' : 'written']++;
  }

  async write(path, value) {
    const bytes = Buffer.from(value);
    await this.emit(path, digest(bytes), target => writeFile(target, bytes));
  }

  async copy(source, path) {
    const info = await stat(source);
    const stamp = JSON.stringify([info.size, info.mtimeMs, info.ctimeMs, info.ino]);
    let record = this.sources.get(source);
    let bytes;
    if (record?.stamp !== stamp) {
      bytes = await readFile(source);
      record = { stamp, hash: digest(bytes) };
      this.sources.set(source, record);
    }
    this.usedSources.add(source);
    await this.emit(path, record.hash, target => bytes ? writeFile(target, bytes) : copyFile(source, target));
  }

  async tree(source, path = '', { filter = () => true } = {}) {
    for (const entry of await readdir(source, { withFileTypes: true })) {
      if (!filter(entry.name)) continue;
      const input = join(source, entry.name);
      const output = join(path, entry.name);
      if (entry.isDirectory()) await this.tree(input, output, { filter });
      else await this.copy(input, output);
    }
  }

  fingerprint() {
    return digest(JSON.stringify([...this.files].sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)));
  }

  snapshot() {
    return { files: this.files, sources: new Map([...this.sources].filter(([path]) => this.usedSources.has(path))) };
  }
}
