#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 为任意交换环.

= 生象交换 $k$-代数和生象环

== 基本定义

#definition(title:[生象交换 $k$-代数 / 生象环])[
  我们定义*生象交换 $k$-代数*的范畴为
  $ AniCAlg_k := Ani(CAlg_k) $
  *生象环* (animated ring) 定义为特例
  $ AniRing := AniCAlg_ZZ $
]

由上一节的讨论, 我们也可以定义
$ AniCAlg_k simeq Fun^times (Poly_k^opp, Ani) $
这个构造可以定义相当显然的 $pi_0:AniRing->CRing$, 只需预复合
$ pi_0 : Ani -> Set $
即可.

#remark[
  当 $k in AniRing$ 时, 我们也可以定义 $AniCAlg_k$ 的对象就是全体生象环的态射
  $ k -> A $
  这么定义是合理的, 也符合朴素的代数直觉.
]

#definition(title:[自由生成生象交换代数])[
  定义 $LSym_k:Ani(Mod_k) -> AniCAlg_k$ 为遗忘函子的左伴随, 将有限生成的投射 $k$-模 $P$ 送到交换的 $k$-代数 $Sym_k P$.
]

由于 $Ani(Mod_k) simeq Dcat_(>=0)(k)$, 我们也可以想象 $LSym_k : Dcat_(>=0) (k)->AniCAlg_k$.

== 导出张量积

为了给出导出张量积定义的同时给出合理的解释 (而不是直接定义成推出), 我个人觉得可以先从多项式 $Poly_k$ 开始. 上节我们也提到, $Poly_k$ 有典范的张量积
$ k[x_1,...,x_n] times.o_k k[x_1,...,x_m] simeq k[x_1,...,x_(n+m)] $
并且这里 $P times.o_k Q = P cop_k Q$ 正好是 $Poly_k$ 的余积.

记
$ yo : Poly_k arrow.hook sInd(Poly_k) = AniCAlg_k, quad P |-> Hom(-,P) $
其中 $yo(P)(A) = Hom_(Poly_k) (A,P)$ 视作离散生象. 因此在可表对象上, 我们应该规定
$ yo(P) dtens_k yo(Q) := yo(P tens_k Q) $
我们可以用自由性典范地延拓这一记号

#proposition[
  双函子
  $ - times.o_k - : Poly_k times Poly_k -> AniCAlg_k, quad (P,Q) |-> yo(P times.o_k Q) $
  存在唯一 (可缩意义下) 的双变量延拓
  $ - dtens_k - : AniCAlg_k times AniCAlg_k -> AniCAlg_k $
  满足:

  + 在可表对象上满足 $yo(P) dtens_k yo(Q) = yo(P times.o_k Q)$.
  + 对每个变量保持筛余极限.
]

#proof[
  暂记 $cal(P) = Poly_k$, $cal(A) = AniCAlg_k = sInd(cal(P))$. 以及 Yoneda
  $ yo : cal(P) arrow.hook cal(A) $
  我们知道对任意有筛余极限的 $oo$-范畴 $cal(D)$ 限制都给出等价
  $ yo^* : Fun^Sigma (cal(A),cal(D)) -->^~ Fun(cal(P),cal(D)) quad (*) $
  考虑我们之前定义的函子
  $ b(-,-) = - times.o_k - : cal(P) times cal(P) -> cal(A) $
  下面要证明存在可缩意义下唯一的延拓 $overline(b):cal(A)times cal(A)->cal(A)$.

  我们先延拓第二个变量, 对固定的 $P in cal(P)$ 有
  $ b(P,-) : cal(P) -> cal(A) $
  由 $(*)$, 存在可缩唯一的保持筛余极限的函子
  $ tilde(b)(P) : cal(A)->cal(A) $
  也就是 $b(P,-)$ 在 $yo^*$ 下的原像. 这些延拓关于 $P$ 函子性地组装成
  $ tilde(b) : cal(P) -> Fun^Sigma (cal(A),cal(A)) $
  然后延拓第一个变量, 范畴 $Fun^Sigma (cal(A),cal(A))$ 具有筛余极限且逐点计算. 事实上若 $F_i$ 都保持筛余极限, 则
  $ (colim_i F_i)(colim_j X_j) simeq colim_i colim_j F_i (X_j) simeq colim_j colim_i F_i (X_j) $
  于是 $colim_i F_i$ 也保持筛余极限, 再次应用 $(*)$ 就得到
  $ hat(b) : cal(A) -> Fun^Sigma (cal(A),cal(A)) $
  解 Curry 就得到了
  $ - dtens_k - : cal(A) times cal(A) -> cal(A) $
]

