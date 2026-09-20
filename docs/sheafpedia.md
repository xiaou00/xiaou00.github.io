# sheafpedia 写作说明

入口为主导航的 `sheafpedia`, 地址为 `/sheafpedia/`. 每个对象独立编译为 HTML + MathML, 共用现有的图表字体和编译缓存.

## 新建对象

```sh
npm run new:object -- Schm0001 "对象名称"
npm run dev
```

命令创建 `content/sheafpedia/Schm/Schm0001.typ`, 不覆盖已有文件. 对象名称在 `name` 参数里修改, 名称可包含行内公式. 文件名决定编号和网址, 更改名称不改变网址.

| 目录和编号前缀 | 大类 |
| --- | --- |
| `Schm` | 概形 |
| `Stck` | 叠 |
| `Drvd` | 导出概形与导出叠 |
| `Spct` | 谱预层对象 |
| `Ring` | 环和代数 |

每类独立使用 `0001` 到 `9999` 的四位编号. 文件名应为 `Schm0001.typ` 等, 必须位于对应类别目录的直接下级, 不嵌套目录. 编号不会因新增或删除条目自动重排. 对象网址例如 `/sheafpedia/Schm0001/`, 部署子目录时自动加上 `site.base`.

下划线或点开头的文件与目录作为草稿, 不进入目录, 检索和公开源文件. 五个分类目录已建好; `content/sheafpedia/Schm/_example.typ` 是参数写法示例, 不占用正式编号.

环和代数使用相同的模板和参数, 例如 `npm run new:object -- Ring0001 "环或代数名称"`, 创建 `content/sheafpedia/Ring/Ring0001.typ`. 引用写作 `#object-ref("Ring0001")`.

## 模板

每个文件导入模板并调用一次 `encyclopedia`, 无需再写 `#show: note`:

```typst
#import "../../sheafpedia-template.typ": *

#encyclopedia(
  name: [对象 $X$],
  aliases: ("Another name",),
  introduction: [简要介绍这个对象.],
  base: [说明基域, 基底或相对态射, 以下性质在此约定下理解.],
  definition: [
    写下对象的定义或构造.
  ],

  smooth: none,
  proper: none,
  dimension: none,

  extra-properties: (:),
  properties: [
    这里写性质的适用条件, 证明或参考资料.
  ],
  numerical-invariants: (:),
  invariants: (
    "某个群": [$G$],
    "某个环": [$R$],
  ),
  invariant-notes: [说明不变量的计算方法和约定.],
)
```

`name` 和 `definition` 必填. `name` 使用行内内容, 可以有公式; `introduction`, `base`, `definition`, `properties`, `invariant-notes` 接收 Typst 内容块 `[...]`. `aliases` 为字符串数组, 用于检索. 其他参数均可省略.

模板生成三个固定栏目: 定义与构造, 基本性质, 不变量. 未记录时给出提示; 简介和基底约定为空时不显示. 内容参数中可以继续使用普通公式, `theorem`, `proof`, `fold`, `web-diagram` 等现有环境, 也可以添加 `==` 小节.

## 布尔性质

以下参数直接填入 `encyclopedia(...)`. **`true` 表示是, `false` 表示否, `none` 或不填写表示未记录.** 不适用或尚不能判断时保留 `none`, 并在 `properties` 中说明. 程序不从已有参数推断其他性质.

| 参数 | 显示名称 |
| --- | --- |
| `smooth` | 光滑 |
| `proper` | 紧合 |
| `separated` | 分离 |
| `quasi-compact` | 拟紧 |
| `quasi-separated` | 拟分离 |
| `finite-type` | 有限型 |
| `finite-presentation` | 有限表示 |
| `affine` | 仿射 |
| `projective` | 射影 |
| `reduced` | 约化 |
| `irreducible` | 既约 |
| `integral` | 整 |
| `normal` | 正规 |
| `regular` | 正则 |
| `noetherian` | Noether |
| `connected` | 连通 |

例如以下只演示语法, 取值需按具体对象填写:

```typst
smooth: true,
proper: false,
separated: none,
extra-properties: (
  "Cohen-Macaulay": true,
  "自定义性质": none,
),
```

