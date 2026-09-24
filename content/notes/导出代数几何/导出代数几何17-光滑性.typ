#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 为生象环, $A$ 为生象 $k$-代数.

= 前置定义

== 投射与有限投射

#definition(title:[投射模与有限投射模])[
  设若 $A in Mod_A$ 是自由模
  $ A^I = plus.o.big_(i in I) A $
  的一个收缩, 则称之为一个*投射模* (projective module). 特别地若指标 $I$ 可指定为有限, 则称之为*有限投射模*.
]

可以验证, 对于生象环 $A$, 投射模完全由 $pi_0A$ 上的投射模决定. 即

#proposition[
  有范畴等价
  $ cat("Proj")(A) simeq cat("Proj")(pi_0A) $
]

#proofsketch[
  显然若 $P$ 是投射 $A$-模, 则 $pi_0P$ 是投射 $pi_0A$-模. 并且有等价
  $ P simeq A times.o_(pi_0A) pi_0P $
]

并且显然由定义, 有限投射模必然是完美复形, 我们甚至有更为精细的结论.

#proposition[
  设 $P in Mod_A$, 则 $P$ 是有限投射模当且仅当 $P$ 完美且平坦.
]

#proof[
  正方向显然, 反之, 设 $P$ 完美+平坦, 并记 $R=pi_0A$. 考虑截断映射 $A->R$, 令
  $ overline(P) = P times.o_A R $
  因为完美在基变换下保持, 从而 $overline(P) in Perf(R)$, 另一方面由于 $P$ 平坦
  $ P times.o_A R $
  集中在零次且
  $ pi_0 (P times.o_A R) simeq pi_0P $
  因此
  $ overline(P) simeq pi_0P[0] $
]

== 有限表示

#definition(title:[有限表示])[
  设 $f:A->B$ 是生象环的态射, 称 $f$ 是*有限表示* (of finite presentation, fp) 的, 是指通过该态射 $B in AniCAlg_A$ 是紧对象.
]

也就是说任何滤过余极限有等价
$ varinjlim(i) Map_(AniCAlg_A) (B,C_i) simeq Map_(AniCAlg_A) (B,varinjlim(i)C_i) $

我们知道
$ AniCAlg_k^omega simeq Idem(chevron Poly_k chevron.r_"有限余极限") $
也就是多项式代数取有限余极限后收缩得到的对象. 离散情形下, 这个定义和一般的有限表示是兼容的, 这个定义等价于
$ B simeq A[x_1,...,x_n]/(f_1,...,f_n) $
是有限表示的 $A$-代数.

#example[
  若 $f:A->B$ 将 $B$ 识别为
  $ B = A[x_1,...,x_n] /\/ (f_1,...,f_m) $
  则 $f$ 有限表示.
]

= 光滑性

== 导出光滑性的定义

#definition(title:[光滑性])[
  设 $f:A->B$ 是生象环的态射, 若满足:

  + $f$ 有限表示.
  + $LL_(B/A)$ 是有限投射的 $B$-模.

  则称 $f$ 是*光滑的* (smooth), $B$ 作为 $A$-生象代数是光滑的.
]

#proposition[
  $f:A->B$ 是光滑的当且仅当:

  + $pi_0f:pi_0A->pi_0B$ 是经典意义下光滑的.
  + $f$ 平坦.
]

#proof[展开定义即证.]

因此, 光滑性可以理解成一种 "所有信息都存在于 $pi_0 A->pi_0 B$" 的条件, 高阶同伦沿着这个映射平坦地传递过去, 没有任何奇异性.

光滑性的另一个核心意义就是无穷小变形都可以提升: 假若有平方零扩张
$ C' ->> C $
以及 $A$-代数映射 $B->C$, 问能否构造提升 $B->C'$. 光滑时 $LL_(B/A)$ 是投射且集中在零次, 固然
$ Ext^1_B (LL_(B/A),M) = 0 $
从而障碍消失, 提升存在.

== 平展性

#definition(title:[平展性])[
  设 $f:A->B$ 是生象环的态射, 若满足:

  + $f$ 有限表示.
  + $LL_(B/A)=0$.

  则称 $f$ 是*平展的* (étale), $B$ 作为 $A$-生象代数是平展的.
]

#proposition[
  $f:A->B$ 平展当且仅当:

  + $pi_0 f:pi_0 A->pi_0 B$ 是经典意义下平展.
  + $f$ 平坦.
]

== 拟光滑性

一般的光滑条件可以等价地写作: $f$ 有限表示, $LL_(B/A)$ 完美且平坦. 而平坦意味着
$ Amp(LL_(B/A)) subset [0,0] $
而拟光滑性是这一条件略放宽后得到的结果

#definition(title:[拟光滑性])[
  设 $f:A->B$ 是生象环的态射, 若满足:

  + $f$ 有限表示.
  + $LL_(A/B)$ 是完美复形.
  + $Amp(LL_(A/B)) subset [0,1]$.

  则称 $f$ 是*拟光滑的* (quasi-smooth), $B$ 作为 $A$-生象代数是拟光滑的.
]

拟光滑性是*局部完全交* (locally complete intersection) 的推广. 局部完全交的含义是概形态射能够分解为正则闭嵌入和光滑态射. 

#example[
  多项式代数
  $ B = k[x_1,...,x_n]/(f_1,...,f_r) $
  是拟光滑的, 因为
  $ LL_(B/k) simeq [B^(plus.o r) ->^J B^(plus.o n)] $
  天然只有 $[0,1]$.
]

#proposition[
  光滑, 平展, 拟光滑在复合下依然是光滑, 平展, 拟光滑的.
]
