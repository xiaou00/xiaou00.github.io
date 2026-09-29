#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= $n$-束

== 束的定义

#definition(title:[$n$-束])[
  设 $cal(X)$ 是 $oo$-意象, 给定 $n>=0$, 一个 *$n$-束* ($n$-gerbe) 是一个 $n$-截断且 $(n-1)$-连通的对象 $X in cal(X)$. 记 $n$-束张成的全子范畴为
  $ Gerb_n (cal(X)) subset cal(X) $
]

对于基点意象, 我们定义一个度数为 $n$ 的 *Eilenberg--MacLane 对象*是一个基点的 $n$-束, 并记
$ EM_n (cal(X)) subset cal(X) $
类似地, 我们定义一个态射 $f:X->Y$ 是一个 $n$-束, 是指其在 $cal(X)_(\/Y)$ 中是一个 $n$-束.

#proposition[
  固定 $oo$-意象 $cal(X)$, 若 $K$ 是一个 $(n+1)$-束, $a,b:*->K$ 是任给态射, 则下图的拉回 $P$
  #web-diagram(diagram({
	node((-1, -1), [$P$])
	node((0, -1), [$*$])
	node((-1, 0), [$*$])
	node((0, 0), [$K$])
	edge((-1, 0), (0, 0), [$a$], label-side: right, "->")
	edge((0, -1), (0, 0), [$b$], label-side: left, "->")
	edge((-1, -1), (0, -1), "->")
	edge((-1, -1), (-1, 0), "->")
  }))
  是一个 $n$-束.
]

#proof[
  注意到可以改写成形式
  #web-diagram(diagram({
	node((-1, -1), [$P$])
	node((0, -1), [$K$])
	node((0, 0), [$K times K$])
	node((-1, 0), [$*$])
	edge((0, -1), (0, 0), [$Delta_K$], label-side: left, "->")
	edge((-1, -1), (-1, 0), "->")
	edge((-1, -1), (0, -1), "->")
	edge((-1, 0), (0, 0), [$(a,b)$], label-side: right, "->")
  }))
  再应用对角线判别法即可.
]

== $EE_n$-群对象与分类空间

#definition(title:[$EE_n$-群对象])[
  给定具有有限积的 $oo$-范畴 $cal(C)$, 对任意 $n>=0$, 定义范畴
  $ EE_0 Grp(cal(C)) := cal(C)_*, quad EE_(n+1)Grp(cal(C)) := Grp(EE_n Grp(cal(C))) $
  其元素称之为 $cal(C)$ 的 *$EE_n$-群对象*.
]

#theorem(title:[Deloop Cycle])[
  对任意 $oo$-意象 $cal(X)$ 和 $n>=0$, 有等价
  $ "B"^n : EE_(n)Grp(cal(X)) arrows.lr^~ cal(X)_(*,>=n) : Omega^(n)  $
] <thm-deloop-cycle>

上述命题的核心就是
$ "B" : Grp(cal(X)) arrows.lr^~ cal(X)_(*,>=1) : Omega $
我们来分别明确两边的含义.

给定 $G in Grp(cal(X))$, 其杠单纯对象为
$ "B"_bullet G : * arrows.ll G arrows.lll G times G ... $
于是我们可以定义

#definition(title:[分类空间])[
  定义*分类空间*函子为
  $ "B" : Grp(cal(X)) -> cal(X)_(*,>=1), quad G |-> abs("B"_bullet G) $
]

环路空间函子照常定义. 关键在于, $"B"_bullet G$ 是一个群胚对象, 于是由于 $oo$-意象的群胚对象都是有效的, 于是
$ "B"_bullet G simeq C(*->"B"G)_bullet $
来自某个 Cech 脉, 特别地有
$ * times_("B"G) * simeq ("B"_bullet G)_1 simeq G $
但左边恰好是 $Omega$, 于是 $Omega"B"G simeq G$, 同时由于
$ * -> "B"G $
是有效满射, 从而 $"B"G$ 由定义是连通的, 于是由

#lemma[
  对于带基点对象 $(X,x) in cal(X)$, $x:*->X$ 是有效满射 ($(-1)$-截断的) 当且仅当 $X$ 是 $0$-截断的.
]

我们有 $"B"G in cal(X)_(*,>=1)$. 反过来设 $(X,x) in cal(X)_(*,>=1)$, 这意味着 $X->*$ 是 $0$-连通的. 同理 $x:*->X$ 为 $(-1)$-连通的, 从而 $x$ 是有效满的, 于是其 Cech 脉
$ X simeq abs(C(*->X)_bullet) $
令 $G = Omega_x X = * times_X *$, 则其天然是群对象. Cech 脉还满足
$ C(*->X)_m simeq G^m $
因此
$ C(*->X)_bullet simeq "B"_bullet G $
于是
$ "B"Omega X simeq X $

#corollary[
  对于 $n>=0$, 有等价
  $ EM_0 (cal(X)) simeq (cal(X)_(<=0))_*, quad EM_1 (cal(X)) simeq Grp(cal(X)_(<=0)), quad EM_n (cal(X)) simeq Ab(cal(X)_(<=0)) quad "对" n>=2 $
]

= 带标束与上同调

$n$-束在障碍理论中十分重要, 对于给定的 $X,Y in cal(X)$, 自然会问 $Y->tau_0 X$ 能不能提升到 $Y->X$, 逐阶地, 假若我们已经有 $Y->tau_(n-1)X$, 能否找到提升 $X->tau_(n)X$, 即

#web-diagram(diagram({
	node((-1, 0), [$Y$])
	node((0, 0), [$tau_(n-1)X$])
	node((0, -1), [$tau_n X$])
	edge((0, -1), (0, 0), "->")
	edge((-1, 0), (0, 0), "->")
	edge((-1, 0), (0, -1), "-->")
}))

