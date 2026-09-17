#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 投射模与合冲

本节中, 固定 $R$ 为一般的环.

== 投射模回顾

#definition(title:[投射模])[
  固定环 $R$, 我们定义 $Mod_R$ 中的*投射模* (projective module) 为满足下列等价条件的模 $P$:

  + $P$ 对所有满射具有提升性质, 即对任意满射 $q:M->>N$ 和任意模同态 $f:P->N$ 都存在唯一的 $tilde(f):P->M$ 使得 $q compose tilde(f) = f$.
  + 函子 $Hom_R (P,-)$ 是正合函子, 这等价于验证其保持满射.
  + 存在模 $Q$ 使得 $P plus.o Q tilde F$, 其中 $F$ 是自由模.
  + 任意短正合列
    $ 0 -> A -> B -> P -> 0 $
    都分裂.
]

证明是基础代数的, 我们知道投射模可以视作自由模的推广. 某些意义上可以视作是向量丛之于平凡向量丛的关系. (交换环上的有限秩投射模对应仿射几何的向量丛.)

== 投射解消

一般而言, 定义*投射解消* (projective resolution) 是一个长正合列
$ ... -> P_2 -> P_1 -> P_0 -> M -> 0 $
每一个 $P_i$ 都是投射模, 等价地, 我们前面也提到这也可以视作是一种纤维替换 (拟同构)

#web-diagram(diagram({
	node((-1, -1), [$0$])
	node((0, -1), [$M$])
	node((1, -1), [$0$])
	node((0, -2), [$P_0$])
	node((-1, -2), [$P_1$])
	node((-2, -2), [$...$])
	node((1, -2), [$0$])
	node((-2, -1), [$...$])
	node((2, -2), [$...$])
	node((2, -1), [$...$])
	edge((-2, -2), (-1, -2), "->")
	edge((-1, -2), (0, -2), "->")
	edge((0, -2), (1, -2), "->")
	edge((1, -2), (2, -2), "->")
	edge((-2, -1), (-1, -1), "->")
	edge((-1, -1), (0, -1), "->")
	edge((0, -1), (1, -1), "->")
	edge((1, -1), (2, -1), "->")
	edge((1, -2), (1, -1), "->")
	edge((0, -2), (0, -1), "->")
	edge((-1, -2), (-1, -1), "->")
}))

投射解消的意义非常明确, 因为在导出范畴中, 这两个复形可以视作是同构
$ P_bullet tilde.eq M $
可以理解成投射解消是用同调上等价但更容易计算的链复形代替原本的模, 我们可以在复形的意义下, 定义
$ M times.o^"L"_R N = P_bullet times.o_R N, quad "RHom"_R (M,N) = Hom_R (P_bullet,N) $
同样也允许我们计算导出函子, 并且在有充分投射对象的假设下, 投射解消是总是存在的.

== 合冲

#definition(title:[合冲模])[
  设 $R$ 是环, $M$ 是一个 $R$-模, 一个*合冲模* (syzygy module) 首先需要指定一个投射模 (或自由模) 满射 $P_0 ->> M$ 并定义第一合冲为其核
  $ Omega^1 (M) := ker (P_0 ->> M) $
  再给 $Omega^1 (M)$ 取投射模 (自由模) 满射 $P_1 ->> Omega^1 (M)$ 并定义
  $ Omega^2 (M) := ker (P_1 ->> Omega^1 (M)) $
  反复下去得到 $Omega^n (M)$ 就统称为 $M$ 的*合冲* (syzygy). 记 $Omega^0 (M):=M$.
]

显然对每一阶的合冲都有短正合列
$ 0 -> Omega^(n+1) (M) -> P_n -> Omega^n (M) -> 0 $
将其首尾拼接
$ ... -> P_2 ->^(d_2) P_1 ->^(d_1) P_0 ->^(d_0) M $
这里每个微分定义为复合
$ d_n : P_n ->> Omega^n (M) arrow.hook P_(n-1) $
显然有
$ im d_n = Omega^n (M), quad ker(d_(n-1)) = Omega^n (M) $
于是这个复形正合, 确实是投射解消. 投射解消可以理解成一种不断取合冲的过程.

