#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 几何态射

== 几何态射的定义

#definition(title:[几何态射])[
  设 $cal(X),cal(Y)$ 是 $oo$-意象, 一个*几何态射* (geometric morphism) 是一个伴随对
  $ f^* : cal(Y) arrows.lr cal(X) : f_*, quad f^* tack.l f_* $
  且 $f^*$ 保持有限极限, 即左正合.
]

几何态射写成 $f:cal(X)->cal(Y)$, 但最重要的态射 $f^*:cal(Y)->cal(X)$ 却是反向的. 我们可以从拓扑空间理解这一点: 若连续映射
$ f:X->Y $
则层逆向为
$ f^(-1) : Shv(Y) -> Shv(X) $
并且构成伴随
$ f^(-1) : Shv(Y) arrows.lr Shv(X) : f_* $

#example(title:[$oo$-意象中的态射诱导切片上的几何态射])[
  设 $cal(X)$ 是 $oo$-意象, $f:U->V$ 是其中的态射, 则有几何态射
  $ f : cal(X)_(\/U) -> cal(X)_(\/V) $
  由
  $ f^* cal(X)_(\/V) arrows.lr cal(X)_(\/U) : Pi_f, quad f^* tack.l Pi_f $'
  决定, 其中
  $ f^* : (Y -> V) |-> (Y times_V U -> U) $
]

#example[
  对于景上的连续函子 $f:(cal(C),J)->(cal(D),K)$, 总能诱导几何态射
  $ f:Shv(cal(C);J) -> Shv(cal(D),K) $
]

== $oo$-意象的 $oo$-范畴

#definition(title:[$oo$-范畴 $Topos_oo$])[
  记 $oo$-范畴 $Topos_oo$ 为:

  + 对象为 $oo$-意象.
  + 1-态射为几何态射.
  + 高阶态射由相应函子之间的同伦以及高阶融贯典范决定.
]

显然
$ Map_(Topos_oo) (cal(X),cal(Y)) $
等价于
$ Fun^("L","lex") (cal(Y),cal(X))^simeq $
表示所有具有右伴随且左正合的函子组成的函子 $oo$-范畴的极大子生象. 并且有显然的嵌入
$ Topos^opp_oo arrow.hook PrL_"lex" $

= 几何嵌入

== 子 $oo$-意象

#definition(title:[几何嵌入])[
  一个几何态射 $i:cal(Y)-cal(X)$ 称之为*几何嵌入* (geometric embedding), 是指其直接像函子
  $ i_* : cal(Y) -> cal(X) $
  全忠实, 此时称 $cal(Y)$ 是 $cal(X)$ 的一个*子意象* (subtopos).
]

这里, $cal(Y)$ 可以直接视作是 $cal(X)$ 的一个反射全子范畴, 有
$ L = i^* : cal(X) -> cal(Y) subset cal(X) $
满足 $L tack.l i_*$. 因此 $cal(X)$ 的子意象, 就是 $cal(X)$ 的一个可及左正合反射局部化.

#definition(title:[局部对象])[
  给定局部化
  $ L : cal(X) arrows.lr cal(Y) : i, quad L tack.l i $
  一个对象 $Y in cal(Y)$ 称为 *$L$-局部的*, 是指单位
  $ Y -> i L Y $
  是等价. 记 $cal(Y)=cal(X)^(L"-loc")$ 就是所有局部对象构成的全子范畴.
]

也就是说, 可以直接作描述
$ cal(Y) = {X in cal(X) : X simeq L X} $

一个态射 $f:A->B$ 称之为 *$L$-局部等价的*, 是指
$ L(f) : L A -> L B $
是等价, 记这类态射为 $W_L$, 从而局部对象也可以完全用 $W_L$ 描述: $Y$ 是局部的当且仅当 $Map(B,Y) ->^~ Map(A,Y)$ 对所有 $A->B in W_L$ 成立.

== 子意象的例子

#example[
  设 $cal(X) = PShv(cal(C))$, 而 $J$ 是一个 Grothendieck 拓扑, 则层化
  $ a_J : PShv(cal(C)) arrows.lr Shv(cal(C);J) : i $
  是可及的左正合局部化. 从而
  $ Shv(cal(C);J) arrow.hook PShv(cal(C)) $
  是一个子意象.
]

#example[
  更一般地, 从前述论证不难观察到, 任何 $oo$-意象都是某个 $PShv(cal(C))$ 的子意象, 其结构就是决定其作为 $oo$-意象的结构.
]
