#import "../../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 自由 $C^oo$-环

== 基本构造

回忆
$ CooRing = Fun^times (Euc,Set) $
记
$ U : CooRing -> Set, quad A |-> A(RR) $
为遗忘函子.

#claim[
  遗忘函子 $U$ 存在左伴随 $F$, 使得对任意 $C^oo$-环 $A$ 都有双射
  $ Hom_(CooRing)(F(S),A) simeq Hom_Set (S,U(A)) $
]

#construction(title:[有限生成情形])[
  对于有限集合
  $ S = {x_1,...,x_n} $
  我们令
  $ F(S) = C^oo (RR^n) $
  这可以理解成可表函子
  $ h_(RR^n) = Hom_Euc (RR^n,-) $
  可表函子保持极限, 且
  $ U(h_(RR^n)) = h_(RR^n)(RR) = C^oo (RR^n) = F(S) $
  从而我们定义了
  $ F_0 : Fin -> CooRing $
]

我们想通过函子式定义使得自由性是自然的, 不难想到利用左 Kan 延拓的语言.

#definition(title:[自由 $C^oo$-环])[
  我们定义自由 $C^oo$-环函子 $F$ 为左 Kan 延拓
  #web-diagram(diagram({
	node((1, 0), [$Fin$])
	node((2, 0), [$Set$])
	node((1, 1), [$CooRing$])
	edge((1, 0), (2, 0), [$j$], label-side: left, "hook->")
	edge((1, 0), (1, 1), [$F_0$], label-side: right, "->")
	edge((2, 0), (1, 1), [$Lan_j F_0$], label-side: left, "-->")
  }))
  即 $F := Lan_j F_0 : Set -> CooRing$.
]

根据逐点公式, 上述构造可以用
$ F(S) simeq varinjlim((T->S) in Fin_(\/S)) F_0(T) $
计算.

#remark(title:[任何集合生成的自由 $C^oo$-环])[
  一种严格地理解任意 $F(S)$ 的方式, 是视作 $RR^S$ 上的函数, 对任何有限子集 $T subset S$, 定义
  $ pr_T : RR^S -> RR^T $
  是坐标投影. 那么
  $ F(S) = union.big_(T subset_"fin" S) pr_T^* C^oo (RR^T) subset Map(RR^S,RR) $
  一些文献将这样的函数称之为*光滑柱状函数* (smooth cylindrical functions). 例如当 $S = NN$ 时, 函数
  $ exp(x_6 x_7) + sin(x_114)cos(x_514) + 1919810 dot x_91^(x_78) in F(NN) $
  但注意, 无穷级数
  $ sum_(n=1)^oo 2^(-n) sin(x_n) in.not F(NN) $
  因为其依赖了无穷多个坐标.
]

由 Kan 延拓内蕴的性质, 我们很容易可以断言这确实就是我们要的 "遗忘的左伴随".

== 可呈示性

接下来我们看一个关键的引理:

#lemma(title:[$CooRing$ 的可呈示性])[
  我们有 $Ner(CooRing) in PrL$.
]

#proof[
  这个证明感觉还挺平凡的, 给一个我喜欢的证明: 对伴随
  $ F : Set arrows.lr CooRing : U $
  得到单子 $T = U F$, 容易验证由 Barr--Beck 有
  $ CooRing := Alg_T (Set) $
  $T$ 显然保持滤过余极限, 而有限元单子的代数范畴必然可呈示.
]

= $RR$-代数的光滑化

== $RR$-代数的 Lawvere 理论

我们知道, $CAlg_RR$ 的 Lawvere 理论对应是
$ Poly_RR = CAlg_RR^"free,fg" $
其对象为
$ RR[x_1,...,x_n] $
态射是限制在其上的全体 $RR$-代数同态. 而交换 $RR$-代数的 Lawvere 是
$ Poly^opp_RR $
注意这里有个反变, 因为 $Poly_RR$ 中的张量积是余积.

