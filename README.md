# Liber 777

个人数学 writings 网站. 以 `cover.png` 和 `参考/template.typ` 中的象牙白, 石灰色, 深红与四芒星为视觉基础.

页面文字统一使用本地加载的思源宋体, 数学公式使用 Libertinus Math. 阅读页左侧目录在桌面为 160px, 较窄屏幕为 140px, 手机上移至正文上方.

直接写 **Typst**, 构建时调用真正的 Typst 编译器, 输出 **HTML + 原生 MathML**. 笔记正文随 HTML 一起生成, 不需要前端框架, 也不依赖 KaTeX, MathJax 或浏览器里的 WASM 编译器.

## 启动

需要 **Node.js 22+** 和 **Typst 0.15.1+**. 本项目在 Node.js 26.8.2, Typst 0.15.1 上验证.

```sh
npm install
npm run dev
```

打开 <http://127.0.0.1:5173>. 保存笔记, 模板, CSS 或站点配置后, 会自动重建并刷新浏览器. 笔记之间的链接标题和反向引用会一起更新. 编译失败会在预览中显示具体诊断, 同时保留上次成功的页面; 修复后自动恢复. 开发预览写入 `.build/dev/`, 正式构建写入 `dist/`, 可以同时运行.

```sh
npm run dev -- --host 0.0.0.0 --port 5173  # 需要局域网访问时
npm run build                            # 生成 dist/
npm run preview                          # 构建并预览静态站点
```

如果 Typst 不在 PATH 中, 可以设置 `TYPST_BIN=/absolute/path/to/typst`.

## 写一篇笔记

```sh
npm run new:note -- "代数/我的数学笔记"
```

打开生成的 `content/notes/代数/我的数学笔记.typ` 即可开始写作. **文件名就是笔记标题(不含 `.typ`), 文件夹就是笔记本, 文件夹名就是笔记本名.** 每个 `.typ` 文件对应一篇独立笔记和一个独立网址, 无需在正文中重复填写标题或笔记本名称. 公共模板 `content/template.typ` 是写作工具, 不作为笔记发布.

```typst
#import "../../template.typ": *

#show: note

= 第一个主题 <first-section>

这里可以写中文与行内公式 $a^2 + b^2 = c^2$.

#definition(title: "某个定义")[
  定义的正文.
] <my-definition>

#theorem(title: "某个定理")[
  定理的正文.
] <my-theorem>

#proof[
  使用 @my-definition 给出论证.
]

== 进一步讨论

通过 @my-theorem 引用定理.

$ sum_(n=1)^infinity 1/n^2 = pi^2/6 $
```

### 按笔记本浏览

主页直接展示 `content/notes/` 中的实际目录. 文件夹显示为同名笔记本, 默认收起, 点击展开或折叠; 每个文件只显示一份笔记标题, 点击即可阅读. 搜索支持笔记本名, 文件路径, 标题和正文, 命中嵌套文件时会自动展开所在目录; 清除搜索后恢复之前的展开状态.

新建文件夹就是新建笔记本, 在里面添加 `.typ` 文件就是添加笔记, 也可以用命令一次完成:

```sh
npm run new:note -- "代数/局部环"
npm run new:note -- "分析/实分析/极限"
```

例如, 目录和页面一一对应:

```text
content/notes/
  算术几何/                 笔记本名: 算术几何
    算术几何笔记.typ         标题: 算术几何笔记
    理想与除子.typ           标题: 理想与除子
  写作/                     笔记本名: 写作
    数学写作与排版.typ       标题: 数学写作与排版
```

