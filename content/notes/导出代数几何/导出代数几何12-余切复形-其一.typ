#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 是生象交换环.

= 余切复形的定义

== 泛性质定义

正如经典理论中的
$ Der_k (A,M) tilde.eq Hom_A (Omega^1_(k/A),M) $
我们可以将这个想法自然地推进到导出层面

#definition(title:[余切复形 / 泛性质定义])[
  设 $A in AniCAlg_k$ 是生象交换 $k$-代数, 那么函子
  $ Der_k (A,-) : Mod^(>=0)_A -> Ani_* $
  可表, 也就是说存在可缩选择意义下唯一的 $LL_(A/k) in Mod_A^(>=0)$ 使得
  $ Map_A (LL_(A/k),-) tilde.eq Der_k (A,-) $
  左边基点为零映射 $0:LL_(A/k)->M$, 右边基点为零导子. 称 $LL_(A/k)$ 为代数 $k->A$ 对应的*余切复形* (cotangent complex).
]

#proof[
  记 $cal(C)_A := AniCAlg_(k"//"A)$, 其中 $A$ 对应于对象 $k->A->^id A$. 有平凡平方零扩张函子
  $ SqZ_A : Mod^(>=0)_A -> cal(C)_A $
  由定义
  $ Der_k (A,M) = Map_(cal(C)_A) (A,SqZ_A (M)) $
  由于

  - $Mod^(>=0)_A$ 是可呈示的 $oo$-范畴.
  - $cal(C)_A = AniCAlg_(k"//"A)$ 也是可呈示的 $oo$-范畴.
  - $SqZ_A$ 可及.
  - $SqZ_A$ 保持极限.

  从而由伴随函子定理, 存在伴随对
  $ Q_(A/k) : cal(C)_A arrows.lr Mod^(>=0)_A : SqZ_A $
  只需令
  $ LL_(A/k) = Q_(A/k) (A) $
  就有
  $ Map_A (LL_(A/k),M) &= Map_A (Q_(A/k)(A),M) \
  &tilde.eq Map_(cal(C)_A) (A,SqZ_A (M)) \
  &tilde.eq Der_k (A,M) $
]

== 通过左 Kan 延拓定义

我们可以从多项式代数 $Poly_k$ 为起点, 由于对自由代数
$ P_n := k[x_1,...,x_n] $
微分完全没有导出修正, 即
$ LL_(P/k) tilde.eq Omega^1_(P/k) [0] tilde.eq P^(plus.o n)[0] $
现在我们希望构造一个保持余极限的函子
$ LL_(-/k) : AniCAlg_k -> AniMod $
注意, 这里的 $AniMod$ 是总范畴. 那么我们本质上只需要构造函子
$ AniCAlg^(omega"p")_k -> AniMod $
即可, 而剩余部分可典范延拓. 现在, 固定生象 $k$-代数 $A$, 考虑所有指向 $A$ 的多项式代数
$ (P -> A), quad P in Poly_k $
因为 $Omega^1_(P/k)$ 本就是 $P$ 模, 为了将其放进同一个范畴比较, 自然想到要沿着 $P->A$ 作标量扩张
$ Omega^1_(P/k) |-> A times.o_P Omega^1_(P/k) in Mod_A $
我们将这些汇集起来, 定义
$ LL_(A/k) = colim_((P->A) in Poly_k times_(AniCAlg_k) AniCAlg_(k"//"A)) (A times.o_P Omega^1_(P/k)) $
指标范畴的意思是 "所有指向 $A$ 的多项式 $k$-代数". 这个余极限在 $Mod_A$ 这个范畴中取.

#definition(title:[余切复形 / 左 Kan 延拓定义])[
  设 $A$ 是生象交换 $k$-代数, 余切复形 $LL_(A/k) in Mod^(>=0)_A$ 定义为 Kähler 微分
  $ P |-> Omega^1_(P/k) [0], quad P in Poly_k $
  沿 $j:Poly_k arrow.hook AniCAlg_k$ 的左 Kan 延拓在 $A$ 处的值, 即
  $ LL_(-/k) tilde.eq Lan_j (Omega^1_(-/k)) $
  等价地有公式
  $ LL_(A/k) tilde.eq colim_(P->A) A times.o_P Omega^1_(P/k) $
]

