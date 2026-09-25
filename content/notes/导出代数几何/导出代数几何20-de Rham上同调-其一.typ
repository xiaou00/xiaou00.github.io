#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 为交换环.

= 经典 de Rham 复形

== de Rham 复形作为 cdga

#definition(title:[分次外代数])[
  设 $R$ 是交换环, 且 $M$ 是一个 $R$-模, 我们定义分次环 $Lambda M$ 为
  $ lr(plus.o.big_(i>=0) M^(times.o i) slash.big lr(chevron m times.o m : m in M chevron.r) ) $
  显然满足 $m^2=0$, 定义其 $i$-分次部分为 $Lambda^i M$. 其构成分次 $R$-代数, 每个分次部分构成 $R$-模.
]

#remark[
  外代数满足的是 Koszul 交换律, 即
  $ x y = (-1)^(abs(x)abs(y)) y x $
]

#definition(title:[de Rham 复形])[
  设 $R$ 是一个交换 $k$-代数, 我们可以构造一个交换 $k$-cdga
  $ 0 -> R ->^d Omega^1_(R/k) ->^d Omega^2_(R/k) ->^d ... $
  其中
  $ Omega^i_(R/k) = and.big_R^i Omega^1_(R/k) $
  其中 $d$ 称为*外微分*或 *de Rham 微分*, 定义为满足
  $ d|_R = (r|->d r), quad d(a_0 dot d a_1 and ... and d a_p) = d a_0 and ... and d a_p $
  的唯一态射. 记其为 $Omega^bullet_(R/k)$, 称之为 *de Rham 复形*. 这个 cdga 是*严格*的, 也就是说对于奇数分次对象 $x$, 必然有 $x^2=0$.
]

显然, de Rham 复形和局部化是相容的, 即
$ Omega^1_(R/k) times.o_R R_f simeq Omega^1_(R_f/k) $
从而仿射开上的 de Rham 复形可以 Zariski 下降到概形上, 于是我们得到概形拟凝聚层的复形

$ Omega^bullet_(X/k) = [cal(O)_X ->^d Omega^1_(X/k) ->^d Omega^2_(X/k) ->^d ...] $

= Hodge--de Rham 谱序列

== Hodge 滤过

#definition(title:[Hodge 滤过])[
  所谓 *Hodge 滤过*本质上就是逐次滤过 de Rham 复形, 设
  $ Omega^bullet_(X/k) = [cal(O)_X ->^d Omega^1_(X/k) ->^d Omega^2_(X/k) ->^d ...] $
  我们定义
  $ FH^s Omega^bullet_(X/k) = [0->0->...-> Omega^s_(X/k) ->^d Omega^(s+1)_(X/k) -> ...] $
  从而得到了滤过
  $ FH^0 supset FH^1 supset FH^2 supset ... $
]

我们可以定义导出全局截面: 对于一个层复形
$ K^bullet = [... -> K^(n-1) ->^(d^(n-1)) K^n ->^(d^n) K^(n+1) -> ...] $
而言, 全局截面复形就是逐项截面
$ Gamma(X,K^bullet)^n := Gamma(X,K^n) $
并且定义微分为
$ d_Gamma = Gamma(X,d^n) : Gamma(X,K^n) -> Gamma(X,K^(n+1)) $
这构成函子
$ Gamma(X,-) : Ch(Shv(X;Mod_k)) -> Ch(k) $
我们可以典范地拟掉拟同构, 这样就得到了导出截面
$ "R"Gamma(X,-) : Dcat(Shv(X;Mod_k)) -> Dcat(k) $
其同调定义
$ HH^n (X,K^bullet) = H^n ("R"Gamma(X,K^bullet)) $
一般就称之为*超上同调*.

#definition(title:[经典 de Rham 上同调])[
  设 $X/k$ 是 $k$-概形, 则定义其 *de Rham 上同调* (de Rham cohomology) 为
  $ H^n_dR (X/k) := HH^n (X,Omega^bullet_(X/k)) $
]

