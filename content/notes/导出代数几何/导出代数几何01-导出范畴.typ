#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 链复形

== 链复形的定义

#definition(title:[链复形])[
  固定一个加性范畴 $cal(A)$, 我们定义*链复形* (chain complex) 就是 $cal(A)$ 中的微分分次对象, 也就是说, 一个(上)链复形是一串
  $ ... --> X^(-1) -->^(d^(-1)) X^0 -->^(d^0) X^1 -->^(d^1) ... $
  满足相邻的*微分态射* $d$ 复合为零态射, 一个链复形的态射, 即*链映射*定义为一列逐对象的态射, 与各自的微分都交换, 这样构成一个加性范畴 $Ch(cal(A))$.
]

#proposition[
  若 $cal(A)$ 是Abel范畴, 则 $Ch(cal(A))$ 亦然.
]

关于链复形的详尽理论是同调代数的主题, 此处不过多赘述.

== 链复形的张量积

下面固定一个交换环 $k$. 或者更一般地固定一个加性对称幺半范畴 $(cal(A),times.o,bold(1))$, 下以交换环为例, 余者自然.

#definition(title:[全复形])[
  *全复形* (total complex) 可以理解作一个函子 $"Tot":Ch(Ch(cal(A)))->Ch(cal(A))$, 逐对象定义作
  $ "Tot"(X)^n := plus.o.big_(p+q=n) X^(p,q) $
  逐微分态射定义作
  $ d_"Tot" = d_"hor" + (-1)^p d_"ver" $
]

#remark[
  因为
  $ d^2_"Tot" x &= d^2_"hor" x + (-1)^(p+1) d_"ver" d_"hor" x + (-1)^p d_"hor" d_"ver" x + d^2_"ver" x \ &= (-1)^p (d_"hor" d_"ver" - d_"ver" d_"hor") = 0 $
  这确实是链复形.
]

#definition(title:[链复形的张量积])[
  设 $(cal(A),times.o,bold(1))$ 是加性对称幺半范畴, 定义链复形的张量积为
  $ A^bullet op(times.o) B^bullet := "Tot"(A^bullet times.square B^bullet) $
  其中 $(A^bullet times.square B^bullet)^(p,q)=A^p times.o B^q$ 是典范诱导的双复形.
]

显然这使得 $(Ch(cal(A)), times.o, bold(1)_(cal(A))[0])$ 构成对称幺半加性范畴.

== Hom复形

#definition(title:[Hom复形])[
  设 $X,Y in Ch(cal(A))$ 是上链复形, 那么可以定义
  $ underline(Hom)(X,Y)^n := product_(p in ZZ) Hom_(cal(A)) (X^p, Y^(p+n)) $
  也就是说次数 $n$ 的元素就是全体
  $ f^p : X^p -> Y^(p+n) $
  定义微分为
  $ d(f) = d_Y compose f - (-1)^n f compose d_X $
  容易验证这构成一个 $Ab$-链复形, 若 $cal(A)$ 是 $k$-线性的, 则构成 $Mod_k$-链复形.
]

这显然使得 $Ch(k)$ 是天然充实于自身的.

= dg-范畴

== dg-范畴的定义

#definition(title:[dg-范畴])[
  固定交换环 $k$, 一个*dg-范畴* (differtial graded category) $cal(C)$ 就是充实于 $(Ch(k), times.o_k, bold(1)_k [0])$ 的范畴. 也就是说, 任何对象之间的Hom集被替换成Hom复形 $Hom_(cal(C))(X,Y)$, 并且有复合态射
  $ compose : Hom_(cal(C))(Y,Z) times.o Hom_(cal(C)) (X,Y) -> Hom_(cal(C))(X,Z) $
  以及单位 $k->Hom_(cal(C))(X,X)$.
]

#example[
  $Ch(k)$ 自身就是一个重要的dg-范畴.
]

#example[
  对于概形 $X$, 有完美复形的dg-范畴 $Perf^"dg" (X)$, 对象为完美复形, Hom是导出Hom的dg-模型 $underline("RHom")^bullet (E,F)$ 满足
  $ H^n underline("RHom")(E,F) tilde.eq Ext^n_X (E,F) $
  其dg-脉应该给出稳定 $oo$-范畴 $Perf(X)$.
]

== dga 和 cdga

下面固定一个交换环 $k$.

#definition(title:[dg-代数])[
  一个*dg-代数*, 简写*dga*, 是 $(Ch(k), times.o)$ 的结合代数对象, 即
  $ cat("dgAlg")_k := Alg(Ch(k)) $
  而*交换dg-代数*, 简写*cdga* 就是其交换代数对象, 即
  $ cat("cdgAlg")_k := CAlg(Ch(k)) $
]

