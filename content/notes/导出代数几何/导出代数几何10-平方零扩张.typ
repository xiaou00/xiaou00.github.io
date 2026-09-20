#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 为什么需要导出?

== 经典理论过渡到导出

经典的微分理论将很多信息都 "压扁" 了, 对于普通的 $k$-代数 $A$, 经典微分由
$ dif : A -> Omega^1_(A\/k) $
控制, 且有
$ Der_k (A,M) tilde.eq Hom_A (Omega^1_(A\/k),M) $
这确实完美地表示了普通的平方零扩张
$ A plus.o M, quad M^2 = 0 $
在经典的微分中, 给定交换环 $A$ 和 $A$-模 $M$, 有分类的平方零扩张 $A plus.o M$, 乘法定义为
$ (a,m)(a',m') = (a a', a m' + a' m) $
从而 $M^2=0$. 几何上 $Spec A plus.o M -> Spec A$ 是在 $X = Spec A$ 上加了一个一阶的无穷小方向.

这里的 $M$ 完全位于第零位, 而导出的角度允许我们做更多: 在将 $A$ 推广到生象环, $M$ 推广到导出模 $Mod_A$ 后, 我们可以写 $A plus.o M[n]$. 在 $Mod_A$ 中他一样合法, 我们自然会想考虑
$ A plus.o M[n] $
上定义乘法, 由
$ (A plus.o M[n]) times.o_A (A plus.o M[n]) $
展开
$ tilde.eq A plus.o M[n] plus.o M[n] plus.o (M[n] times.o_A M[n]) $
规定四个部分
$
A times.o_A A &-> A quad ("用" A "自身的乘法") \
A times.o_A M[n] &-> M[n] quad ("用模的作用") \
M[n] times.o_A A &-> M[n] quad ("用模的作用") \
M[n] times.o_A M[n] &-> 0
$
也就是说
$ A plus.o M[n] plus.o M[n] plus.o (M[n] times.o_A M[n]) -> A plus.o M[n] $
定义为
$ (a,x,y,z) |-> (a,x+y) $
最后一项送到 $0$. 这个构造可以典范地视作是生象环, 下面给出这个构造的具体解释.

= 增广代数

下面的生象环可直接替换成生象 $k$-代数, 为了方便我们只讨论生象环的情形.

== 基本定义

我们知道一个生象 $A$-代数就是一个生象环 $B$ 连带一个生象环的映射
$ eta:A->B $
也就是说对象属于范畴
$ AniRing_(A\/) $
而增广代数则是这个想法的延伸:

#definition(title:[增广生象代数])[
  一个*增广 $A$-代数*就是一个图
  $ A -->^eta B -->^epsilon A $
  满足 $epsilon compose eta tilde.eq id_A$, 其中 $eta$ 将 $B$ 识别为 $A$-代数, 而 $eta:B->A$ 称为*增广映射*. 这也就是说 $A$ 是 $B$ 的一个收缩. 该范畴记作
  $ AugAlg_A := (AniRing_(A\/))_(\/id_A) $
]

可以将这个构造想成, 一个增广代数就是在代数 $B$ 的基础上选取一个合适的 $A$-值点.

显然一个增广对象可以同时典范视作 $AniRing_(A\/)$ 的元素, 也可以典范视作 $AniRing_(\/A)$ 的元素.

== 增广理想

#definition(title:[增广理想])[
  对于一个 $(A->^eta B->^epsilon A) in AugAlg_A$, 定义其*增广理想*为
  $ I = fib(B -->^epsilon A) $
  也就是遗忘到 $Mod_A$ 中取纤维得到的 $A$-导出模.
]

在普通环角度下, 这就是 $I = ker(epsilon)$, 例如
$ A[x] larr^(x|->0) A $
的增广理想就是 $I=(x)$. 直觉上, 增广理想就是 $I$ 在所选的原点处消失的函数.

因为 $A->^eta B->^epsilon A$ 具有截面, 所以有底层的 $A$-模序列
$ I -> B -> A $
是分裂的, 因此作为 $A$-模, 有典范的分解
$ B tilde.eq A plus.o I $
但这不一定是平方零的. 因为 $I$ 的内部可能有非零的乘法
$ I times.o_A I -> I $
例如刚才的例子 $I=(x)$ 中 $x dot x = x^2 != 0$ 不是平方零的. 若把增广代数 $B$ 想成 "在原点附近的函数", 那么增广理想 $I$ 是在原点消失的函数, 我们还有滤过
$ B supset I supset I^2 supset I^3 supset ... $
可以类比为 $I^n$ 表示 "至少 $n$ 阶小量的部分", 而商
$ B\/I^n $
就表示只保留常数项以及所有 $n-1$ 次项. 对于 $B\/I^2$, 这恰好是
$ B\/I^2 tilde.eq A plus.o (I\/I^2) $
对应一个平方零扩张.

