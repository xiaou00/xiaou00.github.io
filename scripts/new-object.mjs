import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { validateObjectId } from './geopedia.mjs';

export async function createObject(root, id, name = id) {
  validateObjectId(id);
  const category = id.slice(0, 4);
  const filename = `content/geopedia/${category}/${id}.typ`;
  const source = `#import "../../geopedia-template.typ": *

#encyclopedia(
  name: [#${JSON.stringify(name)}],
  aliases: (), // 例如 ([另一个名称], [$X$]).
  introduction: [],
  base: [],
  definition: [在这里填写定义或构造.],

  properties: (), // 内容列表, 例如 ([光滑], [紧合]), 可以包含公式.
  invariants: (), // 键值列表, 例如 (([维数], [$n$]),).
  invariant-notes: [],
  content: [], // 一般讨论, 可以包含段落, 小节, 公式和证明.
)
`;
  await mkdir(dirname(join(root, filename)), { recursive: true });
  await writeFile(join(root, filename), source, { flag: 'wx' });
  return filename;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    const [id, name, ...extra] = process.argv.slice(2);
    if (!id || extra.length) throw new Error('用法: npm run new:object -- Schm0001 "对象名称"');
    const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
    const filename = await createObject(root, id, name);
    console.log(`已创建 ${filename}; 保存后自动加入 GeoPedia.`);
  } catch (error) {
    console.error(error.code === 'EEXIST' ? '对象文件已存在, 未覆盖.' : error.message);
    process.exitCode = 1;
  }
}
