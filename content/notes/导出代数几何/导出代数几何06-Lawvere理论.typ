#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节先引入一些 Lawvere 理论的知识, 对于后续定义生象环的部分非常有启发性.

= Lawvere 理论基本观念

== Lawvere 理论

#definition(title:[Lawvere 理论 / 定义一])[
  一个 *Lawvere理论* 是一个具有有限极限的小范畴 $TT$, 满足存在一个对象 $X$ 使得每个 $TT$ 的对象都同构于 $X$ 的一个有限积 $X^n$. $X$ 称为其*泛对象*.
]

我们还有一个等价定义, 当然可以很容易看出来二者等价性:

#definition(title:[Lawvere 理论 / 定义二])[
  定义范畴 $FF$ 的对象为 $NN$, 态射
  $ Hom_FF (m,n) := Map({1,...,m},{1,...,m}) $
  一个 *Lawvere理论* 是一个范畴 $TT$ 配备一个函子 $J:FF^opp->TT$, 满足 $J$ 在对象意义下是恒等的, 并且严格保持有限乘积.
]

Lawvere 理论之间的态射 $TT->TT'$ 是保持积和泛对象的函子, 记这个范畴为 $cat("Law")$.

对于一个 Lawvere 理论, 我们应该将其 Hom 集想作编码代数理论运算的全体. 例如 $TT(n,1):=TT(X^n,X)$ 就可以视作 $n$ 元运算的集合.

#definition(title:[$TT$-代数])[
  一个 *Lawvere $TT$-代数* 就是一个保持有限积的函子
  $ A : TT -> Set in Fun^times (TT,Set) $
]

#remark[
  注意到, 若 $TT$ 是某个具有有限余极限范畴的对偶 $cal(C)^opp$, 那这个构造恰好是 $"1-"sInd(cal(C))$.
]

#example(title:[刻画 Abel 群理论的 Lawvere 结构])[
  我们可以取
  $ TT_Ab := cat("FreeAb")_"fg"^opp $
  是全体有限生成自由 Abel 张成的 $Ab$ 的全子范畴的对偶. 其对象对应
  $ {0,1,2,...} |-> {0, ZZ^1, ZZ^2, ...} $
  我们来检查 $TT(n,1)$ 在此处的含义, 对于 Abel 群, 任何由群运算构造出来的 $n$-元运算最终都能唯一写成
  $ a_1 x_1 + ... + a_n x_n, quad a_i in ZZ $
  因此 $TT_Ab (n,1) simeq ZZ^n$, 例如 $TT_(Ab) (2,1) simeq ZZ^2$, 元素 $(a,b)$ 对应操作 $(x,y)|->(a x + b y)$. 反范畴恰好把自由代数之间的同态反转为多元代数操作. 一个 $TT_Ab$ 代数是一个保持有限积的函子
  $ A : TT_Ab -> Set $
  令 $X = A(1) := A(ZZ)$, 由于保持有限积, $A(n)=A(1^n) simeq X^n$. $T$ 中的态射
  $ + : 2->1, quad - : 1->1, quad 0 : 0->1 $
  被 $A$ 送到
  $ A times A -> A, quad A -> A, quad * -> A $
  恰好编码出 Abel 群公理. 反之, 给定 Abel 群 $Y$, 都能给出模型 $B(n) = A^n$, 并让
  $ (a_1,...,a_n) in TT(n,1) $
  作用为
  $ (x_1,...,x_n) |-> a_1 x_1 + ... + a_n x_n $
  我们导出了核心等价
  $ Fun^times (TT_Ab,Set) simeq Ab $
]

= 交换代数的 Lawvere 理论

== 如何通往生象环的理论

接下来我们进入我们引入 Lawvere 理论的正题: 我们希望定义一个编码 $CAlg_k$, 即 $k$-交换代数的 Lawvere 结构 $TT$, 使得
$ CAlg_k simeq Fun^times (TT,Set) $
并且我们有如下引理

#lemma[
  设 $cal(C)$ 是具有有限余极限的范畴, 则
  $ sInd(cal(C)) simeq sInd(cat("Idem")(cal(C))) $  
]

#proof[显然, 因为 $cat("Idem")(cal(C)) subset sInd(cal(C))$ 是自动的.]

然后我们将证明 $cat("Idem")(TT^opp)$ 恰好是 $CAlg_k$ 的紧投射对象, 这样我们可以直接将上述的 $Set$ 替换成 $Ani$ 来刻画生象交换 $k$-代数.

== 多项式范畴 $Poly_k$

#definition(title:[范畴 $Poly_k$])[
  定义 $Poly_k subset CAlg_k$ 为有限生成的自由交换 $k$-代数生产的全子范畴, 也就是说, 其对象为
  $ k[x_1,...,x_n], quad n>=0 $
  态射就是限制在这些代数之上的 $k$-代数同态.
]