#definition(title:[导出张量积])[
  上述定义的 $- dtens_k -$ 就称之为 $AniCAlg_k$ 上的*导出张量积* (derieved tensor product).
]

#proposition[
  $dtens_k$ 恰好是 $AniCAlg_k$ 中的余积.
]

更一般地, 我们也可以定义 $AniCAlg_k$ 中的相对张量积 $A dtens_B C$, 这个构造其实可以直接通过将 $A,C$ 视作 $AniCAlg_B$ 中的元素来实现, 而这个操作也典范等价于推出.

== 生象 $k$-代数的单纯模型

#theorem(title:[$AniCAlg_k$ 的单纯模型])[
  有 $oo$-范畴等价
  $ simp(CAlg_k) [W^(-1)] simeq AniCAlg_k $
]

#proofsketch[
  给定 $A_bullet in simp(CAlg_k)$, 定义
  $ Phi(A_bullet) : Poly^opp_k -> Ani $
  为
  $ Phi(A_bullet)(P) := abs(Delta^opp -> Set\, quad [n] |-> Hom_(CAlg_k)(P,A_n)) $
  也就是先形成单纯集后, 再将其视作一个生象 (Kan 复形), 这是典范的, 因为每个 $A_n$ 的加法以及面和退化映射的同态性质使其构成一个单纯 Abel 群, 而单纯 Abel 群必然是 Kan复形. 可以验证其保持有限乘积. 再由于我们有 1-范畴等价
  $ simp(CAlg_k) simeq Fun^times (Poly^opp_k, simp(Set)) $
  我们遂可以证明 $W$ 恰好对应逐点的弱等价, 局部化后由一些 Lawvere 理论技术细节即可导出等价.
]

上述构造的核心就是
$ Phi(A_bullet)(P) := abs(Delta^opp -> Set\, quad [n] |-> Hom_(CAlg_k)(P,A_n)) $
对于 $P = k[x_1,...,x_r]$, 这无非就是
$ P |-> "oblv"(A_bullet)^r $
从而特别地
$ pi_i (Phi(A)(k[x])) = pi_i ("oblv"(A_bullet)) = pi_i (A_bullet) $
说明单纯交换环的那些高阶同伦群, 正好就是生象环的导出信息.

== 生象 $k$-代数的代数结构

由于我们有自由-遗忘伴随
$ LSym : AniMod_k arrows.lr AniCAlg_k : "oblv" $
我们知道 $AniMod_k simeq Dcat_(>=0)(k) simeq Mod^(>=0)_(H k)$, 即 $k$-生象模等价于 $H k$-连通模谱, 他们共同刻画连通的导出范畴.

也就是说, 当我们还停留在讨论模的时候, 模谱构造和生象模构造是兼容的. 问题在于, 怎么在这些导出结构上加入乘法?

#question[
  $AniCAlg_k$ 和 $CAlg_(H k)^(>=0)$ 有什么本质区别? 又有什么关系?
]

事实上, 上面的两个情形分别对应于我们定义乘法结构的两种不同的路线.

首先生象环本质上是先取交换代数后, 再生象化. 我们从普通的 1-范畴 $CAlg_k$ 开始, 取其中有限生成的自由对象 $Poly_k$, 然后作生象化
$ AniCAlg_k = Fun^times (Poly^opp_k,Ani) $
模型上等价于 $simp(CAlg_k)[W^(-1)]$.

