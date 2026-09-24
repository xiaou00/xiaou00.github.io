#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

下面固定 $k$ 为生象交换环.

= 障碍理论引入

== 提升的障碍

现在假设我们有一个无穷小的加厚 $p:tilde(S)->S$, 和一个映射 $f:R->S$. 一个基本的问题是: $f in Map(R,S)$ 能否提升成某个 $tilde(f) in Map(R,tilde(S))$?

#definition(title:[提升空间])[
  继承上述假设, 定义 $f$ 的*提升空间* (lifting space) 为
  $ Lift_p (f) := fib_f (Map(R,tilde(S)) -> Map(R,S)) $
  因此 $Lift_p (f) != nothing$ 等价于其可以提升.
]

上述定义也就是下图中使得图表交换的虚线态射的空间

#web-diagram(diagram({
  node((0, 1), [$R$])
  node((1, 0), [$tilde(S)$])
  node((1, 1), [$S$])
  edge((1, 0), (1, 1), "->")
  edge((0, 1), (1, 1), "->", [$f$], label-side: right)
  edge((0, 1), (1, 0), "-->")
}))

所谓*障碍类* (obstruction class), 就是从提升问题构造一个元素
$ o_p (f) $
使得 $Lift_p (f) != nothing => o_p (f) = 0$. 若反之也成立, 则称之为一个*完备障碍类*. 显示地, 我们可以直接定义

#definition(title:[障碍空间 / 障碍谱])[
  设 $p:tilde(S)->S$ 是平方零扩张, $f:R->S$ 是映射, 定义*障碍空间* (obstruction space) 为
  $ cal(O)_p (f) := Map_R (LL_(R/k),M[1]) in Ani $
  也可以作显然的障碍谱
  $ underline(Map)_R (LL_(R/k,M[1])) in Sp $
  若无歧义二者用同一个记号.
]

通常我们选取障碍类, 就是在 $cal(O)_p (f)$ 中选取一个元素, 具体实现为
$ pi_0 cal(O)_p (f) = pi_0 Map_R (LL_(R/k),M[1]) simeq Ext^1_R (LL_(R/k),M) $
这也是为什么我们说 $Ext^1$ 分类障碍.

== 平方零扩张的分类

#question[
  $Map(S,M[1])$ 究竟蕴含什么信息?
]

在稳定 $oo$-范畴中, 一个纤维序列
$ M -> E -> S $
可以视作 $S$ 以 $M$ 为纤维的一个模扩张. 那他自动延长为
$ M -> E -> S ->^partial M[1] $
反之, 给定任意
$ partial : S -> M[1] $
定义
$ E_partial = fib(partial) $
那么有
$ M -> E_partial ->S ->^partial M[1] $
从而
$ { S "的以" M "为纤维的模扩张" } simeq Map(S,M[1]) $

回顾一个平方零扩张, 其构成群胚 $SqExt_k (S,M)$, 由定义, 显然固定 $S,M$ 后平方零扩张完全由导子 $d:S->S plus.o M[1]$ 决定. 不难验证
$ SqExt_k (S,M) simeq Der_k (S,M[1]) $
而导子又被余切复形表示, 于是就有了如下的结论:

#proposition[
  有平方零扩张的完全分类
  $ Theta_(S,M) : SqExt_k (S,M) -->^~ Map_(S) (LL_(S/k),M[1]) $
]

这也印证了前面定义的 $cal(O)_p (f)$ 的合法性, 即一个障碍类
$ [o_p (f)] in pi_0 cal(O)_p (f) $
恰好对应一个平方零扩张.

设 $f:R->S$, 以及 $p:tilde(S)->S$ 是关于 $M in Mod_S$ 的平方零扩张, 一般我们记其分类导子为
$ eta_p = Theta_(S,M) (p) : LL_(S/k) -> M[1] $
于是我们可以定义
$ tilde(o)_p (f) = Map_S (S times.o_R LL_(R/k), M[1]) $
为复合
$ S times.o_R LL_(R/k) -->^(d f) LL_(S/k) -->^(eta_p) M[1] $
由伴随可以对应到
$ o_p (f) in pi_0 Map_R (LL_(R/k),f^* M[1]) $
精确描述如下:

#lemma(title:[拉回平方零扩张])[
  固定 $f:R->S$ 和平方零扩张 $p:tilde(S)->S$, 作拉回平方零扩张
  #web-diagram(diagram({
	node((-1, -1), [$tilde(R)$])
	node((-1, 0), [$R$])
	node((0, -1), [$tilde(S)$])
	node((0, 0), [$S$])
	edge((0, -1), (0, 0), [$p$], label-side: left, "->")
	edge((-1, 0), (0, 0), [$f$], label-side: right, "->")
	edge((-1, -1), (-1, 0), [$p_f$], label-side: right, "->")
	edge((-1, -1), (0, -1), "->")
  }))
  则 $p_f:tilde(R)->R$ 是关于 $f^* M$ 的平方零扩张.
]

#proof[
  考虑合并的拉回方形
  #web-diagram(diagram({
	node((-1, -1), [$tilde(S)$])
	node((0, -1), [$S$])
	node((-1, 0), [$S$])
	node((0, 0), [$S plus.o M[1]$])
	node((0, -2), [$R$])
	node((-1, -2), [$tilde(R)$])
	edge((0, -1), (0, 0), [$0$], label-side: left, "->")
	edge((-1, 0), (0, 0), [$d$], label-side: right, "->")
	edge((-1, -1), (-1, 0), "->")
	edge((-1, -1), (0, -1), [$p$], label-side: right, "->")
	edge((0, -2), (0, -1), [$f$], label-side: left, "->")
	edge((-1, -2), (0, -2), [$p_f$], label-side: left, "->")
	edge((-1, -2), (-1, -1), "->")
  }))
  即可.
]

#definition(title:[障碍类])[
  固定 $f:R->S$ 和平方零扩张 $p:tilde(S)->S$ 并拉回 $p_f:tilde(R)->R$, 定义 $f$ 关于平方零扩张 $p$ 的*障碍类*为
  $ o_p (f) = [p_f] in pi_0 SqExt_k (R,f^*M) larr^(pi_0 Theta_(R,f^*M))_~ pi_0 Map_R (LL_(R/k),f^* M[1]) $
]

#proposition[
  $Lift_p (f)!= nothing$ 当且仅当 $o_p (f) = 0$. 也就是说 $o_p (f)$ 是完备的障碍类.
]

#proof[
  设 $tilde(S)->S$ 是关于 $M in Mod_S$ 的平方零扩张, $f:R->S$, 令
  $ p_f : tilde(R) -> R $
  是沿 $f$ 的拉回平方零扩张, 由拉回泛性质, $Lift_p (f)!=nothing$ 当且仅当 $p_f$ 存在截面, 另一方面有
  $ eta_(p_f) = o_p (f) in pi_0 Map_R (LL_(R/k), f^* M[1]) $
  若一个平方零扩张 $q:E->R$ 由导子
  $ d:R->R plus.o N[1] $
  定义, 则
  $ E simeq R times_(R plus.o N[1]) R $
  两个映射是 $d$ 和零导子.  一个截面 $s:R->E$ 由拉回的泛性质恰好等价于给出一个同伦
  $ d simeq 0 $
  而
  $ [d] = eta_q in pi_0 Der_k (R,N[1]) simeq pi_0 Map_R (LL_(R/k),N[1]) $
  从而 $q$ 有截面当且仅当 $eta_q = 0$. 代回 $p_f$ 的论证即可.
]

== 形式光滑与形式平展

#definition(title:[形式光滑 / 形式平展])[
  设 $R in AniCAlg_k$ 是生象交换环的态射, 称 $R$ 是 *$k$-形式光滑* (formally smooth) 的, 是指对任意平方零扩张 $p:tilde(S)->S$ 和任意映射 $f:R->S$, $Lift_p (f)$ 都非空, 若其甚至是可缩的, 则称之为*形式平展* (formally étale).
]