这个观点可以给出余切复形很具体的计算公式, 例如设 $A in AniCAlg_k$, 我们可以取一个典范的多项式代数单纯解消
$ P_bullet -> A, quad abs(P_bullet) tilde.eq A $
其中每个 $P_n$ 都是多项式代数. 逐层计算 $Omega^1_(P_n/k)$ 后标量变换到 $A$ 得
$ A times.o_(P_n) Omega^1_(P_n/k) $
那么我们有计算公式
$ LL_(A/k) tilde.eq abs(A times.o_(P_bullet) Omega^1_(P_bullet/k)) $
若 $k,A,P_n$ 都是普通环, 那么
$ LL_(A/k) tilde.eq DK(A times.o_(P_bullet) Omega^1_(P_bullet/k)) $

#theorem(title:[两个定义等价])[
  设 $LL_(A/k) tilde.eq colim_(P->A) A times.o_P Omega^1_(P/k)$, 则
  $ Map_A (LL_(A/k),-) tilde.eq Der_k (A,-) $
]

#proof[
  先取任意 $M in Mod^(<=0)_A$, 那么
  $
  Map_(Mod_A)(LL_(A/k),M) &tilde.eq Map_(Mod_A) (colim_(P->A)A times.o_P Omega^1_(P/k),M) \
  &tilde.eq lim_(P->A) Map_(Mod_A) (A times.o_P Omega^1_(P/k),M) \
  &tilde.eq lim_(P->A) Map_(Mod_P) (Omega^1_(P/k),M)
  $
  其中第三个等式是由标量扩张和限制的伴随
  $ A times.o_P (-) : Mod_P arrows.lr Mod_A : f^* $
  诱导的, 对于每个 $f:P->A$, $M$ 通过 $f$ 视作 $P$ 模. 由于 $P$ 是多项式代数, Kähler 微分的泛性质给出
  $ Map_(Mod_P) (Omega^1_(P/k),M) tilde.eq Der_(k,f)(P,M) $
  右边的记号表示这是以 $P->^f A$ 为基点的导子空间. 也就是
  $ Der_(k,f) (P,M) := Map_(AniCAlg_(k"//"A)) ((P->^f A),(A plus.o M->A)) $
  从而
  $ Map_(Mod_A) (LL_(A/k),M) tilde.eq lim_(P->^f A) Der_(k,f) (P,M) $
  剩下只需证明
  $ lim_(P->A) Der_(k,f) (P,M) tilde.eq Der_k (A,M) $
  由多项式代数的稠密性, 有
  $ A tilde.eq colim_(P->A) P $
  从而
  $ Map(A,A plus.o M) tilde.eq lim_(P->A) Map(P,A plus.o M) $
  以及
  $ Map(A,A) tilde.eq lim_(P->A) Map(P,A) $
  在 $id_A$ 上取纤维, 而极限与极限交换, 故
  $
  Der_k (A,M) &tilde.eq lim_(f:P->A) fib_f (Map(P,A plus.o M)->Map(P,A)) \
  &tilde.eq lim_(f:P->A) Der_(k,f) (P,M)
  $
  证毕.
]

== 对角线定义

经典情形下, 若
$ I = ker(A times.o_k A -> A) $
那么总有
$ Omega^1_(A/k) tilde.eq I/I^2 $
其中万有微分可以很自然地写成
$ d : A -> I / I^2, quad a |-> [1 times.o a - a times.o 1] $
在导出情形下, 我们也可以很自然地推广这个定义

