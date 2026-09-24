#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 为任意交换环.

= 生象环的 $pi_*$

== $pi_n$ 的定义

上节提到过我们可以将 $A in AniCAlg_k$ 典范地视作一个交换环谱. 但我们还有另一种方法来解释生象环的 $pi_n$, 将在接下来的内容中介绍.

对于
$ A : Poly^opp_k -> Ani $
保持有限乘积, 显然有
$ A(k[x_1,...,x_r]) simeq A(k[x])^r $
我们用 $abs(A)$ 记录生象 $k$-代数 $A$ 的底层生象
$ abs(A) := A(k[t]) $
我们意识到整个 $A$ 已经由其控制. 普通的环运算已经完全由多项式映射给出, 例如加法和乘法
$ k[t] -> k[x,y], quad t |-> x+y $
和
$ k[t] -> k[x,y], quad t |-> x y  $
取反后都得到
$ +, dot : abs(A) times abs(A) simeq A(k[x,y]) -> A(k[t]) = abs(A) $
而
$ k[t] -> k[x], quad t |-> -x $
和
$ k[t] -> k, quad t |-> 0 $
也给出
$ - : abs(A) -> abs(A), quad 0 : * -> abs(A) $
这里, $0$ 恰好给出了一个典范的点, 于是我们可以定义同伦群

#definition(title:[生象环的同伦群])[
  设 $A$ 是生象 $k$-代数, 定义其*同伦群* (homotopy group) 为
  $ pi_n (A) := pi_n (abs(A),0) $
]

== $pi_0$ 作为 $k$-代数

我们可以论证 $pi_0 (A)$ 具有典范的 $k$-代数结构. 只需逐点追加作用
$ pi_0 : Ani -> Set, quad P |-> pi_0 (A(P)) $
由于 $pi_0$ 保持有限乘积, 因此
$ pi_0 A in Fun^times (Poly^opp_k,Set) $
而经典 Lawvere 重构恰好给出
$ Fun^times (Poly^opp_k,Set) simeq CAlg_k $
其底层的集合恰好是
$ pi_0 (abs(A)) $

== 同调观点

经典的遗忘函子
$ U : CAlg_k -> Mod_k $
保持筛余极限, 于是可以生象化为
$ U : AniCAlg_k -> AniMod_k $
而 $AniMod_k simeq Dcat_(>=0)(k)$, 从而对于 $A in AniCAlg_k$ 忘掉乘法后, 本质上就是一个连通的导出 $k$-模 (拟同构意义下唯一的链复形), 即 $U(A) in Dcat_(>=0)(k)$, 并且有核心对应
$ pi_n (A) simeq H_n (U(A)) $

== 同伦分次环

上述结构中, 仅仅知道 $pi_n$ 和 $H_n$ 的定义并没涉及乘法结构, 由于单纯 $k$-代数具有逐级乘法
$ A_bullet times.o_k A_bullet -> A_bullet $
Dold--Kan 函子虽然不是严格对称幺半函子, 但确实是松对称幺半的. 即有 shuffle map
$ DK(A) times.o DK(A) -->^"sh" DK(A times.o A) $
再复合乘法, 就在同伦上得到了
$ pi_p (A) times.o_(pi_0 A) pi_q (A) -> pi_(p+q) (A) $
可以证明
$ pi_* A = plus.o.big_(n>=0) pi_n (A) $
确实是一个非负分次 $k$-代数, 并且满足 Koszul 交换律
$ x y = (-1)^(p q) y x $
并且这个定义和先视作交换环谱后的同伦分次环是一致的.

= Postnikov 理论

== 截断与基础 Postnikov

对于一个生象 $X$, 其称之为 *$n$-截断的*, 若对任意 $x$ 和 $i>n$ 有
$ pi_i (X,x) simeq 0 $
等价地, 对任意空间 $Y$, $Map(Y,X)$ 都是 $n$-截断的空间. 可以得到全子范畴
$ Ani_(<=n) arrow.hook Ani $
这个包含函子具有左伴随 $tau_(<=n)$, 称之为*截断函子* (truncation). 容易验证这个函子保持有限乘积, 于是对
$ A : Poly^opp_k -> Ani $
我们可以逐点定义
$ (tau_(<=n)A)(P) = tau_(<=n)(A(P)) $
这仍然保持有限乘积, 因此
$ tau_(<=n) A in AniCAlg_k $
满足
$
pi_i (tau_(<=n) A) = cases(
  pi_i (A) quad & i<=n,
  0 quad & i>n
)
$

特别地有 $tau_(<=0)A simeq pi_0 A$, 右边看作离散生象环. $A->tau_(<=n)A$ 的态射由伴随函子 $tau_(<=n) tack.l i_n$ 立即得到. 而 $tau_(<=n)A -> tau_(<=n-1)A$ 的态射由于有 $A larr^(eta_(n-1)) tau_(<=n-1)A$, 由于目标是 $n$-截断的, 利用 $A larr^(eta_n) tau_(<=n)A$ 的泛性质唯一地分解为

#web-diagram(diagram({
	node((-1, 0), [$A$])
	node((0, 0), [$tau_(<=n)A$])
	node((0, 1), [$tau_(<=n-1)A$])
	edge((0, 0), (0, 1), [$p_n$], label-side: left, "->")
	edge((-1, 0), (0, 0), [$eta_n$], label-side: left, "->")
	edge((-1, 0), (0, 1), [$eta_(n-1)$], label-side: right, "->")
}))

