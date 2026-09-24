#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定的环都是生象环或连通 $EE_oo$-环, 前者以典范方式视作后者.

= 稳定包络

== 绝对稳定包络

稳定包络是高阶代数中, 刻画稳定 $oo$-范畴的一个非常 "泛性质" 的手段.

#remark[下面我们记 $Fun^"R" (cal(C),cal(D))$ 为 $cal(C)$ 到 $cal(D)$ 的函子中, 存在左伴随函子张成的全子函子范畴.]

#definition(title:[稳定包络])[
  设 $cal(C)$ 是可呈示的 $oo$-范畴, 一个 $cal(C)$ 的*稳定包络* (stable envelope) 是一个范畴性纤维化 $u:cal(C)'->cal(C)$ 满足:

  + $oo$-范畴 $cal(C)'$ 是稳定且可呈示的.
  + 函子 $u$ 存在左伴随, 即 $u in Fun^"R" (cal(C)',cal(C))$.
  + 对任意可呈示的稳定 $oo$-范畴 $cal(E)$, 与 $u$ 后复合 $F|->u compose F$ 诱导了 $oo$-范畴的等价
    $ Fun^"R" (cal(E),cal(C)') -> Fun^"R" (cal(E),cal(C)) $
]

#proposition[
  稳定包络在等价意义下唯一.
]

#proofsketch[
  设 $u:cal(C)'->cal(C)$ 和 $v:cal(C)''->cal(C)$ 都是 $cal(C)$ 的稳定包络. 那么由 $v$ 的泛性质, $u$ 唯一提升为
  $ F:cal(C)'->cal(C)'' $
  使得 $v F simeq u$, 同理由 $u$ 的泛性质得到
  $ G:cal(C)''->cal(C)' $
  使得 $u G simeq v$, 于是
  $ v G F simeq u, quad v F G simeq v $
  再利用相应的泛性质给出的函子范畴等价的全忠实性可以得出
  $ G F simeq id_(cal(C)), quad F G simeq id_(cal(C)'') $
  从而 $F$ 是等价.
]

#proposition(title:[典范稳定包络])[
  设 $cal(C)$ 是可呈示的 $oo$-范畴, 则
  $ Omega^oo_(cal(C)) : Sp(cal(C)) -> cal(C) $
  将 $Sp(cal(C))$ 展示为 $cal(C)$ 的一个稳定包络.
]

#remark[
  等价地, 对任意可呈示稳定 $oo$-范畴 $cal(D)$, 和 $Omega^oo_(cal(C))$ 复合诱导了
  $ Fun^"R" (cal(D),Sp(cal(C))) simeq Fun^"R" (cal(D),cal(C)) $
]

#proof[
  只需验证稳定包络的泛性质: 对任意稳定可呈示的 $cal(D)$ 有
  $ (Omega^oo)_* : Fun^"R" (cal(D),Sp(cal(C))) -->^~ Fun^"R" (cal(D),cal(C)) $
  给定 $G:cal(D)->cal(C)$ 是右伴随, 定义其提升 $tilde(G)$ 为
  $ tilde(G)(X)_n := G(Sigma^n X) $
  由于 $cal(D)$ 稳定且 $G$ 保持极限
  $ G(Sigma^n X) simeq G(Omega Sigma^(n+1) X) simeq Omega G(Sigma^(n+1) X) $
  这些对象组成一个谱
  $ Omega^oo tilde(G) simeq G $
  反之若 $H:cal(D)->Sp(cal(C))$ 是右伴随, 令 $G = Omega^oo H$, 因为 $H$ 是稳定 $oo$-范畴之间保持有限极限的函子, 从而 $H$ 正合, 于是
  $ H(X)_n simeq Omega^oo (Sigma^n H(X)) simeq Omega^oo H(Sigma^n X) = G(Sigma^n X) $
  从而 $H simeq tilde(G)$, 自然变换逐层恢复, 从而
  $ Fun^"R" (cal(D),Sp(cal(C))) simeq Fun^"R" (cal(D),cal(C)) $
  所以
  $ Omega^oo : Sp(cal(C)) -> cal(C) $
  确实展示 $Sp(C)$ 为 $cal(C)$ 的稳定包络.
]

