import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { validateObjectId } from './sheafpedia.mjs';

export async function createObject(root, id, name = id) {
  validateObjectId(id);
  const category = id.slice(0, 4);
  const filename = `content/sheafpedia/${category}/${id}.typ`;
  const source = `#import "../../sheafpedia-template.typ": *

#encyclopedia(
  name: [#${JSON.stringify(name)}],
  introduction: [],
  base: [],
  definition: [在这里填写定义或构造.],

  // 布尔性质: true / false / none. none 表示尚未记录.
  smooth: none,
  proper: none,
  separated: none,
  finite-type: none,
  extra-properties: (:),
  properties: [],

  // 数值可为 0, 负数或小数. 含公式的值请放在 invariants 中.
  dimension: none,
  numerical-invariants: (:),
  invariants: (:),
  invariant-notes: [],
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
    console.log(`已创建 ${filename}; 保存后自动加入 sheafpedia.`);
  } catch (error) {
    console.error(error.code === 'EEXIST' ? '对象文件已存在, 未覆盖.' : error.message);
    process.exitCode = 1;
  }
}