设 $A$ 是生象交换代数, 回顾上节中定义的增广代数, 事实上
$ mu : A dtens_k A -> A $
已经蕴含了这个结构, 因为有两个因子
$ i_1,i_2 : A arrows A dtens_k A $
其中
$ i_1 : a |-> a times.o 1, quad i_2 : a |-> 1 times.o a $
不妨取 $i_1$ 就得到了一个增广代数
$ (A -->^(i_1) A dtens_k A -->^mu A) in AugAlg_A $
回顾函子
$ SqZ_A : Mod^(>=0)_A -> AugAlg_A $
在第一个定义的证明里我们已经说明了它有左伴随
$ Q_A : AugAlg_A -> Mod^(>=0)_A $
于是我们可以定义

#definition(title:[余切复形 / 对角线定义])[
  设 $A in AniCAlg_k$ 是生象交换 $k$-代数, 我们可以定义
  $ LL_(A/k) := Q_A (A -->^(i_1) A dtens_k A -->^mu A) $
  称之为其对应的*余切复形*.
]

在生象的语境里, 我们有增广理想
$ I := fib(A dtens_k A -->^mu A) in Mod^(>=0)_A $
于是 $A dtens_k A tilde.eq A plus.o I$. $I$ 自然被赋予乘法 $I dtens_k I -> I$.

这里的 $Q_A$ 应该被理解成 $(I/I^2)^"der"$, 也就是这个商行为在导出的自然推广.

= 一些基本概念

== 与普通微分的关系

#proposition[
  对生象交换 $k$-代数 $A$, 我们有
  $ pi_0 LL_(A/k) tilde.eq Omega^1_(pi_0 A/pi_0 k) $
]

#proof[
  因为经典的 Kähler 微分满足泛性质
  $ Der_(pi_0 k) (pi_0 A,M) tilde.eq Hom_(pi_0 A)(Omega^1_(pi_0 A/pi_0 k),M) $
  将等价连起来有
  $
  Hom_(pi_0 A) (pi_0 LL_(A/k),M) &tilde.eq pi_0 Map_(Mod_A) (LL_(A/k),M) \
  &tilde.eq pi_0 Der_k (A,M) \
  &tilde.eq Der_(pi_0 k) (pi_0 A,M) \
  &tilde.eq Hom_(pi_0 A) (Omega^1_(pi_0 A/pi_0 k),M)
  $ 
  由 Yoneda 引理, 即证 $pi_0 LL_(A/k) tilde.eq Omega^1_(pi_0 A/pi_0 k)$.
]

== 一些例子

一个非常重要的启示是, 若将普通的交换 $k$-代数 $A$ 看作生象的, 并不意味着其
$ LL_(A/k) $
也是离散的, 完全可能有
$ pi_i (LL_(A/k)) != 0, quad i>0 $
这也正是余切复形的强大之处.

#example[
  对于普通环 $k[epsilon]/(epsilon^2)$, 其与余切复形为
  $ LL_((k[epsilon]/(epsilon^2))/k) tilde.eq [k[epsilon]/(epsilon^2) larr^(2 epsilon) k[epsilon]/(epsilon^2)] $
]

== 万有导子

#definition(title:[万有导子])[
  对 $A in AniCAlg_k$, 我们总有典范的
  $ d_(A/k) : A -> LL_(A/k), quad d_(A/k) in Der_k (A,LL_(A/k)) $
  作为 $k$-模的映射, 具体构造由泛性质
  $ Map_(Mod_A) (LL_(A/k),LL_(A/k)) tilde.eq Der_k (A,LL_(A/k)), quad id_(LL_(A/k)) <-> d_(A/k) $
  诱导, 称之为*万有导子* (universal derivation).
]

简单来说, 由于对任意导子 $delta in Der_k (A,M)$, 都有 $phi_delta in Map_(Mod_A) (LL_(A/k),M)$ 与之对应, 那 $d_(A/k)$ 本质上就是这一典范的分解:

#web-diagram(diagram({
	node((-1, -1), [$A$])
	node((0, -1), [$LL_(A/k)$])
	node((0, 0), [$M$])
	edge((-1, -1), (0, -1), [$d_(A/k)$], label-side: left, "->")
	edge((-1, -1), (0, 0), [$delta$], label-side: right, "->")
	edge((0, -1), (0, 0), [$phi_delta$], label-side: left, "->")
}))
