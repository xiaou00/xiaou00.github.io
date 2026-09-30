#import "../../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 是基底 $C^oo$-环, 若要得到普通 $C^oo$-环的理论, 取 $k=RR$ 即可.

= $C^oo$-环的理想

== 理想的定义

#definition(title:[$C^oo$-环的理想])[
    设 $A$ 是一个 $C^oo$-环, $A$ 的一个*理想* (ideal) 就是其作为交换 $RR$-代数的理想.
]

我们知道理想可以完全由生成元区分, 即, 设 $A$ 为 $C^oo$-环, $S subset A$, 则
$ (S) = {sum_(i=1)^n b_i s_i | b_i in A, s_i in S, n>=0} $
确实对应一个理想.

== 商的泛性质定义

我们可以先用非常典范的方式来定义 $C^oo$-代数中的商.

#definition(title:[$C^oo$-代数的商 / 有限元])[
    设 $A in CooAlg_k$, 给定 $f_1,...,f_n in A$. 那么存在两个 $k$-代数映射
    $
    phi :     k{x_1,...,x_n} -> A, quad x_i |-> f_i \
    epsilon : k{x_1,...,x_n} -> k, quad x_i |-> 0 $
    定义*商* (quotient) 为相对张量积
    $ A/(f_1,...,f_n) := A times.o^oo_(k{x_1,...,x_n}) k  $
]

也就是推出:

#web-diagram(diagram({
	node((1, -1), [$k{x_1,...,x_n}$])
	node((2, -1), [$A$])
	node((1, 0), [$k$])
	node((2, 0), [$A\/(f_1,...,f_n)$])
	edge((1, -1), (1, 0), [$x_i|->0$], label-side: right, "->")
	edge((1, -1), (2, -1), [$x_i|-> f_i$], label-side: left, "->")
	edge((2, -1), (2, 0), "->")
	edge((1, 0), (2, 0), "->")
	edge((1, -1), (2, 0), [$corner.r.b$], label-side: center, label-pos: 0.9, shift: 0.1, " ")
}))

对于任何理想, 我们也可以以同样的方式定义商:

#definition(title:[$C^oo$-代数的商 / 任意元])[
    设 $A in CooAlg_k$, 给定 $S subset A$, 那么存在两个 $k$-代数映射
    $
    phi :     k{S} -> A, quad x_s |-> f_s \
    epsilon : k{S} -> k, quad x_s |-> 0 $
    定义*商* (quotient) 为相对张量积
    $ A/(S) := A times.o^oo_(k{S}) k $
]

也就是下面图表的推出:

#web-diagram(diagram({
	node((1, -1), [$k{S}$])
	node((2, -1), [$A$])
	node((1, 0), [$k$])
	node((2, 0), [$A\/(S)$])
	edge((1, -1), (1, 0), [$x_s|->0$], label-side: right, "->")
	edge((1, -1), (2, -1), [$x_s|-> f_s$], label-side: left, "->")
	edge((2, -1), (2, 0), "->")
	edge((1, 0), (2, 0), "->")
	edge((1, -1), (2, 0), [$corner.r.b$], label-side: center, label-pos: 0.9, shift: 0.1, " ")
}))

这个定义亦就是说, 将指定的理想中的元素普遍地视作零得到的新的 $C^oo$-$k$-代数.

#proposition(title:[商的泛性质])[
    设 $I ideal A$, 商映射 $A->A/I$ 满足
    $ Hom_(CooAlg_k)(A/I,B) simeq {f:A->B | I subset ker f} $
] <prop-quotient-universal>

#proof[
    由#note-ref("./微分几何DoneRight03-C∞张量积",target:<thm-tensor-hom>), 有
    $
    Hom_k (A/I,B) &simeq Hom_k (k times.o^oo_(k{S}) A, B) \
                  &simeq Hom_(k{S}) (A,epsilon^*B) \ 
                  &simeq {g in Hom_k (A,B) | g compose phi = eta_B compose epsilon} \
                  &simeq {g in Hom_k (A,B) | g(a_s) = 0, forall s in S} \
                  &={g in Hom_k (A,B) | I subset ker g}
    $
]

== 商的显式定义

有一个没有那么自然, 但更加好算的商的等价定义, 也更契合我们对商的直觉.

#construction(title:[底层集合的构造])[
    对于 $A in CooAlg_k$, 且 $I ideal A$, 令 $A/I$ 的底层集合为
    $ abs(A/I) = {[a] | a in A} $
    其中
    $ [a] = [b] <=> a - b in I $   
]

再继续我们的构造之前, 我们先看一个引理:

#lemma(title:[Hadamard 引理])[
    设 $f in C^oo (RR^n)$, 则存在光滑函数
    $ g_1,...,g_n in C^oo (RR^(2n)) $
    使得对任意 $x,y in RR^n$, 都有
    $ f(x) - g(x) = sum^n_(i=1) (x_i - y_i)g_i (x,y) $
    并且可以取
    $ g_i (x,y) = integral_0^1 frac(partial f,partial x_i)(y+t(x-y)) dif t $
]

#proof[
    固定 $x,y in RR^n$, 定义
    $ h(t) = f(y + t(x-y)) $
    由微积分基本定理
    $ f(x) - f(y) = h(1) - h(0) = integral_0^1 h'(t) dif t $
    又由链式法则
    $ h'(t) = sum_(i=1)^n (x_i-y_i) frac(partial f, partial x_i) (y + t(x-y)) $
    代入得
    $ f(x) - f(y) &= sum_(i-1)^n (x_i-y_i) integral_0^1 frac(partial f,partial x_i)(y + t(x-y)) dif t \
    &= sum_(i=1)^n (x_i-y_i)g_i (x,y)  $
    被积函数关于 $(t,x,y)$ 光滑, 积分区间紧致, 显然 $g_i in C^oo (RR^(2n))$.
]

#construction(title:[$A/I$ 作为 $k$-代数])[
    现在对每个 $f:RR^n->RR$, 定义
    $ Phi^(A/I)_f ([a_1],...,[a_n]) = [Phi^A_f (a_1,...,a_n)] $
    我们只需要验证右边与代表元的选取无关: 由 Hadamard 引理, 存在光滑函数 $g_i$ 使得
    $ f(x) - f(y) = sum_(i=1)^n (x_i-y_i) g_i (x,y) $
    因此若 $a_i - b_i in I$, 则
    $ Phi^A_f (a) - Phi^A_f (b) = sum_(i=1)^n (a_i - b_i) Phi^A_(g_i) (a,b) in I $
    于是这个构造是良定义的, $C^oo$-环的公理直接继承, 并且结构态射给出
    $ k -> A -> A/I $
]

= 同构定理

== 第一同构定理

#lemma[
    设 $f:A->B$ 是 $C^oo$-代数的同态, 则 $im f = {f(a) | a in A} subset B$ 是一个 $B$ 的子 $C^oo$-代数.
]

#proof[
    对任何 $b_1,...,b_n in im f$, 可以选取 $a_i in A$, 使得 $b_i = f(a_i)$. 由于 $f$ 是 $C^oo$-同态, 则
    $ Phi_g^B (b_1,...,b_n) &= Phi^B_g (f(a_1),...,f(a_n)) \ &=f(Phi^A_g (a_1,...,a_n)) in im f $
    从而 $im f$ 对所有光滑运算封闭, 故是子 $C^oo$-代数.
]

#remark[
    我们也可以等价地将其识别为
    $ im f = "coEq"(A times_B A arrows^(p_1)_(p_2) A) $
]

#theorem(title:[第一同构定理])[
    设 $f:A->B$ 是 $C^oo$-代数的同态, 则
    $ A / ker f ->^~ im f $
] <thm-1st-iso>

#proof[
    由@prop-quotient-universal, $f$ 唯一分解为
    $ A -->^q A/I -->^(overline(f)) B $
    其中
    $ overline(f)([a]) = f(a) $
    由于
    $ ker overline(f) = 0 $
    所以 $overline(f)$ 单, 其像恰为 $f$, 证毕.
]

== 第二同构定理

#theorem(title:[第二同构定理])[
    设 $A subset B$ 是子 $C^oo$-代数, $I ideal B$, 则
    $ A/(A inter I) simeq (A+I)/I $
] <thm-2nd-iso>

#proof[
    考虑复合 $f:A arrow.hook B ->> B/I$, 显然 $ker f = A inter I$, 另一方面
    $ im f = {a + I | a in A} = (A + I)/I $
    直接应用 @thm-1st-iso 即证.
]

== 第三同构定理

#theorem(title:[第三同构定理])[
    设 $I subset J ideal A$, 则
    $ (A/I)/(J/I) simeq A/J $
] <thm-3rd-iso>

#proof[
    对任意 $B in CooAlg_k$, 有
    $
         &Hom_(CooAlg_k)((A/I)/(J/I),B) \ 
    simeq&{g:A/I->B | J/I subset ker g} \
    simeq&{f:A->B | J subset ker f} \
    simeq&Hom_(CooAlg_k)(A/J,B)
    $
    由 Yoneda 即证.
]