#example[
  对于 $oo$-范畴 $Ani$, 其稳定包络是 $oo$-范畴 $Sp$, 即
  $ Sigma^oo_+ : Ani->Sp, quad Omega^oo : Sp -> Ani, quad Sigma^oo_+ tack.l Omega^oo $
]

== 相对稳定包络

#definition(title:[可呈示纤维化])[
  一个 $oo$-函子 $p:cal(X)->cal(S)$ 若满足:

  + $p$ 是 Cartesian 纤维化.
  + $p$ 是余 Cartesian 纤维化.
  + 对每个 $s in cal(S)$, $cal(X)_s := cal(X) times_cal(S) {s}$ 是可呈示的 $oo$-范畴.

  则称之为一个*可呈示纤维化* (presentable fibration).
]

#remark(title:[双 Cartesian 纤维化])[
  一个纤维化称之为*双 Cartesian* (biCartesian) 是指其同时是 Cartesian 且余 Cartesian 的. 这样的纤维化满足一个性质: 对于 biCartesian 的
  $ p : cal(X) -> cal(C) $
  在 $cal(C)$ 中, 这意味着每条基底态射都给出一个伴随对, 即
  $ f:b->c quad ~> quad f_! : cal(X)_b -> cal(X)_c, quad f^* : cal(X)_c -> cal(X)_b, quad f_! tack.l f^* $
]

#definition(title:[相对稳定包络])[
  设 $p:cal(C)->cal(D)$ 是一个可呈示纤维化, 其上的一个*稳定包络*定义为一个范畴性纤维化
  $ u : cal(C)' -> cal(C) $
  使得:

  + 复合 $p compose u : cal(C)' -> cal(D)$ 是一个可呈示纤维化.
  + 复合 $u$ 将 $(p compose u)$-Cartesian 态射送到 $p$-Cartesian 态射.
  + 对每个 $d in cal(D)$, 诱导的纤维上的函子
    $ u_d : cal(C)'_d -> cal(C)_d $
    是绝对意义下的稳定包络.
]

#proposition[
  对任意可呈示的纤维化 $p:cal(C)->cal(D)$ 都存在一个稳定包络, 其在 $d in cal(D)$ 之上的纤维可被 $Sp(cal(C)_d)$ 识别.
]

= 切丛

== 切丛的初步定义

#definition(title:[切丛])[
  一个可呈示 $oo$-范畴 $cal(C)$ 的*切丛* (tangent bundle) 定义为一个函子
  $ tan : TT cal(C) -> Fun(Delta^1, cal(C)) $
  将 $TT cal(C)$ 表作终点投影 $ev_1 : Fun(Delta^1,cal(C))->cal(C), (a->b)|->b$ 的稳定包络. 复合
  $ p : TT cal(C) larr^tan Fun(Delta^1,cal(C)) larr^(ev_1) cal(C) $
  称为*切丛投影*.
]

#definition(title:[切范畴])[
  对任意 $A in cal(C)$, 存在典范的等价
  $ TT_A cal(C) := TT cal(C) times_cal(C) {A} tilde.eq Sp(cal(C)_(\/A)) $
  其中 $TT_A cal(C)$ 称之为*切范畴* (tangent category), 一个 $TT cal(C)$ 的元素可以表作一组 $(A,M)$, 其中 $A in cal(C)$ 且 $M in Sp(cal(C)_(\/A))$.
]

#example[
  生象范畴 $Ani$ 的切丛 $TT Ani$ 满足
  $ TT_X Ani simeq Sp(Ani_(\/X)) simeq Fun(X,Sp) $
]

#example[
  $EE_oo$ 环谱的范畴 $CAlg_SS$ 的切丛就是 $Mod$, 其中
  $ TT_A CAlg_SS simeq Mod_A $
]

