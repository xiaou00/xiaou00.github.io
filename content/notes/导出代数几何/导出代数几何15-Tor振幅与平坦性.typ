#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

下面固定一个生象环 $k$, $k$-生象交换代数 $A$. 张量积等操作若未明说默认以导出理解.

= Tor 振幅

== 基本定义

下面记 $Mod^[a,b]_R = Mod_R^(>=a) inter Mod_R^(<=b)$.

#definition(title:[Tor 振幅])[
  设 $A in AniCAlg_k$, 以及 $M in Mod_A$. 称 $M$ 的 *Tor振幅*包含于 $[a,b]$, 是指对任意离散 $pi_0 A$-模 $N$, 即 $N in Mod_A^suit.heart$ 有
  $ M times.o_A N in Mod^[a,b]_A $
  若其 Tor 振幅是某个整数组 $Amp(M)=[a,b]$, 则称之为有界的.
]

回顾经典代数中的*平坦维数*定义为平坦解消的最小长度, 即
$ "dim.flat"_R (M) = inf {n>=0 : 0->F_n->...->F_0->M->0, "每个" F_i "平坦"} $
等价地可以用 $Tor$ 刻画
$ "dim.flat"_R (M) = sup {i : Tor^R_i (M,N) != 0 "对于某个" N} $
注意 Tor 振幅是对平坦维数的导出推广: 若 $A,M$ 都离散, 那么
$ pi_i (M times.o N) = Tor^A_i (M,N) $
从而 $Amp(M) = [0,n]$ 等价于 $"dim.flat"_A (M)<=n$.

#remark[
  注意, 在生象环 $A$ 上的 $Amp_A (M) = [0,0]$ 不意味着
  $ pi_i (M) = 0, quad i>0 $
  例如当 $M=A$ 时, 显然 $A times.o_A N simeq N$ 对任意离散 $N$ 都离散, 从而 $Amp(A)=[0,0]$, 但 $A$ 自身完全可以有 $pi_i A!=0$. Tor 振幅的信息是相对某个基环刻画的.
]

== Tor 振幅的运算律

#proposition[
  若 $M,N in Mod_A$, 且 $Amp(M)subset[a,b], Amp(N)subset[c,d]$, 则
  $ Amp(M times.o_A N) subset [a+c,b+d] $
]

#proof[
  取任意离散的 $A$-模 $P$, 由于 $Amp(N) subset [c,d]$, $X := N times.o_A P in Mod^[c,d]_A$, 只需证明 $M times.o_A X in Mod^[a+c,b+d]_A$. 我们取其有限的 Postnikov 塔
  $ 0 = tau_(<=c-1)X -> tau_(<=c)X -> ... -> tau_(<=d) X = X $
  其各层为
  $ cofib(tau_(i-1)X -> tau_(i)X) = pi_i X [i], quad c<=i<=d $
  因为 $M times.o_A -$ 保持余纤维序列, 只需逐层检查即可, 由于 $pi_i X$ 是离散模, 且由 $Amp(M) subset [a,b]$, 有
  $ M times.o_A pi_i X in Mod^[a,b]_A $
  从而
  $ M times.o_A (pi_i X[i]) simeq (M times.o_A pi_i X)[i] in Mod^[a+i,b+i]_A $
  结合 $Mod^[a+c,b+d]_A$ 对扩张是封闭的, 证毕.
]

= Künneth 谱序列

在正式进入平坦性的论证之前, 我们先要介绍一个非常强有力的谱序列工具.

#theorem(title:[Künneth 谱序列])[
  这里设 $A$ 是连通的 $EE_1$-环 (特别地, 生象交换环), $M,N$ 是连通的  $A$-模, 则有自然的强收敛谱序列
  $ E^2_(p,q) = Tor^(pi_*A)_p (pi_* M,pi_* N)_q => pi_(p+q) (M times.o_A N) $
]

#proof[
  下记 $R=pi_*A$. 首先对 $M$ 作典范的自由解消
  $ ... ->F_1->F_0->pi_*M->0 $
  其中每个
  $ F_p simeq plus.o.big_alpha R[d_(p,alpha)] $
  都是分次 $R$-模. (p.s. 这里的方括号含义是位移) 并且有 $R[d] = pi_* (A[d])$ 显然, 于是每个 $F_p$ 都实现为自由 $A$-模
  $ P_p := plus.o.big_alpha A[d_(p,alpha)], quad pi_*P_p simeq F_p $
  易证其构成一个单纯增广模
  $ P_bullet -> M $
  满足 
  $ abs(P_bullet) simeq M $
  且
  $ pi_* P_bullet -> pi_* M $
  是单纯自由解消, 作用 $- times.o_A N$ 有
  $ M times.o_A N simeq abs(P_bullet) times.o_A N simeq abs(P_bullet times.o_A N) $
  不妨记 $X_bullet = P_bullet times.o_A N$. 剩余的问题就是计算单纯模 $X_bullet$ 的实现, 自然的想法就是取骨架滤过
  $ abs("sk"_0 X_bullet) -> abs("sk"_1 X_bullet) -> ... -> abs(X_bullet) $
  于是给出了单纯谱的几何实现谱序列
  $ E^1_(p,q) = pi_q (X_p) => pi_(p+q) abs(X_bullet) $
  其中 $d^1 = sum_i (-1)^i (d_i)_*$, 从而这里有
  $ E^1_(p,q) = pi_q (P_p times.o_A N) $
  而 $P_p$ 是自由 $A$-模, 若
  $ P_p = plus.o.big_alpha A[d_alpha] $
  则
  $ P_p times.o_A N simeq plus.o.big_alpha N[d_alpha] $
  从而
  $ pi_*(P_p times.o_A N) simeq pi_*P_p times.o_R pi_*N $
  于是
  $ E^1_(p,*) simeq F_p times.o_R pi_*N $
  现在来计算 $E^2$ 页. 注意到, $d^1$ 正是自由解消
  $ ... -> F_2 -> F_1 -> F_0 $
  张量 $pi_*N$ 得到的微分, 因而
  $ E^2_(p,*) = H_p (F_bullet times.o_R pi_*N) $
  所以
  $ E^2_(p,q) = Tor^(pi_*A)_p (pi_*M,pi_*N)_q $
  另一方面由于 $abs(X_bullet) simeq M times.o_A N$, 谱序列收敛到
  $ pi_(p+q)(M times.o_A N) $
]

