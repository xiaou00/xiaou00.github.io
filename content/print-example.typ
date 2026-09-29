#import "print-template.typ": *

#show: note.with(
  title: "结构与联系",
  subtitle: "数学笔记 · 排版示例",
  author: "xiaou0",
  date: "2026 年 9 月",
  series: "Liber 777",
  description: [关于数学的笔记、片段与思考。于抽象之中，寻找结构与联系。],
  edition: "数学手稿 / 01",
)

= 生象与映射 <chap-animation>

数学的叙述由定义开始，经由例子建立直觉，再在证明中确认结构之间的联系。
这份手稿延续网页的白底、黑字与宋体排版，以细灰线区分数学环境，并用少量_红色_标记强调和引用。

== 生象的截断 <sec-truncation>

#definition(title: [$n$-截断])[
  一个生象 $K in Ani$ 称为 *$n$-截断的*，是指对每个基点 $x in K$，都有
  $ pi_i(K, x) = 0, quad i > n. $
] <def-truncated>

定义中的符号与网页保持一致。正文中的公式，例如 $Map_(cal(C))(X,Y)$，
随文字自然排列；独立公式则保留足够的上下间距。

=== 低阶情形 <sec-low-degree>

低阶对象给出最直接的例子，也使抽象定义与熟悉的数学语言相衔接。

#example(title: [集合与群胚])[
  $0$-截断的生象可以视为集合，$1$-截断的生象可以视为群胚对应的 $1$-型。
]

==== 基点与约定 <sec-conventions>

这里使用四级标题组织内容。每一级标题都会出现在目录中，目录条目和正文引用都可以点击。
例如，@def-truncated 指向本章的定义，@sec-truncation 指向所在的小节。

#remark[
  对数学术语使用 *粗体*，对需要提醒读者的文字使用_强调_。
  数学环境沿用网页中的独立计数方式。
]

== 路径与循环空间

#lemma(title: [循环空间的同伦群])[
  设 $K$ 是带基点 $x$ 的生象，则对 $i >= 0$，有
  $ pi_i(Omega_x K) simeq pi_(i+1)(K,x). $
] <lem-loop>

#proof[
  循环空间的定义给出带基点映射空间的伴随关系
  $ Map_*(S^i, Omega_x K) simeq Map_*(S^(i+1), K). $
  对两侧取连通分支即得所述对应。
]

= 数学陈述与论证 <chap-statements>

正文保留宽松的行距和段落间距。定理使用与网页相同的细灰色左边线，
证明则使用较轻的标题与结束方框。页眉给出手稿标题和当前章节，页脚记录页码。

== 定义、命题与定理

#definition(title: [终对象])[
  设 $cal(C)$ 为 $oo$-范畴。对象 $bold(1) in cal(C)$ 称为终对象，若对任意 $X in cal(C)$，都有
  $ Map_(cal(C))(X, bold(1)) simeq *. $
] <def-terminal>

#proposition[
  若一个范畴具有终对象，则任意两个终对象之间存在唯一的同构。
] <prop-terminal>

#proof[
  设 $T$ 与 $T'$ 都是终对象。由终对象的定义，分别存在唯一态射
  $f:T -> T'$ 与 $g:T' -> T$。复合 $g f$ 与 $f g$ 分别是 $T$ 与 $T'$ 的自态射，
  因而只能是恒等态射。这说明 $f$ 与 $g$ 互为逆。
]

#theorem(title: [表示对象的唯一性])[
  设 $cal(C)$ 是局部小范畴，$X,Y in cal(C)$。若存在自然同构
  $ Hom_(cal(C))(-,X) simeq Hom_(cal(C))(-,Y), $
  则 $X$ 与 $Y$ 同构。
] <thm-representable>

#proofsketch[
  由 Yoneda 引理，自然同构及其逆分别对应态射 $X -> Y$ 与 $Y -> X$。
  自然变换的复合对应态射的复合，因此两个态射互为逆。
]

#corollary[
  一个可表示函子的表示对象在同构意义下唯一。
]

== 公式与引用

斜线分式写作 $a/b$；上下分式写作 $frac(a,b)$。需要交叉引用的公式可以单独编号：

#math.equation(block: true, numbering: "(1)")[
  $ Hom_(cal(C))(X,Y) simeq "Nat"(Hom_(cal(C))(-,X), Hom_(cal(C))(-,Y)) $
] <eq-yoneda>

由 @eq-yoneda 可得 @thm-representable。脚注用于补充说明，避免打断叙述。#footnote[本示例用于展示版式；可以替换全部正文，保留开头的模板导入与配置。]

= 写作与整理 <chap-writing>

== 列表与表格

一篇手稿通常包括以下几类内容：

+ 对象与基本定义。
+ 典型例子与必要的约定。
+ 结构性命题及其证明。

#table(
  columns: (1fr, 1fr, 1.5fr),
  table.header([层级], [写法], [目录编号]),
  [章节], [`= 标题`], [1],
  [小节], [`== 标题`], [1.1],
  [小小节], [`=== 标题`], [1.1.1],
  [小小小节], [`==== 标题`], [1.1.1.1],
)

== 引文与补充说明

#quote(block: true)[
  于抽象之中，寻找结构与联系。
]

#fold(title: [补充说明])[
  PDF 中的折叠内容会完整展开。这样，屏幕上的补充推导在纸面上仍然可读，
  也可以保留公式、列表和多段论证。
]

#question[
  如何从具体例子中辨认一个定义所刻画的共同结构？
]

#answer[
  先写出例子之间保留的映射，再比较这些映射满足的泛性质。
]

== 开始新的手稿

复制本文件，修改开头的标题、作者和日期，再替换正文。
模板保留熟悉的 `#definition`、`#theorem`、`#proof` 等写法。

```typst
#import "print-template.typ": *
#show: note.with(title: "我的数学笔记", author: "xiaou0")
= 第一章
== 第一节
=== 一个专题
==== 约定
#definition(title: [定义名称])[在这里写定义。]
```
