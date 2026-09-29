#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本篇的环, 生象环, 环谱都默认为交换环.

= 完美复形

完美复形是高阶代数几何中对于向量丛概念的推广, 简单来说, 于环/生象环/$EE_oo$-环 $A$ 上, 完美复形的范畴定义为
$ Perf(A) := Mod_A^omega simeq Dcat(A)^omega $
对于离散的环 $A$, 这就是有限投射模. 在#note-ref("./导出代数几何16-完美复形.typ")这一个笔记中, 有关于 $EE_oo$-环上的完美复形理论的粗略介绍.

== 拟凝聚层

现在设 $X$ 是一个导出叠 $X in dSt_S$, 或更一般的预叠 $X in dPSt_S$, 我们
可以这样考虑拟凝聚层的范畴:

#construction[
  现在考虑 Yoneda 嵌入
  $ j : dAff_S arrow.hook dPSt_S $
  考虑仿射上的函子
  $ M:dAff^opp_S -> PrL_"st", quad Spec A |-> Mod_A $
  只需沿着 $j$ 做右 Kan 延拓 $QCoh(-)=Ran_j (Mod)$, 即
  #web-diagram(diagram({
      node((-1, -1), [$dAff$])
      node((0, -1), [$dPSt$])
      node((-1, 0), [$PrL_"st"$])
      edge((-1, -1), (0, -1), [$j$], label-side: left, "->")
      edge((-1, -1), (-1, 0), [$M^opp$], label-side: right, "->")
      edge((0, -1), (-1, 0), [$QCoh(-)^opp$], label-side: left, "-->")
  }))
  就得到了函子
  $ QCoh(-) : dPSt^opp -> PrL_"st" $
]

这恰好解释了对任意 $f:X->Y$, 都有自然的拉回 $f^*:QCoh(Y)->QCoh(X)$. 显式地可以构造
$ QCoh(X) = lim_(Spec A->X) Mod_A $

#claim[
  一个对象 $cal(F) in QCoh(X)$ 恰好就是对每个仿射点
  $ x : Spec A -> X $
  给出一个 $cal(F)_x in Mod_A$, 并且满足基变换相容性. 也就是说对于图表
  #web-diagram(diagram({
	node((-1, -1), [$Spec B$])
	node((0, -1), [$Spec A$])
	node((0, 0), [$X$])
	edge((-1, -1), (0, -1), [$f$], label-side: left, "->")
	edge((0, -1), (0, 0), [$x$], label-side: left, "->")
	edge((-1, -1), (0, 0), [$y$], label-side: right, "->")
  }))
  给出了等价 $B times.o_A cal(F)_x simeq cal(F)_y$.
]

这其实就是上面那个极限公式的 Pointwise 含义.

== 结构层

我们先规定
$ cal(O)_(Spec A) := A in Mod_A $
若 $f:Spec B -> Spec A$ 对应 $A->B$, 则
$ f^*(A) = A times.o_A B simeq B $
所以这个结构沿着基变换相容. 对于一般的预叠 $X$, 我们定义 $cal(O)_X$ 为对任意仿射点 $x:Spec A -> X$, 给定
$ (cal(O)_X)_x = A $
也就是说
$ x^*cal(O)_X simeq A = cal(O)_(Spec A) $
这确实确定了 $QCoh(X)$ 中的唯一对象. 因为若
$ Spec B -> Spec A -> X $
则
$ A times.o_A B simeq B $
最直接的定义方式, 就是指定
$ cal(O)_X = {A}_(Spec A->X) in lim_(Spec A->X)Mod_A $

换个角度说, 每个 $Mod_A$ 都具有对称幺半结构 $(Mod_A, times.o_A, A)$, 而基变换
$ - times.o_A B : Mod_A -> Mod_B $
是对称幺半函子, 从而极限 $QCoh(X)$ 自然得到逐点的对称幺半结构
$ (QCoh(X), times.o_(cal(O)_X), cal(O)_X) $
结构层 $cal(O)_X$ 就是其单位元.

== 全局截面

由于 $QCoh(X) in PrL_"st"$, 我们其实可以直接定义全局截面谱
$ Gamma(X,cal(F)) := underline(Map)_(QCoh(X))(cal(O)_X,cal(F)) in Sp $
特别地, *层上同调*直接定义为
$ H^i (X,cal(F)) := pi_(-i)Gamma(X,cal(F)) $
而
$ pi_n Gamma(X,cal(F)) = Hom_("h"QCoh(X)) (cal(O)_X [n],cal(F)) $

