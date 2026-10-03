#import "../../../template.typ": *

#show: note

= 极大谱

为了方便初步理解交换代数的概念在几何上都干了什么, 我们可以定义极大谱的概念

#definition(title:[极大谱])[
    设 $A$ 是交换环, 定义*极大谱* (maximal spectrum) $Specm A$ 为全体 $A$ 的极大理想构成的集合.
]

#remark[
    需要注意的是, $Specm$ 不是一个函子, 真正具有函子性的是 $Spec$, 接下来就会介绍.
]

我们知道, 极大理想对应一个剩余域, 于是极大谱可以理解为所有域值点构成的集合, 直觉上就是这个概形的点集. 我们也可以相对基环定义这个概念, 回顾一个 $A$-代数 $B$ 其实就是指一个环同态
$ A->B $
并且范畴 $CAlg_A$ 本质上就是切片范畴 $CAlg_(A\/)$. 当我们取代数闭域 $overline(k)$ 时, 极大谱基本上就只有 $overline(k)$-点, 这可以理解成所有的 (有限) 代数方程组的解都落在自身中, 无需扩域就能 "看到" 所有的点, 我们在介绍了 _Hilbert 零点定理_后会详细证明这个直觉.

= 素谱

#definition(title:[范畴 $Aff$])[
    我们定义范畴 $Aff$ 是全体形如
    $ Spec A := Hom_CAlg (A,-) $
    的函子构成的 $Fun(CAlg,Set)$ 的全子范畴, 其对象称之为*仿射概形* (affine scheme). 对于基环 $k$, 也可以讨论 $Aff_k$ 是全体形如
    $ Spec_k A := Hom_(CAlg_k) (A,-) $
    的函子构成的 $Fun(CAlg_k,Set)$ 的全子范畴, 其对象称之为 *$k$-仿射概形*.
]

#remark[由于 $ZZ$ 是 $CAlg$ 始对象, $CAlg$ 可以视作 $CAlg_ZZ$, 下面我们总是固定一个交换环 $k$ 作为基底, 并记 $Spec_k = Spec$. 常规环的理论取 $k=ZZ$ 就能得到.]

#claim[Yoneda 嵌入直接诱导范畴等价 $Spec : CAlg_k^opp ->^~ Aff_k$.]

至于为什么这个构造叫做素谱, 我们之后会给出其传统定义. 显然对于任何环 $B$, $Spec A (B)$ 就给出了 $Spec A$ 的所有 $B$-值点, 从现在开始我们将 $Spec A$ 视作代数几何对象.

= 自由代数

现在我们回归标题. 范畴论中, 我们介绍过_伴随函子_的概念, 简单来说, 这是一个刻画函子对偶性的概念. 往深层次说, 伴随函子本质上都是一种_自由构造 vs 遗忘构造的配对_.

#example[
    自由群函子和遗忘函子
    $ F : Set arrows.lr Grp : U $
    是一对伴随对, 总有
    $ Hom_Grp (F(X),G) simeq Hom_Set (X,U(G)) $
]

于是
#quote[自由是遗忘的左伴随]
不止是一句略带哲学意味的台词, 更是每一个几何学家都应该铭记在心的口诀.

#claim[
    $k[-]:Set->CAlg_k, S|->k[x_s : s in S]$ 是自由函子.
]

#proof[
    只需验证泛性质成立. 给定一个 $k$-同态
    $ phi : k[S] -> A $
    它完全由各个生成元的像
    $ phi(x_s) in A, quad s in S $
    决定, 从而得到集合映射
    $ S -> U(A), quad s |-> phi(x_s) $
    而反过来, 给定任意集合态射
    $ f : S -> U(A) $
    令 $x_s |-> f(s)$, 对任意多项式
    $ P(x_(s_1),...,x_(s_n)) in k[S] $
    定义
    $ tilde(f)(P) = P(f(s_1),...,f(s_n)) in A $
    多项式只使用 $k$ 中的系数和 $A$ 中的加法乘法, 这给出唯一的 $k$-代数同态
    $ tilde(f):k[S]->A $
    两种构造互逆, 所以
    $ Hom_(Alg_k)(k[S],A) simeq Hom_Set (S,U(A)) $
]

#corollary[
    任何 $k$-代数 $A$ 都被某个自由代数满射, 即存在 $k[S]->>A$.
]

= 自由代数的几何图景

为了让概念理解起来更简便, 我们取 $k$ 是一个域. 则
$ k[nothing] simeq k $
对应的几何对象 $Spec k$ 就是一个单纯的点, 并且 $(Spec k)(k) simeq *$.

现在我们逐步添加自由度, 对于一般的 $k[S]$ 而言, 由自由代数的泛性质, 我们有
$  (Spec k[S])(k) = Hom_(Alg_k)(k[S],k) simeq Hom_Set (S,abs(k)) simeq abs(k)^S $
也就是以 $k$ 为坐标系数的 $S$ 维笛卡尔空间, 例如当 $k = RR$, $S = {1,...,n}$ 时, 其 $RR$-点空间就是 $RR^n$.

#remark[
    这也是为什么从现在开始, 我们都记
    $ Spec_k k[x_1,...,x_n] =: AA^n_k, quad Spec_k k[S] =: AA^S_k $
    这个构造在代数几何里称之为 *$k$-仿射空间* (affine space).
]

而任何 $k$-代数都是某个自由代数的子代数, 反过来, 我们就得到

#claim[
    任何 $k$-仿射概形都是某个仿射空间的 (闭) 子概形.
]
