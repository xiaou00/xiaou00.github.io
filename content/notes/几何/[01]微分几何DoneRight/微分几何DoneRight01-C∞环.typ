#import "../../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= $Euc$ 的 Lawvere 理论

== Lawvere 基本观念

在开始我们整个理论之前, 我们先来看一个人畜无害的范畴.

#definition(title:[范畴 $Euc$])[
  定义小范畴 $Euc$ 的对象为
  $ {RR^0, RR^1, RR^2, ...} $
  态射为
  $ Hom(RR^m,RR^n) := C^oo (RR^m,RR^n) $
  也就是所有经典意义下的光滑映射.
]

这确实是 $Mfd$ 的一个全子范畴 (不过我希望你现在忘掉流形的定义, 我们在后面会给出一个更为震撼的版本).

回归主题, Lawvere 理论是一套数学中, 用于编码群, 环, 结合代数等代数理论的抽象工具, 不过其本身定义并不复杂, 反而简单地精妙

#definition(title:[Lawvere 理论])[
  一个 *Lawvere 理论* (Lawvere theory) 是一个具有有限极限的小范畴 $TT$, 满足存在一个对象 $X$, 使得 $TT$ 的全部对象都同构于某个 $X^n, n>=0$. 这样的 $X$ 称之为*泛对象* (universal object).
]

在#note-ref("../../导出代数几何/导出代数几何06-Lawvere理论.typ")中, 我们给出过 Lawvere 理论的基础讨论. 下面我们复述一遍概要, 既然 Lawvere 编码了运算, 我们可以用一种典范的方式来还原代数结构.

#definition(title:[$TT$-代数])[
  一个 *Lawvere $TT$-代数* 就是一个保持有限积的函子
  $ A : TT -> Set in Fun^times (TT,Set) $
]

#remark[
  注意到, 若 $TT$ 是某个具有有限余极限范畴的对偶 $cal(C)^opp$, 那这个构造恰好是 $"1-"sInd(cal(C))$.
]

#example(title:[刻画 Abel 群理论的 Lawvere 结构])[
  我们可以取
  $ TT_Ab := cat("FreeAb")_"fg"^opp $
  是全体有限生成自由 Abel 张成的 $Ab$ 的全子范畴的对偶. 其对象对应
  $ {0,1,2,...} |-> {0, ZZ^1, ZZ^2, ...} $
  我们来检查 $TT(n,1)$ 在此处的含义, 对于 Abel 群, 任何由群运算构造出来的 $n$-元运算最终都能唯一写成
  $ a_1 x_1 + ... + a_n x_n, quad a_i in ZZ $
  因此 $TT_Ab (n,1) simeq ZZ^n$, 例如 $TT_(Ab) (2,1) simeq ZZ^2$, 元素 $(a,b)$ 对应操作 $(x,y)|->(a x + b y)$. 反范畴恰好把自由代数之间的同态反转为多元代数操作. 一个 $TT_Ab$ 代数是一个保持有限积的函子
  $ A : TT_Ab -> Set $
  令 $X = A(1) := A(ZZ)$, 由于保持有限积, $A(n)=A(1^n) simeq X^n$. $T$ 中的态射
  $ + : 2->1, quad - : 1->1, quad 0 : 0->1 $
  被 $A$ 送到
  $ A times A -> A, quad A -> A, quad * -> A $
  恰好编码出 Abel 群公理. 反之, 给定 Abel 群 $Y$, 都能给出模型 $B(n) = A^n$, 并让
  $ (a_1,...,a_n) in TT(n,1) $
  作用为
  $ (x_1,...,x_n) |-> a_1 x_1 + ... + a_n x_n $
  我们导出了核心等价
  $ Fun^times (TT_Ab,Set) simeq Ab $
]

= $C^oo$-环

== $C^oo$-环的定义

#proposition[
  显然, $Euc$ 构成一个 Lawvere 理论.
]

所谓 $C^oo$-环, 其实就是这个 Lawvere 理论对应的 Lawvere 代数

#definition(title:[$C^oo$-环])[
  定义一个 *$C^oo$-环*就是保持有限乘积的函子
  $ A : Euc -> Set $
  我们记其范畴为 $CooRing := Fun^times (Euc,Set)$.
]

