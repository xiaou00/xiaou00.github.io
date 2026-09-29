#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 截断

== 生象的截断

#definition(title:[$n$-截断])[
  一个生象 $K in Ani$ 称之为 $n$-截断的, 是指对每个基点 $x in K$, 都有
  $ pi_i (K,x) = 0, quad i > n $
]

在低阶情况下, 我们一般作约定:

+ $-2$-截断的生象是 $*$.
+ $-1$-截断的生象是 $nothing, *$.
+ $0$-截断的生象是集合.
+ $1$-截断的生象是群胚对应的 1-型.

#definition(title:[$n$-截断对象])[
  设 $cal(C)$ 是任意 $oo$-范畴, 定义 $X in cal(C)$ 为 *$n$-截断的*, 若对任意 $T in cal(C)$, $Map_(cal(C))(T,X)$ 是 $n$-截断的生象.
]

== 态射的截断

#definition(title:[$n$-截断态射])[
  在 $oo$-范畴 $cal(C)$ 中给定 $f:X->Y$, 若其作为 $cal(C)_(\/Y)$ 中的对象是 $n$-截断的, 则称之为 *$n$-截断态射*.
]

等价地, 对任意 $T->Y$, 上述条件在说
$ Map_(cal(C)_(\/Y)) (T,X) $
是 $n$-截断的生象.

#proposition[$X$ 是 $n$-截断对象当且仅当 $X->bold(1)$ 是 $n$-截断态射, 当终对象存在时成立.]

== 对角线判据

#lemma[
  设 $K$ 是生象, $n>=0$, 则 $K$ 是 $n$-截断的当且仅当对任意 $x,y in K$, $Map_K (x,y)$ 是 $(n-1)$-截断的.
]

#proof[
  若 $x,y$ 不在同一连通分支则 $Map_K (x,y)=nothing$, 是 $(n-1)$-截断的. 若其在同一分支, 则任选路径 $p:x->y$, 路径拼接给出等价
  $ Map_K (x,y) simeq Omega_x K $
  而
  $ pi_i (Omega_x K) simeq pi_(i+1)(K,x) $
  从而 $Omega_x K$ 是 $(n-1)$-截断.
]

#corollary(title:[对角线判据])[
  设 $cal(C)$ 是 $oo$-范畴, $f:X->Y$ 是其中的态射, 则 $f$ 是 $n$-截断的当且仅当
  $ Delta_f : X -> X times_Y X $
  是 $(n-1)$-截断的.
]

== 截断函子与塔

下设 $n>=-2$. $cal(C)_(<=n)$ 是
$ cal(C)_(<=n) := {X in cal(C) | X "是" n"-截断的"} $
张成的全子范畴.

#definition(title:[截断函子])[
  若 $cal(C) in PrL$ 可呈示, 则嵌入函子
  $ i_n : cal(C)_(<=n) arrow.hook cal(C) $
  有左伴随
  $ tau_(<=n) :cal(C) arrows.lr cal(C)_(<=n): i_n, quad tau_(<=n) tack.l i_n $
]

#proof[
  取一小族生成元 $cal(G) subset cal(C)$. 由于 $cal(C)$ 可呈示
  $ cal(C) times.o Ani simeq cal(C) $
  从而对 $K in Ani$ 和 $A in cal(C)$ 可取
  $ K times.o A in cal(C) $
  满足
  $ Map_(cal(C))(K times.o A,X) simeq Map_Ani (K,Map_(cal(C))(A,X)) $
  现在对每个 $G in cal(G)$ 考虑
  $ S^(n+1) times.o G -> G $
  这些态射组成小集合 $S_n$, 而 $X$ 对这些态射局部当且仅当
  $ Map(G,X) -> Map(S^(n+1) times.o G,X) $
  是等价, 而
  $ Map(S^(n+1) times.o G,X) simeq Map(S^(n+1),Map(G,X)) $
  所以条件变成
  $ Map(G,X) ->^~ Map(S^(n+1),Map(G,X)) $
  是等价当且仅当 $K$ 是 $n$-截断的, 从而 $X$ 是 $S_n$ 局部的当且仅当 $Map(G,X)$ 是 $n$-截断的, 对任意 $G in cal(G)$. 由于 $cal(G)$ 生成 $cal(C)$, 我们证明了 $cal(C)_(<=n) simeq cal(C)_(S_n"-loc")$. 由小正交类引理, $cal(C)_(<=n)$ 可及且 $i_n$ 是可及嵌入, 容易验证其对极限封闭, 由伴随函子定理即证.
]

截断函子可以由泛性质刻画, 对任意 $n$-截断的 $Y$ 都有
$ Map(tau_(<=)X,Y) simeq Map(X,Y) $
由于任何 $oo$-意象都是可呈示的, 从而总有截断
$ tau_(<=n) : cal(X) -> cal(X)_(<=n) $

#proposition[
  $tau_(<=n)$ 保持有限极限.
]

#corollary[
  $cal(X)_(<=n)$ 是 $cal(X)$ 的子意象.
]

显然, 若 $m<=n$, 则 $cal(X)_(<=m) subset cal(X)_(<=n)$, 并且
$ tau_(<=m) tau_(<=n) simeq tau_(<=m) $

#definition(title:[Postnikov 塔])[
  设 $cal(X)$ 是 $oo$-意象, $X in cal(X)$, 有塔
  $ bold(1) = tau_(<=-2) X <- tau_(<=-1) X <- tau_(<=0) X <- ... <- tau_(<=n) X <- ... <- X $
]

#remark[
  注意, 自然的映射
  $ X -> varprojlim(n) tau_(<=n) X $
  不一定是等价, 对于 $oo$-意象来说, 满足这一等价的条件称之为*超完备性*, 若有余裕将会介绍.
]