#construction[
  若 $X$ 是 $k$-预叠, 即 $X in dPSt_k$, 也就是说有结构态射
  $ p : X -> Spec k $
  由于拉回
  $ p^* : Mod_k -> QCoh(X) $
  保持余极限, 有右伴随
  $ p_* : QCoh(X) -> Mod_k $
  那么我们直接定义
  $ Gamma(X,cal(F)) := p_*cal(F) in Mod_k $
  由伴随关系
  $ Map_(Mod_k)(M,Gamma(X,cal(F))) simeq Map_(QCoh(X))(p^*M,cal(F)) $
  刻画, 这给层截面赋予了典范的 $k$-模结构.
]

特别地, 对于结构层, 有
$ Gamma(X,cal(O)_X) = End_(QCoh(X))(cal(O)_X) $
自然是一个 $EE_oo$-环, 称为*导出全局函数环*.

== 完美复形的定义与性质

#definition(title:[完美复形])[
  给定 $X in dPSt_k$, 定义
  $ Perf(X) = QCoh(X)^"dual" $
  称之为*完美复形*的范畴, 也就是所有可对偶的拟凝聚层的全子范畴.
]

#remark[
  显然 $cal(E) in QCoh(X)$ 是完美的, 当且仅当对任意仿射点 $x:Spec A->X$, 都有
  $ x^*cal(E) in Perf(A) := Mod^omega_A $
  在引用的笔记中也证明过了, 在仿射情形可对偶性和紧性完全等价. 不过完美复形最核心的性质还是可对偶性.
]

回顾可对偶性的概念, 这也就是说, 对于 $cal(E)$ 存在 $cal(E)^or$ 以及
$ coev : cal(O)_X -> cal(E) times.o cal(E)^or, quad ev : cal(E)^or times.o cal(E) -> cal(O)_X $
满足三角恒等式.

#proposition(title:[2-out-of-3])[
  若 $cal(E)->cal(F)->cal(G)$ 是纤维序列, 其中两个完美, 则第三个完美.
]

#proposition(title:[移位稳定性])[
  若 $cal(E)$ 完美, 对任意 $n in ZZ$, $cal(E)[n]$ 完美.
]

#proposition(title:[张量封闭性])[
  $Perf(X)$ 对张量积封闭.
]

#proposition(title:[内部Hom公式])[
  若 $cal(E)$ 是完美复形, 则对任意拟凝聚 $cal(F)$, 有
  $ Map_(QCoh(X)) (cal(E),cal(F)) simeq Gamma(X,cal(E)^or times.o cal(F)) $
]

#proof[
  考察内部 Hom 性质
  $ underline(Hom)(cal(E),cal(F)) simeq cal(E)^or times.o cal(F) $
  即可.
]

#proposition(title:[拉回稳定])[
  任意预叠态射 $f:X->Y$, 有
  $ f^*:QCoh(Y)->QCoh(X) $
  保持完美复形, 且
  $ (f^*cal(E))^or simeq f^*(cal(E)^or) $
]

#proof[
  回顾 $f^*$ 是一个对称幺半函子即可.
]

= 导出概形

== Zariski 层

现在我们来定义经典的概形的导出. 下面我们统一采用环为 $aCAlg_k$ 的对象. 对于环 $A$, 以及 $f in pi_0 A$, 我们可以定义*局部化*为
$ A[f^(-1)] := A dtens_(k[t]) k[t,t^(-1)] $
其中 $k[t]->A, t|->f$. 具体理论参见#note-ref("./导出代数几何09-生象环-其三.typ"). 若写成推出
#web-diagram(diagram({
	node((-1, -1), [$k[t]$])
	node((0, -1), [$k[t,t^(-1)]$])
	node((-1, 0), [$A$])
	node((0, 0), [$A[f^(-1)]$])
	edge((-1, -1), (-1, 0), [$t|->f$], label-side: right, "->")
	edge((-1, -1), (0, -1), "->")
	edge((0, -1), (0, 0), "->")
	edge((-1, 0), (0, 0), "->")
}))
对推出的态射 $A->A[f^(-1)]$ 定义
$ i: D(f):=Spec A[f^(-1)]->Spec A $
也就是 *Zariski主开集*. 更一般地, 设 $f:Spec B -> Spec A$, 其中 $A,B in aCAlg$, 那么称 $f$ 是一个 *Zariski 嵌入*, 是指:

+ $Spec pi_0 B -> Spec pi_0 A$ 是经典的 Zariski 嵌入.
+ 对所有 $n>0$ 有 $pi_n B simeq pi_n A times.o_(pi_0 A) pi_0 B$.

形式上, 这个条件很类似于平坦性, 我们确实可以借由#note-ref("./导出代数几何15-Tor振幅与平坦性.typ")给出的平坦性来刻画这一概念, 也就是说 $f$ 是 Zariski 嵌入当且仅当:

+ $Spec pi_0B->Spec pi_0A$ 是经典 Zariski 嵌入.
+ $f$ 平坦.

一个族 ${Spec B_i -> A}$ 称之为 *Zariski 覆盖*, 是指每个态射都是 Zariski 嵌入, 且
$ {Spec pi_0B_i -> Spec pi_0A} $
是经典的 Zariski 覆盖. 类似的我们可以定义出景
$ (dAff,J_"Zar") $
于是我们得到了 *Zariski 层*, 也就是
$ Shv(dAff;J_"Zar") $

== 导出概形的定义

导出概形是一种更特殊的 Zariski 层, 其条件和经典的概形条件十分类似:

#definition(title:[导出概形])[
  一个 Zariski 层 $X in Shv(dAff;J_"Zar")$ 称为一个*导出概形* (derived scheme), 是指存在一族导出仿射概形 $U_i = Spec A_i$ 和态射 $f_i : U_i -> X$ 使得每个 $f_i$ 都是可表的 Zariski 嵌入, 并且
  $ product.co_i f_i : product.co_i U_i -> X $
  是有效满射.
]

#example[
  分类叠 $B GG_m$ 显然是一个 Zariski 层, 但它不是一个导出概形.
]

== 导出概形与经典概形

对于 $X = Spec A$, 我们有函子
$ t_0 : dSch -> Sch $
本质上就是预层层面的函子
$ tau_(<=0) i^* : dPSt -> "1-"PShv(dAff) $
限制到 $dSch$ 得到的, 简单来说可以先定义
$ t_0Spec A = Spec pi_0 A $
并在仿射片上可以下降: 即对于
$ X = union.big_i U_i, quad U_i = Spec A_i $
可定义
$ t_0 X = colim_"Zar" t_0 U_i $
或者用结构层来刻画, 就是
$ t_0 X = (abs(X),pi_0 cal(O)_X) $

#construction[
  一般地, 我们还可以定义 $t_n X$, 使得
  $ t_n Spec A = Spec tau_n A $
  并且有塔
  $ t_0 X -> t_1 X -> t_2 X -> ... -> X $
  这也诱导了结构层的
  $ pi_0 cal(O)_X <- tau_1 cal(O)_X <- tau_2 cal(O)_X <- ... <- cal(O)_X $
  并且有
  $ cal(O)_X simeq varprojlim(n)tau_n cal(O)_X $
]

== 局部结构和全局结构

在仿射情况下, 设 $A$ 是连通的导出环, 令 $X = Spec A$, 其导出结构由
$ pi_i A, quad i>0 $
记录, 而
$ pi_i cal(O)_X simeq tilde(pi_i A) $
是 $t_0 X$ 上的拟凝聚 $cal(O)_(t_0 X)$-模. 在仿射情形我们就有
$ Spec A ~> (Spec pi_0 A, tilde(pi_1 A), tilde(pi_2 A), ...) $
虽然仅仅知道这些模也不够, 我们还需要知道其如何通过 Postnikov $k$-不变量粘在一起. 具体内容在#note-ref("./导出代数几何14-障碍理论.typ")有所涉及.

#claim[
  全局上一个导出概形可以等价地看作
  $ (abs(X), cal(O)_X) $
  其中 $cal(O)_X$ 是一个连通导出环层, 且
  $ (abs(X),pi_0 cal(O)_X) $
  是普通概形, 并且
  $ pi_n cal(O)_X in QCoh(t_0 X), quad n>0 $
]

可以验证, 我们还有伴随对
$ i : Sch arrows.lr dSch : t_0 $
将 $Sch$ 中的概形视作典范离散的导出概形.

= 导出概形上的完美复形

== 完美复形的秩

一般情况下, 完美复形的秩不是一个非负整数, 而是一个虚秩. 设 $X$ 是导出概形, $cal(E) in Perf(X)$, 则
$ rk(cal(E)) in H^0(abs(X),ZZ) $
右边代表 $abs(X)$ 上局部常值的整数函数 (对每个点都存在开邻域使得限制在该领域上常值) 的环. 取一点
$ x in abs(X) $
其剩余域为 $kappa(x)$, 将点视作
$ x : Spec kappa(x) -> X $
定义纤维为
$ x^*cal(E) = cal(E) dtens_(cal(O)_X) kappa(x) $
这是一个有限维的完美 $kappa(x)$-复形, 定义
$ rk_x (cal(E)) = chi(x^*cal(E)) = sum_i (-1)^i dim_(kappa(x))pi_i (x^*cal(E)) $
我们得到了 $K_0$-环上的同态 ($K$ 理论直接来自幂等完备的稳定结构)
$ rk : K_0 (X) -> H^0 (abs(X),ZZ) $

