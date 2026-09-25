#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本篇将详略得当地概述一遍 Higher Topos 的理论.

= 层

== 预层

预层是我们对几何和 Yoneda 理论认知的开端.

#definition(title:[预层])[
  设 $cal(C)$ 是一个小的 $oo$-范畴, 定义
  $ PShv(cal(C)) := Fun(cal(C)^opp,Ani) $
  为*预层范畴*, 其中的元素为*预层* (presheaf).
]

这个定义和经典定义的唯一区别就是 $Ani$ 和 $Set$ 的区别, 我们可以通过预复合 $pi_0$, 即
$ cal(C)^opp -> Ani larr^(pi_0) Set $ 
来得到一个经典的预层. 我们知道有 Yoneda 嵌入
$ yo : cal(C) arrow.hook PShv(cal(C)), quad U |-> h_U := Map(-,U) $
在代数几何的语境下, 通常称这样的函子为*点函子* (functor of points), 其背后原理就是 Yoneda 嵌入. 这样的一个预层称之为*可表预层* (representable presheaf).

== 景与 $oo$-景

在下降理论中, 我们讨论过景的定义, 我们使用筛的语言可以非常精巧地描述这一现象:

#definition(title:[筛])[
  设 $cal(C)$ 是一个 1-范畴, $U in cal(C)$, 一个 $U$ 上的*筛* (sieve) 是指预层 $h_U = Hom(-,U)$ 的一个子预层
  $ R arrow.hook h_U $
]

#remark[
  我们可以典范地将一个筛视作所有以 $U$ 为终点的一族态射
  $ {f:V->U} $
  满足若 $f:V->U in R$, 那么对任意 $g:W->V$, 复合 $f compose g:W->U$ 仍然属于 $R$, 也就是一族对预复合封闭的族.
]

显然对于态射 $f:U->V$, 我们可以定义预层的拉回

#web-diagram(diagram({
	node((0, -1), [$f^*R$])
	node((1, -1), [$R$])
	node((0, 0), [$h_V$])
	node((1, 0), [$h_U$])
	edge((0, -1), (1, -1), "->")
	edge((1, -1), (1, 0), "hook->")
	edge((0, -1), (0, 0), "->")
	edge((0, 0), (1, 0), [$h_f$], label-side: right, "->")
}))

也就是说
$ f^*R = {g:W->V | f compose g in R} $
显然 $U$ 上的最大的筛就是可表筛 $h_U$.

#definition(title:[景])[
  一个*景* (site) 是一个范畴 $cal(C)$ 配备 *Grothendieck 拓扑* $J$, 为每个 $U in cal(C)$ 都指定了一族筛 $J(U)$, 满足:

  + $h_U in J(U)$.
  + 对任何 $R in J(U)$ 和 $f:V->U$, $f^*R in J(V)$.
  + 对 $R in J(U)$, $S$ 是 $U$ 上任意筛, 若对每个 $f:V->U$ 都有 $f^*S in J(V)$, 则 $S in J(U)$.

  这样的一个筛 $R in J(U)$ 称为 $U$ 的一个*覆盖筛*.
]

对于 $oo$-的情况, 其实也没有更高阶的结构, 定义如下

#definition(title:[$oo$-景])[
  一个 $oo$-范畴 $cal(C)$ 被称为 *$oo$-景*是指指定了 $"h"cal(C)$ 上的 Grothendieck 拓扑 $J$.
]

== 层

设 $F in PShv(cal(C))$, 即 $F:cal(C)^opp -> Ani$, 对于一个筛 $R arrow.hook h_U$, 其中 $U in "h"cal(C)$, 由 $oo$-Yoneda 引理, 有等价
$ Map(h_U,F) simeq F(U) $
并且有 $i:R->h_U$ 诱导的比较态射 $Map(i,F)$ 确定为
#web-diagram(diagram({
	node((1, -1), [$h_U$])
	node((0, -1), [$R$])
	node((1, 0), [$"Map"(h_U,F)$])
	node((0, 0), [$"Map"(R,F)$])
	edge((0, -1), (1, -1), [$i$], label-side: left, "->")
	edge((1, -1), (1, 0), "|->")
	edge((0, -1), (0, 0), "|->")
	edge((1, 0), (0, 0), [$"Map"(i,F)$], label-side: left, "->")
}))

#definition(title:[层])[
  设 $F in PShv(cal(C))$, 若对任意覆盖筛 $i:R->h_U$, 诱导的
  $ Map(i,F) : F(U) ->^~ Map(R,F) $
  是等价, 则称之为一个*层* (sheaf).
]

记 $Shv(cal(C);J) subset PShv(cal(C))$ 为 $J$-层构成的 $oo$-范畴, 这个定义显然覆盖经典的层论和叠论, 例如其 0-截断
$ F : cal(C)^opp -> Ani larr^(tau_(<=0)) Set $
给出了经典的层条件, 而 1-截断
$ F : cal(C)^opp -> Ani larr^(tau_(<=1)) Grpd $
给出了经典的叠条件.

= 层化

== 反射局部化

#definition(title:[反射局部化])[
  若 $oo$-伴随对
  $ L : cal(C) arrows.lr cal(D) : i, quad L tack.l i $
  且 $i$ 是全忠实的, 则称之为一个*反射局部化*.
]

嵌入 $i:Shv(cal(C);J)->PShv(cal(C))$ 显然是全忠实的. 我们想找出一个合理的反射局部化使得 $Shv(cal(C))$ 构成一个反射子范畴, 经典的层论启示我们这是可行的, 事实也如此:

== 层化的存在性

#lemma[
  $PShv(cal(C))$ 是可呈示的.
]

#proof[平凡. 觉得这个难的自己去看定义. (它甚至是自由余完备化)]

#lemma[
  
]