由于一个 $C^oo$-环 $A$ 是保持有限乘积的函子, 所以
$ A(RR^n) simeq A(RR)^n $
这个函子实际上由一个集合
$ abs(A) := A(RR) $
和一大族运算决定: 对每个光滑函数 $f:RR^n->RR$, 在函子作用
#web-diagram(diagram({
	node((-1, -1), [$RR^n$])
	node((-1, 0), [$RR$])
	node((0, -1), [$abs(A)^n$])
	node((0, 0), [$abs(A)$])
	edge((-1, -1), (-1, 0), [$f$], label-side: right, "->")
	edge((0, -1), (0, 0), [$Phi_f$], label-side: left, "->")
	edge((-1, -1), (0, -1), "|->")
	edge((-1, 0), (0, 0), "|->")
}))
下, 都可以指定一个操作
$ Phi_f : A^n -> A $
下面我们可以通过刻画这些操作来给出一个等价的, 更直观的定义.

#definition(title:[$C^oo$-环])[
  一个 *$C^oo$-环*是一个集合 $A$, 对每个
  $ f in C^oo (RR^n,RR), quad n>=0 $
  都指定一个运算
  $ Phi_f : A^n -> A $
  满足:
  
  + 若 $pr_i:RR^n->RR$ 是第 $i$ 个投影, 则 $Phi_(pr_i)(a_1,...,a_n)=a_i$.
  + 设 $f_i:RR^n->RR, i=1,...,m$, 且 $g:RR^m->RR$, 则
    $ Phi_(g compose (f_1,...,f_m)) = Phi_g compose (Phi_(f_1),...,Phi_(f_m)) $
    也就是说 $Phi$ 不改变原本复合的顺序.
]

第二条本质上就是下图的函子性:

#web-diagram(diagram({
	node((-1, -1), [$RR^m$])
	node((-1, 0), [$RR$])
	node((0, 0), [$RR$])
	node((1, 0), [$dots.c$])
	node((2, 0), [$RR$])
	node((-1, -2), [$RR^n$])
	node((3, -2), [$A^n$])
	node((3, -1), [$A^m$])
	node((3, 0), [$A$])
	node((4, 0), [$A$])
	node((5, 0), [$dots.c$])
	node((6, 0), [$A$])
	node((-1, 1), [$RR$])
	node((3, 1), [$A$])
	edge((-1, -1), (2, 0), "->")
	edge((-1, -1), (0, 0), "->")
	edge((-1, -1), (-1, 0), "->")
	edge((-1, -2), (-1, 0), [$f_1$], label-side: right, "->", bend: -36deg)
	edge((-1, -2), (0, 0), [$f_2$], label-side: center, label-pos: 0.4, "->", bend: 36deg)
	edge((-1, -2), (2, 0), [$f_m$], label-side: left, "->", bend: 54deg)
	edge((-1, -2), (-1, -1), [$exists!(f_1,...,f_m)$], label-side: center, "-->")
	edge((-1, -2), (3, -2), "|->", bend: 36deg)
	edge((-1, -1), (3, -1), "|->", bend: 18deg)
	edge((3, -2), (3, 0), [$Phi_(f_1)$], label-side: right, "->", bend: -36deg)
	edge((3, -2), (4, 0), [$Phi_(f_2)$], label-side: left, "->", bend: 36deg)
	edge((3, -2), (6, 0), [$Phi_(f_m)$], label-side: left, "->", bend: 36deg)
	edge((3, -2), (3, -1), [$exists!(Phi_(f_1),...,Phi_(f_m))$], label-side: center, "-->")
	edge((3, -1), (3, 0), "->")
	edge((3, -1), (4, 0), "->")
	edge((3, -1), (6, 0), "->")
	edge((-1, -1), (-1, 1), [$g$], label-side: right, "->", bend: -36deg)
	edge((3, -1), (3, 1), [$Phi_g$], label-side: right, "->", bend: -36deg)
	edge((-1, 1), (3, 1), "|->")
}))

(我草我为什么要画这个这不是纯粹的废话吗)

从这个构造中, 我们可以观察出一个非常重要的事实:

