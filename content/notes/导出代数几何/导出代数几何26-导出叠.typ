#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 导出预叠的构造

== 导出仿射概形

#definition(title:[导出仿射概形])[
  定义范畴 $dAff_k simeq aCAlg_k^opp$, 称之为 *$k$-导出仿射概形*.
]

这很符合我们在普通代数几何中的直觉, 类似地, 我们记 $Spec A$ 为生象 $k$-代数 $A$ 在 $dAff_k$ 中的对应物.

在生象环范畴中, 我们有函子的伴随对
$ pi_0 : aCAlg_k arrows.lr CAlg_k : i $
诱导其反范畴上的伴随对
$ i : Aff_(pi_0 k) arrows.lr dAff_k : t_0 $

== 导出预叠

#definition(title:[导出预叠])[
  一个 *$k$-导出预叠* (derived prestack) 就是范畴 $dPSt_k:=PShv(dAff_k)$ 的对象. 也就是一个函子
  $ X : aCAlg_k -> Ani $
]

预层范畴总是是 $oo$-意象, 于是

#proposition[
  $dPSt_k$ 是一个 $oo$-意象.
]

显然, $dAff_k$ 的元素 $Spec A$ 可以通过 Yoneda 嵌入典范地全忠实嵌入 $dPSt_k$, 即
$
yo : dAff_k arrow.hook& dPSt_k \
Spec A |->& Map_(dAff_k)(-,Spec A)\
simeq & Map_(aCAlg_k)(A,-)
$

于是当我们提到导出仿射概形时, 我们也时常将其视作一个函子.

对于一个普通的代数几何中的预层
$ X in PShv_0(Aff_(k)) $
通过预复合
$ dAff_k^opp larr^(i^opp) Aff_k^opp larr^X Set $
可以得到
$ i^* : dPSt_k -> PShv(Aff_k) $
其自动有两个伴随
$ i_! tack.l i^* tack.l i_* $
其中
$ i_! = Lan_(i^opp), quad i_* = Ran_(i^opp) $
其中 $i_!$ 是最自然的延拓, 对 $X:Aff^opp_k -> Ani$, 我们定义
$ (i_!X)(Spec A) simeq colim_(Spec A->i(Spec R)) X(Spec R) $
等价地有
$ (i_!X)(A) simeq colim_(R->A, R in CAlg_k) X(R) $
满足
$ i_! (h_(Spec R)) simeq h_(Spec R)^"der" $
具体地, 即
$ (i_! h_(Spec R))(A) simeq Map_(aCAlg_k) (R,A) $
它可以看见高阶的导出信息, 而 $i_*$ 则是只看 $pi_0$, 它可以写成
$ (i_*X)(X) = X(pi_0 A) $
完全忽略了导出信息.

= 导出叠的构造

== 平展景

我们现在在 $dAff_k$ 上定义典范的 Grothendieck 拓扑 $J_et$.

#definition(title:[联合满射])[
  对于一族导出仿射概形态射
  $ f_i : U_i = Spec B_i -> X = Spec A $
  取其截断 $t_0 X = Spec pi_0 A, t_0 U_i = Spec pi_0 B_i$, 称
  $ {f_i:U_i -> U} $
  是*联合满射* (jointly surjective) 的, 是指
  $ product.co_i abs(t_0(U_i)) -> abs(t_0(X)) $
  满.
]

我们称一个全部由导出平展态射构成的联合满射为*平展覆盖*, 并记函子
$ chevron.l U_i -> U chevron.r(V) = {f:V->U|f "过某个" U_i->U "分解"} $
我们作定义

#definition(title:[导出平展景])[
  我们可以典范地将一个筛视作所有以 $U$ 为终点的一族对预复合封闭态射, 于是定义
  $ J_et (U) = {R "是" U "上的筛" : exists "平展覆盖" {U_i->U}, chevron.l U_i -> U chevron.r subset R} $
  称 $(dAff_k,J_et)$ 为 *$k$-平展景*.
]

== 导出叠

#definition(title:[导出叠])[
  我们定义*导出叠* (derived stack) 是 $dSt_k := Shv(dAff_k,J_et)$ 的一个元素.
]

#remark[
  我们还有常用的, 更好操作的等价刻画: 我们定义导出叠是 $PShv(dAff_k)$ 上满足*平展下降*的对象, 也就是说对于平展满射 $f:Spec S->Spec R$, 有
  $ X(Spec R) ->^~ lim_Delta X(C(f)_bullet) $
  是等价, 且保持有限无交并为乘积.
]

= $n$-几何叠

== $n$-几何性

#definition(title:[$n$-几何性])[
  设 $k$ 是生象交换环, 则:

  + 一个导出叠称之为 *$0$-几何的*, 是指其等价于某个 $product.co_(i in I) Spec S_i$, $S_i in aCAlg_k$.
  + 一个 $0$-几何导出叠 $X simeq product.co_(i in I) Spec S_i$ 是*光滑的*, 是指每个 $S_i/k$ 是光滑的.
  + 假若我们定义了 $n$-几何导出叠, 和光滑 $n$-几何导出叠, 我们称态射 $U->X$ 是 *$n$-几何的态射*, 是指对每个生象 $k$-代数 $R$ 和 $dSt_k$ 中的任意态射 $Spec R -> X$, 拉回
    #web-diagram(diagram({
        node((-1, -1), [$P$])
        node((0, -1), [$"Spec" R$])
        node((0, 0), [$X$])
        node((-1, 0), [$U$])
        edge((-1, -1), (-1, 0), "->")
        edge((-1, 0), (0, 0), "->")
        edge((-1, -1), (0, -1), "->")
        edge((0, -1), (0, 0), "->")
    }))
    的 $P$ 是 $n$-几何的.
  + 我们称 $U->X$ 是*光滑的 $n$-几何的态射*, 是指拉回的 $P$ 是光滑的 $n$-几何导出叠.
  + 一个导出叠 $X$ 是 *$n$-几何的*, 当且仅当存在光滑的 $(n-1)$-几何的满射 $U->X$, 其中 $U$ 是 $0$-几何的.
]

所谓 $n$-几何的含义就是, 为了把对象局部解析为仿射的, 所需要的 "重叠复杂度" 层数.

#example[
  设 $X$ 是分离的概形, 则 $X$ 是 1-几何的: 若 ${U_i}$ 是仿射开覆盖, 则
  $ product.co_(i in I) U_i -> X $
  是光滑且 0-几何的.
]

#example[
  设 $tilde(AA)^2$ 是双重原点的仿射平面, 令 $U_0,U_1$ 是两个仿射片, 每个都同构于 $AA^2$, 则
  $ U_0 times_(tilde(AA)^2) U_1 simeq AA^2 - {0} $
  不难看出 $U_0 cop U_1 -> AA^2$ 是光滑的 1-几何满射, 从而 $tilde(AA)^2$ 是 2-几何的.
]


