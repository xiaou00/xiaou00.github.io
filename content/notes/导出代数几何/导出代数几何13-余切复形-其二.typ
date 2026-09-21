#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 是生象交换环, 从现在起 $tens_k$ 在导出语境里默认识别为 $dtens_k$.

= 余切复形的基本计算

== 自由代数规则

#proposition[
  设 $M in AniMod_k$ 是 $k$-生象模, 则自由代数
  $ LL_(LSym_k (M) / k) tilde.eq LSym_k (M) tens_k M $
]

#proof[
  我们证明其表示同一个导子函子, 为此我们来计算自由代数上的导子, 下面记 $A = LSym_k (M)$, 利用纤维序列
  $ Der_k (A,N) tilde.eq fib_(id_A) (Map_(AniCAlg_k) (A,A plus.o N) -> Map_(AniCAlg_k) (A,A)) $
  以及自由性
  $ Map_(AniCAlg_k) (LSym_k (M),B) tilde.eq Map_(AniMod_k) (M,U(B)) $
  得
  $ Der_k (A,N) tilde.eq fib_eta (Map_k (M,U(A plus.o N)) -> Map_k (M,U(A))), quad eta:M->U(A) $
  而作为 $k$-模显然有
  $ U(A plus.o N) tilde.eq U(A) plus.o U(N) $
  从而
  $ Map_k (M,U(A plus.o N)) tilde.eq Map_k (M,U(A)) times Map_k (M,U(N)) $
  于是在 $eta$ 上取纤维立刻得到
  $ Der_k (A,N) tilde.eq Map_(Mod_k) (M,N) $
]

#corollary[
  由于 $LSym(k^(plus.o n)) tilde.eq k[x_1,...,x_n]=: P_n$, 立即得
  $ LL_(P_n/k) tilde.eq A tens_k k^(plus.o n) tilde.eq A^(plus.o n) $
  一般我们记
  $ LL_(P_n/k) tilde.eq Omega^1_(P_n/k)[0] tilde.eq plus.o.big_(i=1)^n A dif x_i $
]

在这个情形下, 万有导子
$ d_(P_n/k) : P_n -> LL_(P_n/k) $
就是典范的
$ d_(P_n/k) (f) = sum_i frac(partial f,partial x_i) dif x_i $

== 传递序列

下面我们记伴随对
$ B tens_A (-) : Mod_A^(<=0) arrows.lr Mod_B^(<=0) : Res^B_A $

#proposition[
  设 $A,B in AniCAlg_k$ 以及态射 $f:A->B$, 我们有典范的纤维序列
  $ B tens_A LL_(A/k) ->^(f_*) LL_(B/k) -> LL_(B/A) $
]

#remark(title:[识别上述序列中的态射])[
  第一个态射 $f_*$ 可以识别为: 先将 $LL_(B/k)$ 沿着 $f:A->B$ 看作 $A$-模, 得到导子
  $ d_(B/k) compose f : A -> LL_(B/k) in Der_k (A,LL_(B/k)) $
  由 $LL_(A/k)$ 的泛性质, 导子唯一地对应到 $A$-模态射
  $ tilde(f)_* : LL_(A/k) -> Res^B_A (LL_(B/k)) $
  从而再由伴随即得
  $ f_* : B tens_A LL_(A/k) -> LL_(B/k) $
  第二个态射先考虑万有导子
  $ d_(B/A) : B -> LL_(B/A) $
  任何 $A$-导子自动是 $k$-导子, 从而可以忘掉 $A$-相对结构, 直接得到
  $ d_(B/A) in Der_k (B,LL_(B/A)) $
  利用 $LL_(B/k)$ 的泛性质
  $ Der_k (B,LL_(B/A)) tilde.eq Map_B (LL_(B/k),LL_(B/A)) $
  就得到了
  $ LL_(B/k) -> LL_(B/A) $
]

