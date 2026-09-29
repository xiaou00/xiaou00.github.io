#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

在前面两节中, 我们分别给出了定义无穷意象的动机和理论基础, 这一节中我们初步讨论无穷意象的理论, 更进一步的结论可以参考 Lurie 的 Higher Topos Theory.

= 无穷意象的定义

== 动机

就像我们研究流形时总是喜欢研究独立于局部坐标系的东西, 在几何的语境中, 景就像是那个局部坐标系, 而意象是独立于坐标系的真正的几何理论.

== 基本定义

#definition(title:[意象])[
  一个 *$oo$-意象*是一个 $oo$-范畴 $cal(X)$, 小 $oo$-范畴 $cal(C)$ 以及可及的左正合局部化
  $ L : PShv(cal(C)) arrows.lr cal(X) : i, quad L tack.l i $
]

#example[
  恒等的局部化将 $PShv(cal(C))$ 本身识别为一个 $oo$-意象.
]

#example[
  显然 $oo$-意象这个定义就是照着层的定义照葫芦画瓢出来的, 固然
  $ a : PShv(cal(C)) arrows.lr Shv(cal(C);J) : i $
  是一个 $oo$-意象.
]

#proposition[
  $oo$-意象 $cal(X)$ 都是可呈示的 $oo$-范畴, 即 $cal(X) in PrL$. 
]

#proof[
  由 $PShv(cal(C))$ 可呈示, 容易验证可呈示的可及反射局部化依然可呈示.
]

#proposition[
  反过来, 每个 $oo$-意象都能表作一个景 $(cal(C);J)$ 上的 $oo$-层
  $ cal(X) simeq Shv(cal(C);J) $
]

也就是说景一般是一个 $oo$-意象的表示, 但这个表示一般不唯一, 不同的表示之间也高度不唯一. 这深化了直觉:

$ "景" = "坐标图册", quad "意象" = "几何本身" $

= 几个前置定义

== Segal 映射

下设 $cal(C)$ 是具有有限极限的 $oo$-范畴. 对 $i=1,...,n$, 定义
$ alpha_i : [1] arrow.hook [n], quad 0 |-> i-1, quad 1 |-> i $
对于单纯对象 $X_bullet: Delta^opp -> cal(C)$, 因为其反变性, 每个 $alpha_i$ 给出
$ X(alpha_i) : X_n -> X_1 $
记作 $e_i$, 这些映射满足
$ d_0 e_i = d_1 e_(i+1) $
因为两条相邻的边在顶点 $i$ 相接, 我们可以得到图表

#web-diagram(diagram(spacing:6mm,{
	node((-1, 0), [$X_1$])
	node((0, 1), [$X_0$])
	node((1, 0), [$X_1$])
	node((2, 1), [$X_0$])
	node((4, 1), [$X_0$])
	node((5, 0), [$X_1$])
	node((2, -2), [$X_n$])
	node((3, 0), [$dots$])
	edge((2, -2), (-1, 0), [$e_1$], label-side: right, "->")
	edge((2, -2), (1, 0), [$e_2$], label-side: right, "->")
	edge((2, -2), (5, 0), [$e_n$], label-side: left, "->")
	edge((-1, 0), (0, 1), [$d_0$], label-side: right, "->")
	edge((1, 0), (0, 1), [$d_1$], label-side: left, "->")
	edge((1, 0), (2, 1), [$d_0$], label-side: right, "->")
	edge((5, 0), (4, 1), [$d_1$], label-side: left, "->")
	edge((3, 0), (2, 1), [$d_1$], label-side: left, "->")
	edge((3, 0), (4, 1), [$d_0$], label-side: right, "->")
}))

于是由拉回的泛性质, 我们可以定义:

#definition(title:[Segal 映射])[
  设 $X_bullet: Delta^opp -> cal(C)$ 是一个单纯对象, 对于 $n>=2$, 有 *Segal 映射*定义为
  $ phi_n:X_n -> underbrace(X_1 times_(X_0) X_1 times_(X_0) ... times_(X_0) X_1,\#n) $
]

#remark[
  换句话说, 给出 $Delta^n$ 的脊 $I^n arrow.hook Delta^n$, Segal 映射就是沿着脊嵌入诱导的限制
  $ X_n -> X(I^n) $
]

#definition(title:[内部范畴])[
  若一个单纯对象 $X_bullet:Delta^opp->cal(C)$ 的 Segal 映射对于 $n>=2$ 都是等价, 则称之为一个*内部范畴对象* (internal category object).
]

内部群胚的条件比 Segal 条件更强, 给定 $[n]={0,...,n}$ 的子集
$ S = {i_0<...<i_p} subset [n] $
则包含 $[p] simeq S arrow.hook [n]$ 诱导
$ X_n -> X_p $
记这个 $X_p$ 为 $X(S)$. 现在若 $[n]=S union T$, 且交于一点 $S inter T = {i}$, 则有自然映射
$ X_n -> X(S) times_(X({i}) simeq X_0) X(T) $