= 单纯模解消

回顾单纯模的理论, 尤其是#note-ref("./导出代数几何02-单纯交换环.typ",target:<prop-simplicial-module-homotopy-homology>)[同伦群与同调群的对应]以及其背后的模型等价.

== 单纯解消的定义

我们可以典范地将一个 $R$-模 $M$ 视作是 $simp(Mod_R)$ 中的一个常值对象 $c M$, 一个*增广* (augmentation) 就是一个单纯模的映射
$ P_bullet -> c M $

#definition(title:[单纯解消])[
  若 $R$-模 $M$ 的一个单纯模增广 $P_bullet -> c M$ 是 $simp(Mod_R)$ 模型中的弱等价, 则称之为一个*单纯解消*.
]

显然, 若 $P_bullet -> c M$ 是单纯解消, 那么 $pi_0 (P_bullet) tilde.eq M$, 并且 $pi_n (P_bullet) = 0$ 对于 $n>0$.
由 Dold--Kan, 这等价于
$ ... -> DK_2 (P) -> DK_1 (P) -> DK_0 (P) -> M -> 0 $
正合.

#proposition[
  若 $P_bullet -> M$ 是单纯解消, 那么在 $Dcat_(>=0)(R)$ 中有 $M tilde.eq abs(P_bullet)$.
]

#proof[
  显然 $DK(P_bullet) ->^~ M[0]$ 是拟同构, 他们在 $Dcat_(>=0) (R)$ 是等价的, 另一方面在 Dold--Kan 等价下
  $ simp(Mod_R)[W^(-1)] tilde.eq Dcat_(>=0)(R) $
  $P_bullet$ 的几何实现对应的对象恰好是 $DK(P_bullet)$.

]

== 单纯投射解消

#definition(title:[单纯投射解消])[
  设 $P_bullet -> M$ 是单纯解消, 若每个 $P_n$ 都是投射 $R$-模, 则称之为一个*单纯投射解消*.
]

回顾恒等式
$ P_n tilde.eq plus.o.big_([n]->>[k]) DK_k (P) $
也就是 Dold--Kan 的逆公式
$ Gamma(C)_n = plus.o.big_([n]->>[k]) C_k $
我们有如下命题

#proposition[
  设 $P_bullet$ 是单纯模, $P_bullet$ 逐度数投射当且仅当 $DK(P_bullet)$ 逐度数投射.
]

#proof[
  由于
  $ P_n tilde.eq plus.o.big_([n]->>[k]) DK_k (P) $
  从而 $DK_n (P)$ 是直和因子, 若每个 $P_n$ 投射, $DK_n (P)$ 也投射. 反之, 若每个 $DK_n (P)$ 投射, 那么
  $ P_n tilde.eq plus.o.big_k DK_k (P)^(plus.o binom(n,k)) $
  也投射.
]

也就是说, 单纯投射解消恰好对应了复形意义下的投射解消.

= 标准自由单纯解消

单纯解消的语言有一个天然的优势, 允许我们可以构造一个完全标准, 函子性的自由解消.

== 预备: 余单子结构

考虑伴随
$ F : Set arrows.lr Mod_R : U $
其中 $F(S):=R^(S)$ 是 $S$ 上的自由 $R$-模, 其右伴随是遗忘函子, 我们定义

$ G = F compose U : Mod_R -> Mod_R $
从而 $G(M)=R^(U(M))$ 是将 $M$ 先视作集合后, 再直接生成新的 $R$-模. 我们有自然的满射
$ epsilon_M : G(M) -> M, quad [m] |-> m $
其中 $[m]$ 是对应于集合元素 $m in U(M)$ 的自由基.

#proposition[
  $G = F compose U$ 有典范的余单子结构
  $ epsilon:G->id_(Mod_R), quad delta:G->G^2 $
  其中 $delta = F eta U$, 而 $eta : id_Set -> U compose F$ 是伴随的余单位. 例如 $delta_M ([m]) = [[m]]$.
]

