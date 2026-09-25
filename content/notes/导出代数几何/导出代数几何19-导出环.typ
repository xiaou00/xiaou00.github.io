#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

在讨论 de Rham 理论之前, 我们先注意到一件事: 生象环一般都是连通的, 也就是说它们的非零同伦都出现在正次数. 而 de Rham 复形一般是余连通的, 其非零同伦都在负次数. 由于我们希望做的事情是通过
$ Poly_k -> AniCAlg_k $
上的经典 de Rham $P^bullet |-> Omega^bullet_(P/k)$ 沿着嵌入作左 Kan 延拓, 天真的想法是得到一个
$ dR : AniCAlg_k -> AniCAlg_k $
但当我们输入 $P$ 的时候, 我们想要恢复 $Omega^bullet_(P/k)$, 然而他一般根本不是连通的, 这件事从一开始就不成立.

于是我们自然需要一种能同时处理两种次数的环, 也就是导出环.

= 单子与 Eilenberg--Moore 代数

== 用高阶代数重访单子论

所谓单子, 核心想法就是: $cal(C)$ 上的单子相当于 $End(cal(C)) = Fun(cal(C),cal(C))$ 中的结合代数. 带有函子复合给出的幺半结构
$ F times.o G = F compose G, quad bold(1) = id_(cal(C)) $
使得 $(End(cal(C)),compose,id_(cal(C)))$ 构成一个幺半范畴 (一般不是对称幺半). 我们先给出 1-范畴中的单子的定义:

#definition(title:[1-单子])[
  一个*单子* (monad) 是一个三元组 $(T,eta,mu)$, 其中
  $ T: cal(C)->cal(C), quad eta: id_(cal(C))->T, quad mu:T compose T -> T $
  满足严格的交换律和结合律, 以显然的方式定义.
]

在 $oo$-范畴中, 我们需要加入所有高阶的同伦, 帮助我们实现这一点的正是 little 1-cube 算畴, 即结合算畴 $EE_1$.

#definition(title:[单子])[
  设 $cal(C)$ 是 $oo$-范畴, 其上的*单子*构成的范畴就是
  $ Mnd(cal(C)) := Alg_(EE_1)(End(cal(C))) $
  其中 $End(cal(C))$ 携带显然的幺半结构.
]

我们可以从一对伴随对典范地抽出一个单子: 对于一对伴随
$ F : cal(C) arrows.lr cal(D) : G, quad F tack.l G $
其中伴随单位和余单位分别是
$ eta : id_(cal(C)) -> G F, quad epsilon : F G -> id_(cal(D)) $
我们可以定义自函子
$ T := G F : cal(C) -> cal(C) $
这个函子天然构成一个单子, 因为其单位就是伴随的单位
$ eta : id_(cal(C)) -> T = G F $
逐对象就是
$ X -> G F X $
而乘法的定义略复杂一点, 我们需要构造
$ mu : T^2 -> T $
因为 $T^2 = G F G F$, 而伴随的余单位有
$ epsilon : F G -> id_(cal(D)) $
从而我们可以进行加函子
$ G epsilon F : G F G F -> G F $
定义 $mu = G epsilon F$ 即可, 可以证明上述构造满足单子公理.

== 单子的代数

与其说这是一种代数, 其本质是是一种代数的模:

#definition(title:[Eilenberg--Moore 代数])[
  设 $cal(C)$ 是 $oo$-范畴, $T in Mnd(cal(C)) = Alg_(EE_1)(End(cal(C)))$, 则定义
  $ Alg_T (cal(C)) := LMod_T (cal(C)) $
  称之为 $T$ 上的 *Eilenberg--Moore 代数*.
]

