#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

#remark[本节中, 固定 $k$ 为任给的交换环.]

= 单纯与模型范畴

== 单纯交换 $k$-代数

回顾范畴 $CAlg_k$, 也就是交换 $k$-代数的 1-范畴. 他可以定义为 $CAlg(Mod_k)$, 也可以等价地视作形如 $k->A$ 的交换环态射的全体对显然的态射.

#definition(title:[单纯交换 $k$-代数])[
  *单纯交换 $k$-代数*就是交换 $k$-代数范畴 $CAlg_k$ 中的单纯对象, 即
  $ simp(CAlg_k) := Fun(Delta^opp, CAlg_k) $
  构成的 1-范畴.
]

我们知道, 在抽象代数里我们了解过函子
$ "Sym"_k : Mod_k -> CAlg_k $
将一个 $k$-模送到自由生成的交换 $k$-代数, 并且有自由-遗忘伴随
$ "Sym"_k : Mod_k arrows.lr CAlg_k : "oblv" $
而集合范畴到模范畴也有完全类似的函子
$ k[-] : Set arrows.lr Mod_k : "oblv" $
为以集合为基自由生成的 $k$-模.

一个范畴的单纯对象范畴 $cal(C)|->simp(cal(C))$ 给出了一个函子 $cat("s"):Cat->Cat$, 逐函子 $F:cal(C)->cal(D)$ 定义为
$ simp(F) : simp(cal(C)) -> simp(cal(D)), quad X_bullet |-> F compose X_bullet $
也就是
$ (X_bullet : Delta^opp -> cal(C)) |-> (Delta^opp larr^(X_bullet) cal(C) ->^F cal(D)) $
容易验证在单纯对象层面我们依然有连续的伴随
$ Set arrows.lr Mod_k arrows.lr CAlg_k $

== Quillen 模型

=== 基本定义

#definition(title:[弱等价])[
  一个单纯集映射 $f:X_bullet->Y_bullet$ 若在几何实现下诱导的 $abs(f):abs(X_bullet)->abs(Y_bullet)$ 是一个弱同伦等价, 则称之为一个*弱等价* (weak equivalence).
]

#definition(title:[Quillen 模型])[
  在 $sSet$ 上有下述的模型结构:

  + 弱等价为单纯集之间的弱等价.
  + 余纤维化为逐点的单射.
  + 纤维化是*Kan纤维化*, 即对任何角包含 $Lambda^n_i subset Delta^n$ 具有右提升性质的全体态射族.

  称之为 *Quillen 模型*, 其余纤维化也可以等价地描述为, 对 $"KanFib" inter W$ 具有左提升性质的态射类.
]

一般而言, 生象的无穷范畴就定义为 Quillen 模型下, $sSet[W^(-1)]$ 作为 $oo$-范畴的局部化 ($W$ 是弱等价的族), 记作 $Ani$.

=== 传递到 $simp(Mod_k)$

接下来我们通过自由-遗忘伴随

$ k[-] : sSet arrows.lr simp(Mod_k) : "oblv" $

将这个模型传递

#definition(title:[$simp(Mod_k)$ 上的 Quillen 模型])[
  我们可以在 $simp(Mod_k)$ 上定义下述的模型结构:

  + $f:M->N$ 是弱等价当且仅当 $"oblv"(f)$ 是 $sSet$ 的 Quillen 模型中的弱等价.
  + $f:M->N$ 是纤维化当且仅当 $"oblv"(f)$ 是 Kan 纤维化.
  + $f$ 是余纤维化当且仅当其对上述两族态射的交具有左提升性质.
]

这个模型非常有意思, 因为通过 Dold--Kan 对应
$ DK : simp(Mod_k) <-->^~ Ch_(>=0) (k) : Gamma  $
其中
$ DK_n (M) := inter.big^n_(i=1) ker(d_i : M_n -> M_(n-1)) $
微分取
$ d = d_0 : DK_n (M) -> DK_(n-1) (M) $

而在 $Ch_(>=0) (k)$ 上, 我们也有一个很重要的模型结构

#definition(title:[$Ch_(>=0) (k)$ 上的投射模型])[
  在 $Ch_(>=0) (k)$ 上可以定义*投射模型结构*为:

  1. 弱等价定义为链复形的拟同构.
  2. 纤维化是在 $n>0$ 次上逐阶满射的链映射.
  3. 余纤维化是*投射余纤维化*, 即 $i:C_bullet->D_bullet$ 是逐次单射, 并且其余核 (商) 复形 $D_bullet/C_bullet$ 在每个次数 $D_n/i_n (C_n)$ 上都是投射 $k$-模.
]