- 子目录递归生成页面, 支持嵌套笔记本. 同名笔记可以放在不同文件夹中, 完整路径决定唯一网址, 例如 `/notes/算术几何/理想与除子/`.
- 改文件名即可改标题, 改文件夹名即可改笔记本名, 保存后自动更新目录和阅读页. 链接文字与反向引用也会随新路径重新生成; 文件路径变化时需同步修改指向它的 `#note-ref`.
- 删除文件后, 预览会自动移除目录项, 笔记页面和公开源文件; 空笔记本也会消失. 删除整个笔记本同样生效, 无需手动清理构建目录.
- 目录中先列文件夹, 再列文件, 按名称自然排序. 不需要日期, 标签, 类型或排序编号.
- 临时草稿请使用 `_draft.typ`, `_drafts/` 或以 `.` 开头的文件和文件夹, 它们不会进入页面和公开源文件目录. 空目录不显示.
- 路径支持中文和英文字母, 数字, 空格, 点, 下划线和连字符, 使用 `/` 分隔文件夹. `new:note` 会自动创建父目录, 不会覆盖已有文件.
- 每篇独立导入模板并声明一次 `#show: note`, 然后直接写正文. 新建命令自动按目录深度写入正确的模板导入路径. 手动移动文件到不同深度后, 需要相应修改 `#import` 的相对路径.

### 笔记之间互相引用

引用另一篇笔记, 文件扩展名 `.typ` 可以省略. 默认从 `content/notes/` 根目录查找. 链接文字自动使用对方的标题, 不需要手写网址:

```typst
#note-ref("算术几何/理想与除子.typ")
#note-ref("算术几何/算术几何笔记")
```

子目录中的笔记可以使用完整路径, 或用 `./` 和 `../` 相对于当前笔记引用:

```typst
#note-ref("算术几何/理想与除子.typ")  // 从 notes/ 根目录查找
#note-ref("./理想与除子.typ")         // 当前笔记本
#note-ref("../随笔.typ")             // 上一级文件夹
```

也可以自定义链接文字, 或直接跳到另一篇笔记的章节, 定义, 定理等带标签的位置:

```typst
#note-ref("算术几何/理想与除子.typ")[理想与除子的笔记]
#note-ref("算术几何/理想与除子.typ", target: <dvr-dedekind>)
#note-ref("写作/数学写作与排版.typ", target: <thm-ideals>)[非零理想的结构定理]
```

在目标笔记中, 用普通 Typst 标签标记位置即可:

```typst
= DVR 与 Dedekind 整环 <dvr-dedekind>

#theorem(title: "非零理想的结构")[
  定理正文.
] <thm-ideals>
```

章节和定理标签即使没有在本篇中使用 `@label` 引用, 也会保留为网页锚点. 本篇内部继续使用 `@label`; 跨篇使用 `#note-ref(...)`.

阅读页底部自动生成 **本文引用** 和 **引用本文**. 同一篇笔记被多次引用只列一次, 也支持 A 引用 B, B 再引用 A. 不需要为了建立链接而 `#include` 或 `#import` 对方的正文.

所有笔记先独立编译, 再统一解析引用. 被引用文件删除或转为草稿后, 对它的引用保留为普通文字, 自动链接文字使用文件名; 不再生成可点击链接或反向引用, 也不会阻止其他笔记更新. 原始 `.typ` 中的引用保持原样, 将文件放回原路径后, 链接会自动恢复. 文件改名后, 可以修改 `#note-ref` 的路径重新建立链接.

无效引用路径, 现有笔记中不存在的目标标签和 Typst 语法错误仍会给出诊断, 并保留上次成功的页面. 正式静态站点需重新构建并部署后同步删除.

### 本篇的章节, 定理和公式

一篇笔记内部直接使用 `= 标题`, `== 小节` 组织正文, 不再使用章节文件拼接成另一篇笔记. 每篇有独立的章节和定理编号.

模板提供与参考文件相近的接口:

`definition`,`theorem`,`lemma`,`proposition`,`corollary`,`axiom`,`example`,`remark`,`question`,`proof`,`proofsketch`,`answer`.

前六种环境由 Typst 原生计数器编号, 可以使用 `<label>` 和 `@label` 交叉引用; 例, 注和问题不编号. 章节目录从编译后的 HTML 标题生成, 既保留原生引用锚点, 也为未被引用的标题补全链接.

定义, 定理等环境的标题直接接首段正文, 例如 "定义 1 (链复形) 固定一个...". 后续段落, 行间公式和列表仍独立排版; 以公式或列表开头时, 标题单独成行.

公式直接生成 `<math>` 元素, 由浏览器渲染. 较宽的公式和表格可以独立横向滚动, 避免把手机页面撑宽. 阅读页还提供目录跟随, 阅读进度, 源文件下载和浏览器打印.