#proof[
  复合显然为零, 因为在导子层面该序列就是
  $ A ->^f B larr^(d_(B/A)) LL_(B/A) $
  而 $d_(B/A)$ 是 $A$-导子, 固然复合为零. 设 $C = cofib(f_*)$, 那么
  $
  Map_B (C,M) &tilde.eq fib(Map_B (LL_(B/k),M)->Map_B (B tens_A LL_(A\/k),M))\
  &tilde.eq fib(Der_k (B,M) -> Der_k (A,M)) \
  &tilde.eq Der_A (B,M) \
  &tilde.eq Map_B (LL_(B/A),M)
  $
  其中第二部用了限制标量伴随. 由 Yoneda 得出 $LL_(B/A) tilde.eq C$.
]

传递序列某些意义上可以理解成微分的 "链式法则" 在导出语境下的完整版本, 核心直觉是: $B/k$ 的全部无穷小变化 = 从 $A/k$ 传来的变化 + $B/A$ 自身的变化.

#corollary[
  对上述序列取 $pi_0$, 就得到了经典的
  $ B times.o_A Omega^1_(A/k) -> Omega^1_(B/k) -> Omega^1_(B/A) -> 0 $
]

== 基变换法则

#proposition[
  对 $A in AniCAlg_k$ 和生象环 $k->k'$, 有
  $ LL_((A tens_k k')/k') tilde.eq A' tens_A L_(A/k), quad A' = A tens_k k' $
]

#proof[
  先构造万有导子 
  $ d_(A'/k') : A' -> LL_(A'/k') $
  沿 $A->A'$ 限制得
  $ A -> A' larr^(d_(A'/k')) LL_(A'/k') $
  这是一个 $k$-导子, 因为 $k->k'->A$ 上的元素已经被 $d_(A'/k')$ 消掉. 从而由 $LL_(A/k)$ 的泛性质得到
  $ LL_(A/k) -> Res^(A')_A LL_(A'/k') $
  再由伴随就得到了比较态射
  $ A' times.o_A LL_(A/k) -> LL_(A'/k') $
  有
  $ Map_(A') (A' times.o_A LL_(A/k), M) &tilde.eq Map_A (LL_(A/k),Res M) \ &tilde.eq Der_k (A,M) $
  因为方块
  #web-diagram(diagram({
	node((-1, 0), [$k$])
	node((0, 0), [$A$])
	node((-1, 1), [$k'$])
	node((0, 1), [$A'$])
	edge((-1, 0), (-1, 1), "->")
	edge((-1, 0), (0, 0), "->")
	edge((0, 0), (0, 1), "->")
	edge((-1, 1), (0, 1), "->")
  }))
  是推出, 一个 $k'$ 导子 $d:A'->M$ 完全由其在 $A$ 上的限制决定, 反之一个 $k$ 导子可以典范地延拓到 $k'$. 于是有
  $ Map_(A') (A' times.o_A LL_(A/k), M) &tilde.eq Der_k (A,M) \ &tilde.eq Der_(k')(A',M) \ &tilde.eq Map_(A')(LL_(A'/k'),M) $
]

这个结论可以看作是 "Kähler 微分与平坦基变换相容" 的真正升级, 即余切复形与任何基变换相容.

= 商法则

下面我们来看一些普通环的余切复形的计算

== $k[x_1,...,x_n]/(f)$ 型

回顾交换代数中的定义

#definition(title:[正则元])[
  一个元素 $f in R$ 是*正则元*, 是指
  $ R -->^(dot f) R $
  是单射.
]

一般来说, 正则元和非零因子是等价的.

#proposition[
  设 $B = k[x_1,...,x_n]/(f)$, 其中 $f$ 是正则元, 则余切复形形如
  $ LL_(B/k) tilde.eq [B dot [f] larr^(d f) plus.o.big_(i=1)^n B dif x_i] tilde.eq [B larr^((partial_1 f,...,partial_n f)) B^(plus.o n)] $
  其中
  $ d f : [f] |-> sum_(i=1)^n frac(partial f,partial x_i) dif x_i $
]

#proof[
  考虑复合
  $ k -> P -> B $
  则由传递序列
  $ B times.o_P LL_(P/k) -> LL_(B/k) -> LL_(B/P) $
  识别两端, 由于 $P$ 是多项式代数
  $ LL_(P/k) tilde.eq plus.o.big_(i=1)^n P dif x_i $
  第一项为
  $ plus.o.big_(i=1)^n B dif x_i $
]
