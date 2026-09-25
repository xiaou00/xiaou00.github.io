#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 1-范畴的余完备化

所谓与完备化是一种构造, 即自由地添加所有损失的余极限. 下面我们来严格地表述这一构造.

== 预层

#remark[我们记 $C^suit.heart$, 以强调这是一个 $oo$-范畴构造的 1-范畴形态, 例如带 $t$-结构的稳定无穷范畴的心.]

#definition(title:[预层])[
  所谓*集合值的预层*就是反变函子 $F:C^opp->Set$, 构成范畴 $PShv(cal(C))^suit.heart := Fun(cal(C)^opp,Set)$.
]

通过 Yoneda 嵌入 $yo:cal(C)->Fun(cal(C)^opp,Set)$, 将对象 $Y in cal(C)$ 送到可表预层 $Hom(-,Y)$.

#theorem(title:[1-Yoneda 稠密性])[
  对任意 $X in PShv(cal(C))^suit.heart$, 有典范的等价
  $ X simeq colim_(yo(c) -> X) yo(c) $
  这里指标范畴是逗号范畴 $(yo arrow.b X)$.
]

#proof[
  由余 Yoneda 引理, 有典范等价
  $ X simeq integral^(c in cal(C)) X(c) times.o yo(c) simeq colim_((c,x) in integral_(cal(C)) X) yo(c) $
  Yoneda 引理给出
  $ X(c) simeq Map_(PShv(cal(C))) (yo(c),X) $
  从而 Grothendieck 构造
  $ integral_cal(C) X $
  恰好是所有 $yo(c)->X$ 组成的指标范畴, 从而
  $ X simeq colim_(yo(c)->X) yo(c) $
]

也就是说, 所有预层本质上都能被可表的预层拼成.

#lemma[
  设 $C$ 是一个小范畴, 那么:

  + 预层范畴 $PShv(cal(C))^suit.heart$ 具有所有小极限.
  + 对任意余完备的范畴 $cal(D)$, 沿着 Yoneda 嵌入的限制诱导了一个等价
    $ yo^* : Fun'(PShv(cal(C))^suit.heart,cal(D)) simeq Fun(cal(C),cal(D)) $
    其中 $Fun'(PShv(cal(C)^suit.heart,cal(D)) subset Fun(PShv(cal(C))^suit.heart,cal(D))$ 是保持余极限函子的全子范畴. 
]

#remark[
  这里沿着 Yoneda 嵌入限制是指: 对于一个保持余极限的函子
  $ F : PShv(cal(C)) -> cal(D) $
  沿着 $yo$ 限制就是取复合
  $ yo^* F := F compose yo : cal(C) -> cal(D) $
  从而得到等价 $yo^*$
]

#proofsketch[
  自然考虑 $Lan_yo tack.l yo^*$, 设 $F:PShv(cal(C))^suit.heart->cal(D)$ 保持所有余极限, Yoneda 稠密给出
  $ F(X) simeq F(colim_(yo(c)->X) yo(c)) simeq colim_(yo(c)->X) F(yo(c)) = colim_(yo(c)->X) yo^* F(c) = Lan_yo (yo^* F)(X) $
  这就导出了互逆.
]

#remark[
  若 $cal(D)$ 额外是可呈示的, 则由伴随函子定理有
  $ Fun'(PShv(cal(C)),cal(D)) simeq Fun^"L" (PShv(cal(C)),cal(D)) $
  右边是全体存在右伴随的函子.
]

== 筛与滤过范畴

#definition(title:[筛范畴 / 滤过范畴])[
  设 $cal(C)$ 是一个 1-范畴, 那么:

  + 我们称 $cal(C)$ 是 *1-筛的*, 当且仅当以 $cal(C)$ 为指标在 $Set$ 中的余极限与有限积交换.
  + 我们称 $cal(C)$ 是 *滤过的*, 当且仅当以 $cal(C)$ 为指标在 $Set$ 中的余极限与有限极限交换.
]

