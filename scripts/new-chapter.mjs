import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { ROOT } from './build.mjs';
import { sectionIdentity } from './books.mjs';

try {
  const [input, ...extra] = process.argv.slice(2);
  if (!input || extra.length) throw new Error('用法: npm run new:section -- "书名/01 章节名/01.1 小节名".');
  const filename = `${input.replace(/\.typ$/, '')}.typ`;
  sectionIdentity(filename);
  const file = join(ROOT, 'content/books', filename);
  await mkdir(dirname(file), { recursive: true });
  await writeFile(file, `#import "../../../template.typ": *

#show: note

= 从这里开始

在这里写下本节内容.

// 同一章的各节连续编号, 例如定理 1.1, 1.2.
// 引用同章小节: #book-ref("./01.2 下一节.typ", target: <my-theorem>)
`, { flag: 'wx' });
  console.log(`已创建 content/books/${filename}; 保存后自动加入书籍目录.`);
} catch (error) {
  console.error(error.code === 'EEXIST' ? '小节文件已存在, 未覆盖.' : error.message);
  process.exitCode = 1;
}
