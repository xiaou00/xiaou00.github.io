#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= Kähler 微分

本节固定 $k$ 为交换环, 所有环与模均取经典意义.

== 导子和 Kähler 微分

#definition(title:[导子])[
  设 $k->R$ 是交换环映射, $M$ 是 $R$-模, 一个 $R$ 在 $M$ 中的 *$k$-导子*定义为函数 (不要求是 $R$-模映射) $d:R->M$ 使得:

  + $d(r+s)=d(r)+d(s)$ 对 $r,s in R$.
  + $d(r s)=r d(s)+s d(r)$ 对 $r,s in R$.
  + $d(t)=0$ 对 $t in k$.
]

记 $Der_k (R,M)$ 是全体 $R$ 在 $M$ 中 $k$-导子的集合, 它按逐点运算构成 $R$-模.

#definition(title:[Kähler 微分模])[
  设 $k->R$ 是交换环映射, 则 *Kähler 微分模* $Omega^1_(R/k)$ 定义为自由模 $plus.o.big_(r in R)R dot dif r$ 商去关系:

  + $dif(r+s)=dif r + dif s$ 对 $r,s in R$.
  + $dif(r s)=r dif s+s dif r$ 对 $r,s in R$.
  + $dif t=0$ 对 $t in k$.
]

#example[
  函数 $dif:R->Omega^1_(R/k), r|->dif r$ 是一个 $R$ 在 $Omega^1_(R/k)$ 中的 $k$-导子, 称之为*泛导子*.
]

#example[
  若 $k->>R$ 是满的, 则 $Omega^1_(R/k)=0$.
]

#remark(title:[泛性质])[
  总有自然同构
  $ Hom_R (Omega^1_(R/k),M) simeq Der_k (R,M), quad u |-> u compose dif $
  这是因为给出 $u(dif r)$ 的相容取值, 恰好就是给出一个导子.
]

#example(title:[多项式与局部化])[
  对 $P=k[x_1,...,x_n]$, 导子由 $x_i$ 的像任意且唯一地确定, 因而
  $ Omega^1_(P/k) simeq plus.o.big_(i=1)^n P dif x_i $
  若 $S subset R$ 是乘法集, 则 $Omega^1_(S^(-1)R/k) simeq S^(-1)Omega^1_(R/k)$: 导子唯一延拓为 $d(r/s)=s^(-1)d(r)-r s^(-2)d(s)$.
]

== 切, 余切与法, 余法

#definition(title:[四类模])[
  对 $k$-代数 $R$, *余切模* (cotangent module) 就是 $Omega^1_(R/k)$, *切模* (tangent module) 是其对偶
  $ T_(R/k) := Der_k (R,R) simeq Hom_R (Omega^1_(R/k),R) $
  对商映射 $R->>B=R/I$, 对应闭浸入 $Z=Spec B arrow.hook X=Spec R$, 定义 *余法模* (conormal module) 和 *法模* (normal module)
  $ C_(Z/X) := I/I^2, quad N_(Z/X) := Hom_B (I/I^2,B) $
  后两者是 $B$-模, 依赖于嵌入 $Z arrow.hook X$. 尤其 $Omega^1_(B/R)=0$, 一般不能把它与 $I/I^2$ 混同.
]

在概形上, $Omega^1$ 由局部化粘合, 切层定义为其层对偶. 余法层为 $cal(I)/cal(I)^2$, 法层为它的层对偶. 光滑时余切层, 切层是向量丛. 正则闭浸入时余法层, 法层是向量丛. 法与余法的约定见 #link("https://stacks.math.columbia.edu/tag/01R1")[Stacks, 01R1].