另一条路线则是先把 $Mod_k$ 导出化了, 得到
$ AniMod_k simeq Mod^(>=0)_(H k) simeq Dcat_(>=0)(k) $
这是一个对称幺半的 $oo$-范畴, 张量积记作 $- dtens_k -$. 我们直接在里面取交换 ($EE_oo$) 代数对象, 就得到
$ CAlg_(H k) := CAlg(Mod_(H k)) simeq CAlg(AniMod_k) simeq CAlg(Dcat_(>=0)(k)) $

整个过程可以画成

#web-diagram(diagram({
	node((0, 0), [$Mod_k$])
	node((0, 1), [$CAlg_k$])
	node((1, 0), [$AniMod_k$])
	node((1, 1), [$CAlg_(H k)$])
	node((0, 2), [$AniCAlg_k$])
	edge((1, 0), (1, 1), [$CAlg$], label-side: left, "->")
	edge((0, 0), (0, 1), [$"1-"CAlg$], label-side: right, "->")
	edge((0, 1), (1, 1), [$H$], label-side: right, "->")
	edge((0, 0), (1, 0), [$Ani$], label-side: left, "->")
	edge((0, 1), (0, 2), [$Ani$], label-side: right, "->")
	edge((0, 2), (1, 1), [$?$], label-side: right, "-->")
}))

我们现在的问题, 就是问是否存在上图中的比较态射, 以及其行为如何.

#question[
  这个比较函子如何构造出来?
]

#answer[
  我们可以构造一个非常自然的比较函子. 我们先看普通多项式代数
  $ P = k[x_1,...,x_n] $
  这个当然可以取 Eilenberg--MacLane 谱
  $ P |-> H P $
  而 $H P$ 又显然是一个 $E_oo$-$H k$-代数, 从而我们有
  $ H : Poly_k -> CAlg^(>=0)_(H k) $
  那么利用 $AniCAlg_k simeq sInd(Poly_k)$, 这个可以唯一延拓到保持筛余极限的函子
  $ Phi : AniCAlg_k -> CAlg^(>=0)_(H k) $
]

在单纯解消的语言下, 这个比较态射其实非常直观: 先取一个
$ A in AniCAlg_k $
取其一个多项式单纯解消, 也就是自由-遗忘伴随的杠解消
$ P_bullet -> A, quad P_n in Poly_k^oo quad ("允许任何大小的生成集合") $
有 $A simeq abs(P_bullet)$. 那么定义 $Phi(A)=abs(H P_bullet)$, 右边的几何实现在 $CAlg_(H k)$ 中计算, 这是非常适合实际计算的一个类比.

实际上, 这两个范畴底层共有的导出模范畴还是一样的, 也就是 $Dcat_(>=0)(k)$. 毕竟 $Mod^(>=0)_(H k)$ 确实等价于 $AniMod_k$, 并且在遗忘函子识别之下这个等价仍然保持, 从而同伦群意义下有
$ pi_i Phi(A) simeq pi_i A $
恒成立.

事实上, $AniCAlg_k$ 就是导出代数几何中最基础的环对象, 而 $CAlg_(H k)$ 就是*谱代数几何*中最基础的环对象. (笔者在写该笔记的时候还未正式接触谱代数几何, 若有谬误敬请谅解)

== 生象环的例子

#example(title:[离散生象环])[
  一个正常的环可以典范视作一个生象环, 只需通过 $Set arrow.hook Ani$ 诱导的
  $ Fun^times (Poly^opp,Set) -> Fun^times (Poly^opp,Ani) $
  即可.
]

#example(title:[自由生象环])[
  我们有自由-遗忘伴随
  $ "Free" : Ani arrows.lr AniRing : "oblv" $
  一个非离散的典型例子就是 $"Free"(S^1)$.
]

= 生象环的模

== 生象环的导出范畴

通过上述构造的比较态射, 我们可以典范地给每个生象环 $R in AniRing$ 都关联一个环谱 $R in CAlg_SS$. 我们使用同一个记号.

