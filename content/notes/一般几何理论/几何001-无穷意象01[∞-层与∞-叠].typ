#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本篇将详略得当地概述一遍经典的层论.

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

== 一些关键论证和结论

#lemma[
  $PShv(cal(C))$ 是可呈示的.
]

#proof[平凡. 觉得这个难的自己去看定义. (它甚至是自由余完备化)]

#definition(title:[$S$-局部])[
  设 $cal(C)$ 是一个 $oo$-范畴, $S$ 是一族态射
  $ S = { f_alpha : A_alpha -> B_alpha } $
  称对象 $X in cal(C)$ 是 *$S$-局部的*, 是指对每个 $(f:A->B) in S$, 预复合 $f$ 给出的
  $ f^* : Map_(cal(C))(B,X) -->^~ Map_(cal(C))(A,X) $
  都是等价. 记 $cal(C)_(S"-loc")$ 为
]

显然, 层的条件无非就是令
$ S = {R arrow.hook h_U | R "是覆盖筛"} $
于是
$ Shv(cal(C),J) = PShv(cal(C))_(S"-loc") $

#lemma(title:[小正交类引理])[
  若 $cal(D)$ 是可呈示的, $S$ 是一小族态射, 则 $cal(D)_(S"-loc")$ 是可及的, 并且
  $ cal(D)_(S"-loc") arrow.hook cal(D) $
  是可及的嵌入.
]

#proof[
  因为 $cal(D)$ 可呈示且 $S$ 小, 可以取到一个充分大的正则基数 $kappa$, 使得:
  
  + $cal(D)$ 是 $kappa$-可及的.
  + 对每个 $s:A->B in S$, $A,B$ 都是 $kappa$-紧的.
  + $abs(S)<kappa$.

  于是对每个 $s:A->B$, 函子
  $ Phi_s : cal(D) -> Fun(Delta^1,Ani), quad X |-> (Map(B,X)->Map(A,X)) $
  保持 $kappa$-滤过余极限, 因此是 $kappa$-可及的. 合起来得到
  $ Phi : cal(D) -> product_(s in S) Fun(Delta^1,Ani) $
  由于 $abs(S)<kappa$, 这个函子依然 $kappa$-可及, 于是可令
  $ "Eq"(Ani) subset Fun(Delta^1,Ani) $
  为同伦等价 $X->^~Y$ 组成的全子范畴, 它可及且可及嵌入的, 事实上有
  $ "Eq"(Ani) simeq Ani $
  (由在原点 evaluation 给出等价) 并且一族等价的余极限依然是等价. 从而有拉回
  #web-diagram(diagram({
	node((0, -1), [$cal(D)_(S"-loc")$])
	node((1, -1), [$product_(s in S)"Eq"(Ani)$])
	node((1, 0), [$product_(s in S) Fun(Delta^1,Ani)$])
	node((0, 0), [$cal(D)$])
	edge((1, -1), (1, 0), "->")
	edge((0, -1), (0, 0), [$i$], label-side: right, "->")
	edge((0, 0), (1, 0), [$Phi$], label-side: right, "->")
	edge((0, -1), (1, -1), "->")
  }))
  而可及 $oo$-范畴和可及函子在小极限下封闭, 故该拉回中的 $cal(D)_(S"-loc")$ 可及且 $i$ 是可及的函子.
]

#corollary[
  $cal(D)_(S"-loc")$ 是可呈示的 $oo$-范畴.
]

== 层化

由上 $Shv(cal(C);J)$ 和 $PShv(cal(C))$ 都是可呈示的, 由 $PrL$ 的伴随函子定理, 必然有伴随对
$ a : PShv(cal(C)) arrows.lr Shv(cal(C),J) : i $

#definition(title:[层化])[
  定义*层化函子* (sheafification) 就是满足泛性质
  $ Map_(Shv(cal(C);J))(a F,G) simeq Map_(PShv(cal(C))) (F,i G) $
  的函子
  $ a : PShv(cal(C)) -> Shv(cal(C);J) $
]

本质上, 层化可以理解为, 对所有可能的覆盖, 都取覆盖上的同伦相容局部截面, 再将两个在某个共同细化上相同的局部截面识别.

#proposition[
  $a : PShv(cal(C)) -> Shv(cal(C);J)$ 是*左正合*的, 意即其保持所有有限极限.
]

#proof[
  因为 Grothendieck 拓扑的覆盖筛对任意拉回稳定, 所以由覆盖筛 $R arrow.hook h_U$ 生成的局部等价类对拉回稳定，故相应的反射局部化
  $ a: PShv(cal(C)) -> Shv(cal(C);J) $
  是左正合的.
]

== 构造 $(-)^+$

由于最大筛 $h_U$ 一定是覆盖筛, 从而是 $J(U)$ 的对象, 由 Yoneda 有
$ F(U) simeq Map(h_U,F) $
而进入余极限, 我们可显式定义

#definition(title:[函子 $(-)^+$])[
  对于预层 $F$, 我们可以定义 $F^+$ 为一个极限构造
  $ F^+ (U) simeq colim_(R in J(U)) Map(R,F) $
  显然这些逐 $U$ 自然, 故有函子 $(-)^+$.
]

#proposition[
  对经典的 $F:cal(C)^opp->Set$, 有
  $ a F simeq F^(++) $
]

#proofsketch[
  只需证明两步: $F^+$ 一定是分离的, 以及分离的预层的 $F^+$ 一定是层. 此处不过多赘述.
]

= 预叠

== 预叠的定义

回忆预层的概念, 我们定义预层是一个函子
$ F : cal(C)^opp -> Ani $
我们将其推广到更一般的情况, 就得到的预叠的概念

#definition(title:[预叠])[
 设 $cal(C)$ 是一个小的 $oo$-范畴, 定义
  $ PSt_(Cat_oo)(cal(C)) := Fun(cal(C)^opp,Cat_oo) $
  为 *$Cat_oo$-值预叠范畴*, 其中的元素为 *$Cat_oo$-值预叠*, 简称*预叠* (prestack). 
]

== 预叠的下降

我们可以定义下降范畴

#definition(title:[下降数据])[
  设 $F$ 是上述意义的预叠, 将一个筛 $R$ 视作所有属于该筛的箭头 $V->U$ 组成的范畴, 定义
  $ Desc_F (R) := lim_((V->U) in R^opp) F(V) $
  由限制 $F(U)->F(V)$ 就得到了自然的函子
  $ F(U) -> Desc_F (R) = lim_((V->U) in R^opp) F(V) $
  该范畴称之为其*下降数据* (descent datum).
]

== 叠

满足下降的预叠就定义为叠

#definition(title:[$Cat_oo$-值叠])[
  定义预叠 $F$ 在景 $(cal(C),J)$ 上满足*下降*, 是指对每个覆盖筛都有等价
  $ F(U) ->^~ lim_((V->U) in R^opp) F(V) $
  这样的预叠就称之为一个*叠* (stack).
]

我们也可以用 $(oo,2)$-范畴的语言来描述, 我们有 $Cat_oo$-值的映射对象, 记作
$ underline(Map)(A,F) in Cat_oo $
有充实 Yoneda 引理
$ underline(Map)(h_U,F) simeq F(U) $
那么我们可以用同样的方式来刻画叠条件, 即对任意覆盖筛 $i:R->h_U$, 诱导的
$ underline(Map)(i,F) : F(U) ->^~ underline(Map)(R,F) $
