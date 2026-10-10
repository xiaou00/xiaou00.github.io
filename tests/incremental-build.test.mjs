import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { cp, mkdir, mkdtemp, readFile, readdir, rm, symlink, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { fileURLToPath, pathToFileURL } from 'node:url';

test('incremental output matches a clean build after edits, errors and deletion', { timeout: 120000 }, async () => {
  const project = fileURLToPath(new URL('../', import.meta.url));
  const root = await mkdtemp(join(tmpdir(), 'liber-incremental-test-'));
  let watcher;
  let batch;
  try {
    for (const name of ['scripts', 'src', 'public', 'site.config.mjs', 'package.json']) {
      await cp(join(project, name), join(root, name), { recursive: true });
    }
    await cp(join(project, 'content'), join(root, 'content'), {
      recursive: true, filter: path => !['notes', 'pedia'].some(name => path === join(project, 'content', name)),
    });
    await mkdir(join(root, 'content/notes'), { recursive: true });
    await mkdir(join(root, 'content/pedia'), { recursive: true });
    await symlink(join(project, 'node_modules'), join(root, 'node_modules'), 'junction');
    const { build } = await import(pathToFileURL(join(root, 'scripts/build.mjs')));
    const { TypstCompiler } = await import(pathToFileURL(join(root, 'scripts/typst-compiler.mjs')));
    const prefix = '#import "../template.typ": *\n#show: note\n';
    const source = name => join(root, `content/notes/${name}.typ`);
    await writeFile(source('A'), prefix + '#note-ref("B.typ", target: <topic>)');
    await writeFile(source('B'), prefix + '= Original heading <topic>\nOriginal body.');
    await writeFile(source('Unchanged'), prefix + 'An independent note.');
    watcher = new TypstCompiler({ cwd: root, watch: true, maxWorkers: 2 });
    batch = new TypstCompiler({ cwd: root });
    const preview = () => build({ dev: true, compilerSession: watcher });
    const snapshot = async () => {
      const folder = join(root, '.build/dev');
      const files = await readdir(folder, { recursive: true, withFileTypes: true });
      return (await Promise.all(files.filter(file => file.isFile()).map(async file => {
        const path = join(file.parentPath, file.name);
        return [path.slice(folder.length + 1), createHash('sha256').update(await readFile(path)).digest('hex')];
      }))).sort(([a], [b]) => a.localeCompare(b));
    };
    await preview();
    const unchanged = await preview();
    assert.equal(unchanged.output.written, 0);
    await writeFile(source('B'), prefix + '= Updated heading <topic>\nUpdated body.');
    const edited = await preview();
    assert.ok(edited.output.reused > edited.output.written);
    assert.ok((await readFile(join(root, '.build/dev/notes/A/index.html'), 'utf8')).includes('Updated heading'));
    let expected = await snapshot();
    await build({ dev: true, compilerSession: batch, fresh: true });
    assert.deepEqual(await snapshot(), expected);
    await writeFile(source('A'), prefix + '#missing-variable');
    await assert.rejects(preview(), /unknown variable/);
    assert.deepEqual(await snapshot(), expected, 'failed builds leave the published preview intact');
    await writeFile(source('A'), prefix + '#note-ref("B.typ", target: <topic>)');
    await rm(source('B'));
    await preview();
    assert.ok((await readFile(join(root, '.build/dev/notes/A/index.html'), 'utf8')).includes('note-reference-missing'));
    await assert.rejects(readFile(join(root, '.build/dev/notes/B/index.html')), { code: 'ENOENT' });
    expected = await snapshot();
    await build({ dev: true, compilerSession: batch, fresh: true });
    assert.deepEqual(await snapshot(), expected, 'removed pages, backlinks and neighboring-page links match a clean build');
  } finally {
    await watcher?.close();
    await batch?.close();
    await rm(root, { recursive: true, force: true });
  }
});
