#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 完美复形

== 完美复形的定义和等价

#definition(title:[完美复形])[
  设 $A$ 是 $EE_oo$-环 (本节语境中, 交换生象环), 我们定义*完美复形* (perfect complex) 为范畴
  $ Perf(A) := Mod_A^omega $
  即导出模范畴的紧对象范畴.
]

在离散的情况下, 这个概念可以视作是*向量丛* (vector bundle) 的导出推广, 这个在我们定义了导出概形之后会再次重访.

我们定义 $Cell^"fin"_A$ 为 $A$ 从有限次移位, 有限直和和余纤维构造出的 $Mod_A$ 的全子范畴, 我们将证明其收缩恰是所有完美复形, 即

#proposition[
  有范畴的等价
  $ Perf(A) tilde.eq Idem(Cell^"fin"_A) $
]

#proof[
  首先 $A$ 是紧的, 这源自一个事实:
  $ Map_A (A,M) tilde.eq Omega^oo M $
  保持滤过余极限. 紧对象在稳定 $oo$-范畴中对有限余极限, 移位和收缩封闭, 故 $cal(D):=Idem(Cell^"fin"_A) subset Perf(A)$.

  反过来, 注意到 $A$ 是 $Mod_A$ 的紧生成元, 若
  $ Map_A (A[n],M) tilde.eq *, quad (forall n in ZZ) $
  则 $pi_n M = 0$ 对任意 $n$ 成立, 从而 $M tilde.eq 0$. 回顾一个标准结论
  #lemma[
    若可呈示 $oo$-范畴 $cal(C)tilde Ind(S)$ 且 $S$ 由紧对象构成, 则
    $ cal(C)^omega = "thick"(S) $
    其中 $"thick"(S)$ 是含 $S$ 且对有限余极限, 移位和收缩封闭的最小子范畴.
  ]

  这个引理来自 HTT Proposition 5.3.5.11 和 HTT Lemma 5.4.2.4, 由定义即证.
]

#proposition[
  完美复形 $M in Perf(A)$ 具有有界 Tor 振幅.
]

#proof[
  记
  $ cal(T) = {M in Mod_A : M "的 Tor 振幅有界"} $
  只需证明 $cal(T)$ 是包含 $A$ 的粗 (对有限余极限, 移位, 收缩封闭) 的子范畴即可. 首先 $A$ 显然具有有限振幅.

  若 $M$ 具有振幅 $[a,b]$, 则 $M[r]$ 显然具有振幅 $[a+r,b+r]$.

  若
  $ M_1 -> M_2 -> M_3 $
  是余纤维序列, 且 $Amp(M_1) subset [a,b], Amp(M_2) subset [c,d]$, 则对任意离散的 $N$, 有余纤维序列
  $ M_1 times.o_A N -> M_2 times.o_A N -> M_3 times.o_A N $
  由同伦长正合列有
  $ M_3 times.o_A N in Mod_A^[min(c,a+1),max(d,b+1)] $
  从而 $M_3$ 仍然有有限 Tor 振幅. 有限直和同理.

  若 $M$ 是 $P$ 的收缩, 则 $M times.o_A N$ 是 $P times.o_A N$ 的收缩, 而 $Mod^[a,b]_A$ 对收缩封闭.

  综上, 这就证明了
  $ Perf(A) = "thick"(A) subset cal(T) $
]

== 几乎完美复形

#definition(title:[几乎完美复形])[
  设 $A$ 是生象交换环, 一个 $A$-导出模 $M$ 称为*几乎完美*的, 是指:

  + $M$ 有下界, 即 $M in Mod^(>=m)_A$ 对某个 $m$.
  + 对每个 $n$, 截断 $tau_(<=n)M$ 是 $Mod^(<=n)_A$ 的紧对象.
]

显然完美复形总是几乎完美的, 因为有限操作保证了下界性, 并且截断的泛性质给出了对于 $X_i in Mod^(<=n)_A$, 有
$ Map_A (tau_(<=n)M,colim_i X_i) tilde.eq Map_A (M,X_i) $
不难验证
$ Map_A (tau_(<=n)M,colim_i X_i) tilde.eq colim_i Map_A (tau_(<=n)M,X_i) $

#lemma(title:[导出 Nakayama 引理])[
  若 $M in Mod_A$ 有下界, 则对任意 $n in ZZ$ 有
  $ M times.o_A pi_0 A in Mod^(>=n)_(pi_0 A) => M in Mod^(>=n)_A $
  特别地
  $ M times.o_A pi_0 A tilde.eq 0 => M tilde.eq 0 $
]

#proof[
  设 $M!=0$ 并令 $r=min{i|pi_i M!=0}$, 考虑典范的 $A->R:=pi_0 A$, 记纤维为
  $ I -> A -> R $
  由 $A$ 连通, $A->pi_0A$ 截掉所有正次数同伦 $I in Mod^(>=1)_A$, 故张量 $M$ 得纤维序列
  $ M times.o_A I -> M -> M times.o_A R $
  且由 $M in Mod^(>=r)_A, I in Mod^(>=1)_A$, 连通性在张量下相加, 故
  $ M times.o_A I in Mod^(>=r+1)_A $
  因此取第 $r$ 同伦, 纤维序列给出同构
  $ pi_r M ->^~ pi_r (M times.o_A R) $
  特别地, 因为 $pi_r M!=0$, 后者也非零, 从而若 $M times.o_A R in Mod^(>=n)_A$, 假若 $M in.not Mod^(>=n)$ 会致使该群为零的矛盾. 证毕.
]

下面的判据非常重要

#proposition[
  $M in Mod_A$ 是完美复形当且仅当其为几乎完美的, 并且具有有界 Tor 振幅.
]

#proof[
  正向已证. 记 $R=pi_0A$. 设 $M$ 几乎完美, 且 $Amp(M) subset [a,b]$, 适当平移后可设 $Amp(M) subset [0,n]$. 由于 $M$ 有下界, 且
  $ M times.o_A R in Mod^[0,n]_R $
  由导出 Nakayama, $M in Mod^(>=0)_A$. 下面对 $n$ 归纳证明. 对 $n=0$, $M$ 振幅为 $[0,0]$, 即平坦. 因为 $M$ 几乎完美, $pi_0 M$ 有限表示, 有因为其平坦, $pi_0 M$ 有限生成且投射. 有限生成投射 $R$-模
]