在仿射情形, $Omega^p_(X/k)$ 的各阶层上同调消失, 从而
$ "R"Gamma(X, Omega^bullet_(Spec A/k)) simeq Gamma(X, Omega^bullet_(Spec A/k)) $
故
$ H^n_dR (X/k) = H^n (A -> Omega^1_(A/k) -> Omega^2_(A/k) -> ...) $
言归正传, Hodge 滤过显然在导出全局截面层面诱导了
$ FH^bullet "R"Gamma(Omega_(X/k)) simeq "R"Gamma(Omega^(>=bullet)_(X/k)) $
并且有分次片
$ gr_"H"^s "R"Gamma(Omega_(X/k)) simeq "R"Gamma(Omega^s_(X/s))[-s] $
我们有典范的 *Hodge--de Rham 谱序列*对应这个滤过
$ E^(s,t)_1 = H^t (X, Omega^s_(X/k)) => H^(s+t) (Omega^bullet_(X/k)) $

= Grothendieck 比较定理

#theorem(title:[Grothendieck 比较定理])[
  若 $X$ 是光滑的 $CC$-概形, 则存在自然的拟同构
  $ "R"Gamma(Omega^bullet_(X/CC)) simeq "R"Gamma(X(CC),CC) $
]

即 de Rham 上同调在光滑情形下天然可以用来计算奇异同调.

= de Rham 的泛性质

#theorem(title:[de Rham 的泛性质])[
  设 $U:scdga^(>=0)_k -> CAlg_k$ 将 $R^bullet |-> R^0$ 是遗忘函子, 那么 de Rham 函子
  $ dR : CAlg_k -> scdga^(>=0)_k, quad S |-> Omega^bullet_(S/k) $
  是其左伴随.
]

虽然上节中掰扯了很多导出环但我还是决定直接写 $EE_oo$-环的情况 (捂脸).

= 将 de Rham 延拓到生象环

== 从多项式开始

先考虑 $k$ 为交换环, 考虑函子
$ CAlg_k -> scdga_k $
将普通的交换环 $A$ 送到离散的 de Rham 复形 $Omega^bullet_(R/k)$, 不过 $scdga_k$ 上没有很好的同伦论, 我们实际上做的是通过典范的函子
$ scdga_k -> Alg_k^(EE_oo) tilde.eq CAlg(Dcat(k)) $
来将其视作一个 $EE_oo$-交换 $k$-代数, 将 $R$ 送到 $Omega^bullet_(R/k)$ 底层的 $EE_oo$-环 $Omega_(R/k)$.

我们先来定义导出 de Rham 在多项式代数上的行为, 这样我们可以用筛余极限来延拓这一理论. 因为
$ CAlg_k^(omega"p") tilde.eq Idem(Poly_k) $
于是对于 $P_n = k[x_1,...,x_n]$ 我们可以定义
$ Omega^bullet_(P_n/k) = plus.o.big_(p>=0) Omega^p_(P_n/k) $
其中
$ Omega^1_(P_n/k) tilde.eq plus.o.big_(i=1)^n P d x_i $

== 导出定义

#definition(title:[导出 de Rham])[
  我们定义
  $ "L"Omega^bullet_(B/k) simeq colim_((P->B) in (Poly_k)_(\/B)) Omega^bullet_(P/k) $
  诱导函子
  $ "L"Omega^bullet_(-/k) : AniCAlg_k -> CAlg(Dcat(k)) $
  称之为*导出 de Rham 复形*.
]

#remark[
  通过选取解消
  $ abs(S_bullet) simeq R $
  我们可以在 $CAlg(Dcat(k))$ 中计算
  $ "L"Omega_(R/k) simeq abs(Omega_(S_bullet/k)) $
]

#proposition[
  函子
  $ "L"Omega^bullet_(-/k) : AniCAlg_k -> CAlg(Dcat(k)) $
  保持余极限.
]

#proofsketch[
  由定义, $"L"Omega^bullet_(-/k)$ 显然保持筛余极限, 在多项式代数上, 有
  $ Omega^bullet_((P times.o_k Q)/k) simeq Omega^bullet_(P/k) times.o_k Omega^bullet_(Q/k) $
  从而由 Kan 延拓其保持有限余积, 任意余积都是有限余积的筛余极限, 而任何余极限都是一个各项为余积的单纯对象的几何实现.
]

#remark[
  若 $k$ 是一个生象 $QQ$-代数, 则
  $ "L"Omega_(-/k) : AniCAlg_k -> CAlg(Dcat(k)) $
  是将 $R$ 送到 $k$ 的常函子.
]

也就是说, de Rham 复形在特征 0 的情况非常的单调且无聊.

