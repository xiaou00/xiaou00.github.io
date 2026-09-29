#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= Hochschild--Kostant--Rosenberg 定理的证明

#theorem(title:[Hochschild--Kostant--Rosenberg 定理])[
  设 $k$ 是生象交换环, $R$ 是生象交换 $k$-代数, 那么存在自然的 $S^1$-等变的乘性的 $ZZ_(>=0)$-标的降滤过 $FHKR^bullet Hoch(R/k)$ 满足
  $ gr^s_"HKR" Hoch(R/k) simeq Lambda^s LL_(R/k)[s] $
  配备平凡的 $S^1$-作用.
]

#proofsketch[
  首先, 我们设 $k$ 和 $R$ 是离散的交换环, 因为 $Hoch(R/k)$ 本身是一个生象交换环, 记
  $ Hoch_bullet (R/k) = pi_* Hoch(R/k) $
  这是一个分次交换环.

  #remark[
    我们的第一个目标是从 $S^1$-作用中, 抽出一个次数 $+1$ 的算子
    $ d : Hoch_t (R/k) -> Hoch_(t+1) (R/k) $
    并且证明它满足
    $ d^2 = 0, quad d(x y)=d(x)y+(-1)^abs(x) x d(y) $
    我们断言, 这使得 $Hoch_bullet (R/k)$ 构成一个 $k$-线性的 cdga, 为了证明这个结论, 我们先来厘清等变映射
    $ Hoch(R/k) times.o_k Hoch(R/k) -> Hoch(R/k) $
    的含义.
  ]

  我们有
  #web-diagram(diagram({
	node((-2, -2), [$plus.o.big_(i+j=s) pi_(i)"HH"(R\/k) times.o^suit.heart_k pi_(j)"HH"(R\/k)$])
	node((-2, -1), [$plus.o.big_(a+b=s+1) pi_(a)"HH"(R\/k) times.o^suit.heart_k pi_(b)"HH"(R\/k)$])
	node((-1, -2), [$pi_(s)("HH"(R\/k) times.o_k "HH"(R\/k))$])
	node((-1, -1), [$pi_(s+1)("HH"(R\/k) times.o_k "HH"(R\/k))$])
	node((0, -2), [$pi_(s)"HH"(R\/k)$])
	node((0, -1), [$pi_(s+1)"HH"(R\/k)$])
	edge((-2, -2), (-1, -2), "->")
	edge((-2, -2), (-2, -1), "->")
	edge((-2, -1), (-1, -1), "->")
	edge((-1, -2), (0, -2), "->")
	edge((-1, -1), (0, -1), "->")
	edge((-1, -2), (-1, -1), "->")
	edge((0, -2), (0, -1), "->")
  }))
  其中 $times.o^suit.heart$ 表示非导出的张量积. $S^1$ 作用限制给出了交换图
  #web-diagram(diagram({
	node((-1, -1), [$pi_i"HH"(R\/k)times.o_k^suit.heart pi_j"HH"(R\/k)$])
	node((-1, 0), [$pi_(i+1)"HH"(R\/k) times.o_k^suit.heart pi_j"HH"(R\/k) plus.o pi_i"HH"(R\/k) times.o_k^suit.heart pi_(j+1)"HH"(R\/k)$])
	node((0, -1), [$pi_(i+j)("HH"(R\/k) times.o_k "HH"(R\/k))$])
	node((0, 0), [$pi_(i+j+1)"HH"(R\/k)$])
	edge((-1, -1), (-1, 0), "->")
	edge((-1, 0), (0, 0), "->")
	edge((-1, -1), (0, -1), "->")
	edge((0, -1), (0, 0), "->")
  }))
  从左上角沿顺时针方向绕交换图, 得到 $d(x y)$. 从左上角沿逆时针方向绕, 得到 $d(x)y + (-1)^i x d(y)$, 也就是说
  $ d(x y) = d(x)y + (-1)^i x d(y) $
  一些讨论可以让我们证明这确实是一个严格的 cdga.

  一旦上述成立, 由 de Rham 复形的泛性质, 存在
  $ Omega^bullet_(R/k) -> Hoch_bullet (R/k) $
  并且这个态射在 $R$ 是多项式环时是同构. Whitehead 塔
  $ tau_(>=bullet)Hoch(R/k) $
  给出了乘性的 $S^1$-等变降滤过, 且当 $R$ 是多项式代数时
  $ gr^s Hoch(R/k) simeq Omega^s_(R/k) [s] $
  $Hoch(-/k)$ 保持筛余极限, 从而我们可以对其 Kan 延拓, 就得到了定理所述的滤过.

  若 $k$ 也是导出的, 我们先解消 $k$ 再代入离散的情况可以讨论.
]

= HKR 定理的基本含义

== 重要推论

HKR 定理告诉了我们, Hochschild 理论本质上是微分形式的导出推广. 对于离散环的情况, HKR 告诉我们

#corollary[
  设 $A$ 是光滑交换 $k$-代数, 则
  $ Hoch_n (A/k) simeq Omega^n_(A/k) $
]

我们还可以推广三个公式

#proposition(title:[Künneth 公式])[
对于 $R,S in aCAlg_k$, 有
$ FHKR^bullet Hoch(R times.o_k S/k) simeq FHKR^bullet Hoch(R/k) times.o_k FHKR^bullet Hoch(S/k) $
]

#proposition(title:[基变换公式])[
对于 $R,S in aCAlg_k$, 有
$ FHKR^bullet Hoch(R/k) times.o_k S simeq FHKR^bullet Hoch(R times.o_k S/S) $
]

#proposition[
若 $k->R->S$ 是连续的生象环映射, 则
$ FHKR^bullet Hoch(S/k) times.o_(FHKR^bullet Hoch(R/k)) R simeq FHKR^bullet Hoch(S/R) $
]

Hochschild 的本质就是在导出和甚至非交换的语境下编码微分形式, 滤过 $FHKR$ 自动给出谱序列

#theorem(title:[Hochschild--Kostant--Rosenberg 谱序列])[
  存在谱序列
  $ E_1^(p,q) = pi_q (LLambda^p_R LL_(R/k)) => Hoch_(p+q)(R/k) $
]