#proposition(title:[筛的等价判别])[
  一个 1-范畴是 1-筛的当且仅当其非空, 且对角函子 $Delta:cal(C)->cal(C) times cal(C)$ 是*共尾的*. 一个函子 $u:cal(C)->cal(D)$ 共尾的含义是, 对任何 $F:cal(D)->cal(E)$, 都有自然的比较映射是等价
  $ colim_(c in cal(C)) F(u(c)) = colim_(c in cal(C)) u^*F(c) -->^~ colim_(d in cal(D)) F(d) $
  意思是原本需要遍历整个 $cal(D)$ 来取极限, 但实际上只要沿着 $u(cal(C)) subset cal(D)$ 就够了. 
]
#proof[
  代入这里的语境的话, 以 $cal(C)$ 为指标在 $Set$ 中的余极限与有限积交换, 即对任何 $F_1,...,F_n:cal(C)->Set$, 有自然映射的同构
  $ colim_(c in cal(C)) product_(i=1)^n F_i (c) -->^~ colim_((c_1,...,c_n) in cal(C)^n) product_(i=1)^n F_i (c_i) $
  由于有限积由空积和二元积生成, 这等价于二元积的情况
  $ colim_(c in cal(C)) F_1 (c) times F_2 (c) -->^~ colim_((c_1,c_2) in cal(C)^2) F_1 (c_1) times F_2 (c_2) larr^tilde_(Set "中余极限被积保持") (colim_(c_1) F(c_1)) times (colim_(c_2) F(c_2)) $  
  因此若 $Delta:cal(C)->cal(C)^2$ 是共尾的, 恰好说明了上述等式成立.

  反过来则需要一个小论证, 取
  $ F_1 (c) = Hom(c_1,c), quad F_2 (c) = Hom(c_2,c) $
  筛条件给出
  $ colim_c (Hom(c_1,c) times Hom(c_2,c)) simeq * $
  而左边恰是逗号范畴 $(c_1,c_2)/Delta$ 的连通分支集合, 于是 $Delta$ 共尾.
]


#proposition[
  一个 1-范畴 $cal(C)$ 滤过当且仅当任意有限图表 $F:J->cal(C)$ 都有余锥.
] <prop-filtered-finite-diagram-cocone>

#proof[
  现在来看滤过范畴, 滤过范畴条件展开即, 对任何有限范畴 $J$ 和函子 $F:cal(C) times J->Set$, 自然比较映射是等价 
  $ colim_(c in cal(C)) lim_(j in J) F(c,j) -->^~ lim_(j in J) colim_(c in cal(C)) F(c,j) $
  现在任取有限图表 $D:J -> cal(C)$, 专门选一个函子
  $ F : cal(C) times J^opp -> Set, quad F(c,j) = Hom_(cal(C))(D(j),c) $
  对固定的 $c$, 有
  $ lim_(j in J^opp) Hom_(cal(C)) (D(j),c) $
  而这个集合恰好是 $D$ 到常值图表 $c$ 的全部余锥. 而
  $ colim_(c in cal(C)) lim_(j in J^opp) Hom_(cal(C))(D(j),c) simeq lim_(j in J^opp) colim_(c in cal(C)) Hom_(cal(C))(D(j),c) $
  容易证明 $colim_(c in cal(C)) Hom_(cal(C))(x,c) simeq *$ 对任给的 $x in cal(C)$ 成立, 于是右边是
  $ lim_(j in J^opp) * simeq * $
  即
  $ colim_(c in cal(C)) lim_(j in J^opp) Hom_(cal(C))(D(j),c) simeq * $
  非空, 也就是说存在某个 $c in cal(C)$ 使得 $lim_(j in J^opp) Hom_(cal(C))(D(j),c)!=nothing$, 等价于说存在余锥 $D(j)->c$ 对 $J$ 的所有箭头相容. 反之显然. 
]

#corollary(title:[滤过的等价判别])[
  一个 1-范畴 $cal(C)$ 是滤过的当且仅当下列条件成立:

  + 对任何 $cal(C)$ 的对象的有限族 ${X_i}_(i in I)$, 都存在 $X in cal(C)$ 使得对每个 $i in I$ 都有态射 $X_i -> X$.
  + 对任意一对态射 $f,g:X->Y$, 存在态射 $h:Y->Z$ 余等化之, 即 $h compose f = h compose g$, 这里不要求泛性质.
]

== 筛完备化和 ind-完备化

#definition(title:[筛完备化 / ind-完备化])[
  设 $cal(C)$ 是一个小 1-范畴, 我们定义:

  + 若 $cal(C)$ 具有有限余极限, 令 $sInd(cal(C))^suit.heart subset PShv(cal(C))^suit.heart$ 是由保持有限积的 $cal(C)^opp->Set$ 函子张成的全子范畴, 称之为 $cal(C)$ 的 *1-筛完备化* (1-sifted completion).
  + 若 $cal(C)$ 具有有限余极限, 令 $Ind(cal(C)) subset PShv(cal(C))^suit.heart$ 是由保持有限极限的 $cal(C)^opp->Set$ 函子张成的全子范畴, 称之为 $cal(C)$ 的 *ind-完备化* (ind-completion).
]