#proposition(title:[形式光滑判据])[
  $R in AniCAlg_k$ 是形式光滑的当且仅当对任意 $M in AniMod_R$, 都有
  $ pi_0 Map_(AniMod_R) (LL_(R/k), M[1]) simeq 0 $
]

#proof[
  若对任意 $R$-模 $M$, $pi_0 Map_R (P,M[1])=0$, 这迫使
  $ o_p (f) in pi_0 Map_R (LL_(R/k), f^* N[1]) $
  为零, 其中 $N$ 是平方零扩张的无穷小方向. 从而 $Lift_p (f)!=0$. 反之, 设 $R$ 形式光滑. 任取 $M$, 以及任意
  $ alpha in pi_0 Map_R (LL_(R/k),M[1]) $
  而 $alpha$ 对应导子 $d$, 进而构造平方零扩张
  $ p_alpha : R_alpha -> R $
  的分类类为 $eta_(p_alpha) = alpha$. 由形式光滑性
  $ Lift_(p_alpha)(id_R) != nothing $
  这说明
  $ alpha = o_(p_alpha) (id_R) = 0 $
]

#proposition[
  $R in AniCAlg_k$ 是形式光滑的当且仅当
  $ LL_(R/k) in Mod^"proj"_R $
  即存在集合 $N$ 使得 $LL_(R/k)$ 是 $R^(plus.o N)$ 的一个收缩.
]

#proposition[
  $R in AniCAlg_k$ 是形式平展的当且仅当 $LL_(R/k) simeq 0$.
]

= Postnikov 塔中的障碍理论

== $k$-不变量

回顾生象环的 Postnikov 塔, 记
$ A_n := tau_(<=n)A $
有自然的塔
$ A -> ... -> A_n ->^(p_n) A_(n-1) -> ... -> A_0 = pi_0 A $

下面记 $Mod_R^[a,b] := Mod_R^(>=a) inter Mod_R^(<=b)$, 有引理

#lemma(title:[Small-extension 引理])[
  若 $q:B'->B$ 是生象环映射, 且纤维 $I = fib(B'->^q B)$ 满足存在 $d$ 使得
  $ I in Mod^[d,2d-1]_B, quad d>=1 $
  那么 $q$ 是一个平方零扩张.
]

#remark[
  这个引理实际上有更强的版本, 若
  $ I in Mod^[d,2d] $
  且乘法
  $ pi_d I times.o_(pi_0 B) pi_d I -> pi_(2d) I $
  为零, 那么也有同样结论. 该证明涉及相对 Hurwicz 引理
  $ tau_(<=2d+1) LL_(B/B') simeq I[1] $
  引理的证明较为复杂, 有机会我们会继续讨论.
]

#theorem(title:[Postnikov $k$-不变量定理])[
  $p_n : A_n -> A_(n-1)$ 是关于 $pi_n (A)[n]$ 的平方零扩张. 也就是说存在一个典范导子
  $ kappa_n (A) in Der_k (A_(n-1),pi_n (A)[n+1]) $
  使得有拉回
  #web-diagram(diagram({
    node((-1, -1), [$A_n$])
    node((-1, 0), [$A_(n-1)$])
    node((0, -1), [$A_(n-1)$])
    node((0, 0), [$A_(n-1) plus.o pi_n A [n+1]$])
    edge((-1, 0), (0, 0), [$kappa_n (A)$], label-side: right, "->")
    edge((0, -1), (0, 0), [$0$], label-side: left, "->")
    edge((-1, -1), (0, -1), "->")
    edge((-1, -1), (0, -1), [$p_n$], label-side: left, "->")
    edge((-1, -1), (-1, 0), "->")
  }))
  由余切复形的泛性质, 可以看作
  $ kappa_n (A) : LL_(A_(n-1)/k) -> pi_n (A) [n+1] $
  $kappa_n (A)$ 称为*第 $n$ Postnikov 不变量*.
]

#proof[
  考虑 $I_n = fib(p_n) simeq pi_n (A)[n] in Mod_A^[n,n]$, 由引理即证.
]

