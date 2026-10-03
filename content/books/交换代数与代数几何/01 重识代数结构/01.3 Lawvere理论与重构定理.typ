#import "../../../template.typ": *

#show: note

= Lawvere 理论

我们给出一个看上去人畜无害的定义, 但他是我们后续一切理论的基石.

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
    一个 *Lawvere $TT$-代数*就是一个保持有限积的函子
    $ A : TT -> Set in Fun^times (TT,Set) $
]

#claim[
    注意到, 若 $TT$ 是某个具有有限余极限范畴的对偶 $cal(C)^opp$, 那这个构造恰好是 $"1-"sInd(cal(C))$.
]

= Lawvere 重构定理

Lawvere 重构定理是 Lawvere 理论最核心的定理, 如果你愿意, 你可以先阅读这个定理的陈述, 然后看后面几节的内容, 品味这个定义的重要性后再细读这个证明. 证明中使用了_杠解消 (bar resolution)_, 这是一个来自单子论和单纯形理论的工具. 我不知道有没有更初等的证明方法, 如果你不知道什么是杠解消, 我非常建议你先去阅读一些相关的更深入的范畴论内容. 现阶段而言, 你大可承认常见的代数结构都满足下述定理的要求, 并满足对应的结论.

#theorem(title:[Lawvere 重构定理])[
    设有 1-范畴的伴随 $F:Set arrows.lr cal(C):U$, 并且 $cal(C)$ 具有筛余极限, $U$ 是保守的 ($U(f)$ 是同构蕴含 $f$ 是同构) 且保持筛余极限, 记 $cal(C)_"ff" subset cal(C)$ 是有限自由对象生成的全子范畴
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
    $ h'_X (F(S)) simeq Hom_Set (S,U(X)) simeq U(X)^S $
    若 $P=F(S)$, 其中 $S$ 是有限集, 而 $I$ 是筛范畴, 则
    $ Hom_(cal(C))(P,colim_(i in I)X_i) &simeq Hom_Set (S,U(colim_(i in I)X_i)) \ &simeq Hom_Set (S,colim_(i in I) U(X_i)) \ &simeq colim_(i in I) (Hom_Set (S,U(X_i))) $
    因此
    $ h'_(colim_(i in I) X_i) simeq colim_(i in I) h'_(X_i) $
    点态成立, 即 $h'_((-))$ 保持筛余极限. 接下来考虑这对伴随 $F tack.l U$ 的杠解消 $Bar_bullet (F,U;X)$. 显然由杠解消的性质有
    $ abs(Bar_bullet (F,U;X)) simeq X $
    并且每个
    $ Bar_n (F,U;X) = F(S_n) $
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
    $ A simeq colim_((P,a) in integral A) j(P) $
    我们可以在 $cal(C)$ 中取
    $ X = colim_((P,a) in integral A) P $
    存在性由上述证明的筛性保证, 由于 $h'_((-))$ 保持筛余极限以及 $h'_P = j(P)$, 不难推出
    $ h'_X simeq colim_((P,a) in integral A) h'_P = colim_((P,a) in integral A) j(P) simeq A $
    从而 $h'_((-))$ 本质满.

    最后考察全忠实性, 固定 $Y in cal(C)$, 考虑全体满足
    $ Hom_(cal(C))(X,Y) -->^~ "Nat"(h'_X,h'_Y) quad (*) $
    的 $X$, 对 $P in cal(D)$, 由 Yoneda 有
    $ "Nat"(h'_P,h'_Y) = "Nat"(j(P),h'_Y) simeq h'_Y (P) = Hom_(cal(C))(P,Y) $
    从而所以 $P in cal(D)$ 都满足 $(*)$. 更进一步, 若
    $ X = colim_i X_i $
    且所有 $X_i$ 都满足 $(*)$, 则
    $ Hom_(cal(C))(X,Y) &simeq lim_i Hom_(cal(C))(X_i,Y) \
    &simeq lim_i "Nat"(h'_(X_i),h'_Y) \
    &simeq "Nat"(colim_i h'_(X_i),h'_Y) \
    &simeq "Nat"(h'_X,h'_Y) $
    而 $cal(D)$ 筛生成 $cal(C)$, 从而所有 $X$ 都满足 $(*)$. 从而全忠实.
]
