#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

在本篇笔记中将记录我关于 Ind/sInd/Pro-完备化的理解, 固定 $cal(C)$ 是小 $oo$-范畴, $kappa$ 是无限正则基数.

= 初步定义和动机

== 预层作为完备化

#claim[
    $PShv(cal(C))$ 就是 $cal(C)$ 的_自由余极限完备化_.
]

这一构造允许任何形式的余极限. 将这个断言精确后就是如下命题

#proposition[
    设 $cal(C)$ 是小 $oo$-范畴, 记 $j:cal(C)->PShv(cal(C))$ 是 Yoneda 嵌入, 则对任意具有小余极限的 $oo$-范畴 $cal(D)$, 沿 $j$ 限制给出等价
    $ j^* : Fun^"L" (PShv(cal(C)),cal(D)) ->^~ Fun(cal(C),cal(D)) $
    其中 $Fun^"L"$ 是保持所有小余极限的函子.
]

也就是下图中诱导的预复合
#web-diagram(diagram({
	node((0, 0), [$cal(C)$])
	node((1, 0), [$PShv(cal(C))$])
	node((0, 1), [$cal(D)$])
	edge((0, 0), (1, 0), [$j$], label-side: left, "->")
	edge((1, 0), (0, 1), [$F$], label-side: left, "->")
	edge((0, 0), (0, 1), [$j^*F$], label-side: right, "->")
}))
而 Kan 延拓
#web-diagram(diagram({
	node((0, 0), [$cal(C)$])
	node((0, 1), [$cal(D)$])
	node((1, 0), [$PShv(cal(C))$])
	edge((0, 0), (0, 1), [$G$], label-side: right, "->")
	edge((0, 0), (1, 0), [$j$], label-side: left, "->")
	edge((1, 0), (0, 1), [$Lan_j G$], label-side: left, "-->")
}))
实际上诱导了其逆操作, 不难验证
$ (Lan_j G) compose j simeq G, quad Lan_j (j^* F) simeq F $

#remark[
    显式地, 由 Yoneda 稠密性我们知道, 任何预层 $X in PShv(cal(C))$ 都是可表函子的余极限
    $ X simeq colim_((j(c)->X) in cal(C)_(\/X)) j(c) $
    从而 $PShv(cal(C))$ 确实可以理解成保持全部余极限的典范延拓.
]

== Ind-完备化

Ind-完备化无非就是在任意余极限的完备化中, 限制 "所有余极限" 到 "滤过余极限".

#definition(title:[$kappa$-滤过范畴])[
    一个 $oo$-范畴 $I$ 称之为 *$kappa$-滤过的* ($kappa$-filtered), 是指对任意 $kappa$-小单纯集 $K$ 和任意图表
    $ p : K -> I $
    都能延拓为
    $ p' : K^triangle.r -> I $
]

也就是说, 一个范畴是 $kappa$-滤过的, 当且仅当其任意 $kappa$-小图表都有余锥. 通常若省略基数说滤过, 都指 $omega$-滤过, 也就是任何有限图表都有余锥.

#proposition[
    一个 $oo$-范畴 $I$ 是 $kappa$-滤过的当且仅当任意以 $I$ 为指标在 $Ani$ 中的余极限与所有 $kappa$-小极限交换.
]

也就是说, 自然比较映射是等价 
  $ colim_(i in I) lim_(j in J) F(i,j) -->^~ lim_(j in J) colim_(i in I) F(i,j) $

具体的这个的证明可以参考我以前的笔记#note-ref("../导出代数几何/导出代数几何03-余完备化.typ").

#definition(title:[Ind-余完备化])[
    设 $cal(C)$ 是小 $oo$-范畴, 所谓 *Ind-余完备化* (Ind-cocompletion) 是指定一个无限正则基数 $kappa$, 并在 $PShv(cal(C))$ 中由 Yoneda 嵌入的像在小 $kappa$-滤过余极限下生成的全子范畴
    $ Ind_kappa (cal(C)) = chevron.l j(cal(C)) chevron.r_(kappa"-滤过余极限") subset PShv(cal(C)) $
]

#proposition[
    设 $cal(C)$ 是具有 $kappa$-小余极限的小 $oo$-范畴, 那么
    $ Ind_kappa (cal(C)) simeq Fun^kappa (cal(C)^opp, Ani) $
    其中 $Fun^kappa$ 表示全体保持 $kappa$-小极限的函子范畴.
]

当 $kappa=omega$ 时, 记 $Ind(cal(C)):=Ind_omega (cal(C))$, 此时上面的假设就化归为 $cal(C)$ 具有有限余极限.

== sInd-完备化

与滤过余极限在 $Ani$ 中和有限极限交换对应, 筛余极限只要求与有限积交换.

#definition(title:[筛范畴])[
    一个小 $oo$-范畴 $I$ 称为*筛的* (sifted), 是指 $I$ 非空, 且对角函子
    $ Delta : I -> I times I $
    是共尾的. 等价地, 对任意有限集 $A$ 和函子族 $F_a:I->Ani$, 自然比较映射
    $ colim_(i in I) product_(a in A) F_a (i) -->^~ product_(a in A) colim_(i in I) F_a (i) $
    都是等价, 注意这里也包括 $A$ 为空集的情形.
]

显然, _每个滤过范畴都是筛范畴_. 

#example(title:[$Delta^opp$])[
    $Delta^opp$ 是筛范畴, 单纯对象的几何实现 
    $ abs(X_bullet):=colim_([n] in Delta^opp) X_n $
    也是筛余极限.
]