== 与范畴 $AniCAlg_(k\/\/R)$

#definition[
  设 $k->R$ 是生象环映射, 即 $R$ 是生象 $k$-代数, 定义范畴
  $ AniCAlg_(k\/\/R) := (AniCAlg_k)_(\/R) $
  也就是全体分解
  $ k -> A -> R $
  构成的范畴.
]

更精确地, 我们有
$ Map_(AniCAlg_(k\/\/R))(A,B) tilde.eq Map_(AniCAlg_k)(A,B) times_(Map_(AniCAlg_k)(A,R)) {alpha:A->R} $

而所谓增广 $R$-代数, 本质上就是 $AniCAlg_(k\/\/R)$ 中的带基点对象. 即
$ AugAlg_R tilde.eq (AniCAlg_(k\/\/R))_* $
因为由定义我们有
$ AugAlg_R tilde.eq (AniCAlg_(k\/\/R))_(R\/) $
而我们有结论佐证这一点

#proposition[
  生象交换 $k$-代数 $R$ 是范畴 $AniCAlg_(k\/\/R)$ 的终对象. 
]

也正是因此, 我们有典范的忘基点遗忘函子
$ U : AugAlg_R -> AniCAlg_(k\/\/R) $

= 平方零扩张与导子

下面的生象环可直接替换成生象 $k$-代数, 为了方便我们只讨论生象环的情形.

== 函子 $A plus.o (-)$

现在, 考虑生象环 $A$ 以及任何连通的 $A$-导出模 $M$, 我们考虑下述构造:

对于单独的 $M in Mod^(>=0)_A$, 我们可定义最简单的乘法
$ M times.o_A M ->^0 M $
也就是规定 $M^2=0$. 于是 $M$ 被典范地视作了一个无幺的交换 $A$-代数, 然后定义底层的 $A$-模为
$ B := A plus.o M $
并规定乘法
$ mu : B times.o_A B -> B $
展开得
$ B times.o_A B tilde.eq A plus.o M plus.o M plus.o (M times.o_A M) $
定义
$ (a,x,y,z) |-> (a,x+y) $
元素直观就是 $(a,m)(b,n)=(a b, a n + b m)$.

这个构造具有显然的增广结构, 即有态射
$ s : A -> A plus.o M, quad a |-> (a,0) $
以及
$ epsilon : A plus.o M -> A, quad (a,m) |-> a $
且显然有 $epsilon compose s = id_A$, 这样得到的
$ A -> A plus.o M -> A $
是一个增广 $A$-代数, 且增广理想恰好是 $M$.

#proposition[
  有函子
  $ A plus.o (-) : Mod^(>=0)_A -> AugAlg_A $
]

事实上, 这个构造落在 $AugAlg_A$ 中的一个很小的范畴里, 显然我们构造的 $A plus.o (-)$ 的像就是分裂的平方零扩张增广代数的范畴, 我们甚至可以定义 $cat(SqZ)_A subset AugAlg_A$ 是其像.

#remark[
  有些时候为了防止歧义, 我们将上述函子记作
  $ SqZ_A : Mod^(>=0)_A -> AugAlg_A $
  并且由于有遗忘函子, 我们还可以作
  $ SqZ_A : Mod^(>=0)_A -> AniCAlg_(k\/\/A) $
]

#proposition[
  函子 $SqZ_A : Mod^(>=0)_A -> AniCAlg_(k\/\/A)$ 保持筛余极限和极限.
]