#remark[
  记号 $F eta U$ 代表单子论中的*加函子* (whiskering) 操作, 即
  $ (F eta U)_M = F(eta_(U(M))) : F U (M) -> F U F U (M) $
]

== 从单子中构造单纯对象

我们现在可以构造
$ B_n (M) = G^(n+1) (M) $
每一级显然都是自由模, 接下来我们来给出单纯结构的构造, 面映射可以定义为
$ d_i = G^i epsilon G^(n-i) : B_n (M) -> B_(n-1) (M), quad 0<=i<=n $
以及退化映射
$ s_i = G^i delta G^(n-i) : B_n (M) -> B_(n+1) (M), quad 0<=i<=n $
显然, 由余单纯恒等式可以推出单纯恒等式, 因此这确实使得 $B_bullet (M)$ 构成了一个单纯模, 并且每一级都是自由模. 再加上增广
$ B_0 (M) = G(M) -->^(epsilon_M) M $

最后我们来看一个最重要的定理

#theorem[
  上述自然诱导的 $B_bullet (M) -> M$ 确实是解消. 也就是说这是一个弱等价.
]

#proof[
  略. 具体可参考 Charles Weibel, An Introduction to Homological Algebra, Chapter 8, §8.6
]

== 计算 $Mod_R$ 的紧对象

#lemma[
  $M$ 是 $Mod_R$ 的投射对象当且仅当是投射模.
]

#proofsketch[
  正向
  $ P "是投射模" <=> Hom(P,-) "正合" => "保持余核" => "保持几何实现" $
  反向对任意满射 $E->>M$ 取 Cech 脉
  $ abs(E^(times_M (bullet + 1))) tilde.eq M $
  于是
  $ Hom(P,E) ->> Hom(P,M) $
  所以 $P$ 满足提升性质, 从而是投射模.
]

#theorem[
  $Mod_R$ 的紧投射对象是有限生成的投射模.
]

#proof[
  先设 $P$ 有限生成且投射, 选择有限的生成元得到满射
  $ R^n ->> P $
  由于 $P$ 投射, 这个满射分裂, 所以
  $ P arrow.hook R^n ->> P, quad P "是" R^n "的收缩" $
  $R$ 显然是紧的, 从而 $R^n$ 也紧, 由于紧对收缩封闭, $P$ 紧, $P$ 原本就投射, 得证.

  反之设 $P$ 紧且投射, 取任意自由满射
  $ q : R^I ->> P $
  因为 $R$ 投射, 存在截面
  $ s : P -> R^I $
  满足 $q compose s = id_P$. 我们可以把无限自由模写成滤过余极限
  $ R^I tilde.eq varinjlim(J subset I\, J "有限") R^J $
  由于 $P$ 紧, 有
  $ Hom_R (P,R^I) tilde.eq varinjlim(J subset I\, J "有限") Hom_R (P,R^J) $
  映射 $s:P->R^I$ 必然已经在某个有限阶段出现: 即存在有限集合 $J subset I$ 和
  $ s_J : P -> R^J $
  使得
  $ s = (P -->^(s_J) R^J arrow.hook R^I) $
  令
  $ q_J : R^J arrow.hook R^I -->^q P $
  那么 $q_J s_J = q s = id_P$, 于是 $P$ 是有限自由模 $R^J$ 的直和因子, 从而 $P$ 是有限生成的自由模.
]

= 杠解消

上述说的全部内容都是杠解消的特例: 杠解消可以理解成一个余单子反复作用产生的典范单纯解消. 下设
$ F:cal(C) arrows.lr cal(D):G $
是伴随, 单位和余单位分别是
$ eta : id_(cal(C)) -> U F, quad epsilon : F U -> id_(cal(D)) $
令 $G = F U : cal(D)->cal(D)$, 则 $G$ 典范构成余单子, 余乘法为
$ delta : F eta U : G -> G^2 $

== 杠解消的定义

#definition(title:[杠解消])[
  对伴随对 $F:cal(C) arrows.lr cal(D):G$, 定义*杠解消* (bar resolution) 为
]