= 连通

== 生象的连通

#definition(title:[$n$-连通])[
  一个生象 $K in Ani$ 称之为 $n$-连通的, 是指
  $ tau_(<=n) K simeq * $
  当 $n>=0$ 时, 等价地, $K$ 连通且对每个基点 $x in K$, 都有
  $ pi_i (K,x) = 0, quad i<=n $
]

在低阶情况下, 我们一般作约定:

+ $-2$-连通的生象是任意生象.
+ $-1$-连通的生象是非空生象.
+ $0$-连通的生象是连通生象.
+ $1$-连通的生象是单连通生象.

#definition(title:[$n$-连通对象])[
  设 $cal(C)$ 是具有终对象的 $oo$-范畴, 定义 $X in cal(C)$ 为 *$n$-连通的*, 若对任意 $n$-截断对象 $T in cal(C)$, $Map_(cal(C))(T,X)$ 是 $n$-连通的生象.
]

当 $n$-截断函子存在时, 等价地,
$ tau_(<=n) X simeq bold(1) $

== 态射的连通

#definition(title:[$n$-连通态射])[
  在 $oo$-范畴 $cal(C)$ 中给定 $f:X->Y$, 若其作为 $cal(C)_(\/Y)$ 中的对象是 $n$-连通的, 则称之为 *$n$-连通态射*.
]

#theorem(title:[单-满刻画])[
  我们有:

  + 一个态射称之为有效满的当且仅当其为 $(-1)$-连通的.
  + 一个态射称之为单的当且仅当其为 $(-1)$-截断的.
]

#proposition[
  显然连通性和截断性都在拉回下保持.
]

== 连通-截断分解系统

#definition(title:[相对截断])[
  设 $cal(X)$ 是 $oo$-意象, 给定态射 $f:X->Y$, 因为 $cal(X)_(\/Y)$ 也是 $oo$-意象, 可以作其截断
  $ X -> tau^Y_(<=n) X -> Y $
  其中 $tau^Y_(<=n) X -> Y$ 是 $n$-截断的.
]

#theorem(title:[连通-截断分解])[
  设 $cal(X)$ 是 $oo$-意象, 记
  $ "Conn"_n = {f : f "是" n"-连通的"}\
    "Trnc"_n = {f : f "是" n"-截断的"} $
  则 $("Conn"_n,"Trnc"_n)$ 构成 $cal(X)$ 上的正交分解系统, 也就是说, 每个 $f:X->Y$ 都能典范分解为
  $ X larr^e tau^Y_(<=n)X larr^p Y $
  其中 $e$ 是 $n$-连通, $p$ 是 $n$-截断. 并且提升问题
  #web-diagram(diagram({
	node((-1, -1), [$A$])
	node((-1, 0), [$B$])
	node((0, -1), [$X$])
	node((0, 0), [$Y$])
	edge((-1, -1), (-1, 0), [$e$], label-side: right, "->")
	edge((-1, 0), (0, 0), "->")
	edge((0, -1), (0, 0), [$p$], label-side: left, "->")
	edge((-1, -1), (0, -1), "->")
	edge((-1, 0), (0, -1), [$exists!$], label-side: center, "-->")
  }))
  有可缩意义下的唯一解.
]

#proof[
  先翻译条件:
  $ f in "Trnc"_n <=> X in (cal(X)_(\/Y))_(<=n) \
    f in "Conn"_n <=> tau^Y_(<=n) X simeq Y $
  显然分解是存在的, 只需取
  $ X larr^e tau^Y_(<=n)X larr^p Y $
  这一典范的构造. 由定义 $p in "Trnc"_n$, 而局部化的单位
  $ X -> tau^Y_(<=n)X $
  是 $n$-连通的, 这是因为在切片 $cal(X)_(\/tau^Y_(<=n)X)$ 中有
  $ tau_(<n)^(tau^Y_(<=n)X)X simeq tau^Y_(<n)X $
  从而 $e in "Conn"_n$.

  现在证明正交性, 考虑上面同款交换方块, 沿着 $B->Y$ 拉回 $p$ 得到
  $ q : E := B times_Y X -> B $
  $n$-截断在拉回下保持, 从而 $E$ 是切片 $cal(X)_(\/B)$ 下的 $n$-截断对象. 原交换方形等价于一个切片中的态射
  $ A -> E $
  而 $e:A->B$ 是 $n$-连通, 从而
  $ tau^B_(<=n)A simeq B $
  因为 $E$ 是 $n$-截断的, 截断的泛性质给出
  $ Map_(\/B)(B,E) &simeq Map_(\/B)(tau^B_(<=n)A,E)\
  &simeq Map_(\/B)(A,E) $
  因此每个 $A->E$ 都对应唯一可缩的 $B->E$, 恰是原方形的 $B->X$.
]

= 超完备化

我们简要介绍一下超完备化的理论.

#definition(title:[$oo$-连通 / 超完备])[
  设 $cal(X)$ 是 $oo$-意象, 一个态射 $f:X->Y$ 称之为 *$oo$-连通的*, 是指对任意 $n$ 都 $n$-连通.

  称之为 *$oo$-截断的*或*超完备*, 若其右正交于 $oo$-连通的态射类.
]

记 $cal(X)_(<=oo)$ 为 $cal(X)$ 中超完备张成的全子范畴.

#theorem(title:[超完备化])[
  设 $cal(X)$ 是 $oo$-意象, 则:

  + 包含 $cal(X)_(<=oo)->cal(X)$ 存在左伴随 $tau_(<=oo):cal(X)->cal(X)_(<=oo)$.
  + $oo$-连通和 $oo$-截断的态射构成正交分解系统.
]

