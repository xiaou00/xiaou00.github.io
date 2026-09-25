#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= Hodge 滤过的动机

我们回顾之前构造的 de Rham 复形
$ "L"Omega_(-/k) : AniCAlg_k -> CAlg(Dcat(k)) $
最初我们其实有一个明确的次数信息
$ Omega^1, Omega^2, Omega^3, ... $
但是微分
$ d: Omega^p -> Omega^(p+1) $
将其连接起来, 我们不能再直接将其连接起来. Hodge 滤过本质上就是一个折衷的方案. 更重要地, 若 $k$ 是 $QQ$-代数, 那么不滤过的导出 de Rham 函子退化, 即对任何 $A in AniCAlg_k$ 都有
$ "L"Omega_(A/k) simeq k $
我们需要一个合理的工具来帮我们截获更多的微分信息.

= 滤过理论

== $oo$-范畴中的滤过

#definition(title:[滤过])[
  我们定义范畴 $DF(k)$ 就是下降滤过复形的 $oo$-范畴, 即
  $ DF(k) := Fun(ZZ^opp,Dcat(k)) $
  我们称一个对象 $X(*) in DF(k)$ 为一个*滤过* (filtration). 一个对象 $M in Dcat(k)$ 上的滤过是一个滤过配备了比较映射
  $ colim_(n->-oo) X(n) -> M $
  的滤过, 通常记作 $"F"^bullet M$. 称之为*穷竭的*, 是指
  $ colim_(n->-oo) "F"^n M ->^~ M $
  是等价. 称之为*完备的*, 是指
  $ lim_(n->oo) "F"^n M ->^~ 0 $
  是等价.
]

我们可以在 $DF(k)$ 上定义代数, 其构造就是 Higher Algebra 中提到过的 Day 卷积:

#definition(title:[Day 卷积])[
  对于 $X(*),Y(*) in DF(k)$, 我们定义
  $ ( X ast.o Y )(n) simeq colim_(i+j>=n) X(i) times.o_k Y(j) $
  称之为滤过的 *Day 卷积*.
]

#example[
  任何 $k$-cdga $R^bullet$ 都决定了一个 $DF(k)$ 上的 $EE_oo$-代数结构, 满足 $gr^n R^bullet simeq R^n$.
]

== 完备性的等价刻画

定义商
$ X / "F"^n X = cofib("F"^n X-> X) $
那么有纤维序列
$ "F"^n X -> X -> X / "F"^n X $
对 $n->+oo$ 取极限, 因为稳定 $oo$-范畴有限极限和余纤维结构相容, 从而得到
$ lim_n "F"^n X -> X -> lim_n X / "F"^n X $
因此 $"F"^bullet X$ 完毕当且仅当 $X ->^~ lim_n X / "F"^n X$, 可以对比经典的 $I$-adic 完备性
$ A simeq lim_n A /I^n A $

== 滤过的谱序列

设 $X in Dcat(k)$ 带降滤过
$ ... -> "F"^(p+1) X -> "F"^p X -> "F"^(p-1) X -> ... $
定义其伴随的分次
$ gr^p_"F" X = cofib("F"^(p+1)X -> "F"^p X) $
从而对每个 $p$ 有纤维序列
$ "F"^(p+1) -> "F"^p X -> gr^p_"F" X $
因为 $Dcat(k)$ 稳定, 取同伦/上同调可以得到长正合列
$ ... -> H^n ("F"^(p+1)X) -> H^n ("F"^p X) -> H^n (gr^p X) ->^partial H^(n+1) ("F"^(p+1)X) -> ... $
为了形成双指标令
$ D^(p,q)_1 = H^(p+q)("F"^p X), quad E^(p,q)_1 = H^(p+q) (gr^p_"F" X) $
将长正合列改写成
$ ... -> D^(p+1,q-1)_1 ->^i D^(p,1)_1 ->^j E^(p,q)_1 ->^k D^(p+1,q)_1 -> ... $
并注意映射的双次数
$ i:(p+1,q-1)|->(p,q), quad j:(p,q)|->(p,q), quad k:(p,q)|->(p+1,q) $
容易验证这是一个正合偶, 于是 $E_1$ 上自然有了微分
$ d_1 : E^(p,q)_1 ->^k D^(p+1,q)_1 ->^j E^(p+1,q)_1 $
$E_1$-页构造完成. 而从原本的导出正合偶 $(D_1,E_1,i,j,k)$ 可以衍生出
$ D_2 = cofib (i:D_1->D_1), quad E_2 = H(E_1,d_1) $
得到新的正合偶, 如此迭代得到
$ E_(r+1) = H(E_r,d_r) $

== 分次 Whitehead 引理

#proposition[
  设 $f:X->Y$ 是 $DF(k)$ 中两个完备滤过对象的态射, 则 $f$ 是等价当且仅当 $gr^n$ 对每个 $n$ 而言都是等价.
]

= Hodge 滤过

== Hodge 滤过的定义

导出 Hodge 滤过就是按微分形式次数递减的滤过, 即