= 共轭滤过

== Frobenius 扭转

#definition(title:[Frobenius 扭转])[
  设 $k$ 是一个交换 $FF_p$-代数, $R$ 是一个平坦的交换 $k$-代数, 记
  $ R^((p)) = R times.o_k (Frob_k)_* k $
  其中
  $ Frob_k : k->k, quad x |-> x^p $
  是 Frobenius, 而 $(F_k)_* k$ 表示 $Frob_k$ 限制标量得到的 $k$-模, 称 $R^((p))$ 是 *Frobenius 扭转*.
]

也就是说, $R^((p))$ 是下构造的推出
#web-diagram(diagram({
	node((-1, 0), [$R$])
	node((0, -1), [$k$])
	node((-1, -1), [$k$])
	node((0, 0), [$R^((p))$])
	edge((-1, -1), (0, -1), [$"Frob"_k$], label-side: left, "->")
	edge((-1, -1), (-1, 0), "->")
	edge((0, -1), (0, 0), "->")
	edge((-1, 0), (0, 0), "->")
}))

我们记 $Frob_(R/k) : R^((p)) -> R, r times.o a |-> r^p a$.

== 特征 $p$ 下的 de Rham

现在我们对普通的 $R/k$ 考虑
$ "L"Omega^bullet_(R/k) in scdga^(>=0)_k $
是一个 $k$-代数, 而 $d$ 是 $R^((p))$-线性的, 即
$ d : Omega^i_(R/k) -> Omega^(i+1)_(R/k) $
通常只对 $k$ 线性, 而不对 $R$ 线性, 因为
$ d (r omega) = d r and omega + r d omega $
然而对于 $R^((p))$ 中的元素, 其在 $R$ 中的本质表现为 $p$-次幂, 例如
$ d(x^p) = 0 $
于是
$ d (x^p omega) = d (x^p) and omega + x^p d omega = x^p d omega $
从而线性, 于是 $Omega^bullet_(R/k)$ 是一个 $R^((p))$ 模复形.

#theorem(title:[Cartier 同构])[
  设 $k$ 是交换 $FF_p$-代数, $R$ 是光滑交换 $k$-代数, 那么对所有 $i>=0$,  存在自然的 $R^((p))$-模同构
  $ C^(-1) : Omega^i_(R^((p))/k) -->^~ H^i (Omega^bullet_(R/k)) $
  在 $i=1$ 时由
  $ d(x^p) |-> x^(p-1) d x $
  诱导, 称之为 *逆 Cartier 同构*.
]

也就是说, de Rham 复形的内部上同调, 其实恰好等价于 Frobenius 扭转上的微分形式.

== 共轭滤过的构造

#definition(title:[共轭滤过])[
  设 $k$ 是交换 $FF_p$-代数, $R$ 为光滑的交换 $k$-代数, 那么定义 $Omega_(R/k)$ 上的*共轭滤过* (conjugate filtration) 为递增的 Whitehead 滤过
  $ "F"^"conj"_i Omega_(R/k) simeq tau_(>=-i) Omega_(R/k) $
  这组成
  $ 0 -> "F"^"conj"_0 -> "F"^"conj"_1 -> "F"^"conj"_2 -> ... $
  并且第 $i$ 分次片被
  $ gr^"conj"_i Omega_(R/k) simeq frac("F"^"conj"_i Omega_(R/k),"F"^"conj"_(i-1) Omega_(R/k)) simeq H^i (Omega_(R/k)) [-i] simeq Omega^i_(R^((p))/k) [-i] $
  确定.
]

#remark[
  这个定义是*完备的*, *穷尽的*且*乘法相容的*. 即:

  + $lim_(i->-oo) "F"_i S simeq 0$.
  + $colim_(i->+oo) "F"_i S simeq S$.
  + 乘法映射
    $ "F"_i S times.o "F"_j S -> S times.o S -> S $
    过 $"F"_(i+j)S->S$ 分解, 也就是直观上有 $"F"_i S dot "F"_j S subset "F"_(i+j) S$.
]

#definition(title:[导出共轭滤过])[
  对于 $k$ 为 $FF_p$-代数, $R$ 为生象交换 $k$-代数. 我们定义显然的
  $ "gr"^"conj"_i "L"Omega_(R/k) simeq "L"Lambda^i LL_(R^((p))/k) [-i] $
]