#remark(title:[点的切空间])[
  若 $k$ 是域, $x in X(k)$ 对应极大理想 $frak(m)$, 则
  $ T_x^* X := Omega^1_(R/k) times.o_R k simeq frak(m)/frak(m)^2, $
  $ T_x X := Der_k (R,k) simeq Hom_k (frak(m)/frak(m)^2,k) $
  事实上 $R=k plus.o frak(m)$, 导子恰好是在 $frak(m)^2$ 上为零的 $k$-线性映射 $frak(m)->k$. 一般不能将 $T_x X$ 与 $T_(R/k) times.o_R k$ 混同 $R/k$ 光滑时二者相同.
]

#remark(title:[余切是对角线的余法])[
  令 $J=ker(R times.o_k R larr^mu R)$, 其中 $mu(a times.o b)=a b$. 则
  $ Omega^1_(R/k) simeq J/J^2, quad dif r |-> [1 times.o r-r times.o 1] $
  右侧的映射满足 Leibniz 律. 逆映射为 $[sum_i a_i times.o b_i] |-> sum_i a_i dif b_i$, 它在 $J^2$ 上为零. 因而切模也是对角线的法模. 参见 #link("https://stacks.math.columbia.edu/tag/00RW")[Stacks, 00RW].
]

= 常用正合列

== 传递正合列

#proposition[
  对 $k->R larr^f B$, 有 $B$-模正合列
  $ B times.o_R Omega^1_(R/k) larr^alpha Omega^1_(B/k) -> Omega^1_(B/R) -> 0, quad alpha(b times.o dif r)=b dif f(r) $
  对任意 $B$-模 $M$, 相应的导子序列为
  $ 0 -> Der_R (B,M) -> Der_k (B,M) -> Der_k (R,M) $
]

#proof[
  将 $Omega^1_(B/k)$ 商去所有 $dif f(r)$, 恰好追加了相对于 $R$ 的微分关系, 故商模为 $Omega^1_(B/R)$. 再取 $Hom_B (-,M)$ 即得第二列, 末箭头是沿 $f$ 限制导子. 参见 #link("https://stacks.math.columbia.edu/tag/00RS")[Stacks, 00RS].
]

== 余法与切—法正合列

#proposition[
  对 $B=R/I$, 有*余法正合列*
  $ I/I^2 larr^delta B times.o_R Omega^1_(R/k) -> Omega^1_(B/k) -> 0, quad delta([f])=1 times.o dif f $
  以及对偶的*切—法正合列*
  $ 0 -> T_(B/k) -> Der_k (R,B) larr^rho N_(Z/X), quad rho(D)([f])=D(f) $
]

#proof[
  因 $dif(I^2) subset I Omega^1_(R/k)$, $delta$ 是良定义的 $B$-线性映射. 对任意 $B$-模 $M$, $k$-导子 $R->M$ 能下降到 $B$ 当且仅当它在 $I$ 上为零. 故 $coker delta$ 表示 $Der_k (B,-)$, 即为 $Omega^1_(B/k)$. 对此右正合列取 $Hom_B (-,B)$, 由左正合性即得第二列. 参见 #link("https://stacks.math.columbia.edu/tag/00RU")[Stacks, 00RU].
]

#corollary(title:[光滑情形])[
  若 $B$ 在 $k$ 上光滑, 余法正合列可补上左端的 $0$, 并且分裂, 对偶后 $rho$ 也满射. 若 $R$ 也在 $k$ 上光滑, 则得到熟悉的
  $ 0 -> T_(B/k) -> B times.o_R T_(R/k) -> N_(Z/X) -> 0 $
  因而光滑闭子概形的法丛就是环境切丛限制后模去自身切丛.
]

#proof[
  由光滑代数的平方零提升性质, $R/I^2->>B$ 有 $k$-代数截面 $s$. 映射 $r |-> (r mod I^2)-s(r mod I)$ 是到 $I/I^2$ 的导子, 在 $I$ 上是自然投影, 故诱导 $delta$ 的左逆. 这给出分裂短正合列, 对偶仍正合. 若 $R/k$ 光滑, $Omega^1_(R/k)$ 有限投射, 故 $Der_k (R,B) simeq B times.o_R T_(R/k)$. 几何版本见 #link("https://stacks.math.columbia.edu/tag/06AA")[Stacks, 06AA].
]