#proof[
  下记 $cal(C)=AniCAlg_k$, $cal(C)_(\/A)=AniCAlg_(k\/\/A)$. 并且设
  $ U : AniCAlg_k -> Mod^(>=0)_k $
  是遗忘函子
  $ V : Mod^(>=0)_A -> Mod^(>=0)_k $
  是限制标量. 由生象环的 Lawvere 理论描述可以简单地证得
  
  - $U$ 保守, 保持所有极限和筛余极限.
  - $V$ 保持极限和筛余极限.

  现在先证 $SqZ_A$ 保持筛余极限, 设 $I$ 是筛 $oo$-范畴, $M:I->Mod^(>=0)_A$, 有典范比较映射
  $ colim_i SqZ_A (M_i) -> SqZ_A (colim_i M_i) $
  对其应用 $U$, 因为 $U$ 保持筛余极限, 有
  $ U(colim_i (A plus.o M_i)) &tilde.eq colim_i (U(A) plus.o V(M_i)) \
  &tilde.eq (colim_i Delta U(A)) plus.o colim_i V(M_i) $
  筛范畴是弱可缩 (所有态射变成等价后可缩) 的, 有
  $ colim_i Delta U(A) tilde.eq U(A) $
  又因为这个筛余极限被 $V$ 保持
  $ colim_i V(M_i) tilde.eq V(colim_i M_i) $
  从而
  $ U(colim_i SqZ_A (M_i)) tilde.eq U(A) plus.o V(colim_i M_i) = U(SqZ_A (colim_i M_i)) $
  由于 $U$ 保守, 比较映射是等价, 从而 $SqZ_A$ 保持筛余极限.

  下面证明其保持极限, 对任意图
  $ X : J -> cal(C)_(\/A) $
  遗忘到 $cal(C)$ 的图依然为 $X$, 且有
  $ lim_(cal(C)_(\/A)) X tilde.eq A times_(lim_J Delta A) lim_J X quad (*) $
  令
  $ X_j = SqZ_A (M_j) = A plus.o M_j $
  设 $M := lim_J M_j$ 是在 $Mod^(>=0)_A$ 中的极限, 由 $U$ 保持极限, 我们有
  $ U(lim_J (A plus.o M_j)) tilde.eq lim_J (U(A) plus.o V(M_j)) $
  而在生象模中, $plus.o$ 是有限双积, 极限函子保持它
  $ lim_J (Delta U(M) plus.o V(M_j)) tilde.eq (lim_J Delta U(A)) plus.o (lim_J V(M_j)) $
  带入 $(*)$ 得到
  $ U(lim_(cal(C)_(\/A)) SqZ_A (M_j)) &tilde.eq U(A) times_(lim_J Delta U(A)) [(lim_J Delta U(A)) plus.o lim_J V(M_j)] \ &tilde.eq U(A) plus.o lim_J V(M_j) $
  再由 $V$ 保持极限有
  $ lim_J V(M_j) tilde.eq V(lim_J M_j) = V(M) $
  于是
  $ U(lim_J SqZ_A (M_j)) tilde.eq U(A) plus.o V(M) = U(SqZ_A (M)) $
  因此比较映射
  $ SqZ_A (lim_J M_j) -> lim_J SqZ_A (M_j) $
  经 $U$ 后等价, 而 $U$ 忠实, 证毕.
]

== 导子

上一节中, 我们在最后给出了经典情形的导子刻画
$ Der_k (A,M) tilde.eq Hom_((CAlg_k)_(\/A))(A,A plus.o M) $

我们可以直接定义导出情形下的导子

#definition(title:[导子])[
  设 $A$ 是生象交换 $k$-代数, $M$ 是 $A$-导出模, 定义 $A$ 到 $M$ 的 $k$-导子为
  $ Der_k (A,M) := Map_(AniCAlg_(k\/\/A))(A,A plus.o M) $
  这里左边的 $A$ 指切片中的对象 $A -->^id A$, $A plus.o M$ 指 $A plus.o M -->^epsilon A$.
]

这么看, 导子本质上就是一个图表

#web-diagram(diagram({
	node((-1, -1), [$A$])
	node((0, -1), [$A plus.o M$])
	node((0, 0), [$A$])
	node((-1, 0), [$A$])
	edge((-1, 0), (0, 0), "=")
	edge((-1, -1), (-1, 0), [$id$], label-side: right, "->")
	edge((-1, -1), (0, -1), [$s$], label-side: left, "->")
	edge((0, -1), (0, 0), [$epsilon$], label-side: left, "->")
}))

亦即 $epsilon compose s tilde.eq id$. 换句话说, 导子就是平方零扩张投影 $A plus.o M -> A$ 的一个截面.