#definition(title:[群胚对象])[
  若一个单纯对象 $X_bullet:Delta^opp->cal(C)$ 对于任意分解 $[n]=S union T$, $S inter T = {i}$ 都有
  $ X_n ->^~ X(S) times_(X_0) X(T) $
  则称之为一个*内部群胚对象* (internal groupoid object).
]

== 几何实现

#definition(title:[几何实现])[
  对任何单纯对象 $X_bullet : Delta^opp->cal(C)$, 定义其*几何实现* (realization) 为
  $ abs(X_bullet) := colim_([n] in Delta^opp) X_n $
]

其满足典范的泛性质
$ Map_(cal(C)) (abs(X_bullet),Y) simeq lim_([n] in Delta) Map_(cal(C)) (X_n,Y) $

== Cech 脉

#definition(title:[Cech 脉])[
  设 $cal(C)$ 是具有有限极限的 $oo$-范畴. 设 $f:U->X$ 是态射, 定义一个典范的单纯对象, 称之为 *Cech 脉*如下:
  $ C(f)_bullet : Delta^opp -> cal(C) $
  其中
  $
  C(f)_n = overbrace(U times_X U times_X ... times_X U, \#n+1) \
  d_i : C(f)_n -> C(f)_(n-1), quad "删除第" i "个因子" \
  s_i : C(f)_n -> C(f)_(n+1), quad "重复第" i "个因子"
  $
]

#proposition[
  Cech 脉自动是内部群胚对象.
]

#proofsketch[
  直观上, 其自动满足 Segal 条件, 并且所有箭头都可逆, 交换两个因子就是逆箭头.
]

显然 Cech 脉天然是到 $X$ 的一个增广
$ C(f)_bullet -> X $
由余极限的泛性质得到唯一的
$ abs(C(f)_bullet) -> X $

#definition(title:[有效满射])[
  假设 $cal(C)$ 中存在 $f:U->X$ 的 Cech 脉的几何实现, 若增广
  $ abs(C(f)_bullet) ->^~ X $
  是等价, 则称 $f$ 是一个*有效满射* (effective epimorphism).
]

也就是说, $f$ 是有效满射当且仅当其 Cech 脉是 $X$ 的一个单纯解消.

= 一些重要结论

== Giraud 定理

Giraud 定理可谓是 $oo$-意象最重要的等价刻画之一

#theorem(title:[Giraud 定理])[
  一个可呈示的 $oo$-范畴 $cal(X)$ 是 $oo$-意象当且仅当满足:

  + 对任意 $f:X->Y$, 拉回 $f^*:cal(X)_(\/Y) -> cal(X)_(\/X)$ 保持所有余极限, 也就是说
    $ X times_Y colim_i Z_i simeq colim_i (X times_Y Z_i) $
  + 若 $X = product.co_(i) X_i$, 则不同的项的交为空 $X_i times_X X_j simeq nothing$, 对 $i!=j$.
  + 若 $U_bullet : Delta^opp -> cal(X)$ 是内部群胚对象, 则它来自某个 Cech 脉, 即
    $ U_bullet ->^~ C(U_0->abs(U_bullet))_bullet $
]

证明暂略.

== van Kampen 余极限

#definition(title:[van Kampen 余极限])[
  一个余极限称之为 *van Kampen 余极限*, 是指其在取切片范畴后变成极限. 具体地, 给定
  $ D:I->cal(C), quad X = colim_(i in I)D_i $
  则每个典范映射 $D_i->X$ 可以拉回对象得到
  $ Phi : cal(C)_(\/X) -> lim_(i in I^opp) cal(C)_(\/D_i) $
  van Kampen 条件就是在说这个比较函子是等价.
]

#proposition[
  设 $cal(X)$ 是 $oo$-意象, 则其中的余极限都是 van Kampen 的.
]

== 切片生象

#theorem(title:[下降定理])[
  设 $cal(X)$ 是 $oo$-意象, $p:U->X$ 是有效满射, 则有自然等价
  $ cal(X)_(\/X) simeq lim_([n] in Delta) cal(X)_(\/C(p)_n) $
]

#proof[
  由于 $oo$-意象的任何余极限都是 van Kampen 的, 取 $I = Delta^opp$ 和 $D= C(p)_bullet$ 即得
  $ cal(X)_(\/X) simeq lim_([n] in Delta) cal(X)_(\/C(p)_n) $
]

#proposition[
  设 $cal(X)$ 是 $oo$-意象, 且 $U in cal(X)$, 则 $cal(X)_(\/U)$ 是 $oo$-意象.
]

#proofsketch[
  只需在 $cal(X)$ 上尝试逐一验证 Giraud 即可.
]

直观地说, 进入 $cal(X)_(\/U)$ 就相当于在 $U$ 上做几何.