下面我们引入的概念就是通过上同调类的消失来重述这一问题.

== 带标束的定义

下面记相对截断
$ underline(pi)_n X := tau^X_(<=0)(Omega^n_X (X times X)) in cal(X)_(\/X) $
称之为*同伦局部系统*. 这是一个 $EE_n$-群对象的相对截断, 他在点上的拉回就是同伦群.

#lemma[
  若 $n>=2$ 且 $X$ 是一个 $n$-束, 则存在唯一 $A in Ab(cal(X)_(<=0))$ 使得
  $ underline(pi)_n X simeq X times A $
]

#proof[
  由定义显然给出 $p:X->*$ 是 $n$-截断且 $(n-1)$-连通, 由于 $n>=2$, 从而 $p$ 至少是 $1$-连通的. 从而拉回给出等价
  $ p^* : cal(X)_(<=0) ->^~ (cal(X)_(\/X))_(<=0) $
  这个保持有限积, 固然有
  $ p^* : Ab(cal(X)_(<=0)) ->^~ Ab((cal(X)_(\/X))_(<=0)) $
  $underline(pi)_n X$ 是右边的一个对象, 由本质满性, 存在
  $ A in Ab(cal(X)_(<=0)) $
  使得 $p^* A simeq underline(pi)_n X$, 结合
  $ p^* A = (X times A larr^(pr_1) X) $
  证毕
]

#remark[
  若 $n=1$, 则 $A in Grp(cal(X)_(<=0))$ 若存在则唯一, 虽然一般不一定存在.
]

这里的 $underline(pi)_n X$ 和 $X times A$ 都可以以典范的方式视作是
$ EE_n Grp((cal(X)_(\/X))_(<=0)) $
中的对象

#definition(title:[带标束])[
  设 $n>=1$, $X$ 是 $n$-束, 考虑 $A in Ab(cal(X)_(>=0))$. 我们称 $X$ *带标* (banded by) $A$, 若其配备了一个 $EE_n Grp((cal(X)_(\/X))_(<=0))$ 中的同构
  $ underline(pi)_n X simeq X times A $
  记 $Gerb^A_n (cal(X))$ 为保持标记 $A$ 的 $n$-束同构构成的生象.
]

#proposition[
  设 $n>=1$, 则平凡的 $n$-束 $"B"^n A$ 是带标 $A$ 的. 并且 $Gerb^A_n (cal(X))$ 可缩.
]

== 带标束的分类

#theorem(title:[带标束的分类])[
  设 $A in Ab(cal(X)_(<=0))$ 且 $n>=1$, 则对任意 $X in cal(X)$ 有等价
  $ Map_(cal(X))(X, "B"^(n+1)A) simeq Gerb^A_n (cal(X)_(\/X)) $
]

#proofsketch[
  设 $Y->X$ 是一个 $A$-标的 $n$-束. 由束的性质选取局部基点总有
  $ Y simeq "B"^n Omega^n Y $
  而标给出 $Omega^n Y simeq A$, 从而局部 $Y simeq "B"^n A$. 另一方面, 由于 $"B"^n A$ 的保持标的自同构空间为
  $ Aut_A ("B"^n A) simeq "B"^n A $
  因此 $A$-标的 $n$-束就是局部模型 $"B"^n A$ 上的扭曲形式, 其自同构对象由 deloop 分类
  $ "B"Aut_A ("B"^n A) simeq "B"("B"^n A) = "B"^(n+1) A $
  由下降得证.
]

#corollary[
  在 $n=0$ 的情况, 这给出了
  $ Map_(cal(X)) (*, "B"G) simeq {cal(X) "中的" G"-挠子"}^simeq $
]

== 在障碍理论的应用

给定一个对象 $X$ 和 $n>=2$, 那么
$ tau_n X -> tau_(n-1)X $
是一个 $n$-束, 并且带标 
$ A in Ab((cal(X)_(\/tau_(n-1) X))_(<=0)) $
我们可以将其写成拉回

#web-diagram(diagram({
	node((-1, -1), [$tau_n X$])
	node((-1, 0), [$tau_(n-1) X$])
	node((0, -1), [$tau_(n-1) X$])
	node((0, 0), [$"B"^(n+1)A$])
	edge((-1, -1), (-1, 0), "->")
	edge((-1, -1), (0, -1), "->")
	edge((0, -1), (0, 0), "->")
	edge((-1, 0), (0, 0), "->")
}))

这里将 $"B"^(n+1)A$ 视作落在 $tau_(n-1)X$ 的切片范畴中, 右上角视作该切片的终对象. 于是寻找 $Y->tau_(n-1)$ 的一个提升 $Y->tau_n$, 相当于令诱导的切片范畴中的 $Y->"B"^(n+1)A$ 零伦. 这启发我们定义上同调

#definition(title:[上同调])[
  设 $cal(X)$ 是 $oo$-意象. $A$ 是 $cal(X)_(<=0)$ 的 Abel 群对象, 且 $Y in cal(X)$, 定义 $Y$ 的 *第 $n$ 个系数在 $A$ 中的上同调*为
  $ H^n (Y;A) := pi_0 Map_(cal(X))(Y,"B"^n A) in Ab $
]

#example(title:[平展上同调])[
  在小平展 $oo$-意象 $cal(X) = Shv(S_et)$ 上, 若 $A in Ab(cal(X)_(<=0))$, 则*平展上同调*定义为
  $ H^n_et (S;A) = pi_0 Map_(cal(X))(1,"B"^n A) $
]
