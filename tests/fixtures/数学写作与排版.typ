#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": *

#show: note

数学写作的形式应当服务于思想. 这是一份网页排版示例, 展示公式, 定义, 证明与交叉引用如何自然地出现在阅读之中.

= 从一个定义开始 <valuation>

一个合适的定义, 往往能将看似不同的对象放在同一视野之下. 我们以离散赋值为例.

#definition(title: "离散赋值")[
  设 $K$ 为域. 一个满射 $v: K^times arrow.twohead ZZ$ 称为_离散赋值_, 如果对任意 $x, y in K^times$, 有

  $ v(x y) = v(x) + v(y), $

  且在 $x + y != 0$ 时满足

  $ v(x + y) >= min { v(x), v(y) }. $

  约定 $v(0) = infinity$, 便可把赋值延拓到整个 $K$.
] <def-valuation>

由 @def-valuation, 可以构造赋值环及其极大理想:

$ R = {x in K | v(x) >= 0}, quad
  frak(m) = {x in K | v(x) > 0}. $

== 一个熟悉的例子 <example>

#example(title: "有理数域上的 p 进赋值")[
  固定素数 $p$. 每个非零有理数都可以唯一地写成

  $ x = p^n a/b, quad n in ZZ, quad p divides.not a, quad p divides.not b, $

  其中 $a, b$ 是互素的整数且 $b > 0$. 令 $v_p (x) = n$, 就得到 $QQ$ 上的离散赋值.
  相应的赋值环是局部化 $ZZ_((p))$.
]

= 定理与证明 <theorems>

选取一个满足 $v(pi) = 1$ 的元素 $pi$, 称为_一致化参数_. 它控制了赋值环中所有非零元素的形状.

#proposition(title: "元素的分解")[
  每个非零元素 $x in R$ 都可以唯一地写成

  $ x = u pi^n, quad u in R^times, quad n in ZZ_(>=0). $
] <prop-factorization>

#proof[
  令 $n = v(x)$, 并设 $u = x pi^(-n)$. 则 $v(u) = 0$, 所以 $u$ 和 $u^(-1)$ 都属于 $R$, 即 $u$ 为单位.

  若 $u pi^n = u' pi^(n')$, 两边取赋值得到 $n = n'$, 进而得到 $u = u'$.
]

#theorem(title: "非零理想的结构")[
  $R$ 的每个非零理想 $I$ 都有形式 $I = (pi^n)$, 其中 $n$ 是唯一的非负整数.
] <thm-ideals>

#proof[
  非空集合 $\{v(x) : x in I, x != 0\}$ 是非负整数集的子集, 因此存在最小元 $n$.
  取 $x in I$ 使得 $v(x) = n$. 由 @prop-factorization, $x = u pi^n$, 故 $pi^n in I$.

  另一方面, 对每个非零 $y in I$, 有 $v(y) >= n$, 从而 $y/pi^n in R$. 因此 $I = (pi^n)$.
  指数的唯一性来自理想中非零元素赋值的最小值.
]

#remark[
  @thm-ideals 将理想的包含关系转化为整数的大小关系:
  $ (pi^m) subset.eq (pi^n) quad arrow.l.r quad m >= n. $
]

= 把结构写清楚 <structure>

== 公式与表格 <formulas>

行间公式保留自己的呼吸空间, 行内公式则融入句子. 例如 $R/frak(m)$ 是剩余域, 而 $K$ 是 $R$ 的分式域.

#table(
  columns: 3,
  table.header([对象], [记号], [描述]),
  [赋值环], $R$, [非负赋值的元素],
  [极大理想], $frak(m) = (pi)$, [正赋值的元素],
  [剩余域], $k = R/frak(m)$, [模去极大理想],
)

== 斜线与分式 <math-slashes-heading>

#html.elem("div", attrs: (id: "math-slashes"))[
  行内 $A/B$, $A \/ B$ 与 $(a + b)/c$.

  $ Omega^1_(A/k) $
  $ ZZ / p ZZ $

  显式分式 $frac(a, b)$.

  $ frac(a/b, c/d) $
]

== 大运算符与多行公式 <math-operators-heading>

#html.elem("div", attrs: (id: "math-operators"))[
  $ A = plus.o.big_(n in ZZ) A^n $
  $ S = sum_(n=0)^infinity a_n $
  $ P = product_(n=1)^N a_n $
  $ sum_(n=0)^infinity a_n = a_0 + a_1 + a_2 + a_3 + a_4 + a_5 + a_6 + a_7 + a_8 + a_9 + a_10 + a_11 + a_12 $
  $ A &= plus.o.big_(n in ZZ) A^n \
    B &= plus.o.big_(n in ZZ) B^n $
]

== 上下划线 <math-lines-heading>

#html.elem("div", attrs: (id: "math-lines"))[
  行内 $underline(Hom)(X, Y)^n$, $overline(x + y)^2$ 与 $overline(i + j)$.

  $ underline(Hom)(X, Y)^n = underline(x + y + z) $
  $ overline(x + y + z) = overline(underline(frac(x, y))) $
  $ underline(overline(x + y)) + underline(underline(x + y)) $
  $ A_(underline(Hom)) + overline(overline(x + y)) $

  文本 #underline[下划线] 和 #overline[上划线].
]

== 写作约定 <conventions>

- 首次出现的术语给出定义, 再在后文用交叉引用连接.
- 证明独立成段, 以方框结束.
- 每个 `.typ` 文件对应一篇笔记, 使用 `#note-ref` 连接不同笔记.

== 笔记之间的联系 <note-links>

相关主题的提纲整理在 #note-ref("../算术几何/理想与除子.typ").
跨笔记引用可以指向整篇文稿, 也可以指向其中的小节, 例如
#note-ref("../算术几何/理想与除子.typ", target: <dvr-dedekind>).

#quote(block: true)[
  留下足够的空白, 让论证本身成为页面的中心.
]

== 交换图 <diagrams>

#web-diagram(diagram({
  node((0, 0), $overline(A)$)
  node((1, 0), $B$)
  node((0, 1), $C$)
  node((1, 1), $D$)
  edge((0, 0), (1, 0), "->", $f$)
  edge((0, 0), (0, 1), "->", $g$)
  edge((1, 0), (1, 1), "->", $h$)
  edge((0, 1), (1, 1), "->", $k$)
}), caption: [一个交换方块]) <commutative-square>

如 @commutative-square 所示, 交换性写作 $h compose f = k compose g$.

#web-diagram(diagram(spacing: 4em, {
  for i in range(9) {
    node((i, 0), $A_i$)
    if i > 0 { edge((i - 1, 0), (i, 0), "->", $d_(i - 1)$) }
  }
})) <long-diagram>
