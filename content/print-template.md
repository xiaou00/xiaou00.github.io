# 普通 Typst / PDF 模板

`print-template.typ` 是网页样式的纸面版本，`print-example.typ` 是可直接改写的完整示例，`print-example.pdf` 是效果预览。

延续网页的白底、宋体和红色点缀，纸面上使用墨黑正文 `#242424`、暖灰辅助文字 `#706c68`、暗红强调色 `#a33632`，搭配浅灰分隔线 `#d8d3cd` 和底色 `#f5f3f0`。默认 A4，Libertinus 数学字体，附独立封面、四级目录、章节页眉和页码。封面不显示页码，目录使用罗马页码，正文从 1 开始。

正文为汉字保留完整的字面高度，行距、段距、公式及数学环境的留白统一随字号缩放。标题前的间距大于标题后的间距，定理与证明正文共用左侧对齐线；目录使用浅色点线，代码使用清晰的等宽字体和单色样式。

## 使用

```typst
#import "print-template.typ": *

#show: note.with(
  title: "我的数学笔记",
  subtitle: "副标题",
  author: "xiaou0",
  date: "2026 年 9 月",
  series: "Liber 777",
  description: [封面上的简短介绍。],
)

= 章节
== 小节
=== 小小节
==== 小小小节

#definition(title: [定义名称])[
  定义正文。
] <my-definition>

参见 @my-definition。
```

从其他目录导入时，调整 `print-template.typ` 的相对路径即可。单独搬走模板时，把 `abbrev.typ` 一并放在模板旁边。

## 可选配置

在 `note.with(...)` 中设置：

| 参数 | 默认值 | 作用 |
| --- | --- | --- |
| `cover` | `true` | 显示封面 |
| `contents` | `true` | 显示目录 |
| `toc-depth` | `4` | 目录显示到第几级 |
| `chapter-break` | `true` | 章节另起一页；短文可设为 `false` |
| `running-title` | 自动使用标题 | 页眉使用的短标题 |
| `edition` | `none` | 封面底部的版本文字 |
| `size` | `11pt` | 正文字号 |
| `font` | 思源宋体及西文后备字体 | 正文字体，可以传字符串或字体名称数组 |
| `math-font` | Libertinus Math 等 | 数学字体及后备字体 |

保留网页中的 `definition`、`axiom`、`theorem`、`lemma`、`proposition`、`corollary`、`example`、`remark`、`question`、`proof`、`proofsketch`、`answer`、`fold`、`web-diagram`、`diagram-row`，以及 `abbrev.typ` 的数学缩写。各类数学环境独立连续编号；例、注、问题不编号。`fold` 在纸面上完整展开，`web-diagram` 直接排版传入的矢量图形。

篇内引用用 `@标签`，外部文章用 `#link("文章网址")[链接文字]`。网页专用的 `note-ref`、`object-ref` 不参与 PDF 的链接解析。Fletcher、CeTZ 等绘图库按正文需要自行导入。

也支持 `#exercise[练习正文]`, `#construction[构造正文]` 和 `#claim[断言正文]`, 分别显示为 "练习", "构造" 和 "断言", 各自独立编号, 支持 `title: [...]` 及标签引用. `#answer[解答正文]` 显示为不编号的 "解答", 沿用证明样式.

## 编译

使用 Typst 0.15.1 或更新版本。安装思源宋体及 Libertinus Math 后，在本目录运行：

```sh
typst compile print-example.typ print-example.pdf
```

字体名称以 `typst fonts` 为准。当前博客构建缓存包含网页使用的字体，也可以直接复用：

```sh
typst compile --font-path ../.build/typst-fonts print-example.typ print-example.pdf
```

如果系统字体数量很多，可以加 `--ignore-system-fonts`，只加载 `--font-path` 指定的字体与 Typst 内置字体。

模板使用 Typst 原生的 [目录](https://typst.app/docs/reference/model/outline/)、[数学环境计数与引用](https://typst.app/docs/reference/model/figure/) 和 [页面布局](https://typst.app/docs/reference/layout/page/)，无需网页构建即可导出 PDF。