通过这个角度, 我们可以对对称幺半的 $oo$-范畴 $cal(C)$ 定义 $Mod_R (cal(C))$. 我们可以定义连通导出范畴
$ Dcat_(>=0)(R) := Mod_R (AniMod_ZZ) simeq Mod_R (Dcat_(>=0)(ZZ)) $
我们知道通过在 $PrL$ 中形式逆转 $Sigma:M|->M[1]$ 可以得到一个稳定无穷范畴 $Dcat(R)$, 即定义为余极限
$ colim(Dcat_(>=0)(R) -->^Sigma Dcat_(>=0)(R) -->^Sigma Dcat_(>=0)(R) -->^Sigma ...) $
当我们在 $PrL$ 中计算这个范畴时, 余极限可以改写作对应右伴随函子的极限
$ Dcat(R) simeq lim(... -> Dcat_(>=0)(R) -->^Omega Dcat_(>=0)(R)  -->^Omega Dcat_(>=0)(R) ) $

== 生象环模的定义

#definition(title:[生象代数的连通导出模])[
  对于 $A in AniCAlg_k$, 我们定义范畴 $Mod_A^(>=0)$ 或 $AniMod_A$ 为下列两两等价的范畴之一:

  + $Ab((AniCAlg_k)_("/"A))$ 即态射 $B->A$ 构成切片范畴中的 Abel 群对象范畴.
  + $Sp((AniCAlg_k)_("/"A))^(>=0)$ 即态射 $B->A$ 构成切片范畴的稳定化后的连通部分.
  + $simp(Mod_(A_bullet)) [W^(-1)]$, 其中 $simp(Mod_(A_bullet))$ 的对象是单纯 $k$-模带有相容的作用 $A_bullet times.o_k M_bullet -> M_bullet$, $A_bullet$ 是 $A$ 在 $simp(CAlg_k)[W^(-1)]$ 中的对应.
  + $Dcat_(>=0)(A) := Mod_A (D_(>=0)(k))$, 即导出范畴上的 $A$-代数对象.
]
#definition(title:[生象代数的一般导出模])[
  对于 $A in AniCAlg_k$, 我们定义范畴 $Mod_A$ 为下列两两等价的范畴之一:

  + $Sp((AniCAlg_k)_("/"A))^(>=0)$ 即态射 $B->A$ 构成切片范畴的稳定化.
  + $Dcat(A) := Mod_A (D(k))$, 即导出范畴上的 $A$-代数对象.
  + 上述定义的 $ lim(... -> Dcat_(>=0)(R) -->^Omega Dcat_(>=0)(R)  -->^Omega Dcat_(>=0)(R) ) $
]

== 映射锥

#proposition(title:[一个简单但重要的计算引理])[
  设 $M,N in Mod_A^suit.heart$, $f:M->N$ 是导出模态射, 则
  $ cofib(M->^f N) simeq [M->^f N] $
]

#proof[
  只需证明 $C=[M->^f N]$ 满足泛性质即可, 即对任意 $X in Mod_A$ 有
  $ Map(C,X) simeq Map(N,X) times_(Map(M,X)) Map(0,X) $
  而由于 $Map(0,X) simeq *$, 问题转化成:

  #question[
    从 $C$ 到 $X$ 的映射是否恰好等价于 $g:N->X$ 加上 $g f:M->X$ 的一个零同伦.
  ]

  答案是肯定的, 有自然包含 $i:N->C$, 复合 $M->^f N->^i C$ 并非严格的零映射, 但存在典范的零伦
  $ h: M->C_1 = M, quad h = id_M $
  由于 $C$ 的微分就是 $f$, 有 $d_C h=f$, 换句话说 $i f = d_C compose id_M$, 也就是 $i f simeq 0$. 现在任取 $X$, 一个映射
  $ phi:C->X $
  限制到 $C_0=N$ 给出 $g:N->X$, 同时 $phi$ 在 $C_1=M$ 上的部分给出了同伦 $h:M->X[1]$, 链映射恰好要求了 $d h+ h d = g f$, 由于 $M$ 集中在 $0$ 度, 也就是说 $d h = g f$, 表示 $h$ 是 $g f$ 的零伦.
]

我们也可以证明下面的定理, 由于篇幅问题就暂且略过了

#theorem(title:[映射锥的对应])[
  对于任意 $M,N in Mod_A$ 和 $f:M->N$, 有
  $ cofib(f) simeq "Cone"(f) $
  是映射锥构造. 也就是说余纤维覆盖了经典的映射锥理论.
]
