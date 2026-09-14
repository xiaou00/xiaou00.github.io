import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { ROOT } from './build.mjs';
import { validateNotePath } from './note-paths.mjs';

try {
  const [input, ...extra] = process.argv.slice(2);
  if (!input || extra.length) throw new Error('用法: npm run new:note -- "笔记本名/笔记标题". 文件名就是标题, 无需另填.');
  const slug = validateNotePath(input.replace(/\.typ$/, ''));
  const template = `${'../'.repeat(slug.split('/').length)}template.typ`;
  const source = `#import "${template}": *

#show: note

= 从这里开始

在这里写下你的笔记.

// 引用同一笔记本的笔记: #note-ref("./另一篇笔记.typ")
// 从 notes/ 根目录引用: #note-ref("笔记本名/另一篇笔记.typ")
// 引用其中的标签: #note-ref("./另一篇笔记.typ", target: <my-theorem>)
`;
  const file = join(ROOT, 'content/notes', `${slug}.typ`);
  await mkdir(dirname(file), { recursive: true });
  await writeFile(file, source, { flag: 'wx' });
  console.log(`已创建 content/notes/${slug}.typ; 保存后自动加入文件目录.`);
} catch (error) {
  console.error(error.code === 'EEXIST' ? '笔记文件已存在, 未覆盖.' : error.message);
  process.exitCode = 1;
}