#construction[
  我们取光滑函数:
  $
  + : RR^2 -> RR, quad (x,y) |-> x+y \
  dot : RR^2 -> RR, quad (x,y) |-> x y \
  - : RR -> RR, quad x |-> -x \
  "对每个" r in RR, "视作" r : RR^0 -> RR 
  $
  这事实上在函子作用下给出了
  $
  Phi_+ : A^2 -> A, quad (a,b) |-> a+b \
  Phi_times : A^2 -> A, quad (a,b) |-> a b \
  Phi_- : A -> A, quad a |-> -a \
  RR->A
  $
  这恰是一个交换 $RR$-代数的结构, 从而有忘却函子
  $ U : CooRing -> CAlg_RR $
  但是 $C^oo$-环的结构远比 $CAlg_RR$ 丰富, 例如在 $C^oo$-环中我们还可以定义
  $ sin(a), quad exp(a), quad sqrt(1+a^2) $
]

我们得到了核心直觉: 一个 $C^oo$-环就是一个交换 $RR$-代数配上光滑的函数运算体系.

== $C^oo (M)$

流形是 $C^oo$-环理论的目的也是重要原型之一.

#construction[
  设 $M in Mfd$ 是光滑流形, 令
  $ A = C^oo (M,RR) $
  若 $f:RR^n->RR$ 是光滑的, 对 $c_1,...,c_n in C^oo (M,RR)$, 定义
  $ Phi_f (c_1,...,c_n) = f compose (c_1,...,c_n) $
  也就是说
  $ Phi_f (c_1,...,c_n)(x) = f(c_1 (x),...,c_n (x)) $
  因此 $C^oo (M)$ 典范地是 $C^oo$-环, 有反变函子
  $ C^oo : Mfd^opp -> CooRing $
]

== $C^oo$-环的态射

我们知道一个 $C^oo$-环的态射是一个函子的自然变换
$ phi : A -> B $
也就是
#web-diagram(diagram({
	node((-1, -1), [$RR^n$])
	node((0, -1), [$abs(A)^n$])
	node((-1, 0), [$RR^m$])
	node((0, 0), [$abs(A)^m$])
	node((1, -1), [$abs(B)^n$])
	node((1, 0), [$abs(B)^m$])
	edge((-1, -1), (0, -1), [$A$], label-side: center, "|->")
	edge((-1, 0), (0, 0), [$A$], label-side: center, "|->")
	edge((-1, -1), (-1, 0), [$f$], label-side: right, "->")
	edge((0, -1), (0, 0), [$A(f)$], label-side: right, "->")
	edge((-1, -1), (1, -1), [$B$], label-side: center, "|->", bend: 36deg)
	edge((-1, 0), (1, 0), [$B$], label-side: center, "|->", bend: -36deg)
	edge((1, -1), (1, 0), [$B(f)$], label-side: left, "->")
	edge((0, -1), (1, -1), [$phi_(RR^n)$], label-side: right, "->")
	edge((0, 0), (1, 0), [$phi_(RR^m)$], label-side: left, "->")
}))
限制在一元函数就是
#web-diagram(diagram({
	node((-1, -1), [$RR^n$])
	node((0, -1), [$A^n$])
	node((-1, 0), [$RR$])
	node((0, 0), [$A$])
	node((1, -1), [$B^n$])
	node((1, 0), [$B$])
	edge((-1, -1), (0, -1), [$A$], label-side: center, "|->")
	edge((-1, 0), (0, 0), [$A$], label-side: center, "|->")
	edge((-1, -1), (-1, 0), [$f$], label-side: right, "->")
	edge((-1, -1), (1, -1), [$B$], label-side: center, "|->", bend: 36deg)
	edge((-1, 0), (1, 0), [$B$], label-side: center, "|->", bend: -36deg)
	edge((1, -1), (1, 0), [$Phi^B_f$], label-side: left, "->")
	edge((0, -1), (1, -1), [$phi_(RR^n)$], label-side: right, "->")
	edge((0, 0), (1, 0), [$phi_(RR)$], label-side: left, "->")
	edge((0, -1), (0, 0), [$Phi^A_f$], label-side: right, "->")
}))

我们现在来精确描述其行为

#definition(title:[$C^oo$-环同态])[
  一个 *$C^oo$-环同态* $phi:A->B$ 是集合映射, 满足对任意光滑函数 $f:RR^n->RR$, 都有
  $ phi(Phi^A_f (a_1,...,a_n)) = Phi^B_f (phi(a_1),...,phi(a_n)) $
]

也就是说, 其不止保持
$ phi(a+b) = phi(a) + phi(b), quad phi(a b) = phi(a)phi(b) $
还要求诸如
$ phi(exp(a)) = exp(phi(a)), quad phi(sin(a)) = sin(phi(a)) $
这样的性质.