#remark[
  要理解 $Poly^opp_RR$ 的具体含义其实也不难, 只需对每个对象取 $Spec_RR$, 即
  $ Spec RR[x_1,...,x_n] simeq AA_RR^n $
  张量积变成空间的积
  $ AA^n_RR times_RR AA^m_RR $
  而多项式态射变成了仿射 $AA^n_RR$ 之间的多项式映射, 可以类比作 $RR^n$ 之间的多项式映射.
]

一个 Lawvere 理论的核心结论告诉了我们
$ CAlg_RR simeq Fun^times (Poly^opp_RR,Set) $

== 光滑化

#construction[
  不难意识到, 多项式映射总是光滑的, 我们实可诱导典范的嵌入
  $ j : Poly^opp_RR arrow.hook Euc $
  遗忘函子就是预复合
  $ j^* : CooRing -> CAlg_RR, quad (Euc->^A Set)|->(Poly->^j Euc->^A Set) $
]

#claim[
  存在左伴随使得
  $ "Smth" : CAlg_RR arrows.lr CooRing : j^*, quad "Smth" tack.l j^* $
]

#lemma[
  设 $cal(C)$ 是小的具有有限余积的范畴, 则
  $ "1-"sInd(cal(C)) simeq Fun^times (cal(C)^opp,Set) $
]

这是 Lawvere 代数的核心性质之一. 分别应用于
$ Poly_RR, quad Euc^opp $
就得到
$ CAlg_RR simeq "1-"sInd(Poly_RR), quad CooRing simeq "1-"sInd(Euc^opp) $

#definition(title:[光滑化])[
  我们定义*光滑化*函子 $"Smth"$ 就是函子作用下的
  #web-diagram(diagram({
	node((1, -1), [$Poly_RR^opp$])
	node((2, -1), [$Euc$])
	node((1, 0), [$CooRing$])
	node((2, 0), [$Alg_RR$])
	edge((1, -1), (2, -1), [$j$], label-side: left, "->")
	edge((2, -1), (2, 0), [$"1-"sInd((-)^opp)$], label-side: left, "|->")
	edge((1, -1), (1, 0), [$"1-"sInd((-)^opp)$], label-side: right, "|->")
	edge((2, 0), (1, 0), [$"Smth"$], label-side: left, "->")
  }))
  这显然是我们所求的左伴随.
]

我们甚至有伴随三角

#web-diagram(diagram({
	node((1, 1), [$CooRing$])
	node((2, -1), [$CAlg_RR$])
	node((3, 1), [$Set$])
	edge((1, 1), (2, -1), [$j^*$], label-side: left, shift: 0.05, "->")
	edge((2, -1), (1, 1), [$"Smth"$], label-side: left, shift: 0.05, "->")
	edge((2, -1), (3, 1), [$U$], label-side: left, shift: 0.05, "->")
	edge((3, 1), (2, -1), [$F$], label-side: left, shift: 0.05, "->")
	edge((1, 1), (3, 1), [$U$], label-side: right, shift: -0.05, "->")
	edge((3, 1), (1, 1), [$F$], label-side: right, shift: -0.05, "->")
}))

= 相对 $C^oo$-代数

== 关于相对情形的抽象废话

#lemma[
  $RR$ 是 $CooRing$ 范畴的始对象.
]

也就是说, $CooRing$ 可以视作范畴 $CooRing_(RR\/)$. 类似地, 我们可以定义相对的

#definition(title:[$A$-$C^oo$-代数])[
  设 $A in CooRing$, 定义一个 *$A$-$C^oo$-代数*为一个 $C^oo$-环的同态
  $ (A -> B) in CooRing_(A\/) =: CooAlg_A $
  注意这里的结构态射必须保持所有的光滑函数运算.
]

#remark[
  作为余切片范畴, 其典范地也具有任意极限和筛余极限. 始对象是 $id_A:A->A$.
]
