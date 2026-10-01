import test from 'node:test';
import assert from 'node:assert/strict';
import { copyFile, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { parseHTML } from 'linkedom';
import { TypstCompiler } from '../scripts/typst-compiler.mjs';
import { prepareTypstFonts } from '../scripts/typst-fonts.mjs';

test('function plots render sampled curves, split domains, validate input and export PDF', { timeout: 120000 }, async () => {
  const root = await mkdtemp(join(tmpdir(), 'typst-function-plot-'));
  const compiler = new TypstCompiler({ cwd: root });
  const input = join(root, 'note.typ');
  const source = `#import "template.typ": *
#show: note
Outside math: $x^2$.
#function-plot(x => x * x, x-range: (-3, 3), y-range: (-1, 9), caption: [平方函数]) <parabola>
See @parabola.
#function-plot((calc.sin, calc.cos), labels: ($sin x$, $cos x$), y-range: (-1.5, 1.5), grid: true)
#function-plot(x => 1 / x, breaks: (0,))
#function-plot(x => if x < 0 { none } else { calc.sqrt(x) })
#function-plot(x => calc.inf)
#function-plot(x => x, x-range: (100000, 100006), y-range: (100000, 100006))
#implicit-plot((x, y) => x*x + y*y - 4, x-range: (-3, 3), y-range: (-3, 3), caption: [圆]) <circle>
See @circle.
#implicit-plot((x, y) => x*y - 1, x-range: (-3, 3), y-range: (-3, 3))
#implicit-plot((x, y) => x*y, x-range: (-3, 3), y-range: (-3, 3))
#implicit-plot((x, y) => if x < 0 { none } else { x*x + y*y - 4 }, x-range: (-3, 3), y-range: (-3, 3))
#implicit-plot(
  (
    (x, y) => x + y,
    (x, y) => x - y,
  ),
  x-range: (-3, 3), y-range: (-3, 3),
  labels: ($x + y = 0$, $x - y = 0$),
)
`;
  const curves = svg => [...svg.querySelectorAll('path[stroke-width="1.15"]')].filter(path => /[ML]/.test(path.getAttribute('d')));
  try {
    for (const name of ['template.typ', 'abbrev.typ', 'function-plot.typ', 'print-template.typ']) {
      await copyFile(resolve('content', name), join(root, name));
    }
    const fontPath = await prepareTypstFonts(resolve('.'));
    const flags = ['--features', 'html', '--root', root, '--ignore-system-fonts', '--font-path', fontPath];
    await writeFile(input, source);
    const first = await compiler.compile(input, flags);
    const { document } = parseHTML(first.html);
    const svgs = [...document.querySelectorAll('.function-plot > svg')];
    assert.equal(svgs.length, 11);
    assert.equal(svgs[0].getAttribute('viewBox'), '0 0 264 180');
    assert.ok(document.querySelector('a[href="#parabola"]'), 'figure labels resolve');
    assert.ok(document.querySelector('math'), 'surrounding math stays native');
    assert.equal(document.querySelector('math svg, math figure'), null);
    assert.equal(curves(svgs[0]).length, 1);
    assert.equal(curves(svgs[0])[0].getAttribute('stroke'), '#ff0000');
    assert.equal(curves(svgs[1]).filter(path => path.getAttribute('d').length > 100).length, 2);
    assert.match(svgs[1].outerHTML, /#242424/);
    assert.match(svgs[1].outerHTML, /#bbbbbb/);
    const reciprocal = curves(svgs[2]).map(path => path.getAttribute('d')).join(' ');
    assert.equal((reciprocal.match(/m/g) || []).length, 2, 'a pole has two separate branches');
    const domain = curves(svgs[3])[0].getAttribute('d');
    assert.equal((domain.match(/m/g) || []).length, 1, 'undefined values leave a gap');
    assert.match(domain, /m 72 72/, 'sqrt starts at the origin in the default equal-scale plot');
    assert.equal(curves(svgs[4]).length, 0, 'non-finite results never become SVG coordinates');
    assert.ok(!svgs.some(svg => /NaN|Infinity/.test(svg.outerHTML)));
    assert.ok(document.querySelector('a[href="#circle"]'));
    assert.equal(document.querySelectorAll('.implicit-plot').length, 5);
    // Decode the emitted line segments, then test their mathematical geometry.
    const segments = paths => paths.flatMap(path => {
      const values = path.getAttribute('d').match(/[MLHVmlhv]|[-+]?(?:\d*\.)?\d+(?:e[-+]?\d+)?/g);
      const output = [];
      let p = [0, 0];
      for (let i = 0; i < values.length;) {
        const command = values[i++];
        const kind = command.toLowerCase();
        const relative = command === kind;
        let q = [...p];
        if (kind === 'h' || kind === 'v') {
          const axis = kind === 'h' ? 0 : 1;
          q[axis] = Number(values[i++]) + (relative ? p[axis] : 0);
        } else {
          q = [Number(values[i++]), Number(values[i++])];
          if (relative) q = q.map((n, axis) => n + p[axis]);
        }
        if (kind !== 'm') output.push([p, q]);
        p = q;
      }
      return output.map(line => line.map(([x, y]) => [x / 144 * 6 - 3, 3 - y / 144 * 6]));
    });
    const circle = segments(curves(svgs[6]));
    assert.ok(circle.length > 100, 'implicit curves contain real vector segments');
    for (const [x, y] of circle.flat()) assert.ok(Math.abs(x*x + y*y - 4) < 0.01, 'circle roots retain equal axis units');
    const hyperbola = segments(curves(svgs[7]));
    assert.ok(hyperbola.length > 50);
    for (const [a, b] of hyperbola) {
      assert.ok(a[0] * b[0] >= 0 && a[1] * b[1] >= 0, 'hyperbola branches never cross an asymptote');
      for (const [x, y] of [a, b]) assert.ok(Math.abs(x*y - 1) < 0.01);
    }
    const crossing = segments(curves(svgs[8]));
    assert.ok(crossing.some(line => line.every(([x]) => Math.abs(x) < 0.001)));
    assert.ok(crossing.some(line => line.every(([, y]) => Math.abs(y) < 0.001)));
    for (const line of crossing) {
      assert.ok(line.every(([x]) => Math.abs(x) < 0.001) || line.every(([, y]) => Math.abs(y) < 0.001), 'xy = 0 has no false diagonal at the intersection');
    }
    const halfCircle = segments(curves(svgs[9]));
    assert.ok(halfCircle.length > 20);
    for (const [x] of halfCircle.flat()) assert.ok(x >= -0.001, 'undefined cells are omitted');
    const lines = curves(svgs[10]).filter(path => path.getAttribute('d').length > 100);
    assert.deepEqual(lines.map(path => path.getAttribute('stroke')), ['#ff0000', '#242424']);
    for (const [i, path] of lines.entries()) {
      const line = segments([path]);
      assert.ok(line.length > 50, 'each equation produces a separate curve');
      for (const [x, y] of line.flat()) {
        assert.ok(Math.abs(i === 0 ? x + y : x - y) < 0.001, 'each curve follows its own equation');
      }
    }
    assert.equal((await compiler.compile(input, flags)).cached, true);
    await writeFile(input, source.replace('x => x * x', 'x => x * x / 2'));
    assert.notEqual((await compiler.compile(input, flags)).html, first.html, 'editing a function invalidates the cached image');

    for (const [call, message] of [
      ['#function-plot(())', /请传入函数/],
      ['#function-plot(x => x, x-range: (2, 2))', /坐标范围/],
      ['#function-plot(x => x, samples: 0)', /samples 必须/],
      ['#function-plot(x => x, labels: ())', /labels 数量/],
      ['#function-plot(x => x, width: 100%)', /绝对长度/],
      ['#function-plot(x => "oops")', /函数必须返回/],
      ['#implicit-plot((x, y) => x*x + y*y == 4)', /不要返回布尔值/],
      ['#implicit-plot((x, y) => x*y, samples: 300)', /samples 必须/],
      ['#implicit-plot((x, y) => x*y, breaks: (0,))', /不使用 breaks/],
    ]) {
      await writeFile(input, `#import "template.typ": *\n#show: note\n${call}`);
      await assert.rejects(compiler.compile(input, flags), message);
    }
    await writeFile(input, '#import "print-template.typ": function-plot, implicit-plot\n#set text(font: "Source Han Serif")\n#function-plot((calc.sin, calc.cos), labels: ($sin x$, $cos x$), caption: [正弦与余弦])\n#implicit-plot(((x, y) => x + y, (x, y) => x - y), labels: ($x + y = 0$, $x - y = 0$), caption: [两条直线])');
    const pdf = join(root, 'plot.pdf');
    await compiler.run(['compile', '--root', root, '--ignore-system-fonts', '--font-path', fontPath, input, pdf]);
    assert.equal((await readFile(pdf)).subarray(0, 4).toString(), '%PDF');
  } finally {
    await compiler.close();
    await rm(root, { recursive: true, force: true });
  }
});