== 障碍类的识别

现在我们来识别这个问题中内蕴的障碍理论, 这个问题很简单. 我们知道有平方零扩张 $p_n:A_n->A_(n-1)$, 问题是 $f:R->A_(n-1)$ 是否能提升为 $tilde(f):R->A_n$ 使得整体交换. 那么我们的障碍类被选为
$ o_(p_n)(f) = [(p_n)_f] in pi_0 Map_R (LL_(R/k), f^*pi_n A [n+1] ) $
刻画 $f$ 的提升障碍, 显然有 $Lift_(p_n) (f) != nothing$ 当且仅当 $o_(p_n)(f)=0$.

= André--Quillen (上)同调论

== 余切复形表示的(上)同调论

最自然地说, André--Quillen 理论, 就是余切复形 $LL_(A/k)$ 表示的同调和上同调理论.

#definition(title:[André--Quillen 同调])[
  设 $A in AniCAlg_k$, 对任意模 $M in Mod_A$, 定义其 *André--Quillen 同调*为
  $ D_n (A/k;M) := pi_n (LL_(A/k) times.o_A M) in Mod_(pi_0 A) $
]

类似地, 可以定义上同调

#definition(title:[André--Quillen 上同调])[
  设 $A in AniCAlg_k$, 对任意模 $M in Mod_A$, 定义其 *André--Quillen 上同调*为
  $ D^n (A/k;M) := pi_(-n) underline(Map)_A (LL_(A/k),M) in Mod_(pi_0 A) $
]

显然上述可以等价地写成
$ pi_0 underline(Map)_A (LL_(A/k),M[n]) $
若其离散, 这个恰好就是
$ Ext^n_A (LL_(A/k),M) $
我们可以识别出其一些平凡的性质, 包括并不限于:

+ $D^0$ 就是普通导子, 因为 $D^0 (A/k;M) = pi_0 Map_A (L_(A/k),M) simeq pi_0 Der_k (A,M)$.
+ $D_0$ 就是 $Omega^1_(pi_0 A/pi_0 k) times.o_(pi_0 A) pi_0 M$ 就是经典 Kähler 微分带系数 $M$.
+ $D^1$ 分类平方零扩张, 因为 $D^1 (A/k;M) simeq pi_0 Der_k (A,M[1])$.

== Jacobi--Zariski 正合列

#proposition(title:[Jacobi--Zariski 同调长正合列])[
  设连续的生象环映射 $k->A->B$, 则存在长正合列
  $ ... -> D_n (A/k;M) -> D_n (B/k;M) -> D_n (B/A;M) ->^partial D_(n-1)(A/k;M) -> ... $
]

#proof[
  直接对传递三角
  $ B times.o_A LL_(A/k) -> LL_(B/k) -> LL_(B/A) $
  张量 $M$ 后取同伦群即可.
]

#proposition(title:[Jacobi--Zariski 上同调长正合列])[
  设连续的生象环映射 $k->A->B$, 则存在长正合列
  $ ... -> D^n (B/A;M) -> D^n (B/k;M) -> D^n (A/k;M) ->^partial D^(n-1)(B/A;M) -> ... $
]

二者形式上十分类似, 在离散的情况下, 前者的低阶部分是
$ D_1 (B/A;M) ->^partial Omega^1_(A/k) times.o_A M -> Omega^1_(B/k) times.o_B M -> Omega^1_(B/A) times.o_B M -> 0 $
取 $M=B$ 就得到了经典的
$ D_1 (B/A;B) -> B times.o_A Omega^1_(A/k) -> Omega^1_(B/k) -> Omega^1_(B/A) -> 0 $
这里的左边甚至被补齐了, $D_1$ 某些意义上刻画了 Kähler 微分正合列左端不再单射的缺陷部分. 而后者的低阶部分形如
$ 0 -> Der_A (B,M) -> Der_k (B,M) -> Der_k (A,M) -> D^1 (B/A,M) -> D^1 (B/k,M) -> D^1 (A/k,M) -> ... $