== 切丛的模型

我们可以用一个很具体的范畴来建模切丛, 下面记 $Ani^"fin"_*$ 是所有基点的有限生象, $Exc(cal(C),cal(D))$ 是那些将推出方形送到拉回方形的函子构成的函子范畴, 称之为*切除函子*的范畴, 那么

#proposition[
  存在模型
  $ TT cal(C) simeq Exc(Ani^"fin"_*,cal(C)) $ 
]

= 余切复形: 一般定义

我们现在可以给出余切复形最本质也是最深刻的一层定义: 我们将分别定义绝对情况与相对情况, 将余切复形视作切丛中的元素.

== 绝对余切复形

我们先承认一个事实: 函子
$ Omega^oo_(cal(C)_(\/A)) : Sp(cal(C)_(\/A)) -> cal(C)_(\/A) $
承认一个相对于基范畴 $cal(C)$ 的左伴随 $Sigma^oo_(cal(C)_(\/A),+)$, 即悬挂谱函子.

#definition(title:[绝对余切复形])[
  设 $delta : cal(C) -> Fun(Delta^1, cal(C)), A |-> id_A$ 是对角函子, *绝对余切复形*定义为函子
  $ LL := F compose delta : cal(C) -> TT cal(C), quad F tack.l_(cal(C)) Omega^oo_(cal(C)_(\/A)) $
  逐点地可以识别为
  $ LL_A = Sigma^oo_(cal(C)_(\/A),+)(id_A) in Sp(cal(C)_(\/A)) $
]

#proposition[
  余切复形函子 $LL : cal(C) -> TT cal(C)$ 是下函子的左伴随
  $ TT cal(C) larr^(Omega^oo_(cal(C)_(\/A))) Fun(Delta^1,cal(C)) larr^(ev_0) cal(C) $
]

== 相对余切复形

#definition(title:[相对余纤维序列])[
  设 $p:TT cal(C)->cal(C)$ 是切丛投影, 一个*相对余纤维序列*是指一个交换方形 $sigma$ 形如
  #web-diagram(diagram({
      node((-2, -1), [$X$])
      node((-1, -1), [$Y$])
      node((-1, 0), [$Z$])
      node((-2, 0), [$0$])
      edge((-2, -1), (-1, -1), "->")
      edge((-1, -1), (-1, 0), "->")
      edge((-2, -1), (-2, 0), "->")
      edge((-2, 0), (-1, 0), "->")
  }))
  其中:

  + 纵向的态射投影到 $cal(C)$ 中的单位态射, 从而同一列的两个对象落在同一个基底中.
  + 该方形是 $TT cal(C)$ 中的推出方形.
]

显然由绝对余切复形的函子性, 我们有
$ LL_f : LL_A -> LL_B $
在 $TT cal(C)$ 中, 我们可以将其补全为相对余纤维序列, 这样就得到了相对余切复形的定义:

#definition(title:[相对余切复形])[
  定义 $f:A->B$ 的*相对余切复形*为相对余纤维序列
  #web-diagram(diagram({
	node((-2, -1), [$LL_A$])
	node((-1, -1), [$LL_B$])
	node((-1, 0), [$LL_(A\/B)$])
	node((-2, 0), [$0$])
	edge((-2, -1), (-1, -1), [$LL_f$], label-side: left, "->")
	edge((-1, -1), (-1, 0), "->")
	edge((-2, -1), (-2, 0), "->")
	edge((-2, 0), (-1, 0), "->")
  }))
  的右下角, 即
  $ LL_(B/A) in TT_B cal(C) simeq Sp(cal(C)_(\/B)) $
  于是我们得到了函子
  $ LL : Fun(Delta^1, cal(C)) -> TT cal(C) $
]

#theorem(title:[绝对-相对余纤维序列])[
  对任何 $f:A->B$, 都有 $TT_B cal(C)$ 中的余纤维序列
  $ f_! LL_A -> LL_B -> LL_(B/A) $
]
