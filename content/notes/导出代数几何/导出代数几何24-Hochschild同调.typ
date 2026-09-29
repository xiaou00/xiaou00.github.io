#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= Hochschild 理论的基本动机

我们自然可以记
$ dAff_k = (aCAlg_k)^opp $
为导出仿射概形的范畴, 之后我们会统一定义导出概形和导出叠. 显然在这里, 我们有
$ Spec A dtimes_(Spec S) Spec B simeq Spec (A dtens_S B) $


== 导出自交

假若 $X = Spec A$ 是一个导出概形, 考虑对角线
$ Delta : X -> X dtimes_(Spec k) X $
并研究其与自身的导出自交
$ X dtimes_(X dtimes_(Spec k) X) X $
事实上, 微分信息在足够好的条件下可以通过导出自交恢复出来: 若设 $A$ 是光滑的 $k$-代数, 那么

#lemma[
  若生象代数 $A/k$ 光滑, 则有自然同构
  $ Tor^(A times.o_k A)_bullet (A,A) simeq Omega^bullet_(A/k) $
]

= Hochschild 同调

== 初步定义

固定一个生象交换环 $k$, 令 $(X,x)$ 是一个基点的生象, 在 $x$ 的取值给出一个拉回映射
$ x^* : aCAlg_k^X -> aCAlg_k $
其中
$ aCAlg_k^X = Fun(X,aCAlg_k) $
由于 $aCAlg^X_k$ 中的极限逐点计算, $x^*$ 与极限交换, 故存在左伴随
$ x_!:aCAlg_k -> aCAlg^X_k, quad x_! tack.l x^* $
一般称之为 "带有 $Omega_x X$-作用的自由生象 $k$-代数".

#definition(title:[Hochschild 同调])[
  固定一个点 $x in B S^1$, 令
  $ Hoch(-/k) : aCAlg_k -> aCAlg^(B S^1)_k $
  为函子
  $ x^* :aCAlg_k^(B S^1) -> aCAlg $
  的左伴随, 其在 $A$ 处的取值 $Hoch(A/k)$ 称之为 $R$ 之于 $k$ 的 *Hochschild 同调*, 这是一个带 $S^1$-作用的交换生象 $k$-代数.
]

显然, Hochschild 同调在等价意义下不依赖于 $x$ 的具体选取.

由构造, Hochschild 同调满足泛性质: 若 $R$ 是生象交换 $k$-代数且 $S$ 是 $S^1$-作用的生象交换 $k$-代数, 则有自然等价
$ Map_(aCAlg_k) (R,S) simeq Map_(aCAlg_k^(B S^1)) (Hoch(R/k),S) $
换句话说, 对于下图表

#web-diagram(diagram({
	node((0, 0), [$R$])
	node((1, 0), [$S$])
	node((0, 1), [$"HH"(R/k)$])
	edge((0, 0), (0, 1), "->")
	edge((0, 0), (1, 0), "->")
	edge((0, 1), (1, 0), "-->")
}))

其中竖向箭头是伴随余单位, 那么存在唯一的虚线箭头使得图表交换.

== 余幂

我们先从集合的直觉开始, 设 $cal(C)$ 是有任意余积的 1-范畴, 给定 $S$ 和 $X in cal(C)$, 定义
$ S dot.o X := product.co_(s in S) X $
也就是给 $X$ 取 $S$ 份余积, 例如
$ {1,2,3} dot.o X simeq X cop X cop X $
其泛性质是
$ Hom_(cal(C))(S dot.o X,Y) simeq Hom_Set (S,Hom_(cal(C))(X,Y)) $

#definition(title:[余幂])[
  设 $cal(C)$ 是 $oo$-范畴, $K in Ani$, $X in cal(C)$, (若存在) 定义
  $ K dot.o X := colim_K X $
  右边是常值函子 $K->cal(C), k|->X$.
]

他满足的泛性质是
$ Map_(cal(C))(K dot.o X,Y) simeq Map_Ani (K,Map_(cal(C))(X,Y)) $
也就是说, 函子
$ - dot.o X : Ani -> cal(C) $
左伴随于
$ Map_(cal(C))(X,-) : cal(C) -> Ani $
若满足这个泛性质的构造 $dot.o$ 对每个 $C in cal(C)$ 和 $X in Ani$ 都存在, 则称 *$cal(C)$ 被 $Ani$ 张量*.

#remark[
  我们知道, 对可呈示的 $oo$-范畴 $cal(C)$, 有
  $ Fun^"L" (Ani,cal(C)) simeq cal(C) $
  只需要指定 $F(*)$ 且给定 $X in cal(C)$, 唯一的保持极限的函子
  $ F_X : Ani -> cal(C) $
  满足 $F_X (*) = X$, 从而可以定义
  $ K dot.o X = F_X (K) $
  可以将余幂看成是典范的作用
  $ Ani times cal(C) -> cal(C) $
  因此可呈示 $oo$-范畴总存在余幂.
]

== 圆张量

#lemma[
  若 $cal(C)$ 是可呈示 $oo$-范畴, 且 $C in cal(C)$, 则函子
  $ (-) dot.o C : Ani -> cal(C) $
  是左 Kan 延拓
  #web-diagram(diagram({
	node((0, 0), [$*$])
	node((1, 0), [$cal(C)$])
	node((0, 1), [$Ani$])
	edge((0, 0), (1, 0), [$C$], label-side: left, "->")
	edge((0, 0), (0, 1), "->")
	edge((0, 1), (1, 0), [$(-) dot.o C$], label-side: right, "->")
  }))
]

#proof[
  显然这个函子保持极限, 且 $Ani$ 由 $*$ 与余极限自由生成.
]