数学上下划线直接使用 Typst 的原写法, 无需额外包裹:

```typst
$underline(Hom)(X, Y)^n$
$ overline(x + y) = overline(x) + overline(y) $
$ overline(underline(x/y)) $
```

模板为 Typst 0.15 尚未导出的 `math.underline` 和 `math.overline` 补充原生 MathML, 横线随内容宽度伸缩, 支持嵌套及上下标. 文本中的 `#underline[文字]` 和 `#overline[文字]` 仍使用原生文本装饰.

### 图表及 HTML 导出边界

Fletcher 交换图和 CeTZ 绘图使用 `#web-diagram(...)` 包裹. 它通过 Typst 的 [`html.frame`](https://typst.app/docs/reference/html/frame/) 将图形导出为内嵌 SVG, 图形外的公式仍是 MathML. `web-diagram` 与 Fletcher 的 `diagram` 名称不同, 可以安全地使用 `: *` 导入.

```typst
#import "@preview/fletcher:0.5.8": *

#web-diagram(diagram({
  node((0, 0), $A$)
  node((1, 0), $B$)
  node((0, 1), $C$)
  node((1, 1), $D$)
  edge((0, 0), (1, 0), "->", $f$)
  edge((0, 0), (0, 1), "->", $g$)
  edge((1, 0), (1, 1), "->", $h$)
  edge((0, 1), (1, 1), "->", $k$)
}), caption: [一个交换方块]) <square>

在 @square 中, 交换性写作 $h compose f = k compose g$.
```

图形默认居中, 宽图可独立横向滚动, 不需要在外面再写 `#align(center, ...)`. `caption` 可省略, 也可以用 `<label>` 和 `@label` 引用带标题的图. 页面保留 SVG 的原始比例, 缩放后箭头与标签仍然清晰.

### 交换图与编译缓存

保持 `npm run dev` 运行即可, `#web-diagram(...)` 的写法不变. 预览为每篇笔记保留一个 Typst 增量编译进程, 复用函数计算及图形布局缓存. 首次打开笔记需要编译, 随后只改正文时, 未变化的 Fletcher/CeTZ 图形会复用计算结果. 修改图形, 引用的变量或公共模板时, Typst 按实际依赖更新. 停止预览会释放这些进程和内存缓存, 下次启动重新预热.

针对 Typst 0.15.1 的 UTF-8 增量解析问题, 特定中文替换和编译期间的连续保存会自动重启受影响的编译进程, 避免错误文字进入页面和磁盘缓存.

整篇笔记的 HTML + MathML + SVG 还会保存到 `.build/typst-cache/`. `npm run build` 根据 Typst 报告的源文件, 导入文件和图片等实际依赖检查内容哈希, 未变化时直接复用; 编译参数, Typst 版本或日期变化也会使缓存失效. GitHub Actions 会保存并恢复这份缓存和 Typst 包缓存. 缓存不会进入网站或公开源文件目录.

更改网页样式和首页配置时, 正文无需重新编译. 文件目录, 跨篇链接及反向引用仍会重新生成, 删除笔记也会正常同步. 模板检查直接读取导出的标记, 不再额外编译一次. 终端会显示命中缓存, 增量编译和首次编译的笔记数量.

需要强制重新编译正式站点时运行:

```sh
npm run build -- --no-cache
```

### HTML 导出边界

Typst 的 HTML 导出目前仍是实验性功能; 0.15 起提供原生 MathML.`page`,`place`, PDF 页眉页脚等布局规则不能直接等价转换成网页, 需要通过网页模板或 `html.frame` 适配. 参见 [HTML 官方文档](https://typst.app/docs/reference/html/) 和 [0.15 更新说明](https://typst.app/docs/changelog/0.15.0/).

`content/template.typ` 是网页模板,`参考/template.typ` 是原始纸面模板, 二者没有互相覆盖. 参考入口还引用了当前目录中未提供的 `references.bib` 和 `math-alphanumeric.csl`, 因此这里没有假定参考文件可以直接完整编译.

## 当前文稿

- **算术几何笔记** (`算术几何/算术几何笔记.typ`): 学习主题索引, 链接到其他独立笔记.
- **理想与除子** (`算术几何/理想与除子.typ`): 独立笔记, 保留 DVR 与 Dedekind 整环提纲.

## 目录

```text
cover.png                  原始主页封面
site.config.mjs            站名, 作者, 简介, 部署根路径
content/
  template.typ             网页写作模板
  notes/**/*.typ           按实际文件夹组织, 每个文件都是一篇独立笔记
src/
  render.mjs               首页, 阅读页和 404 模板
  style.css                纸面主题与响应式样式
  client.js                文件搜索, 文件夹展开, 目录及阅读进度
scripts/
  build.mjs                Typst 编译与静态页面生成
  typst-compiler.mjs        常驻增量编译, 依赖检查和磁盘缓存
  note-links.mjs           跨笔记链接解析与反向引用
  note-paths.mjs           从路径读取标题和笔记本, 递归发现文件, 路径解析和网址编码
  serve.mjs                预览, 文件监听和错误反馈
  new-note.mjs             新建文稿
public/fonts/              本地字体及许可证
参考/                      原始参考文件
dist/                      构建产物, 可以整体部署
```

## 部署与验证

### GitHub Pages

已提供自动部署工作流 `.github/workflows/pages.yml`. GitHub Actions 安装 Node.js 22 和 Typst 0.15.1, 执行 `npm ci` 和 `npm run build`, 然后发布 `dist/`. 无需提交构建产物, 也无需单独创建 `gh-pages` 分支或填写个人访问令牌.

当前仓库为 `xiaou00/xiaou00.github.io`, 对应站点地址 <https://xiaou00.github.io/>. `site.config.mjs` 已设置 `url: 'https://xiaou00.github.io'` 和 `base: '/'`.

首次部署:

1. 打开 [仓库 Pages 设置](https://github.com/xiaou00/xiaou00.github.io/settings/pages), 在 **Build and deployment > Source** 选择 **GitHub Actions**. 免费 GitHub 账户需要使用公开仓库.
2. 将当前使用的 `master` 设置为仓库默认分支. 工作流支持 `master` 和 `main`, 仅从默认分支部署; 若以后改名为 `main`, 在 GitHub 中同步修改默认分支.
3. 提交并推送部署配置:

   ```sh
   git add .github/workflows/pages.yml site.config.mjs README.md
   git commit -m "Configure GitHub Pages deployment"
   git push -u origin master
   ```

4. 打开仓库 **Actions**, 等待 **Deploy to GitHub Pages** 中的 `build` 和 `deploy` 都成功, 然后访问 <https://xiaou00.github.io/>. 也可以在该工作流页面选择 **Run workflow** 手动触发.

以后把笔记的新增, 修改或删除提交并推送到默认分支, 网站就会自动更新. 仅在本地保存会更新本地预览, 发布需要推送到 GitHub. 如果构建失败, 在 Actions 的失败步骤查看 Typst 诊断; 上一次部署的网站仍然保留.

设置步骤参见 [GitHub Pages 官方文档](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

### 其他静态托管与本地验证

执行 `npm ci && npm run build`, 把 `dist/` 部署到任意支持目录 `index.html` 的静态服务. 构建环境必须安装 Typst; 线上服务器只需托管静态文件. 将 `404.html` 配置为自定义错误页即可; 无需 SPA 路由回退.

部署到子目录(例如 GitHub Pages 项目路径)时, 将 `site.config.mjs` 中的 `base` 改成 `/repository-name/`, 重新构建. 填写 `url` 后会生成 canonical URL.

`dist/sources/` 包含公开的 `content/` 内容, 便于访问者下载原文; 每篇笔记依赖公共模板, 跨笔记链接则由网站构建器统一解析.

```sh
npm test                   # 实际编译, 文件发现, 路径解析, MathML 与引用检查
npm run test:browser        # Chromium: 笔记本, 搜索, 中文路径, 改名, 手机, 无 JS 和自动编译
```

浏览器测试默认使用 `/usr/bin/chromium`. 其他路径可设置 `CHROMIUM_PATH`. 测试会短暂新建使用随机名称的相互引用的笔记, 并在结束后清理.