#definition(title:[sInd-余完备化])[
    设 $cal(C)$ 是小 $oo$-范畴, 所谓 *sInd-余完备化*, 也称*筛完备化* (sifted completion), 是 $PShv(cal(C))$ 中包含 Yoneda 嵌入的像且对所有小筛余极限封闭的最小全子范畴
    $ sInd(cal(C)) := chevron.l j(cal(C)) chevron.r_("筛余极限") subset PShv(cal(C)) $
]

由滤过范畴都是筛的, 自然有全忠实的包含
$ Ind(cal(C)) subset sInd(cal(C)) subset PShv(cal(C)) $

#proposition[
    设 $cal(D)$ 是具有所有小筛余极限的 $oo$-范畴, 则沿 Yoneda 嵌入限制给出等价
    $ j^* : Fun^"sift" (sInd(cal(C)),cal(D)) ->^~ Fun(cal(C),cal(D)) $
    其中 $Fun^"sift"$ 表示保持所有小筛余极限的函子的全子范畴. 这就是自由添加筛余极限的泛性质.
]

#proposition[
    若 $cal(C)$ 具有有限余积, 则
    $ sInd(cal(C)) simeq Fun^times (cal(C)^opp,Ani) $
    其中 $Fun^times$ 表示保持有限积的函子的全子范畴, 包括保持空积, 即终对象. 换言之, 这些预层将 $cal(C)$ 中的有限余积送到 $Ani$ 中的有限积.
]

在有限余积的假设下, 这个范畴也常记为 $PShv_Sigma (cal(C))$. 上述描述可参考 #link("https://www.math.ias.edu/~lurie/papers/HTT.pdf")[Higher Topos Theory, §5.5.8], 命题 5.5.8.15.

== Pro-完备化

Pro-完备化是 Ind-完备化的对偶构造, 即自由添加余滤过极限. _注意余滤过极限和滤过余极限是完全两码事_. 为了使其有区分度我们也可以将滤过余极限称之为*归纳极限*, 余滤过极限称之为*投射极限*. 

#definition(title:[$kappa$-余滤过范畴])[
    一个 $oo$-范畴 $I$ 称为 *$kappa$-余滤过的* ($kappa$-cofiltered), 是指 $I^opp$ 是 $kappa$-滤过的. 等价地, 任意 $kappa$-小单纯集 $K$ 上的图表
    $ p : K->I $
    都可以延拓成锥
    $ p' : K^triangle.l->I $
]

#definition(title:[Pro-完备化])[
    设 $cal(C)$ 是小 $oo$-范畴, 定义其 *Pro-完备化* (Pro-completion) 为
    $ Pro_kappa (cal(C)) := (Ind_kappa (cal(C)^opp))^opp $
    通常记 $Pro(cal(C)):=Pro_omega (cal(C))$. 对偶的 Yoneda 嵌入给出全忠实函子
    $ j^opp : cal(C) -> Pro_kappa (cal(C)) subset Fun(cal(C),Ani)^opp, quad c |-> Map_cal(C)(c,-) $
]

一个 Pro-对象可以由小 $kappa$-余滤过图表 $X:I->cal(C)$ 表示, 并在 $Pro_kappa (cal(C))$ 中写成
$ X simeq varprojlim(i in I) j^opp (X_i) $
这里将图表及其对应的 Pro-对象都记为 $X$. 这是在 Pro-完备化中取的极限, 不要求原范畴 $cal(C)$ 中存在这个极限.

#remark[
    若 $X:I->cal(C)$ 和 $Y:J->cal(C)$ 是两个小 $kappa$-余滤过图表, 则对应 Pro-对象之间的映射空间为
    $ Map_(Pro_kappa (cal(C)))(X,Y) simeq varprojlim(j in J) varinjlim(i in I^opp) Map_cal(C)(X_i,Y_j) $
    内层沿 $I^opp$ 取滤过余极限, 是因为映射空间对源对象反变. 这个公式由 Ind-对象的映射空间公式取对偶得到.
]

#proposition[
    设 $cal(D)$ 是具有所有小 $kappa$-余滤过极限的 $oo$-范畴, 则沿 $j^(opp)$ 限制给出等价
    $ j^(opp,*) : Fun^(kappa"-cofilt") (Pro_kappa (cal(C)),cal(D)) ->^~ Fun(cal(C),cal(D)) $
    其中左边是保持所有小 $kappa$-余滤过极限的函子的全子范畴. 对函子 $F:cal(C)->cal(D)$, 其延拓在上述 Pro-对象上的值为 $lim_(i in I) F(X_i)$.
]

#proposition[
    若 $cal(C)$ 具有 $kappa$-小极限, 则由 Ind 的相应命题取对偶可得
    $ Pro_kappa (cal(C)) simeq (Fun^kappa (cal(C),Ani))^opp $
    其中 $Fun^kappa$ 表示保持 $kappa$-小极限的函子的全子范畴. 特别地, 若 $cal(C)$ 具有有限极限, 则 $Pro(cal(C)) simeq (Fun^"lex" (cal(C),Ani))^opp$, 这里 $Fun^"lex"$ 表示保持有限极限的函子.
]

这些 Pro-构造的性质是 #link("https://www.math.ias.edu/~lurie/papers/HTT.pdf")[Higher Topos Theory, §5.3.5] 中 Ind-构造的对偶, 对应于推论 5.3.5.4 和命题 5.3.5.10.