直观上, 他们都是忘掉高阶同伦信息的态射, 于是我们有构造

#definition(title:[Postnikov 塔])[
  对于一个生象 $k$-代数 $A$, 有 *Postnikov 塔*定义为一条链
  $ A -> ... -> tau_(<=3) A -> tau_(<=2) A -> tau_(<=1) A -> pi_0 A $
]

正如我们所期待的那样, Postnikov 塔是收敛的, 即

#theorem[
  对于上述的 Postnikov 塔, 总有 $A simeq varprojlim(n) tau_(<=n)A$.
]

#proofsketch[
  因为生象本身是 Postnikov 完备的, 在 $Fun^times (Poly^opp_k, Ani)$ 中逐点计算极限即可.
]

== 生象环的模的 $pi_n$

对于一个生象环 $A$, 上一节定义了稳定 $oo$-范畴 $Mod_A$, 其带有标准的 $t$-结构. 首先可以考虑遗忘函子
$ U : Mod_A -> Sp $
后, 拉回 $Sp$ 上的标准 $t$-结构, 得到新的 $t$-结构 $Mod_A^(<=0), Mod_A^(>=0)$.

容易证明 $Mod^suit.heart_A simeq Mod_(pi_0 A)$. 我们可以定义
$ pi_0 : Mod_A -> Mod^suit.heart_A $
由 $tau_(<=0)tau_(>=0)$ 定义, 这样我们就能定义
$ pi_n M := pi_0 (M[n]) $
显然每个 $pi_n M$ 典范地都是 $pi_0 A$-模. 并且有作用
$ pi_p A times.o_(pi_0 A) pi_q M -> pi_(p+q) M $
因此 $pi_* M$ 可以典范地视作一个分次 $pi_* A$-模.

== Eilenberg--MacLane 模

#definition(title:[Eilenberg--MacLane 模])[
  设 $A$ 是生象环, 给定一个 $N in Mod_(pi_0 A)$ 为普通 $pi_0 A$-模, 我们定义
  $ N[n] := Sigma^n H N in Mod_A $
  为对 $N$ 的 Eilenberg--MacLane 模进行移位 $[n]$, 这样得到的结果满足
  $ pi_0 (N[n]) = cases(
    N quad & i = n,
    0 quad & i != n
  ) $
  于是 $N[n]$ 可以视作纯粹位于第 $n$ 层的一个模 $N$.
]

#lemma[
  配备 $t$-结构的任意稳定 $oo$-范畴都有典范的纤维序列
  $ tau_(>=n)X -> X -> tau_(<=n-1)X $
]

#theorem[
  我们有 $Mod_A$ 中的纤维序列
  $ pi_n (M)[n] -> tau_(<=n)M -> tau_(<=n-1)M $
  由于这是稳定无穷范畴, 可以作
  $ pi_n (M)[n] -> tau_(<=n)M -> tau_(<=n-1)M larr^(kappa_n (M)) pi_n (M)[n+1] $
]

#proof[
  对引理中取 $X=trunl(n)M$ 得到
  $ trunr(n)trunl(n)M -> trunl(n)M -> trunl(n-1)trunl(n) M $
  识别两端显然.
]

#remark[
  在链复形 (导出模) 范畴中, 直和就是逐项直和. 例如当 $M,N$ 是普通模时,
  $ M[0] plus.o M[1] plus.o M[2] $
  就是在 $0,1,2$ 号位置互相无关地放 $M$, 并且直和会在同位上相加, 即
  $ M[1] plus.o N[1] simeq (M plus.o N)[1] $
]

== 环的 Postnikov Step

对于 $A in AniCAlg_k$, 记 $A_n = trunl(n)$, 考虑 $A_n->A_(n-1)$, 其加入的唯一同伦群就是
$ pi_n A $
在线性 (遗忘到生象模) 意义下
$ fib(A_n -> A_(n-1)) simeq (pi_n A)[n] $
也就是说, 第 $n$ 个 Postnikov 层在线性化后为 $(pi_n A)[n]$, 但是 $A_n$ 一般不会等价于
$ A_(n-1) plus.o (pi_n A)[n] $
而它真正如何粘贴上去, 由 *$k$-不变量*
$ LL_(A_(n-1)/k) -> (pi_n A)[n+1] $
控制, 这是我们之后的重要主题.

= 多项式代数与生象代数

== 稠密性

#theorem(title:[多项式代数的稠密性])[
  设 $A in AniCAlg_k$, 则
  $ A simeq colim_((P->A) in (Poly_k)_("/"A)) P $
]

#proof[
  通过 Lawvere 观点将生象环视作预层
  $ A in Fun^times (Poly^opp_k, Ani) $
  由 Yoneda 稠密, 有
  $ A simeq colim_((P,x) in integral_(Poly_k) A) yo(P) $
  又由 Yoneda, $A(P) simeq Map_(AniCAlg_k)(P,A)$, 于是一个元素 $x in A(P)$ 恰好对应映射 $P->A$, 于是有典范等价
  $ integral_(Poly_k) A simeq Poly_k times_(AniCAlg_k) (AniCAlg_k)_("/"A) simeq (Poly_k)_("/"A) $
  又, 在 $A simeq sInd(Poly_k)$ 的识别下, $yo(P)$ 就是多项式代数 $P$ 本身, 分别代入 Yoneda 稠密的陈述即证.
]