这个模型范畴中的余纤维替换就是同调代数里的*投射解消*, 可以用于计算左导出信息.

#proposition[
  $simp(Mod_k)$ 的 Quillen 模型在 Dold--Kan 对应下恰好是 $Ch_(>=0) (k)$ 的投射模型, 三类态射都恰好对应.
]

$Ch_(>=0)(k)$ 逆掉所有的拟同构恰好是导出范畴的定义, 实际上我们有
$ Ner(Ch_(>=0)(k))["qis"^(-1)] simeq Ner^"dg" (Ch_(>=0)(k))["qis"^(-1)] simeq Dcat_(>=0)(k) $
从而 $simp(Mod_k)[W^(-1)] simeq Dcat_(>=0)(k)$ 是一种 Dold--Kan 对应.

#proposition(title:[同伦--同调对应])[
  我们可以将 $X_bullet in simp(Mod_k)$ 遗忘成单纯集后取几何实现, 以零元为基点可作同伦群 $pi_n (abs(X_bullet),0)$. 我们也可以定义单纯集的同伦群为显然的 $pi_n^"simp" (X_bullet,0) := [S^n,X_bullet]$, 其中 $S^n := Delta^n/partial Delta^n$. 那么我们有
  $ pi_n (abs(X_bullet),0) simeq pi_n^"simp" (X_bullet,0) simeq H_n (DK(X)) $
] <prop-simplicial-module-homotopy-homology>

#proof[
  由 Dold--Kan
  $ DK_n (X) = inter.big_(i=1)^n ker ( d_i : X_n -> X_(n-1) ) \
  d = d_0 : DK_n (M) -> DK_(n-1) (M) $
  其中 $d_i$ 是面映射, 下面观察这个链复形的闭链
  $ Z_n (DK(X)) = ker (d_0 : DK_n (X) -> DK_(n-1) (X)) $
  因为 $x in DK_n (X)$ 本身已经满足
  $ d_1 x = ... = d_n x = 0 $
  再加上核条件 $d_0 x = 0$, 所以 $Z_n (DK(X))$ 恰好就是所有边都退化到 $0$ 的 $n$-单形, 从而映射 $Delta^n -> X$ 下降成 $Delta^n/partial Delta^n = S^n -> X$, 从而闭链恰好是基点的 $n$-球代表.

  接下来再看边界, 我们有
  $ B_n (DK(X)) = d_0 (DK_(n+1) X) $
  也就是说一个边界长成 $x=d_0 y$, 其中
  $ y in X_(n+1), quad d_1 y = ... = d_(n+1) y = 0 $
  而这样的一个 $y$ 恰好提供了 $x$ 的一个单纯零伦, 从而 $x$ 在 $pi_n (X)$ 中为零当且仅当 $x in d_0 (DK_(n+1)(X))$. 从而我们证明了
  $ pi_n^"simp" (X,0) simeq frac(Z_n (DK(X)),B_n (DK(X))) simeq H_n (DK(X)) $
]

这个结论很有启发性, 它告诉我们如果一个同伦对象能够用单纯 Abel 群建模,那么其同伦群可以用链复形的同调计算.

= 单纯交换 $k$-代数

== 单纯交换 $k$-代数的模型结构

我们再考察自由-遗忘伴随

$ "Sym" : simp(Mod_k) arrows.lr simp(CAlg_k) : "oblv" $

#definition(title:[$simp(CAlg_k)$ 上的 Quillen 模型])[
  我们可以在 $simp(CAlg_k)$ 上定义下述的模型结构:

  + $f:A->B$ 是弱等价当且仅当 $"oblv"(f)$ 是 $simp(Mod_k)$ 的 Quillen 模型中的弱等价.
  + $f:A->B$ 是纤维化当且仅当 $"oblv"(f)$ 是 $simp(Mod_k)$ 的纤维化.
  + $f$ 是余纤维化当且仅当其对上述两族态射具有左提升性质.
]

我们先承认几个结论:

#theorem[
  前面定义的两对伴随
  $ 
  k[-]:sSet arrows.lr simp(Mod_k):"oblv"\
  "Sym":simp(Mod_k) arrows.lr simp(CAlg_k):"oblv"
  $
  是 Quillen 伴随.
]

#proposition[
  Dold--Kan 对应函子 $DK:simp(Mod_k) -> Ch_(>=0)(k)$ 是松对称幺半函子, 配对的比较态射是 shuffle map
  $ nabla_(X,Y) : DK(X) times.o DK(Y) -> DK(X times.o Y) $
] <prop-dold-kan-lax-symmetric-monoidal>