#remark[
  显然若 $cal(C)$ 具有有限余极限, 则 $Ind(cal(C)) subset sInd(cal(C))^suit.heart$.
]

= $oo$-范畴的余完备化

== 生象值预层

#definition(title:[生象值预层])[
  设 $cal(C)$ 是小的 $oo$-范畴或任何小的单纯集, 函子范畴 $Fun(cal(C),Ani)$ 给出*生象值预层*的 $oo$-范畴. 并且有典范的 Yoneda 嵌入
  $ yo : cal(C) -> Fun(cal(C)^opp, Ani), quad Y |-> Map_cal(C) (-,Y) $
]

== 将 1-范畴的构造提升到 $oo$-范畴

我们可以用很显然的方式推广筛和滤过范畴的定义

#definition(title:[筛范畴 / 滤过范畴])[
  设 $cal(C)$ 是一个 $oo$-范畴, 那么:

  + 我们称 $cal(C)$ 是 *筛的*, 当且仅当以 $cal(C)$ 为指标在 $Ani$ 中的余极限与有限积交换.
  + 我们称 $cal(C)$ 是 *滤过的*, 当且仅当以 $cal(C)$ 为指标在 $Ani$ 中的余极限与有限极限交换.
]

同样地

#definition(title:[筛完备化 / ind-完备化])[
  设 $cal(C)$ 是一个小 $oo$-范畴, 我们定义:

  + 若 $cal(C)$ 具有有限余极限, 令 $sInd(cal(C)) subset PShv(cal(C))$ 是由保持有限积的 $cal(C)^opp->Ani$ 函子张成的全子范畴, 称之为 $cal(C)$ 的 *筛完备化* (1-sifted completion).
  + 若 $cal(C)$ 具有有限余极限, 令 $Ind(cal(C)) subset PShv(cal(C))$ 是由保持有限极限的 $cal(C)^opp->Ani$ 函子张成的全子范畴, 称之为 $cal(C)$ 的 *ind-完备化* (ind-completion).
]

我们承认以下关于筛完备化和 Ind-完备化的结论, 具体证明可以参考 Lurie 的 Higher Topos Theory, 第5章:

#definition(title:[几何实现])[
  设 $cal(C)$ 是一个 $oo$-范畴, $X_bullet:Delta^opp->cal(C)$ 是一个单纯对象, 定义
  $ abs(X_bullet) := colim_(Delta^opp) X_bullet $
  称之为其*几何实现*, 它是函子
  $ abs(-) : simp(cal(C)) -> cal(C) $
]

#proposition[
  设 $cal(C)$ 是一个小的 $oo$-范畴, 且 $cal(C)$ 具有有限的余积, 那么:

  + 包含函子 $i: sInd(cal(C)) arrow.hook PShv(cal(C))$ 保持筛的余极限, 并且存在左伴随, 从而 $sInd(cal(C))$ 是可呈示的.
  + Yoneda 函子 $yo : cal(C) -> PShv(cal(C))$ 落在 $sInd(cal(C))$ 中.
  + 一个对象 $X in PShv(cal(C))$ 落在 $sInd(cal(C))$ 中当且仅当存在一个单纯对象 $X_bullet : Delta^opp->PShv(cal(C))$ 使得 $X simeq abs(X_bullet) = colim_([n] in Delta^opp) X_n$, 并且每个 $X_n$ 都是 $cal(C) subset PShv(cal(C))$ 中的滤过余极限.
]

#proposition[
  设 $cal(C)$ 是一个小的 $oo$-范畴, 且 $cal(C)$ 具有有限的余积, 那么:

  + 若 $cal(D)$ 是具有 1-筛余极限的 1-范畴, 则沿 Yoneda 的限制诱导等价
    $ yo^* : Fun^("sift") (sInd(cal(C)), cal(D)) -->^~ Fun(cal(C),cal(D)) $
    其中 $Fun^("sift") (sInd(cal(C)),cal(D)) subset Fun(sInd(cal(C)),cal(D))$ 是保持 1-筛余极限函子的全子范畴.
  + 若 $cal(D)$ 是具有全部余极限的 1-范畴, 则沿 Yoneda 的限制诱导等价
  $ yo^* : Fun'(sInd(cal(C)), cal(D)) -->^~ Fun^union.sq (cal(C),cal(D)) $
  左边是保持余极限函子的全子范畴, 右边是保持有限余积的函子的全子范畴.
]