#example[
  一个dga可以典范地视作一个只有一个对象的dg-范畴.
]

dga和cdga也可以非常直接地定义, 本质上就是分次环+微分. 一个dga就是一个 $ZZ$-分次的 $k$-代数
$ A = plus.o.big_(n in ZZ) A^n $
满足乘法保持次数
$ A^p A^q subset A^(p+q) $
配备一个次数 $+1$ 的 $k$-线性映射
$ d:A^n -> A^(n+1) $
满足 $d^2=0$, 以及分次Leibniz律
$ d(a b) = d(a)b + (-1)^(deg a) a d (b) $
而cdga就是额外要求了Koszul符号律
$ a b = (-1)^(deg a deg b) b a $

== dg-脉

dg-脉是微分分次的核心构造. 现在开始我们固定一个dg-范畴 $cal(C)_"dg"$, 下面我们逐步给出目标无穷范畴 $cal(C)_oo$ 的构造:

+ 首先对每对 $X,Y$ 取 $tau_(<=0)underline(Hom)(X,Y)$, 这里取的是好截断,也就是说
  $ (tau_(<=0) C)^n := cases(
    C^n quad & n<0,
    Z^0C:=ker(d : C^0->C^1) quad & n=0,
    0 quad & n>0
  ) $
+ 将上述结果重新编号得
  $ K_n (X,Y) := (tau_(<=0)underline(Hom)(X,Y))^(-n) $
  得到了复形
  $ K_bullet (X,Y) = (Z^0 <- underline(Hom)^(-1) <- underline(Hom)^(-1) <- ...) $
+ 由Dold--Kan对应, 有范畴等价 $"DK":Ch_(>=0)(k) -->^~ cat("sMod")_k$, 于是我们规定
  $ Map_(cal(C)_Delta) (X,Y) := "DK"(K_bullet (X,Y)) $
  得到了一个单纯范畴. 单纯范畴是无穷范畴的一种模型. 我们也可以作同伦相干脉函子 $Ner^"hc" (cal(C)_Delta)$ 换成拟范畴模型. 通常我们定义
  $ Ner^"dg" (cal(C)) := Ner^"hc" (cal(C)_Delta) $

现在我们来考察这个函子的含义, 其 0-单形就是 $cal(C)$ 的对象, 一个 1-单形
$ X_0 -> X_1 $
就是一个
$ f_(01) in Z^0 underline(Hom)(X_0,X_1) $
满足 $d f_(01)=0$, 也就是说一个 1-单形就是一个闭的度为零的态射. 而 2-单形刻画一种"复合"关系, 要求给定三个
$ f_(01) : X_0 -> X_1, quad f_(12) : X_1 -> X_2, quad f_(02) : X_0 -> X_2 $
给出一个单形的 filling
$ f_(012) in Hom^(-1) (X_0, X_2) $
满足
$ d f_(012) = f_(02) - f_(12) f_(01) $
也就是要求 $f_(02)$ 和 $f_(12) f_(01)$ 不严格相等, 但链同伦. 更高阶的单形刻画更高阶的相容关系. 因此 dg-脉的核心思想就是将 Hom 复形的负次数方向解释为 $oo$-范畴中的高阶态射, 注意这并没有丢失正次数的信息, 正次数的信息通常可以通过平移来恢复. 核心公式是
$ pi_n Map_(Ner^"dg" (cal(C))) (X,Y) tilde.eq H^(-n) underline(Hom)_(cal(C)) (X,Y) $

从现在开始, 我们可以将 $Ch(A)$ 视作一个由链复形, 链映射和高阶链同伦组成的无穷范畴.

= 导出范畴

== $oo$-范畴的局部化

我们先来规定一个记号, 设 $cal(C),cal(D)$ 是 $oo$-范畴, 并且指定一族态射 $W subset "Mor"(cal(C))$. 定义记号
$ Fun_W (cal(C),cal(D)) subset Fun(cal(C),cal(D)) $
是全体将 $W$ 中态射映为等价的函子张成的全子 $oo$-范畴.

#definition(title:[$oo$-范畴的局部化])[
  给定一个 $oo$-范畴 $cal(C)$ 以及一族 $W subset "Mor"(cal(C))$, 我们定义 *$oo$-范畴的局部化*是一个函子
  $ L:cal(C)->cal(C)[W^(-1)] $
  满足对每个 $w in W$, $L(w)$ 是 $cal(C)[W^(-1)]$ 是等价, 并且满足泛性质
  $ Fun(cal(C)[W^(-1)],cal(D)) tilde.eq Fun_W (cal(C),cal(D)) $
  对任意 $oo$-范畴 $cal(D)$ 成立.
]