一个 Eilenberg--Moore 代数可以理解作将单子作用在范畴的对象上, 其一般的对象形如二元组
$ (A,a) $
其中, $A in cal(C)$ 是一个对象, $a:T(A)->A$ 是 $cal(C)$ 中的态射. 并且 $a compose eta_A = id_A, a compose T(a) = a compose mu_A$. 即交换图
#web-diagram(diagram({
	node((0, 0), [$A$])
	node((1, 0), [$T(A)$])
	node((1, 1), [$A$])
	edge((0, 0), (1, 1), [$id_A$], label-side: right, "->")
	edge((0, 0), (1, 0), [$eta_A$], label-side: left, "->")
	edge((1, 0), (1, 1), [$a$], label-side: left, "->")
}))
和
#web-diagram(diagram({
	node((0, 0), [$T^2(A)$])
	node((1, 0), [$T(A)$])
	node((0, 1), [$T(A)$])
	node((1, 1), [$A$])
	edge((1, 0), (1, 1), [$a$], label-side: left, "->")
	edge((0, 1), (1, 1), [$a$], label-side: right, "->")
	edge((0, 0), (0, 1), [$mu_A$], label-side: right, "->")
	edge((0, 0), (1, 0), [$T(a)$], label-side: left, "->")
}))
而态射 $f:(A,a)->(B,b)$ 定义为满足 $f compose a = b compose T(f)$ 的 $f:A->B$, 即
#web-diagram(diagram({
	node((1, 0), [$T(B)$])
	node((0, 1), [$A$])
	node((1, 1), [$B$])
	node((0, 0), [$T(A)$])
	edge((0, 0), (1, 0), [$T(f)$], label-side: left, "->")
	edge((1, 0), (1, 1), [$b$], label-side: left, "->")
	edge((0, 0), (0, 1), [$a$], label-side: right, "->")
	edge((0, 1), (1, 1), [$f$], label-side: right, "->")
}))

== Barr--Beck--Lurie 定理

对于一对伴随
$ F : cal(C) arrows.lr cal(D) : U $
其典范具有单子 $T=U F$, 有典范的比较函子
$ K : cal(D) -> Alg_T (cal(C)) $
构造为
$ K(Y) = (U Y, T(U Y) = U F U Y larr^(U(epsilon_Y)) U Y) $
其中 $epsilon : F U -> id_(cal(D))$ 是余单位.

#definition(title:[单子性的函子])[
  我们称一对伴随
  $ F : cal(C) arrows.lr cal(D) : U $
  是*单子性* (monadic) 的, 是指 $K:cal(D)->Alg_T (cal(C))$ 是范畴等价.
]

回忆一个*增广单纯对象*和*分裂单纯对象*的定义, 所谓增广单纯对象, 就是在 $Delta$ 这个范畴中额外加入
$ [-1] := nothing $
得到的范畴 $Delta_+$ 意义下的单纯对象 $Delta^opp_+ -> cal(C)$. 而分裂单纯对象是指将 $Delta_+$ 的每个对象都添加一个最小元 $-oo$, 即对象形如
$ [n]_(-oo) = {-oo<0<1<...<n}, quad [-1]_(-oo) = {-oo} $
并且态射满足 $f(-oo)=-oo$ 的范畴 $Delta_(-oo)$ 意义下的单纯对象. 普通单纯对象若能延拓成分裂单纯对象就称之为分裂的, 若在函子 $F$ 映射下是分裂的, 则称之为 $F$-分裂的.

我们承认以下结论

#theorem(title:[Barr--Beck--Lurie 定理])[
  设 $F:cal(C) arrows.lr cal(D):U$ 是一对 $oo$-范畴的伴随, 令 $T = U F$ 是典范的单子, 若:

  + $U : cal(D) -> cal(C)$ 是保守的, 即 $U(f)$ 是等价蕴含 $f$ 是等价.
  + $cal(D)$ 中任意 $U$-分裂的单纯对象
    $ X_bullet : Delta^opp -> cal(D) $
    都存在几何实现 $abs(X_bullet)$.
  + $U$ 保持几何实现
    $ U(abs(X_bullet)) simeq abs(U(X_bullet)) $

  那么这对伴随是单子性的, 即 $K:cal(D) ->^~ Alg_T (cal(C))$.
]

= 利用 Barr--Beck--Lurie 建模范畴

== $A$-模

例如, 设 $(cal(C), times.o, bold(1))$ 是一个幺半范畴, 且 $A in Alg(cal(C))$, 则遗忘函子
$ U : LMod_A (cal(C)) -> cal(C) $
有左伴随
$ F(X) = A times.o X $
因此单子是
$ T(X) = A times.o X $
乘法是
$ T^2(X) = A times.o A times.o X larr^(mu_A times.o id) A times.o X $
单位是
$ X simeq bold(1) times.o X larr^(eta_A times.o id) A times.o X $
于是一个 Eilenberg--Moore 代数就是
$ alpha : A times.o X -> X $
满足
$ alpha(mu_A times.o bold(1)) = alpha(bold(1) times.o alpha) $
和单位律, 这恰好是一个左 $A$-模, 于是
$ LMod_(A)(cal(C)) simeq Alg_(A times.o -)(cal(C)) $