#theorem(title:[圆张量])[
  Hochschild 同调可以由圆张量计算, 即
  $ Hoch(R/k) simeq S^1 dot.o R in aCAlg_k^(S_1) $
]

#proof[
  由定义, $Hoch(R/k)$ 显然是左 Kan 延拓
  #web-diagram(diagram({
	node((0, 0), [$*$])
	node((1, 0), [$aCAlg_k$])
	node((0, 1), [$B S^1$])
	edge((0, 0), (1, 0), [$R$], label-side: left, "->")
	edge((0, 0), (0, 1), [$x$], label-side: right, "->")
	edge((0, 1), (1, 0), [$"HH"(R/k)$], label-side: right, "->")
  }))
  以及切片 $oo$-范畴 $* arrow.b B S^1$ 等价于 $Omega B S^1 simeq S^1$, 从而我们可以在点 $x in B S^1$ 处由左 Kan 延拓来计算 $Hoch(R/k)-> B S^1-> aCAlg_k$, 即
  $ colim_(x->x "于" B S^1) R simeq colim_(Omega B S^1) R simeq colim_(S^1) R simeq S^1 dot.o R $
]

#remark(title:[单位映射])[
  伴随
  $ Hoch(-/k) : aCAlg_k arrows.lr aCAlg^(B S^1)_k : x^* $
  的单位给出
  $ R -> x^* Hoch(R/k) $
  在 $Hoch(R/k) simeq S^1 dot.o$ 的描述下, 就是基点嵌入
  $ x:*->S^1 $
  诱导的
  $ R simeq * dot.o R -> S^1 dot.o R $
  这个映射一般不是 $S^1$-等变的.
]

#remark(title:[坍缩映射])[
  另一个方向来自
  $ p:S^1->* $
  诱导的
  $ S^1 dot.o R -> * dot.o R simeq R $
  即
  $ Hoch(R/k) -> R $
  精确地说, 他是在 $aCAlg^(B S^1)_k$ 中的映射
  $ Hoch(R/k) -> p^* R $
  这个映射显然是 $S^1$-等变的.
]

#proposition[
  作为生象交换环有
  $ Hoch(R/k) simeq R times.o_(R times.o_k R) R $
  其中 $R$ 通过乘法映射视作 $R times.o_k R$-代数.
] <prop-HH-tensor>

#proof[
  首先, 余幂保持极限, 故将下图左边的图表传递成右边的图表
  #web-diagram(diagram({
	node((0, 0), [$S^0$])
	node((1, 0), [$*$])
	node((0, 1), [$*$])
	node((1, 1), [$S^1$])
	node((2, 0), [$S^0 dot.o R$])
	node((2, 1), [$* dot.o R$])
	node((3, 0), [$* dot.o R$])
	node((3, 1), [$S^1 dot.o R$])
	edge((0, 0), (0, 1), "->")
	edge((0, 0), (1, 0), "->")
	edge((1, 0), (1, 1), "->")
	edge((0, 1), (1, 1), "->")
	edge((2, 0), (3, 0), "->")
	edge((3, 0), (3, 1), "->")
	edge((2, 0), (2, 1), "->")
	edge((2, 1), (3, 1), "->")
  }))
  这又等价于方形
  #web-diagram(diagram({
	node((0, 0), [$R times.o_k R$])
	node((0, 1), [$R$])
	node((1, 0), [$R$])
	node((1, 1), [$"HH"(R/k)$])
	edge((0, 0), (1, 0), "->")
	edge((1, 0), (1, 1), "->")
	edge((0, 0), (0, 1), "->")
	edge((0, 1), (1, 1), "->")
  }))
]

= Hochschild 同调基础性质

== 保持极限

#proposition[
  函子
  $ Hoch(-/k) : aCAlg_k -> aCAlg^(B S^1)_k $
  保持极限.
]

#proposition[
  函子
  $ Hoch(-/k) : aCAlg_k -> aMod^(B S^1)_k $
  保持筛余极限.
]

== Künneth 公式

由于该函子保持筛余极限, 从而保持推出, 即

#proposition(title:[Künneth 公式])[
  对于 $R,S in aCAlg_k$, 有
  $ Hoch(R times.o_k S/k) simeq Hoch(R/k) times.o_k Hoch(S/k) $
]

== 基变换公式

#proposition(title:[基变换公式])[
  对于 $R,S in aCAlg_k$, 有
  $ Hoch(R/k) times.o_k S simeq Hoch(R times.o_k S/S) $
]

== 坍缩还原公式

#proposition[
  若 $k->R->S$ 是连续的生象环映射, 则
  $ Hoch(S/k) times.o_(Hoch(R/k)) R simeq Hoch(S/R) $
]

== 一些例子

#example(title:[自由生象环])[
  设 $R simeq LSym_k (M)$, 则
  $ Hoch(R/k) simeq S^1 dot.o R simeq S^1 dot.o LSym_k (M) simeq LSym_k (S^1 dot.o M) $
  由 @prop-HH-tensor 同款论证即得推出方形
  #web-diagram(diagram({
	node((-1, -1), [$M plus.o M$])
	node((-1, 0), [$M$])
	node((0, -1), [$M$])
	node((0, 0), [$S^1 dot.o M$])
	edge((-1, -1), (-1, 0), "->")
	edge((-1, 0), (0, 0), "->")
	edge((-1, -1), (0, -1), "->")
	edge((0, -1), (0, 0), "->")
  }))
  也就是说 $S^1 dot.o M simeq M plus.o Sigma M simeq M plus.o M[1]$, 代回计算
  $ Hoch(R/k) simeq LSym_k (M) times.o_k LSym_k (M[1]) simeq LSym_k (R times.o_k M[1]) simeq LSym_k (LL_(R/k)[1]) $
]
