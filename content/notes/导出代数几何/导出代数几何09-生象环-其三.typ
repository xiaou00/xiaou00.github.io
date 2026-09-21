#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 为任意交换环.

= 生象环的局部化

== 单个元素的局部化

#definition(title:[对单个元素的局部化])[
  设 $A in AniCAlg_k$, $f in pi_0 (A)$, 那么我们可以定义
  $ A[f^(-1)] := A dtens_(k[t]) k[t,t^(-1)] $
  其中 $k[t]->A, t |-> f$. 称之为*局部化* (localization).
]

类似地, 我们可以定义模的情形

#definition(title:[模的单元素局部化])[
  取 $M in Mod_A$, 我们定义
  $ M[f^(-1)] := A[f^(-1)] dtens_A M $
]

显然这个定义与前面的兼容.

#proposition(title:[局部化的望远镜结构])[
  作为 $A$-模, 有典范等价
  $ A[f^(-1)] tilde.eq varinjlim("") (A->^(dot f) A->^(dot f) A->^(dot f)...) $
  这个构造称之为*局部化望远镜* (localization telescope).
]

#proof[
  我们知道作为 $k[t]$-模有
  $ k[t,t^(-1)] tilde.eq varinjlim("") (k[t]->^(dot t) k[t]->^(dot t) k[t]->^(dot t)...) $
  由于 $A times.o_(k[t]) (-)$ 是左伴随, 有
  $
  A[f^(-1)] &tilde.eq A times.o_(k[t]) k[t,t^(-1)] \
  &tilde.eq A times.o_(k[t]) varinjlim("") (k[t]->^(dot t) k[t]->^(dot t) k[t]->^(dot t)...) \
  &tilde.eq varinjlim("") (A times.o_(k[t]) k[t]->^(dot t) A times.o_(k[t]) k[t]->^(dot t) A times.o_(k[t]) k[t]->^(dot t)...) \
  &tilde.eq varinjlim("") (A->^(dot f) A->^(dot f) A->^(dot f)...)
  $
]

#corollary[
  类似地, 对于一般的模也有
  $ M[f^(-1)] tilde.eq varinjlim("") (M ->^(dot f) M ->^(dot f) M ->^(dot f) ...) $
]

#proposition[
  总有
  $ pi_n (A[f^(-1)]) tilde.eq pi_n (A) [f^(-1)] $
  后面将 $pi_n (A)$ 看作 $pi_0 A$-模.
]

#proof[
  只需识别到
  $ pi_n (A[f^(-1)]) &tilde.eq pi_n (varinjlim("") (A->^(dot f) A->^(dot f) A->^(dot f)...)) \
  &tilde.eq varinjlim("") (pi_n (A) ->^(dot f) pi_n (A) ->^(dot f)...) \
  &tilde.eq pi_n (A)[f^(-1)] $
]

== 乘性集的局部化

#definition(title:[对乘性集的局部化])[
  若 $S subset pi_0 A$ 是乘性子集, 则定义 $A[S^(-1)]$ 为满足全体 $s in S$ 都在 $pi_0 B$ 中变成单位的始 $A$-代数, 形式地, 我们可以定义
  $ A[S^(-1)] = colim_(s in S) A[s^(-1)] $
]

#proposition[
  对于同样的假设有
  $ pi_n (A[S^(-1)]) tilde.eq S^(-1) pi_n (A) $
]

= 生象环的商

== 对一个元素的商

在生象环的语境下, 商的定义比较微妙.

#definition(title:[导出商])[
  给定 $A in AniCAlg_k$ 以及 $f in pi_0 A$, 我们定义*导出商* (derived quotient) 为
  $ A /\/ f  := A dtens_(k[t]) k $
  其中 $t|->f$, 而 $k[t]->k$ 将 $t$ 送到 $0$.
]

也就是说, 导出商是下列图表

#web-diagram(diagram({
	node((-1, 0), [$k[t]$])
	node((0, 0), [$A$])
	node((-1, 1), [$k$])
	node((0, 1), [$A\/\/f$])
	edge((-1, 0), (0, 0), [$t|-> f$], label-side: left, "->")
	edge((-1, 0), (-1, 1), [$t|-> 0$], label-side: right, "->")
	edge((-1, 1), (0, 1), "->")
	edge((0, 0), (0, 1), "->")
}))

的推出, 也就是说, 导出商是 "自由地施加 $f=0$ 这一关系" 的结构.

#proposition[
  作为底层 $A$-模, 有
  $ A /\/ f tilde.eq cofib(A ->^(dot f) A) $
]

#proof[
  由基础代数学可构造出纤维序列
  $ k[t] ->^(dot t) k[t] -> k $
  也就是说
  $ k tilde.eq cofib(k[t]->^(dot t)k[t]) $
  沿着 $k[t]->A$ 做基变换, 基变换保持纤维序列, 证毕.
]

#corollary[
  设 $A$ 是普通交换环, 那么 $pi_1 (A/\/f) tilde.eq Ann_A (f)$.
]
