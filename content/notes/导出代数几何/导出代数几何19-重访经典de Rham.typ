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
$ Gamma(X,-) : Ch(Sh(X;Mod_k)) -> Ch(k) $
我们可以典范地拟掉拟同构, 这样就得到了导出截面
$ "R"Gamma(X,-) : Dcat(Sh(X;Mod_k)) -> Dcat(k) $
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


