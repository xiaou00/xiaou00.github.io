#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

范畴 $PrL$, 是现代代数中最常用也最重要的环境范畴之一, 他同时制约了:

+ 预层.
+ 层和反射局部化.
+ 幺半范畴.
+ 模.
+ 稳定 $oo$-范畴.

= $PrL$ 的定义

== 紧性与可及性

#definition(title:[$kappa$-滤过范畴])[
  给定正则序数 $kappa$, 我们称一个 $oo$-范畴 $cal(C)$ 是 *$kappa$-滤过的*, 当且仅当以 $cal(C)$ 为指标在 $Ani$ 中的余极限与所有 $kappa$-小极限交换.
]

#proposition[
  一个 $oo$-范畴 $cal(C)$ 是 $kappa$-滤过当且仅当任意 $kappa$-小单纯集 $J$, $F:J->cal(C)$ 都有余锥.
]

#definition(title:[$kappa$-紧对象])[
  给定正则序数 $kappa$ 和 $oo$-范畴 $cal(C)$, 对象 $X in cal(C)$ 称之为 *$kappa$-紧*的, 是指
  $ Map_(cal(C))(X,-) : cal(C) -> Ani $
  保持 $kappa$-滤过极限.
]

也就是说
$ colim_(i in I) Map(X,Y_i) simeq Map(X,colim_(i in I) Y_i) $
对若有 $kappa$-滤过的 $I$ 成立.

通常, 我们记 $cal(C)^kappa subset cal(C)$ 为 $kappa$-紧对象张成的全子范畴, 若不指定序数说紧对象, 通常指 $omega$-紧对象.

#definition(title:[可及范畴])[
  一个 $oo$-范畴 $cal(C)$ 是 *$kappa$-可及的*, 是指:

  + $cal(C)$ 存在所有 $kappa$-滤过极限.
  + 存在本质小的 $kappa$-紧对象族 (张成子范畴) $cal(C)_0 subset cal(C)$ 使得 $cal(C) simeq Ind_kappa (cal(C)_0)$.

  若存在某个正则基数 $kappa$ 使得 $cal(C)$ 是 $kappa$-可及的, 则称之为*可及的* (accessible).
]

== 可呈示性

#definition(title:[可呈示性])[
  若 $oo$-范畴 $cal(C)$ 是可及的且具有所有小的余极限, 则称之为*可呈示的* (presentable).
]

#definition(title:[范畴 $PrL$])[
  我们定义 $PrL$ 为下述范畴:

  + 对象是全体可呈示的 $oo$-范畴.
  + 态射为全体保持小余极限的函子.

  同时记 $Fun^"L" (cal(C),cal(D))$ 为保持所有余极限的函子构成的函子 $oo$-范畴.
]

== 伴随函子定理

#theorem(title:[伴随函子定理 I])[
  设 $cal(C)$ 和 $cal(D)$ 是可呈示 $oo$-范畴, 则函子 $F:cal(C)->cal(D)$ 有左伴随, 当且仅当 $F$ 保持所有小的极限.
]

#proofsketch[
  若 $L tack.l F$, 则 $F$ 是右伴随, 所以保持所有极限, 反之, 若 $F$ 可及也保持所有极限, 固定 $d in cal(D)$, 考虑逗号 $oo$-范畴
  $ cal(C)_d = (d arrow.b F) $
  其对象为
  $ (c,eta:d->F(c)) $
  现在只需证明其有初对象, 由于 $F$ 可及, 所以 $(d arrow.b F)$ 可及, 因为 $F$ 保持所有小极限, $(d arrow.b F)$ 也具有所有小极限, 且极限由 $cal(C)$ 的极限计算. 可及且完毕的 $oo$-范畴具有初对象, 初始性恰意味着对所有  $c in cal(C)$ 有
  $ Map_(cal(C))(L d,c) simeq Map_(cal(D))(d,F c) $
  于是 $d|->L d$ 给出伴随.
]

#theorem(title:[伴随函子定理 II])[
  设 $cal(C)$ 和 $cal(D)$ 是可呈示 $oo$-范畴, 则函子 $F:cal(C)->cal(D)$ 有右伴随, 当且仅当 $F$ 保持所有小的余极限.
]