= 平坦模

== 平坦模的定义

在一般的代数中, 我们已经定义过了平坦模, 当时我们定义为使得函子
$ - times.o_R M : Mod_R -> Mod_R $
正合的函子. 现在我们将给出这个概念更加本质的定义.

#definition(title:[平坦模])[
  称 $M in Mod_A$ *平坦* (flat), 是指
  $ Amp(M) = [0,0] $
]

也就是说, 对每个离散的 $pi_0 A$-模 $N$, $M times.o_A N$ 依然离散, 不会平添导出信息. 显然, 若 $M$ 平坦, 等价于与 $M$ 张量不会改变平坦振幅.

#proposition[
  若 $A$-模 $M$ 平坦, 则对任意 $A$-模 $X$ 有
  $ Tor^A_n (M,X) = pi_n (M times.o_A X) simeq pi_0 M times.o_(pi_0 A) pi_n X $
]

#proof[
  对 $X$ 作 Postnikov 滤过, 第 $i$ 层为 $pi_i X[i]$, 张量后变为
  $ (M times.o_A pi_i X)[i] $
  由于 $pi_i X$ 离散且 $M$ 平坦, 有
  $ pi_0 (X times.o_A pi_i X) simeq pi_0 M times.o_(pi_0 A) pi_i X $
  从而这一层只在次数 $i$ 有同伦群, 且同伦群为 $pi_0 M times.o_(pi_0 A) pi_i X$. 对 Postnikov 塔归纳即证.
]

从而, 作为分次模, 有
$ pi_* M simeq pi_* A times.o_(pi_0 A) pi_0 M $
也就是说张量 $M$ 不会产生任何新的 Tor 信息.

#remark[
  也就是说, 平坦的 $M$ 的同伦群不是新的数据, 其完全由 $A$ 的高阶同伦和经典平坦模 $pi_0 M$ 决定.
]

#proposition[
  对于 $M in Mod_A^(>=0)$, 则 $M$ 是平坦的 $A$ 模当且仅当:

  + $pi_0 M$ 是平坦 $pi_0 A$-模.
  + $pi_n A times.o_(pi_0 A) pi_0 M -->^~ pi_n M$, 对 $n>=0$.
]

#proof[
  假设 $M$ 平坦, 第一个条件显然, 第二个条件由前一个命题, 由 $M times.o_A A simeq M$, 有
  $ pi_n M simeq pi_0 M times.o_(pi_0 A) pi_n A $
  反过来比较复杂, 重新改写条件无非就是分次 $pi_*A$-模同构
  $ pi_*M simeq pi_*A times.o_(pi_0 A) pi_0 M $
  由于 $pi_0 M$ 是离散的 $pi_0 A$-模, $pi_*A times.o_(pi_0 A)pi_0 M$ 是平坦的分次 $pi_*A$-模, 有对任意分次 $pi_*A$-模 $P$, 有
  $ (pi_*A times.o_(pi_0 A)pi_0M) times.o_(pi_* A) P simeq pi_0 M times.o_(pi_0 A) P $
  并且右边关于 $P$ 是正合的. 任取离散的 $pi_0 A$-模 $N$, 有 Künneth 谱序列
  $ E^2_(p,q) = Tor^(pi_* A)_p (pi_*M,N)_q => pi_(p+q) (M times.o_A N) $
  由前述的两条有
  $ Tor^(pi_* A)_p (pi_* M,N) = 0, quad p>0 $
  而
  $ pi_* M times.o_(pi_* A) N simeq (pi_*A times.o_(pi_0) pi_0 M) times.o_(pi_*A) N simeq pi_0 M times.o_(pi_0 A) N $
  都集中在内部次数 $0$, 故谱序列坍缩, 得到
  $ pi_n(M times.o_A N) = 0, quad (n!=0) $
  以及
  $ pi_0 (M times.o_A N) simeq pi_0 M times.o_(pi_0 A) N $
  从而对任意离散 $N$, $M times.o_A N$ 离散, 故 $M$ 平坦.
]

== 平坦态射

#definition(title:[平坦态射])[
  给定 $f:A->B$ 作为生象 $k$-代数的态射, 称 $f$ 是*平坦*的是指 $B$ 通过 $f$ 作为 $A$-模是平坦的, 即 $Amp_A (B) = [0,0]$.
]

#proposition[
  $f:A->B$ 平坦等价于:

  + $pi_0 A->pi_0 B$ 是经典平坦态射.
  + $pi_n A times.o_(pi_0 A) pi_0 B -->^~ pi_n B$.
]
