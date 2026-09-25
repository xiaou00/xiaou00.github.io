#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 1-范畴定义

我们先来给出这三个函子的经典定义与意义

== $Sym$ 函子

显然, 我们有对称群 $S_n$ 通过置换因子作用在 $M^(times.o n)$ 上, 定义
$ Sym^n_k (M) := (M^(times.o_k n))_(S_n) $
亦即商掉关系
$ m_1 times.o ... times.o m_n ~ m_(sigma(1)) times.o ... times.o m_(sigma(n)) $
而总对称代数
$ Sym_k (M) = plus.o.big_(n>=0) Sym^n_k (M) $
也可以定义成
$ Sym_k (M) = T_k (M) / chevron.l x times.o y - y times.o x | x , y in M chevron.r $
核心泛性质是
$ Hom_(CAlg_k) (Sym_k (M),A) simeq Hom_(Mod_k) (M,A) $
即他是遗忘函子的左伴随.
$ Sym : Mod_k -> CAlg_k $

== $Lambda$ 函子

我们可以直接定义外幂代数为
$ Lambda_k (M) := T_k (M) / chevron.l x times.o x | x in M chevron.r $
有自然的分次
$ Lambda_k (M) = plus.o.big Lambda^n_k (M) $
其中 $Lambda^n_k (M)$ 是次数 $n$ 部分. 等价地其由交错多线性映射表示
$ Hom_k (Lambda^n (M),N) simeq "Alt"^n_k (M,N) $
其中
$ f:M^n -> N $
是交错的, 也就是说只要 $x_i=x_j, i!=j$, 就立即有
$ f(x_1,...,x_n) = 0 $
$Lambda^n$ 的生成元一般就是 $x_1 and ... and x_n$.

== $Gamma$ 函子

$Gamma$ 函子, 或称*除幂代数* (divided power algebra) 函子. 具体地, $Gamma$ 是由符号
$ gamma_n (x), quad x in M, n>=0 $
生成的交换分次 $k$-代数, 满足除幂关系:

+ $gamma_0(x)=1$, $gamma_1(x)=x$.
+ $gamma_n (a x) = a^n gamma_n (x)$.
+ $gamma_n (x+y) = sum_(i+j=n) gamma_i (x) gamma_j (y)$.
+ $gamma_m (x) gamma_n (x) = binom(m+n,m)gamma_(m+n)(x)$.

定义
$ Gamma_k (M) = plus.o.big_(n>=0) Gamma^n_k (M) $
是 $n$ 次部分. 形象地, 我们可以将 $gamma_n (x)$ 理解成
$ frac(x^n,n!) $
不过一般环中并没有 $n!$, $Gamma$ 构造本质上是将这个想法内在化. 他满足泛性质为
$ Hom_k (Gamma^n_k (M),N) simeq "Pol"^n_k (M,N) $
其中右边是 $n$ 次的齐次多项式范畴.

== 一些结论

#proposition[
  若 $M$ 是有限投射模, 则
  + $ Gamma^n (M) simeq (Sym^n (M^or))^or $
  + $ (Lambda^n (M^or))^or simeq Lambda^n (M) $
]

= 移位

== 函子的导出

我们现在可以将上面的三个函子都导出, 即通过他们在
$ Mod_k^(omega"p") $
上的行为来延拓. 我们可以定义
$ AniMod_k -> AniCAlg_k $
上的函子
$ LSym, quad LLambda, quad LGamma $

== 移位的证明

#theorem(title:[移位 (Décalage)])[
  设 $k$ 是生象交换环, $M$ 是生象 $k$-模, 则:

  + 存在自然等价 $LSym^s (M[1]) simeq LLambda^s (M)[s]$.
  + 存在自然等价 $LLambda^s (M[1]) simeq LGamma^s (M)[s]$.
]

#proof[
  暂略.
]
