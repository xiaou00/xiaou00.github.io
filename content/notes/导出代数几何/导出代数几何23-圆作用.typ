#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

在进入 Hochschild 理论之前, 我们先来讲清楚在代数几何中我们是怎么建模圆作用的.

= 什么是 $S^1$

== $S^1$ 作为群生象

一般而言, 在导出的语境中, 我们定义 $S^1 = B ZZ simeq K(ZZ,1)$. 一般的模型是取普通圆群
$ U(1) = {z in CC : abs(z)=1} $
取同伦型后就得到了
$ S^1 in EE_(oo)Grp(Ani) $
#note-ref("../意象论/意象论06-扭子与束.typ")[这篇文章]给出了该记号的详细含义.

#lemma[
  $EE_(oo)Grp(Ani) simeq Sp_(>=0)$.
]

#proof[
  回顾#note-ref("../意象论/意象论06-扭子与束.typ", target:<thm-deloop-cycle>), 我们有
  $ B^n : EE_(n)Grp(Ani) simeq Ani_(*,>=n) : Omega^n $
  设 $G$ 是 $EE_oo$-群生象, 则对每个 $n>=0$ 都有对应的 delooping
  $ X_n simeq B^n G $
  并且这些 delooping 相容, 即
  $ X_n simeq Omega X_(n+1) $
  从而得到了一个 $Omega$-谱 $X_bullet$. 我们构造了函子
  $ Phi : EE_(oo)Grp(Ani) -> Sp_(>=0) $
  另一方面, 设 $X in Sp_(>=0)$, 令
  $ X_n = Omega^oo Sigma^n X $
  就给出了互逆的操作, 令 $G=X_0$ 即可.
]

在这个含义下, $S^1$ 给出了一个连通谱 $S^1 in Sp_(>=0)$.

= 参数化复形

== 参数化的含义

#definition(title:[参数化])[
  设 $cal(C)$ 是 $oo$-范畴, $X$ 是一个生象, 则函子范畴
  $ Fun(X,cal(C)) simeq cal(C)^X $
  就称之为 *$X$ 参数化的 $cal(C)$* 构成的 $oo$-范畴.
]

#example[
  对于一个群 $G$, $B G$ 是其分类生象, 那么 $cal(C)^(B G) simeq Rep_G (cal(C))$ 是 $cal(C)$ 中对象的 $G$-表示.
]

== 参数化复形

#definition(title:[参数化复形])[
  设 $X$ 是生象, $k$ 是生象交换环, 则 *$X$-参数化复形*构成的 $oo$-范畴定义为
  $ Dcat(k)^X simeq Fun(X,Dcat(k)) $
]

一般地, 设 $f:X->Y$ 是生象的映射, 与 $f$ 复合诱导了拉回
$ f^* : Dcat(k)^Y -> Dcat(k)^X $
由于极限和余极限在预层中是逐点计算的, $f^*$ 与极限和余极限交换, 从而有伴随
$ f_! tack.l f^* tack.l f_* $

== 群代数

#definition(title:[导出群代数])[
  设 $A in CAlg_SS$ 是交换环谱, 并设 $G in EE_(1)Grp(Ani) simeq Ani_(*,>=1)$, 则定义
  $ A[G] := A times.o_SS Sigma^oo_+ G $
  因为
  $ Sigma^oo_+ : (Ani, times) -> (Sp, smash) $
  确实是对称幺半函子, 从而 $G$ 的乘法可以诱导
  $ A[G] times.o_SS A[G] -> A[G] $
]

特别地, 若 $G in EE_(oo)Grp(Ani) simeq Sp_(>=0)$, 则
$ A[G] in CAlg_(A\/) $

#theorem(title:[群代数的 Morita 等价])[
  对于上述假设, 有范畴等价
  $ Dcat(k)^X simeq Dcat(k[Omega X]) $
]

#proof[
  只需作 $G = Omega X in Grp(Ani)$, 于是
  $ Dcat(k)^X simeq Fun(B G,Mod_k) $
  我们只需证明
  $ Fun(B G,Mod_k) simeq LMod_(k[G]) $
  这是一个非常表示论的命题. 可证明如下: 取值函子 
  $ U : Fun(B G,Mod_k) -> Mod_k, quad F |-> F(*) $
  其左伴随是自由 $G$-作用
  $ F_G (M) = G times.o M $
  由于 $Mod_k$ 被空间张量化有
  $ G times.o M simeq (k times.o Sigma^oo_+ G) times.o_k M = k[G] times.o_k M $
  从而伴随 $F_G tack.l U$ 产生单子
  $ T(M) = k[G] times.o_k M $
  而 $T$-代数恰好是左 $k$-模, 由 Barr--Beck--Lurie 即证.
]

更进一步, 只需逐点张量就能在 $Dcat(k)^X$ 上定义对称幺半结构
$ (F times.o_X G)(x) := F(x) times.o_k G(x) $
这也相当于 $Dcat(k[Omega X])$ 上的对称幺半结构.

= 群作用

== 一般的群作用

#definition(title:[群作用])[
  给定一个 $G in Grp(Ani)$, $oo$-范畴 $cal(C)$ 上的一个 *$G$-作用*是指一个函子 $B G->cal(C)$, 也就是说其构成范畴
  $ cal(C)^G := Fun(B G,cal(C)) $
]

#example[
  $Vect_k$ 中的一个 $G$-作用就是 $G$ 的一个群表示, 即
  $ Rep_k (G) simeq Fun(B G, Vect_k) $
]

== 圆作用

#definition(title:[圆作用])[
  一个 $oo$-范畴 $cal(C)$ 中的*圆作用* (circle action) 是指
  $ cal(C)^(S^1) := Fun(B S^1, cal(C)) $
  中的对象, 这里视 $S^1 in EE_(oo)Grp(Ani) subset Grp(Ani)$.
]

#example[
  在经典的模情形, 有
  $ Mod_k^(S^1) simeq Mod_(k[S^1]) $
]


