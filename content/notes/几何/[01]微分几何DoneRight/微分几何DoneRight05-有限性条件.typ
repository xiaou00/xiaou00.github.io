#import "../../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 是基底 $C^oo$-环, 若要得到普通 $C^oo$-环的理论, 取 $k=RR$ 即可.

= 有限生成性

== 有限生成性的定义

#definition(title:[有限生成])[
    一个 $C^oo$-$k$-代数 $A$ 称之为*有限生成的* (finite generated), 是指存在 $n>=0$ 和满射
    $ k{x_1,...,x_n} ->> A $
    由第一同构定理, 等价地, 存在某个理想 $I$ 使得
    $ A simeq k{x_1,...,x_n}/I $
]

#proposition[
    $A$ 有限生成当且仅当有底层的正合列
    $ 0 -> I -> k{x_1,...,x_n} -> A -> 0 $
]

#proof[
    显然的.
]

== 有限展示性的定义

#definition(title:[有限展示])[
    一个 $C^oo$-$k$-代数 $A$ 称之为*有限展示的* (finite presented), 是指存在 $n>=0$ 和商
    $ A simeq k{x_1,...,x_n}/(f_1,...,f_m) $
]

#proposition[
    $A$ 有限展示当且仅当有底层的正合列
    $ k{x_1,...,x_n}^(plus.o m) larr^((f_1,...,f_m)) k{x_1,...,x_n} -> A -> 0 $
]

#proof[
    显然的.
]

我们记这有限生成和有限展示的 $C^oo$-代数的范畴分别为
$ CooAlg_k^"fg", quad CooAlg_k^"fp" $

== 一个有限生成但非有限展示的例子

#construction[
    我们考虑理想
    $ I = {f in C^oo (RR) : f "在" 0 "的某个开邻域上消失"} $
    这个理想不是有限生成的, 假若 $I = (f_1,...,f_n)$, 则所有 $f_i$ 在某个公共邻域 $U$ 上消失, 从而其生成的全部函数都在其上消失. 但我们可以构造一个支集包含在 $U\\{0}$ 中的非零光滑函数, 并且其属于 $I$. 因此
    $ A = C^oo (RR)/I $
    是一个有限生成但非有限展示的 $C^oo$-环.
]

== 有限展示与紧性

#theorem[
    一个 $C^oo$-$k$-代数是有限展示的当且仅当它是 $CooAlg_k$ 中的紧对象, 也就是说, 其保持所有滤过余极限.
]

= 一些例子

本篇剩余的篇幅给出一些经典例子的计算.

== 点嵌入

#construction[
    考虑原点嵌入
    $ i : * -> RR^n $
    诱导的同态
    $ i^* C^oo (RR^n) -> RR, quad f |-> f(0) $
    由于
    $ ker i^* = (x_1,...,x_n) $
    由第一同构定理
    $ C^oo (RR^n)/(x_1,...,x_n) simeq RR $
    事实上, 对任意点 $a=(a_1,...,a_n)$ 都有
    $ C^oo (RR^n)/(x_1-a_1,...,x_n-a_n) simeq RR $
]

这启发我们可以定义 $Spec_oo A$ 上的一个点为 $p:*->Spec_oo A$, 这相当于一个
$ p^*:A -> RR $
这已经揭示了微分几何对象内在的*点函子*结构:

#definition(title:[$Spec_oo$ 作为空间])[
    我们定义
    $ Spec_oo : CooRing^opp -> Set, quad A |-> Hom_(CooRing)(-,RR) $
    也就是说, 一个 $A$ 上的 $RR$-点是一个 $C^oo$-环同态
    $ x : A -> RR $
    而我们可以定义 $Spec_oo A$ 上的拓扑, 其开集总是形如
    $ U_c := { x in Spec_oo A : x(c) !=0 } , quad c in A $
    容易验证这构成一个拓扑空间, 并且是函子
    $ Spec_oo : CooRing^opp -> Top $
]

== 二次曲线嵌入

#construction(title:[抛物线])[
    现在考虑光滑嵌入
    $ i:RR->RR^2, quad t|->(t,t^2) $
    像是抛物线 $P={(x,y):y=x^2}$, 则限制
    $ i^*:C^oo (RR^2) -> C^oo (RR) $
    满足
    $ i^*(f)(t) = f(t,t^2) $
    对于任何满足 $f(x,x^2)=0$ 的光滑函数, 有
    $ f(x,y) = f(x,y) - f(x,x^2) \
    = (y-x^2) integral_0^1 frac(partial f,partial y)(x, x^2 + t(y - x^2)) dif t $
    依然光滑, 因此
    $ f in (y-x^2) $
    这证明了
    $ ker i^* = (y-x^2) $
    于是
    $ C^oo (P) simeq C^oo (RR^2) / (y-x^2) simeq C^oo (RR) $
]

#implicit-plot(
    (x,y) => y - x*x,
)

这初步预示了, 商一个方程, 就是在几何中添加这个方程的关系.

== 两个点与非约化点

#construction[
    考虑嵌入
    $ i:{-1,1} arrow.hook RR $
    反过来诱导
    $ i^*: C^oo (RR) -> RR times RR, quad f |-> (f(-1),f(1)) $
    而
    $ f(-1)=f(1)=0 <=> f in (x^2-1) $
]

#construction[
    考虑
    $ B = C^oo (RR) / (x^2) $
    利用 Taylor 展开, 得
    $ f(x) = f(0) + x f'(0) + x^2 g(x) $
    从而
    $ B simeq RR[epsilon]/(epsilon^2) $
]

== 两个曲线的交

#construction[
    考虑 $RR^2$ 中的两条曲线
    $ X = {(x,y) : y = x^2}, quad Y = {(x,y) : y = 0} $
    只有一个交点 $(0,0)$, 但在该点并不横截相交, 其对应的环分别为
    $ A = CC^oo (RR^2)/(y-x^2) \
    B = C^oo (RR^2)/(y) $
    令 $R = C^oo (RR^2)$, 则
    $
    A times.o^oo_R B &simeq R/(y-x^2,y) \
                     &simeq C^oo (RR)/(x^2) \
                     &simeq RR[epsilon]/(epsilon^2)
    $
    保留了一个无穷小的信息.
]

== 一个非多项式的例子

#construction[
    考虑
    $ A = C^oo (RR) / (sin x) $
    几何上, $sin x$ 的零点集是
    $ Z(sin x) = pi ZZ = {n pi : n in ZZ} $
    容易证明
    $ C^oo (RR) / (sin x) simeq C^oo (pi ZZ) simeq product_(n in ZZ) RR $
    若考虑
    $ B = C^oo (RR^2) / (sin x-y) $
    几何上这降了一维, 得到的就是下图中的函数图像 $Gamma_sin$
    #function-plot(
        (x) => calc.sin(x),
    )
    不难猜想并验证
    $ C^oo (RR^2)/(sin x-y) simeq C^oo (RR) $
]