#definition(title:[Hodge 滤过])[
  设 $P = k[x_1,...,x_n]$, 普通 de Rham 复形是
  $ Omega^bullet_(P/k) = [P ->^d Omega^1_(P/k) ->^d Omega^2_(P/k) -> ...] $
  定义*递减 Hodge 滤过*为
  $ FH^p Omega^bullet_(P/k) = Omega^(>=p)_(P/k) = [0->...->0->Omega^p_(P/k)->^d Omega^(p+1)_(P/k) -> ...] $
  于是有
  $ FH^0 supset FH^1 supset FH^2 supset ... $
  对 $i:Poly_k -> AniCAlg_k$ 作左 Kan 延拓有
  $ FH^bullet "L"Omega_(-/k) := Lan_i (FH^bullet Omega^bullet_(-/k)) $
  称之为 *Hodge 滤过*, 其构成函子
  $ FH^bullet "L"Omega_(-/k) : AniCAlg_k -> CAlg(DF(k)) $
]

#remark(title:[为什么具有乘法结构?])[
  因为 de Rham 复形有楔积
  $ Omega^i_(P/k) times.o_P Omega^j_(P/k) -> Omega^(i+j)_(P/k) $
  从而有
  $ FH^p Omega^bullet times.o FH^q Omega^bullet -> FH^(p+q) Omega^bullet $
]

== Hodge 完备导出 de Rham

#definition(title:[Hodge 完备化])[
  设我们已经有了导出 Hodge 滤过
  $ "L"Omega_(R/k) = FH^0 "L"Omega_(R/k) supset FH^1 "L"Omega_(R/k) supset FH^2 "L"Omega_(R/k) supset ... $
  那么定义
  $ hat("L"Omega)_(R/k) := lim_(n->oo) ("L"Omega_(R/k) / FH^n "L"Omega_(R/k)) $
  称之为 *Hodge 完备化*, 这里
  $ "L"Omega / FH^n := cofib(FH^n "L"Omega -> "L"Omega) $
]

#remark[
  这个定义和 $I$-adic 完备化也完全平行, 即
  $ hat(M)_I = varprojlim(n)M/I^n M $
]

#remark[
  我们也可以用另一条道路定义之, 我们现在的过程是
  $ Poly_k larr^(FH^bullet Omega) DF(k) larr^Lan DF(k) larr^(hat((-))) hat(DF)(k) $
  第二种是可以直接
  $ Poly_k larr^(hat(FH^bullet Omega^bullet)) hat(DF)(k) larr^Lan hat(DF)(k) $
]

#proposition[
  设 $R in AniCAlg_k$, 那么分次片上有
  $ gr^s_"H" "L"Omega_(R/k) simeq gr^s_"H" hat("L"Omega_(R/k)) simeq "L"Lambda^s LL_(R/k) [-s] $
]

#proofsketch[
  先在多项式代数 $P = k[x_1,...,x_n]$ 上计算, 由定义
  $ FH^s Omega^bullet_(P/k) = Omega^(>=s)_(P/k) $
  所以
  $
  gr^s_"H" Omega^bullet_(P/k) &= cofib(FH^(s+1)Omega^bullet_(P/k) -> FH^s Omega^bullet_(P/k)) \ 
  &simeq Omega^s_(P/k)[-s] \
  &simeq Lambda^s_P Omega^1_(P/k) [-s]
  $
  而对于多项式代数总有 $LL_(P/k) simeq Omega^1_(P/k)$ 于是
  $ gr^s_"H" Omega^bullet_(P/k) simeq Lambda^s_P LL_(P/k) [-s] $
  现沿着 $i:Poly_k -> AniCAlg_k$ 作 Kan 延拓. 因为有
  $ FH^bullet "L"Omega_(-/k) = Lan_i (FH^bullet Omega^bullet_(-/k)) $
  而
  $ gr^s_"H" : DF(k) -> Dcat(k), quad FH^bullet X |-> cofib (FH^(s+1)X -> FH^s X) $
  由取值和余纤维构成, 从而保持余极限, 从而
  $
  gr^s_"H" "L"Omega_(-/k) &simeq Lan_i (gr^s_"H" Omega^bullet_(-/k)) \
  &simeq Lan_i (Lambda^s Omega^1_(-/k) [-s])
  $
  而导出外幂恰好是这个函子的左 Kan 延拓
  $ Lan_i (P |-> Lambda^s_P Omega^1_(P/k)) (R) = "L"Lambda^s_R LL_() $
  因此
  $ gr^s_"H" "L"Omega_(R/k) simeq "L"Lambda^s_R LL_(R/k) [-s] $
]

#proposition[
  对光滑的生象 $k$-代数 $R$, 有
  $ hat("L"Omega)_(R/k) simeq Omega_(R/k) $
]

#proof[
  光滑时, $LL_(R/k)$ 投射且集中在零次, 即 $LL_(R/k) simeq Omega^1_(R/k)[0]$. 故
  $ gr^s_"H" "L"Omega_(R/k) simeq "L"Lambda^s Omega^1_(R/k)[-s] simeq Omega^s_(R/k) [-s] $
  在每个分次上是等价, 从而确实是整体的等价.
]