== 交换 $k$-代数

现在来考虑
$ Sym_k : Mod_k arrows.lr CAlg_k : U $
诱导的单子
$ T = U compose Sym_k $
我们检查几个条件:

+ 因为 $f$ 已经是代数同态, 其底层映射有逆, 这个逆自动保持代数运算, 不难考证 $U$ 是保守的.
+ 由标准的代数理论的性质, 交换 $k$-代数是一种有限元的代数理论, 遗忘函子创建所需的极限, 可以在底层模中验证 $U$-分裂等条件.

由 Barr--Beck--Lurie 定理
$ CAlg_k simeq Alg_T (Mod_k) $
一个对象就是 $k$-模 $A$ 加
$ Sym_k (A) -> A $
这个映射一次性编码了
$ k -> A, quad Sym^2 (A) -> A, Sym^3 (A) -> A, ... $
即单位, 乘法和所有的迭代乘法.

== 生象代数

普通的自由交换代数单子导出可作
$ LSym_k : Dcat_(>=0)(k) -> Dcat_(>=0)(k) $
可以验证
$ AniCAlg_k simeq Alg_(LSym_k) (Dcat_(>=0)(k)) $
所以一个生象交换代数本质上就是
$ A in Dcat_(>=0) (k) $
加上一个融贯的作用
$ LSym_k (A) -> A $

= 导出环的实现

== Bhatt--Mathew 的构造

上面我们自然地将生象代数视作了
$ AniCAlg_k simeq Alg_(LSym_k) (Dcat_(>=0)(k)) $
自然的想法就是将这个 $>=0$ 去掉, 也就是说, 我们要想办法将 $LSym_k$ 以合理的方式延拓到任意次数, 以得到 "合理的自由函子"
$ Dcat(k) -> dCAlg_k $

这个构造不可以直接 Kan 延拓, 因为 $Dcat_(>=0)(k) subset Dcat(k)$ 并不是那种可以靠筛余极限恢复的包含关系.

Bhatt--Mathew 想到, 可以利用 $LSym$ 的一个特殊性质, 即 $LSym$ 是有限次数的多项式函子组成的, 一般的 $Sym$ 可以分解为
$ Sym(M) simeq plus.o.big_(r>=0) Sym^r (M) $
导出之后有
$ LSym(M) simeq plus.o.big_(r>=0) LSym^r (M) $
其中
$ LSym^r $
是第 $r$ 导出对称幂次. 通过某种 Goodwille 微积分的道理, Raksit 证明了
$ LSym^(<=r) := plus.o.big_(0<=j<=r) LSym^j $
是 $n$-切除的, 一些 Goodwille 道理告诉我们, 一个在连通部分上的保持筛余极限的多项式函子可以唯一地延拓到整个范畴 (这部分我还没看到等以后来补充吧 xwx). 于是对每个 $r$ 都能得到唯一的延拓
$ LSym^r_k : Dcat(k) -> Dcat(k) $
但 $LSym$ 本身不具有多项式的性质, 解决方法是考虑滤过
$ LSym^(<=0) -> LSym^(<=1) -> LSym^(<=2) -> ... $
其中的每一个都是有限的多项式函子, 从而每一层都能延拓.

我们接下来得延拓整个单子结构, 也就是说必须延拓 
$ eta : id -> LSym $
和
$ mu : LSym compose LSym -> LSym $
由于有结论: 多项式自函子对复合封闭, 整个 $LSym^(<=bullet)$ 的滤过单子结构能够一起延拓, 延拓后取余极限得到整个
$ LSym = varinjlim(n) LSym^(<=n) $
使得
$ LSym : Dcat(k) -> Dcat(k) $
仍然是单子, 我们就可以顺理成章地定义

#definition(title:[导出 $k$-代数])[
  定义*导出 $k$-代数* (derived $k$-algebra) 为上述单子对应的 Eilenberg--Moore 代数范畴, 即
  $ dCAlg_k = Alg_(LSym_k) (Dcat(k)) $
]

也就是说, 一个导出代数是一个 $M in Dcat(k)$ 配合一个融贯的作用 $LSym_k (M)->M$. 并且
$ dCAlg_k^(>=0) simeq AniCAlg_k $

== 一些可操作性

#remark[
  在 $char k =0$ 时, 我们可以用 cdga 模去拟同构来操作导出代数, 即
  $ dCAlg_k simeq cdga_k ["qis"^(-1)] $
]