#proposition[
  设 $cal(C)$ 是一个小的 $oo$-范畴, 且 $cal(C)$ 具有有限的余极限, 那么:

  + 包含函子 $i: Ind(cal(C)) arrow.hook PShv(cal(C))$ 保持滤过的余极限, 并且存在左伴随, 从而 $Ind(cal(C))$ 是可呈示的.
  + Yoneda 函子 $yo : cal(C) -> PShv(cal(C))$ 落在 $Ind(cal(C))$ 中.
  + 一个对象 $X in PShv(cal(C))$ 落在 $Ind(cal(C))$ 中当且仅当存在可表作子范畴 $yo:cal(C) arrow.hook PShv(cal(C))$ 中对象的滤过余极限.
]

#proposition[
  设 $cal(C)$ 是一个小的 $oo$-范畴, 且 $cal(C)$ 具有有限的余极限, 那么:

  + 若 $cal(D)$ 是具有滤过余极限的 1-范畴, 则沿 Yoneda 的限制诱导等价
    $ yo^* : Fun^("filt") (sInd(cal(C)), cal(D)) -->^~ Fun(cal(C),cal(D)) $
    其中 $Fun^("filt") (sInd(cal(C)),cal(D)) subset Fun(sInd(cal(C)),cal(D))$ 是保持滤过余极限函子的全子范畴.
  + 若 $cal(D)$ 是具有全部余极限的 1-范畴, 则沿 Yoneda 的限制诱导等价
  $ yo^* : Fun'(sInd(cal(C)), cal(D)) -->^~ Fun^"rex" (cal(C),cal(D)) $
  左边是保持余极限函子的全子范畴, 右边是保持有限余极限的函子的全子范畴.
]

类似的结论显然也在 1-范畴的语境下成立, 只需作概念替换即可.

= 可呈示性

== $kappa$-滤过

#definition(title:[$kappa$-滤过范畴])[
  给定正则序数 $kappa$, 我们称一个 $oo$-范畴 $cal(C)$ 是 *$kappa$-滤过的*, 当且仅当以 $cal(C)$ 为指标在 $Ani$ 中的余极限与所有 $kappa$-小极限交换.
]

显然, 一般的滤过范畴就是 $omega$-滤过范畴. 等价地, 由@prop-filtered-finite-diagram-cocone, 我们可以显然地将其推广到序数

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

#example[
  完美复形的定义就是 $Perf(R):=(Mod_R)^omega$.
]

#definition(title:[任意序数的 Ind-完备化])[
  设 $kappa$ 是正则序数, $cal(C)$ 是小 $oo$-范畴. 若 $cal(C)$ 具有有限余极限, 则令 $Ind_(kappa) (cal(C)) subset PShv(cal(C))$ 是由保持 $kappa$-小极限的 $cal(C)^opp->Ani$ 函子张成的全子范畴, 也就是 $Fun^"lex" (cal(C)^opp,Ani)$. 称之为 $cal(C)$ 的 *$kappa$-小 Ind-完备化*.
]

更一般的情况下, 不需要 $cal(C)$ 具有有限余极限的假设, 我们可以直接定义
$ Ind_kappa (cal(C)) = chevron yo(C) chevron.r_(kappa"-滤过余极限") $
来直接生成, 这是可行并且标准的.

== 可及范畴与可呈示范畴

#definition(title:[可及范畴])[
  一个 $oo$-范畴 $cal(C)$ 是 *$kappa$-可及的*, 是指:

  + $cal(C)$ 存在所有 $kappa$-滤过极限.
  + 存在本质小的 $kappa$-紧对象族 (张成子范畴) $cal(C)_0 subset cal(C)$ 使得 $cal(C) simeq Ind_kappa (cal(C)_0)$.

  若存在某个正则基数 $kappa$ 使得 $cal(C)$ 是 $kappa$-可及的, 则称之为*可及的* (accessible).
]

#definition(title:[可呈示范畴])[
  一个可及的 $oo$-范畴 $cal(C)$ 若存在全部小余极限, 则称之为*可呈示的* (presentable).
]

类似地我们可以用典范的方法推广 $kappa$-筛的概念, 读者可自行完成.