#remark(title:[shuffle map 的构造])[
  取 $x in DK_p (X)$ 和 $y in DK_q (Y)$, 一个 *$(p,q)$-shuffle* 就是将
  $ {0<...<p+q-1} $
  无交地拆分为两个保序子集
  $ {mu_1<...<mu_p}, quad {nu_1<...<nu_q} $
  那么我们定义 shuffle map 为
  $ nabla (x times.o y) = sum_(mu,nu) (-1)^(epsilon(mu,nu)) s_(nu_q) ... s_(nu_1) x times.o s_(mu_p) ... s_(mu_1) y $
  其中 $s$ 是退化映射, 符号是这个 shuffle 的奇偶性, 取
  $ epsilon(mu,nu) := \# {(i,j):nu_j<mu_i} $
]

#corollary[
  Dold--Kan 对应诱导了函子
  $ DK : Alg(simp(Mod)_k) -> Alg(Ch_(>=0)(Mod_k)) $
  也就是
  $ DK : simp(Alg_k) -> dga_(k,>=0) $
  注意这个函子一般不是范畴等价, 因为 $DK$ 只是松的对称幺半函子, 并不是严格的. 类似地也有
  $ DK : simp(CAlg_k) -> cdga_(k,>=0) $
]

== dga 和 cdga 的模型结构

=== dga 的模型结构

我们有伴随对
$ T : Ch_(>=0) (k) arrows.lr dga_(k,>=0) : "oblv" $
其中
$ T(V) = k plus.o V plus.o V^(times.o 2) plus.o ... $
是张量代数, 我们自然可以在 $dga_(k,>=0)$ 上定义自然转移的模型结构.

#definition(title:[dga 的模型结构])[
  我们可以给非负次数 dga 定义标准的模型结构:

  + 弱等价是拟同构.
  + 纤维化是逐正次数的满射.
  + 余纤维化自然诱导.
]

局部化得到 $dga_(k,>=0) ["qis"^(-1)]$ 就是连通结合导出 $k$-代数的一个模型. $oo$-范畴角度我们可以干净地写
$ dga_(k,>=0) ["qis"^(-1)] simeq Alg_(EE_1) (Dcat_(>=0) (k)) $
并且在谱代数的意义下
$ Dcat_(>=0) (k) simeq Mod_(H k,>=0) $
是对称幺半稳定 $oo$-范畴的等价, 从而
$ dga_(k,>=0) ["qis"^(-1)] simeq Alg(Mod_(H k))_(>=0) $
右边是 $H k$ 上的连通结合代数谱, 常称为*导出代数*.

=== cdga 的模型结构

同样地, 我们有伴随对 
$ "Sym" : Ch_(>=0) (k) arrows.lr cdga_(k,>=0) : "oblv" $
其中 $"Sym"$ 是对称代数.

但 cdga 的情形有些许不同, 当 $k$ 取任意的交换环时, 会存在自然的比较函子
$ cdga_(k,>=0) ["qis"^(-1)] -> CAlg(Dcat_(>=0)(k)) $
但一般不是等价: 关键在于底层的局部化函子
$ L : Ch_(>=0) (k) -> Dcat_(>=0) (k) $
中, 左边用的是普通张量 $times.o_k$, 右边是导出张量 $times.o^"L"_k$. 从而 $L$ 一般不是对称幺半的, 而是松对称幺半的. 之所以结合代数可以, 是因为结合代数不涉及 $S_n$-作用取商.

= 同调分次环

== 同调分次环的构造

设 $R_bullet in simp(CAlg_k)$, 那么定义
$ pi_* R := plus.o.big_(n>=0) pi_n (R) $
由@prop-simplicial-module-homotopy-homology, 这也可以视作是
$ H_* (DK(R)) = plus.o.big_(n>=0) H_n (DK(R)) $
由于 $R_bullet$ 有乘法
$ mu : R_bullet times.o_k R_bullet -> R_bullet $
使得 $pi_* R$ 构成一个非负的分次交换 $k$-代数, 而 $pi_0 R$ 也是一个普通的交换 $k$-代数, 有函子伴随对
$ pi_0 : simp(CAlg_k) arrows.lr CAlg_k : c $
其中 $c$ 将普通的交换 $k$-代数视作常值的单纯代数, 每个 $pi_n$ 也是函子
$ pi_n : simp(CAlg_k) -> Mod_k $
将所有次数放在一起就得到
$ pi_* : simp(CAlg_k) -> cat("GrCAlg")_(k,>=0) $
并且同调分次环的乘法满足 Koszul 符号交换律
$ x y = (-1)^(p q) y x, quad x in pi_p R_bullet, y in pi_q R_bullet $