也就是说, $cal(C)[W^(-1)]$ 就是普遍地将 $W$ 中所有态射变成等价的 $oo$-范畴, 这个构造在范畴等价的意义下显然是唯一的.

== 导出范畴

现在我们通过之前介绍的 dg-方法将 $Ch(cal(A))$ 视作 $oo$-范畴, 记 $"qis"$ 是所有拟同构的族, 我们可以给出导出范畴的定义:

#definition(title:[导出范畴])[
  固定一个Abel范畴 $cal(A)$, 其*导出范畴* (derived category) 定义为
  $ Dcat(cal(A)) := Ch(cal(A))["qis"^(-1)] $
]

#proposition[
  若 $cal(A)$ 是良好的 Abel 范畴, 例如 Grothendieck 范畴, 那么导出 $oo$-范畴通常是可呈示的稳定 $oo$-范畴, 即 $Dcat(cal(A)) in cat("Pr")^"L"_"st"$.
]

上述结论保证了导出范畴有任意的小极限, 并且可以使用伴随函子定理: 若 $F:cal(C)->cal(D)$ 保持余极限并满足可达性, 通常自动有右伴随.

== 导出范畴的 $t$-结构

#definition(title:[导出范畴的 $t$-结构])[
  给定 Abel 范畴 $cal(A)$, 我们可以在 $Dcat(cal(A))$ 上定义
  $
  Dcat_(<=0)(cal(A)) = {X | H^i (X) = 0 "对于" i>0} \
  Dcat_(>=0)(cal(A)) = {X | H^i (X) = 0 "对于" i<0} \
  Dcat_(<=n)(cal(A)) = Dcat_(<=0)(cal(A))[-n], quad
  Dcat_(>=n)(cal(A)) = Dcat_(>=0)(cal(A))[-n]
  $
  称之为导出范畴的*典范 $t$-结构*.
]

#theorem[
  $Dcat(cal(A))^suit.heart tilde.eq cal(A)$.
]

直观下, 设有复形
$ ... --> X^(-1) -->^(d^(-1)) X^0 -->^(d^0) X^1 --> ... $
且 $H^i (X) = 0$ 对 $i!=0$ 成立, 做好的截断
$ tau_(<=0) X = (... -> X^(-1) -> ker(d^0) -> 0 -> ...) $
再作 $tau_(>=0)$ 就只剩
$ coker(X^(-1) -> ker(d^0)) = H^0 (X) $
从而 $tau_(<=0)tau_(>=0) X = H^0(X)[0]$, 而由于 $X$ 没有其他上同调, 所有的截断态射都是拟同构, 因此在导出范畴中 $X tilde.eq H^0 (X)[0]$.

通常来说, $"h"Dcat(cal(A))$ 就是同调代数里引入过的三角范畴意义下的导出范畴, 不过从现在开始我们统一使用 $Dcat(cal(A))$ 作为导出 $oo$-范畴的语言.

= 环谱的模范畴

== 环谱

#remark[
  在之后的笔记中, 我们默认读者熟悉高阶代数 (Higher Algebra) 的部分基础知识
]

#definition(title:[环谱])[
  *环谱* (ring spectra) 是环的概念在稳定 $oo$-范畴语境的自然推广. 具体地, 他们是谱的对称幺半稳定 $oo$-范畴 $(Sp, smash, SS)$ 的 $EE_k$ 代数对象, 其中 $k in NN^* union {oo}$, 其中最常见的是 *$EE_1$-环谱*
  $ Alg(Sp) := Alg_(EE_1) (Sp) $
  和 *$EE_oo$-环谱*, 或称*交换环谱*
  $ CAlg(Sp) := Alg_(EE_oo) (Sp) $
]

一个普通的环可以通过 Eilenberg-MacLane 谱典范地视作一个环谱: 令 $K(A,n)$ 是只有第 $n$ 个同伦群是 $A$ 的 Eilenberg-MacLane 生象, 令 $K(A,0)$ 是离散生象, 标准等价
$ K(A,n) tilde.eq Omega K(A,n+1) $
给出 $Omega$-谱 
$ H A = (A,K(A,1),K(A,2),...) $
环结构所诱导的代数结构典范地经此提升, 这可以理解作一对伴随
$ pi_0 : Sp_(>=0) arrows.lr Ab : H $
以及
$ 
pi_0 : Alg(Sp)_(>=0) arrows.lr cat("Ring") : H \
pi_0 : CAlg(Sp)_(>=0) arrows.lr cat("CRing") : H
$
它还诱导了心层面的等价
$ pi_0 : Sp^suit.heart <->^~ Ab : H $

