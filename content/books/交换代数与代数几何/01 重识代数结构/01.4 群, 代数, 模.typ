#import "../../../template.typ": *

#show: note

本节中将简要断言三个代数对象的刻画模型, 论证方面会有比较大的 gap, 若感兴趣可以自行查询.

= 群论的模型

#construction(title:[群词范畴 $Word$])[
    我们定义范畴 $Word$ 为有限生成自由群的范畴, 等价地, 其对象为所有有限集, 一个态射 $S->T$ 就是给每个 $s in S$ 都指定一个 $T$-群词. 态射的复合就是代入. 例如
    $ R = {a,b}, quad S = {x,y}, quad T = {u,v} $
    有两个态射
    $
    R -> S, quad a |-> x y x, quad b |-> x^(-1) y \
    S -> T, quad x |-> v u^(-1), quad y |-> u^2
    $
    则 $R->S->T$ 就是代入运算
    $ a |-> (v u^(-1))u^2 (v u^(-1)) = v u v u^(-1) \
      b |-> (v u^(-1))^(-1) u^2 = u v^(-1) u^2 $
    我们可以典范地将等价的有限集压缩成一个对象, 记这些对象为
    $ 1,2,... $
]

#claim[
    $Word^opp$ 是一个 Lawvere 理论, 它刻画群结构, 有
    $ Grp simeq Fun^times (Word^opp, Set) $
]

我们可以这么理解这一构造. 所谓群乘法由 $Word^opp$ 中的态射
$ 2->1, quad z |-> x y $
控制, 对于一个模型
$ G : Word^opp -> Set $
将上述态射送到
$ G(2) simeq G(1) times G(1) -> G(1) $
类似地, 逆元由
$ 1->1, quad x |-> x^(-1) $
单位由
$ 0->1, quad x |-> overline(Lambda) $
控制.

#claim[
    设 $cal(C)$ 是具有有限积的范畴, 则其中的群对象就是
    $ Grp(cal(C)) := Fun^times (Word^opp, cal(C)) $
]

= 代数的模型

#construction(title:[多项式范畴 $Poly_k$])[
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

#claim[
    $Poly_k^opp$ 就是刻画代数的 Lawvere 理论. 即
    $ CAlg_k simeq Fun^times (Poly_k^opp, Set) $
    对任何有有限积的范畴 $cal(C)$, $k$-代数对象就是
    $ CAlg_k (cal(C)) simeq Fun^times (Poly_k^opp, cal(C)) $
]

这无非是说 $Poly_k$ 通过筛余极限生成 $k$-代数范畴, 即 $CAlg_k simeq Ind^1 (Poly_k)$.

= 模的模型

#construction(title:[矩阵范畴 $Mat_k$])[
    定义范畴 $Mat_k$ 的对象为 $1,2,...$ 态射为
    $ Hom_(Mat_k) (n,m) = M_(m times n)(R) $
    复合就是矩阵乘法, $n+m$ 就是积, 于是这构成一个 Lawvere 理论.
]

#claim[ 
    $Mod_k^opp$ 就是刻画模的 Lawvere 理论. 即
    $ CAlg_k simeq Fun^times (Mat_k^opp, Set) $
    对任何有有限积的范畴 $cal(C)$, $k$-模对象就是
    $ CAlg_k (cal(C)) simeq Fun^times (Mat_k^opp, cal(C)) $
]

读者可以自己思考这些运算是如何编码的.