下面我们定义其对应的 Lawvere 结构, 我们定义
$ TT_k := Poly^opp_k $
并令
$ n <-> k[x_1,...,x_n] $
因为在 $CAlg_k$ 中的推出就是张量积 $times.o_k$, 因此在 $TT_k$ 中
$ n times m := k[x_1,...,x_n] times.o_k k[x_1,...,x_m] simeq k[x_1,...,x_(n+m)] =: n + m $
确实满足 Lawvere 理论的对象结构.

#proposition[
  我们有 $TT_k (n,m) simeq k[x_1,...,x_n]^m$ 也就是 $m$ 个 $n$ 元多项式组成的集合.
]

#proof[
  由自由生成 $k$-代数的泛性质平凡. 映射构造为
  $ f <-> (f(y_1),...,f(y_m)) $
]

这也显示了在 $Poly_k$ 中, 一个态射完全由 $m$ 个 $n$ 元多项式组成的元组决定.

#proposition[
  $Poly_k subset CAlg_k^(omega"p")$, 也就是说 $k[x_1,...,x_n]$ 都是紧投射的 $k$-代数.
] <prop-poly-compact-projective-side-1>

#proof[
  记 $P_n = k[x_1,...,x_n]$. 只需证明 $Hom_(CAlg_k) (P_n, -)$ 保持筛余极限, 由自由的泛性质
  $ Hom_(CAlg_k) (P_n,A) simeq "oblv"(A)^n $
  其中 $"oblv":CAlg_k->Set$ 是遗忘函子. 设 $I$ 是筛的, 给定图表 $D : I -> CAlg_k$, 计算得
  $ Hom_(CAlg_k) (P_n, colim_(i in I) D(i)) & simeq "oblv"(colim_(i in I) D(i))^n \ & simeq (colim_(i in I) "oblv"(D(i)))^n \ & simeq colim_(i in I) "oblv"(D(i))^n \ & simeq colim_(i in I) Hom_(CAlg_k) (P_n, A) $
  其中 $"oblv"$ 显然保持筛余极限, 并且筛余极限在 $Set$ 中与有限积交换.
]

#corollary[
  显然紧投射对收缩封闭, 于是 $cat("Idem")(Poly_k) subset CAlg_k^(omega"p")$.
]

== Lawvere 重构定理

Lawvere 重构定理是 Lawvere 理论最核心的定理

#theorem(title:[Lawvere 重构定理])[
  设有 1-范畴的伴随 $F:Set arrows.lr cal(C):"oblv"$, 并且 $cal(C)$ 具有筛余极限, $"oblv"$ 是保守的 ($"oblv"(f)$ 是同构蕴含 $f$ 是同构) 且保持筛余极限, 记 $cal(C)_"ff" subset cal(C)$ 是有限自由对象生成的全子范畴
  $ "Ob"(cal(C)_"ff") := {F(S) | S in cat("FinSet")} $
  定义该伴随对应的 Lawvere 理论 $TT_F := cal(C)^opp_"ff"$, 那么有等价
  $ cal(C) simeq Fun^times (TT_F, Set) $
] <thm-lawvere-reconstruction>