#corollary[
  一个可呈示的 $oo$-范畴不仅存在所有余极限, 也存在所有的极限.
]

= 一些有用的性质

== $PrR$

#proposition[
  有 $(PrL)^opp simeq PrR$.
]

#proof[
  由伴随函子定理, 显然选取态射对应为对应的伴随函子即可.
]

== 可及局部化

#proposition[
  设 $cal(C)$ 可呈示, $S$ 是一小族态射, 则
  $ i:cal(C)_(S"-loc") arrow.hook cal(C) $
  有左伴随 $L tack.l i$.
]

层化, 叠化确实都是这个论证的一个特例.

== $PrL$ 的幺半结构

#definition(title:[$PrL$ 的幺半结构])[
  我们可以在 $PrL$ 上定义一个典范的幺半结构 $(PrL, times.o, Ani)$, 定义 $cal(C) times.o cal(D)$ 为满足泛性质
  $ Fun^"L" (cal(C) times.o cal(D),cal(E)) simeq Fun^("L","L")(cal(C) times cal(D),cal(E)) $
  其中右边代表双函子
  $F : cal(C) times cal(D) -> cal(E) $
  对两个变量都保持余极限.
]

其中幺半单位是 $Ani$, 这源于一个事实
$ Fun^"L" (Ani,cal(D)) simeq cal(D) $

#proposition(title:[张量范畴公式])[
  若 $cal(A)$ 小且 $cal(C)$ 可呈示, 则:

  + $PShv(cal(A)) times.o cal(C) simeq Fun(cal(A)^opp,cal(C))$.
  + $PShv(cal(A)) times.o PShv(cal(B)) simeq PShv(cal(A) times cal(B))$.
]

#proof[
  由 $PShv(cal(A))$ 的自由余完备性, 有
  $ Fun^"L" (PShv(cal(A)),cal(D)) simeq Fun(cal(A),cal(D)) $
  因此对任意可呈示的 $cal(D)$, 有
  $ 
  Fun^"L" (PShv(cal(A)) times.o cal(C), cal(D)) &simeq Fun^("L","L") (PShv(cal(A)) times cal(C), cal(D))\
  &simeq Fun(cal(A),Fun^"L" (cal(C),cal(D)))\
  &simeq Fun^"L" (Fun(cal(A)^opp,cal(C)),cal(D))
  $
  最后由 $PrL$ 中的 Yoneda, 有
  $ PShv(cal(A)) times.o cal(C) simeq Fun(cal(A)^opp,cal(C)) $
  再取
  $ cal(C) = PShv(cal(B)) $
  就得到了第二个.
]

#proposition(title:[tensor--Hom])[
  有 tensor--Hom 伴随
  $ Fun^"L" (cal(A) times.o cal(C),cal(D)) simeq Fun^"L" (cal(A),Fun^"L" (cal(C),cal(D))) $
  等价地
  $ Fun^("L","L") (cal(A) times cal(C),cal(D)) simeq Fun^"L" (cal(A),Fun^"L" (cal(C),cal(D))) $
  也就是说 $Fun^"L" (cal(C),cal(D))$ 是这个幺半结构的内部 Hom.
]

#proofsketch[
  通过普通的指数律
  $ Fun(cal(A) times cal(C),cal(D)) simeq Fun(cal(A),Fun(cal(C),cal(D))) $
  限制到保持余极限的函子后 currying 即证.
]

#corollary[
  有标准等价 / 模型
  $ cal(C) times.o cal(D) simeq Fun^"R" (cal(C)^opp,cal(D)) $
]

== 可呈示幺半范畴

所谓可呈示幺半范畴, 本质上其实就是 $(PrL, times.o, Ani)$ 的代数对象. 例如我们考虑
$ Alg_(EE_1) (PrL) $
时, 相当于考虑了一个可呈示的幺半 $oo$-范畴 $(cal(C), times.o, bold(1))$ 满足
$ X times.o -, quad - times.o X $
都保持所有余极限. 类似地
$ Alg_(EE_oo) (PrL) $