#example(title:[方程与 Jacobian])[
  若 $P=k[x_1,...,x_n]$, $I=(f_1,...,f_m)$, $B=P/I$, 余法正合列给出
  $ B^m larr^J B^n -> Omega^1_(B/k) -> 0, quad J(e_j)=sum_i overline((partial f_j)/(partial x_i))e_i $
  因而 $Omega^1_(B/k)=coker J$, $T_(B/k)=ker(J^*:B^n->B^m)$, 其中 $J^*$ 为对偶映射. 若 $f_1,...,f_m$ 是正则序列, 则 $I/I^2 simeq B^m$, $N_(Z/Spec P) simeq B^m$.
]

= 平方零扩张

#quote[所谓平方零扩张, 就是给一个环加入一个自身乘积为零的, 线性的无穷小方向.]

#definition(title:[经典平方零扩张])[
  设 $q:A'->>A$ 是交换环的满射, 记 $I = ker q$, 且 $I^2=0$, 于是
  $ 0 -> I -> A' ->>^q A -> 0 $
  称为一个*平方零扩张* (square-zero extension, SZE).
]

这里的核 $I$ 典范地是 $A$-模: 用 $a in A$ 的任意提升作用在 $I$ 上, 因为 $I^2=0$, 结果与提升的选择无关.

下面我们来看一类重要的平方零扩张

#definition(title:[平凡平方零扩张])[
  给定任意 $A$-模 $M$, 定义 $A plus.o M$ 并令
  $ (a,m)(b,n) = (a b, a n + b m) $
  则
  $ 0 -> M -> A plus.o M larr^("pr") A -> 0 $
  是平方零扩张, 因为这里 $(0,m)(0,n)=(0,0)$. 这个构造称之为*平凡平方零扩张*.
]

平凡平方零扩张是许多平方零扩张现象的基本模型, 例如最典型的例子就是
$ k[epsilon]/(epsilon^2) simeq k plus.o k epsilon $
若平方零扩张有环截面 $s:A->A'$, 则 $(a,m)|->s(a)+m$ 给出 $A plus.o I simeq A'$, 所以它是平凡平方零扩张.

#example(title:[非平凡的例子])[
  一个非常简单的例子是
  $ ZZ/p^2 -> FF_p $
  其核为 $p ZZ/p^2 simeq FF_p$, 而 $(p ZZ/p^2)^2 = 0$, 于是有
  $ 0 -> FF_p -> ZZ/p^2 -> FF_p -> 0 $
  是平方零扩张, 但它没有环截面 $FF_p -> ZZ/p^2$: 保幺映射会把等式 $p dot 1=0$ 映到矛盾.
]

同样的定义可以推广到 $CAlg_k$ 这个范畴中.

== 导子的无穷小解释

设 $S$ 是交换 $k$-代数, 记 $CAlg_(k"//"S) simeq (CAlg_k)_("/"S)$.

#theorem[
  设 $g : R->S$ 是 $CAlg_(k"//"S)$ 的对象, 且 $f:S plus.o J->>S$ 是平凡的平方零扩张, 那么有自然的同构
  $ Hom_(CAlg_(k"//"S))((R,g),(S plus.o J,f)) simeq Hom_R (Omega^1_(R/k),J) simeq Der_k (R,J) $
]

#proof[
  一个位于 $S$ 上方的 $k$-代数映射 $h:R->S plus.o J$ 必形如 $h(r)=(g(r),D(r))$. 它保持乘法恰好等价于
  $ D(r r')=g(r)D(r')+g(r')D(r), $
  而保持加法与 $k$-代数结构恰好给出导子的其余条件. 这里 $J$ 经 $g$ 视为 $R$-模. 再用 $Omega^1$ 的泛性质即可.
]