页面只列出明确填写的 `true` 和 `false`, 并提示未列出的性质尚未记录. 自定义性质与内置性质一样可以检索. 字典键是页面显示名, 不能重复已有显示名; 值必须是布尔值或 `none`, 不接受字符串 `"true"`.

光滑, 紧合等性质往往依赖指定的态射或基底, 在 `base` 中统一写明, 附加条件写在 `properties` 中. 这里是作者填写的性质档案, 不验证数学结论或各性质之间的逻辑相容性.

## 数值及其他不变量

| 参数 | 显示名称 |
| --- | --- |
| `dimension` | 维数 |
| `genus` | 亏格 |
| `degree` | 次数 |
| `euler-characteristic` | Euler 示性数 |
| `picard-number` | Picard 数 |

这些参数接受有限的整数或小数, 也接受 `none`. `0` 与负数会原样保留. 自定义数值放在 `numerical-invariants` 字典中, 参与数值范围筛选:

```typst
dimension: 0,
euler-characteristic: -2,
numerical-invariants: (
  "某个秩": 3,
),
```

上述取值仅演示语法. 依赖参数的表达式, 无穷值, 群, 环, 分次对象等放在 **`invariants` 字典**中, 值可为任意 Typst 内容:

```typst
invariants: (
  "相对维数": [$n$],
  "Picard 群": [$ZZ$],
  "上同调": [$H^*(X)$],
),
invariant-notes: [在这里继续说明计算过程.],
```

内容不变量参与关键词搜索, 不参与数值范围筛选. 结构化数值与内容字典分开填写, 避免把公式误当成可比较的数.

可用参数及中文名称集中在 `content/sheafpedia-schema.json`. 拼错内置参数, 写错类型, 重复自定义名称或使用无穷数值都会给出构建错误.

## 浏览与检索

目录按 `Schm`, `Stck`, `Drvd`, `Spct`, `Ring` 分组, 同类按编号升序排列. 支持:

- 关键词: 编号, 类别, 名称, 别名与正文. 空格分隔多个关键词时需要同时匹配, 英文不区分大小写.
- 类别筛选.
- 一项布尔性质及其值: 是, 否, 未记录. 未记录不会与否混淆.
- 一项数值不变量的最小值和最大值, 包含端点. 选中数值不变量后, 未填写该数值的对象不匹配. 空的边界表示不限.

不同筛选条件同时生效. 自定义的性质和数值名称会自动加入选项. 查询保存在网址参数中; 从对象页的返回链接返回, 或刷新页面, 会保留筛选. 清除筛选恢复全部对象. 无 JavaScript 时可以按类别浏览并打开所有对象, 折叠环境也仍可展开.

对象页保留章节目录, 源文件下载, 打印和反向引用. 页底的上一个 / 下一个按同类的编号顺序生成, 不受当前检索结果影响.

## 引用

文稿和百科对象都可以引用对象, 自动链接文字包含编号和名称:

```typst
#object-ref("Schm0001")
#object-ref("Schm0001", target: <properties>)
#object-ref("Schm0001")[自定义链接文字]
```

模板提供三个固定标签: `<construction>`, `<properties>`, `<invariants>`. 自定义结论继续使用普通标签:

```typst
#theorem[结论正文.] <my-result>
```

其他文稿或对象用 `#object-ref("Schm0001", target: <my-result>)` 引用它. 本条目内部继续使用 `@my-result`.

百科引用普通笔记时, 路径从 `content/notes/` 根目录填写:

```typst
#note-ref("笔记本名/笔记标题", target: <my-theorem>)
```

支持双向引用, 每次构建自动生成引用列表和反向引用. 对象改名后自动链接文字更新, URL 不变. 删除或转为草稿后, 原有引用保留为普通文字; 将文件放回原路径, 链接自动恢复. 引用现有对象中不存在的标签会报错.

## 预览与发布

使用 `npm run dev`, 新增, 修改和删除对象都会自动更新. 修改生成器脚本后需重启已运行的预览进程. 对象的编译, 依赖跟踪, Fletcher 图形与磁盘缓存沿用笔记流程, 不需要每次重新编译所有对象.

`npm run build` 生成完整静态页面. 原有 GitHub Pages 工作流会同时发布笔记和 sheafpedia, 无需增加后端或部署步骤.