#example(title:[Day 卷积])[
  若 $cal(A)$ 是小的对称幺半范畴, 则我们可以在 $PShv(cal(A))$ 上诱导一个张量积结构, 称之为 *Day 卷积*.

  由于 
  $ PShv(cal(A)) times.o PShv(cal(A)) simeq PShv(cal(A) times cal(A)) $
  而 $cal(A)$ 上的乘法
  $ m : cal(A) times cal(A) -> cal(A), quad (a,b) |-> a times.o b $
  诱导左 Kan 延拓
  $ m_! : PShv(cal(A) times cal(A)) -> PShv(cal(A)) $
  于是, 我们定义
  $ F ast.o G := m_! (F times.square G) $
  其中
  $ (F times.square G)(a,b) = F(a) times G(b) $
  也就是说规定乘法为
  $ PShv(cal(A)) times.o PShv(cal(A)) simeq PShv(cal(A) times cal(A)) larr^(m_!) PShv(cal(A)) $
  我们使得 $PShv(cal(A)) in CAlg(PrL)$.
]

若 $cal(A) in CAlg(PrL)$, 则一个 $cal(A)$-模可呈示范畴是一个
$ cal(M) in LMod_(cal(A))(PrL) $
带有作用
$ cal(A) times.o cal(M) -> cal(M) $
对应一个双函子
$ cal(A) times cal(M) -> cal(M) $
分别保持余极限.

给定 $cal(M) in cat("RMod")_(cal(A))$ 和 $cal(N) in LMod_(cal(A))$, 则可以定义
$ cal(M) times.o_(cal(A)) cal(N) $
由杠构造给出:
$ cal(M) times.o_(cal(A)) cal(N) simeq abs(Bar(cal(M),cal(A),cal(N))_bullet) $

= 稳定版本 $PrL_"st"$

== $PrL_"st"$ 的定义

#definition(title:[$PrL_"st"$])[
  定义 $PrL_"st" subset PrL$ 是全部可呈示 $oo$-范畴张成的全子范畴.
]

由于如果 $F:cal(C)->cal(D)$ 是稳定可呈示 $oo$-范畴之间的左伴随, 那么 $F$ 自动正合: 由于其保持余极限, 其自动保持:

+ 零对象.
+ 有限余极限.

而在稳定 $oo$-范畴中, 有限余极限=有限极限. 从而 $PrL_"st"$ 可以理解成稳定可呈示范畴+保持余极限的正合函子.

#lemma[
  
]

#proposition[
  对于可呈示的 $oo$-范畴 $cal(C)$, 其稳定化满足
  $ Sp(cal(C)) simeq Sp times.o cal(C) $
]

#proof[
  从泛性质入手, 设 $cal(C) in PrL$, 稳定化
  $ Sigma^oo : cal(C) -> Sp(cal(C)) $
  由如下泛性质刻画, 即, 对任意的稳定可呈示的 $cal(D)$, 预合成给出
  $ Sigma^(oo,*) : Fun^"L" (Sp(cal(C)),cal(D)) ->^~ Fun^"L" (cal(C),cal(D)) $
  下证 $Sp times.o cal(C)$ 满足相同的泛性质: 由 tensor--Hom, 有
  $ Fun^"L" (Sp times.o cal(C), cal(D)) simeq Fun^"L" (cal(C),Fun^"L" (Sp,cal(D))) $
  而当 $cal(D)$ 稳定时显然有 $Fun^"L" (Sp,cal(D)) simeq cal(D)$, 因为 $Sp$ 是自由的稳定可呈示 $oo$-范畴, 其生成元为球谱 $SS$, 一个左伴随
  $ F:Sp->cal(C) $
  则完全由 $F(SS) in cal(D)$ 决定.

  整理上述信息, 有
  $ Fun^"L" (Sp times.o cal(C),cal(D)) simeq Fun^"L" (cal(C),cal(D)) $
  从而由 $PrL$ 中的 Yoneda, $Sp times.o cal(C) simeq Sp(cal(C))$.
]

#proposition[
  有 $oo$-范畴等价
  $ PrL_"st" simeq Mod_Sp (PrL) $
]

#example[
  设 $R$ 是 $EE_oo$-环, 则 $Mod_R$ 也属于 $CAlg(PrL_"st")$, 并且 $times.o_R$ 分别保持余极限. 对于 $EE_oo$ 环 $R,S$, 有
  $ Mod_R times.o Mod_S simeq Mod_(R times.o S) $
]