#proof[
  记 $cal(D)=cal(C)_"ff"$, 函子
  $ h' : cal(C) -> Fun(cal(D)^opp, Set), quad h'_X := h_X|_(cal(D)) = Hom_(cal(C))(-,X) $
  首先由于 $cal(D)$ 具有有限余积, 因为 $F$ 是左伴随, 从而
  $ F(S union.sq T) simeq F(S) union.sq F(T), quad F(nothing) simeq 0 $
  于是在 $TT_F = cal(D)^opp$ 中, 这些变为有限乘积, 于是
  $ h'_X ((P union.sq Q)^opp) &= Hom_(cal(C))(P union.sq Q, X) \ &simeq Hom_(cal(C))(P,X) times Hom_(cal(C))(Q,X) $
  且 $h'_X (0) = *$, 从而
  $ h'_X : cal(C) -> Fun^times (TT_F,Set) $
  特别地, 对有限集 $S$, 有
  $ h'_X (F(S)) simeq Hom_Set (S,"oblv"(X)) simeq "oblv"(X)^S $
  若 $P=F(S)$, 其中 $S$ 是有限集, 而 $I$ 是筛范畴, 则
  $ Hom_(cal(C))(P,colim_(i in I)X_i) &simeq Hom_Set (S,"oblv"(colim_(i in I)X_i)) \ &simeq Hom_Set (S,colim_(i in I) "oblv"(X_i)) \ &simeq colim_(i in I) (Hom_Set (S,"oblv"(X_i))) $
  因此
  $ h'_(colim_(i in I) X_i) simeq colim_(i in I) h'_(X_i) $
  点态成立, 即 $h'_((-))$ 保持筛余极限. 接下来考虑这对伴随 $F tack.l "oblv"$ 的杠解消 $Bar_bullet (F,"oblv";X)$. 显然由上一节的结论, 有
  $ abs(Bar_bullet (F,"oblv";X)) simeq X $
  并且每个
  $ Bar_n (F,"oblv";X) = F(S_n) $
  都是某个集合 $S_n$ 上的自由对象, 而任何集合都是其有限子集的滤过余极限
  $ S_n simeq varinjlim(S' subset_"fin" S_n) S' $
  由于 $F$ 是左伴随, 有
  $ F(S_n) simeq varinjlim(S' subset_"fin" S_n) F(S') $
  滤过余极限也是筛余极限, 因此每个 $Bar_n (X)$ 都在有限自由对象筛余极限的闭包中, 再取几何实现, 可知 $cal(C)$ 由 $cal(D)$ 在筛余极限下生成.

  接下来证明 $h'_((-))$ 本质满. 取
  $ A in Fun^times (cal(D)^opp,Set) $
  考虑 Grothendieck 构造
  $ integral_(cal(D)) A $
  下面证明这是一个筛范畴, 首先 $A(0) simeq *$, 从而 $integral A$ 非空. 再取两个对象 $(P,a),(Q,b)$, 由于 $A$ 将积送到余积, 即
  $ A(P union.sq Q) -->^~ A(P) times A(Q) $
  存在唯一 $c in A(P union.sq Q)$ 对应于 $(a,b)$. 于是有典范的图表
  $ (P,a) -> (P union.sq Q,c) <- (Q,b) $
  事实上它在这两个对象的该图表范畴中是始对象, 若另有
  $ (P,a) -->^f (R,r) <--^g (Q,b) $
  则余积泛性质给出唯一的
  $ [f,g] : P union.sq Q -> R $
  并且 $A([f,g])(r)=c$. 因为其在 $A(P) times A(Q)$ 两个分量中正是
  $ A(f)(r) = a, quad A(g)(r) = b $
  于是任意两个对象的形如 $i -> bullet <- j$ 的范畴都有始对象, 其中 $i,j in integral A$ , 而这个范畴恰好是逗号范畴 $(i,j) arrow.b Delta$, 其中 $Delta:integral A -> integral A times integral A$ 是对角函子. 对任意 $i,j$ 该逗号范畴非空且连通等价于说 $Delta$ 是共尾的, 从而 $integral A$ 是筛的. 另一方面, Yoneda 稠密性给出
  $ A simeq colim_((P,a) in integral A) yo(P) $
  我们可以在 $cal(C)$ 中取
  $ X = colim_((P,a) in integral A) P $
  存在性由上述证明的筛性保证, 由于 $h'_((-))$ 保持筛余极限以及 $h'_P = yo(P)$, 不难推出
  $ h'_X simeq colim_((P,a) in integral A) h'_P = colim_((P,a) in integral A) yo(P) simeq A $
  从而 $h'_((-))$ 本质满.

  最后考察全忠实性, 固定 $Y in cal(C)$, 考虑全体满足
  $ Hom_(cal(C))(X,Y) -->^~ "Nat"(h'_X,h'_Y) quad (*) $
  的 $X$, 对 $P in cal(D)$, 由 Yoneda 有
  $ "Nat"(h'_P,h'_Y) = "Nat"(yo(P),h'_Y) simeq h'_Y (P) = Hom_(cal(C))(P,Y) $
  从而所以 $P in cal(D)$ 都满足 $(*)$. 更进一步, 若
  $ X = colim_i X_i $
  且所有 $X_i$ 都满足 $(*)$, 则
  $ Hom_(cal(C))(X,Y) &simeq lim_i Hom_(cal(C))(X_i,Y) \
  &simeq lim_i "Nat"(h'_(X_i),h'_Y) \
  &simeq "Nat"(colim_i h'_(X_i),h'_Y) \
  &simeq "Nat"(h'_X,h'_Y) $
  而 $cal(D)$ 筛生成 $cal(C)$, 从而所有 $X$ 都满足 $(*)$. 从而全忠实.
]

#corollary[
  我们有
  $ CAlg_k simeq Fun^times (Poly^opp_k, Set) $
  也就是说
  $ "1-"sInd(Poly_k) simeq CAlg_k $
] <cor-1sind-poly-calg>

最后我们来证明@prop-poly-compact-projective-side-1 的另一半

#proposition[
  $CAlg_k^(omega"p") subset cat("Idem")(Poly_k)$, 也就是说紧投射的 $k$-代数必然是某个有限生成多项式代数的收缩.
] <prop-poly-compact-projective-side-2>

#proof[
  设 $A in CAlg_k^(omega"p")$, 由@cor-1sind-poly-calg, 可作
  $ A simeq colim_(i in I) P_i, quad P_i in Poly_k $
  其中 $I$ 是筛的. 由于 $A$ 紧投射, 有
  $ Hom(A,A) simeq colim_(i in I) Hom(A,P_i) $
  特别地, $id_A in Hom(A,A)$ 必定来自某个 $Hom(A,P_i)$ 元素 $s:A->P_i$. 若 $r_i:P_i->A$ 是余极限的结构映射, 那么 $s$ 被映射到 $id_A$ 恰好意味着
  $ r_i compose s = id_A $
  也就是
  $ A -->^s P_i -->^(r_i) A $
  从而 $A$ 是某个 $P_i in Poly_k$ 的收缩.
]