显示地, 一个 $EE_1$-环谱 $A$ 可以视作一个谱指定了运算和单位
$ mu : A smash A -> A quad eta : SS -> A $
再配备一系列同伦信息,  例如存在决定结合律的同伦
$ mu(mu smash 1) tilde.eq mu(1 smash mu) $
以及更多高阶同伦. $EE_oo$-环谱还要添加更高阶相干的交换律 $mu tilde.eq mu compose tau$ 等.

#definition(title:[同伦分次环])[
  设 $A$ 是一个 $EE_1$-环谱, 则
  $ pi_* A = plus.o.big_(n in ZZ) pi_n A $
  带有分次乘法
  $ pi_p A times.o pi_q A -> pi_(p+q) A $
  从而是一个 $ZZ$-分次环. 若 $A$ 还是 $EE_oo$-环谱, 则这个分次环满足Koszul符号律
  $ x y = (-1)^(p q) y x, quad x in pi_p A, quad y in pi_q A $
]

具体地, 由于同伦群定义为 $pi_p A = [S^p, A]$, 一个元素 $a in pi_p A$ 可以由谱映射 $a:S^p -> A$ 表示, 乘积 $a b in pi_(p+q) A$ 就定义为
$ S^(p+q) tilde.eq S^p smash S^q larr^(a smash b) A smash A -->^mu A $

这个构造通过广义上同调理论, 就诱导了我们熟悉的(上)同调环, 而dga通过取 $H^*$ 也天然诱导(上)同调环. 其间有关系图

#web-diagram(diagram({
	node((-1, -1), [$k"-dga" B$])
	node((0, -1), [$H^*(B)$])
	node((0, 0), [$pi_* A$])
	node((-1, 0), [$"algebra" A "over" H k$])
	edge((-1, -1), (0, -1), "~>")
	edge((-1, -1), (-1, 0), "<~>")
	edge((0, -1), (0, 0), "<~>")
	edge((-1, 0), (0, 0), "~>")
}))

== 环谱的模

现在我们希望定义的左模是带有同伦相干的作用
$ alpha : A smash M -> M $
的一种谱 $M$.

#definition(title:[模谱])[
  一个 $cat("LM")^times.o$-*模谱* (module spectra) 是对称幺半稳定 $oo$-范畴 $(Sp, smash, SS)$ 中的 $cat("LM")^times.o$-模对象, 即
  $ Alg_(cat("LM")^times.o) (Sp) $
]

由于我们有忘却函子 $Alg_(cat("LM")^times.o) (Sp) -> Alg_(EE_1) (Sp)$, 定义为 $(A,M)|->A$, 我们定义
$ LMod_A (Sp) := Alg_(cat("LM")^times.o) (Sp) times_(Alg_(EE_1) (Sp)) {A} $

上述定义也可换算畴为 $cat("RM")^times.o$ 或 $cat("BM")^times.o$, 得到的就是右模, 双模的对应物.

下面我们用符号 $Mod_A$ 默认代表 $LMod_A$.

#theorem[
  对任意 $EE_1$-环谱 $A$, $Mod_A$ 是可呈示的稳定无穷范畴, 即 $Mod_A in cat("Pr")^"L"_"st"$.
]

== 模范畴与导出范畴

环谱的模范畴之所以重要, 是因为它已经内蕴了所有的导出结构.

#definition(title:[模范畴的 $t$-结构])[
  给定连通环谱 $A$, 其模范畴的 $t$-结构定义为
  $
  Mod_(A,>=0) := {M : pi_i M = 0 "对任意" i<0} \
  Mod_(A,<=0) := {M : pi_i M = 0 "对任意" i>0}
  $
]

#proposition[
  $pi_0$ 给出普通 Abel 范畴的等价
  $ Mod_A^suit.heart tilde.eq Mod_(pi_0 A)^"ord" $
  右边表示是常规的模范畴
]

更重要的是下面的结论

#theorem[
  对于普通的交换环 $A$, 我们有 $oo$-范畴的等价
  $ Dcat(A) tilde.eq Mod_(H A) $
]

我们之后如果直接对环谱的模范畴定义函子, 一般意义下它都已经蕴含了导出信息, 例如 $Hom$ 自动替换为 $"RHom"$, 而 $times.o $ 换成 $times.o^"L"$.