#remark(title:[和熟悉的 Leibniz 导子的关系])[
  下设 $A,M$ 都是离散 $k$-代数和模, 设 $d:A->M$ 是一个普通函数, 可以由其构造
  $ s_d : A -> A plus.o M, quad a |-> (a, d(a)) $
  因为第一个分量是 $a$, 自动有
  $ epsilon s_d = id_A $
  现在要求 $s_d$ 是一个 $k$-代数的映射, 那么加法给出
  $ d(a+b) = d(a) + d(b) $
  乘法给出
  $ s_d (a b) = s_d (a) s_d (b) $
  左边有
  $ s_d (a b) = (a b, d(a b)) $
  而右边利用平方零的乘法
  $ (a,d(a))(b,d(b)) = (a b, a d(b)+b d(a)) $
  这就导出了 Leibniz 律
  $ d(a b) = a d(b) + b d(a) $
  并且由于 $s_d$ 是 $k$-代数映射
]

导子生象 $Der_k (A,M)$ 中有天然的基点, 即典范截面
$ s_0 : A -> A plus.o M, quad a |-> (a,0) $
也就是零导子.

#proposition[
  有典范的纤维序列
  $ Der_k (R,M) -> Map_(AniCAlg_k)(R, R plus.o M) larr^(epsilon_*:f
-> epsilon compose f) Map_(AniCAlg_k) (R,R) $
  第一个生象的基点是零导子, 第二个生象的基点是类似定义的 $s_0$ 截面, 第三个生象的基点是 $id_R$.
]

#proposition[
  $Der_k (R,-) : Mod_R^(>=0) -> Ani_*$ 是函子, 并且保持极限.
]

== 一般平方零扩张

上面, 我们只讨论了平方零扩张分裂的情况, 平方零扩张当然可以不分裂, 但怎么给出其合适的定义是一个很好的问题. 我们先来端详前述的 $R plus.o M$ 性质. 显然, $R plus.o M$ 可以视作 $AniAlg_(k\/\/R)$ 中的一个环路空间对象, 不难验证下面的方形是拉回方形

#web-diagram(diagram({
	node((0, -1), [$R plus.o M$])
	node((1, -1), [$R$])
	node((0, 0), [$R$])
	node((1, 0), [$R plus.o Sigma M$])
	edge((0, -1), (0, 0), "->")
	edge((0, 0), (1, 0), "->")
	edge((0, -1), (1, -1), "->")
	edge((1, -1), (1, 0), "->")
}))

而两边的 $R->R plus.o Sigma M$ 都由平凡导子给出. 图中给出
$ R plus.o M tilde.eq Omega(R plus.o Sigma M) $
由于 $Der_k (R,-)$ 保持极限, 下记 $cal(C) = AniCAlg_(k\/\/R)$, 有
$ Der_k (R,M) &tilde.eq Map_cal(C)(R,R plus.o M) \
              &tilde.eq Map_cal(C)(R,R times_(R plus.o Sigma M) R) \
              &tilde.eq Map(R,R) times_(Der_k (R,Sigma M)) Map(R,R) $
而因为 $R$ 是终对象, $Map_(cal(C))(R,R)tilde.eq *$, 于是有
$ Der_k (R,Sigma^n M) tilde.eq Omega Der_k (R,Sigma^(n+1)M) $
若令 $X_n := Der_k (R,Sigma^n M)$, 就得到一列
$ X_0, X_1, X_2, ... $
构成一个 $Omega$-谱. 容易验证这得到了一个 $Sp_(>=0)$ 的对象, 称之为*导子谱*, 记作 $underline(Der)_k (R,M)$.

回顾正题, 我们现在可以推广平方零扩张的定义到非分裂的情形

#definition(title:[平方零扩张])[
  设 $p:tilde(S)->S$ 是 $AniCAlg_k$ 的态射, 称其为 $S$ 关于 $M$ 的一个*平方零扩张* (square zero extension, SZE), 是指存在一个导子 $d in Der_k (S,Sigma M)$, 使得 $tilde(S)$ 可置入拉回方形
  #web-diagram(diagram({
      node((0, -1), [$tilde(S)$])
      node((1, -1), [$S$])
      node((0, 0), [$S$])
      node((1, 0), [$S plus.o Sigma M$])
      edge((0, -1), (0, 0), "->")
      edge((0, 0), (1, 0), [$d$], label-side: right, "->")
      edge((0, -1), (1, -1), [$p$], "->")
      edge((1, -1), (1, 0), [$0$], label-side: left, "->")
  }))
  其中横向态射 $d$ 是给定导子, $0$ 是零导子.
]

上述定义的核心思想, 就是将 $tilde(S)$ 识别为 $fib(d)$, 虽然这个纤维是在非线性的代数范畴取的.

在下一节的与切复形中, 我们会将这些概念更深一步地串联起来.