#proposition(title:[纤维序列中的可加性])[
  对完美复形的纤维序列
  $ cal(E)' -> cal(E) -> cal(E)'' $
  有
  $ rk(cal(E)) = rk(cal(E)') + rk(cal(E)'') $
]

#proposition[
  对完美复形 $cal(E)$, 有 $rk(cal(E)) = rk(cal(E)^or)$.
]

#proposition[
  对完美复形 $cal(E)$, 有 $rk(cal(E)[1]) = -rk(cal(E))$.
]

#proposition[
对完美复形 $cal(E),cal(F)$, 有 $rk(cal(E) times.o cal(F)) = rk(cal(E))rk(cal(F))$.
]

== 线丛

#definition(title:[线丛])[
  设 $X$ 是导出概形, 一个 $cal(L) in Perf(X)$ 称之为*线丛* (line bundle), 是指其秩函数为恒 $1$, 且 Tor 振幅为零. 等价地, 其 Zariski 局部是 $cal(O)_X$.
]

通常定义
$ Pic_"line" (X) $
为全体线丛在张量积下构成的交换群, 等价地
$ Pic_"line" (X) = pi_0 Map(X,B GG_m) $
不过稍微需要注意的是我们有个截然不同的定义, 更高阶的自然想法是直接取 $QCoh(X)^times.o$ 的可逆对象
$ Pic(X) := (QCoh(X)^times.o)^times $
这是个 $EE_oo$-群生象, 其 $pi_0$ 就是可逆拟凝聚复形的等价类, 不过这里的比通常意义下的线丛稍大, 因为
$ cal(O)_X [1] times.o cal(O)_X [-1] simeq cal(O)_X $
所以 $cal(O)_X [1] in Pic(X)$. 可以证明可逆的完美复形局部有形式
$ cal(L)[n] $
其中 $cal(L)$ 是线丛, $n in ZZ$.

== 行列式

我们希望定义的行列式满足
$ det : K_0 (X) -> Pic(X) $
是群的同态.

由完美复形理论的一个标准结论, 一个环 $A$ 上的完美复形可以写成
$ E = [...->0->P_1->...->P_n->0->...] $
其中每个 $P_i$ 都是有限生成的 $A$-投射模. 这个情况下, 我们记
$ det(E) = times.o.big_i det(P^i)^((-1)^i) $
其中 $P^(-1) = P^or$, 相当于利用了 $K$-理论中的
$ [E] = sum_i (-1)^i [P^i] $
这些构造可以规范地粘起来, 得到一个全局的线丛 $det cal(E) in Pic_"line" (X)$.

= 余切复形

== 导出预叠上的余切复形

设 $X in dPSt_S$ 是一个导出预叠, $x:Spec A->X$ 是一个点以及 $M in Mod_A$, 考虑平方零扩张
$ A plus.o M $
定义 $x$ 在方向 $M$ 上的导子空间为
$ Der_x (X,M) := fib_x (X(A plus.o M) -> X(A)) $
称 $X$ 在这个点处有余切复形, 是指存在
$ LL_(X,x) in Mod_A $
使得
$ Der_x (X,M) simeq Map_(Mod_A)(LL_(X,x),M) $
若存在 $LL_(X/S) in QCoh(X)$ 使得对每个 $x:Spec A->X$ 都有
$ x^*LL_(X/S) simeq LL_(X/x) $
称其为 $X$ 的*全局余切复形*.

相对情形下, 对于 $f:X->Y$, 以及 $x:Spec A->X$, 记 $y=f(x)$, 诱导映射
$ Der_x (X,M) -> Der_y (Y,M) $
定义相对导子空间为
$ Der_(X/Y,x) (M) := fib(Der_x (X,M) -> Der_y (Y,M)) $
若这些点态信息能下降, 就得到了
$ LL_(X/Y) in QCoh(X) $

#proposition(title:[传递序列])[
  对 $X->^f Y->^g Z$ 有纤维序列
  $ f^*LL_(Y/Z) -> LL_(X/Z) -> LL_(X/Y) $
]

== 导出概形上的余切复形

#claim[
  导出概形以及导出概形的态射上一定存在全局余切复形.
]

对开覆盖片 $U_i$, 每个仿射片上已经有 $LL_(A_i/k)$, 并且容易验证这些对象在交叠处兼容, 并且对于离散环, 总有
$ pi_0 LL_(B/A) simeq Omega^1_(B/A) $
而 $f:X->Y$ 光滑时, $LL_(X/Y)$ 是有限秩的, 集中在度数零的向量丛, 也就是说
$ LL_(X/Y) simeq Omega^1_(X/Y) $
没有高阶导出信息.

