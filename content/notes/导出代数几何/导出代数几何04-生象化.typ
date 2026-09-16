#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 一些神奇的生成条件

== 三种对象

下面固定一个正则序数 $kappa$. $cal(C)$ 是一个可呈示的 $oo$-范畴.

#definition(title:[绝对对象])[
  若 $X in cal(C)$ 满足余可表预层 $Map_(cal(C)) (X,-)$ 与任何余极限交换, 则称之为 $cal(C)$ 的一个*绝对对象*.
]

#definition(title:[投射对象])[
  若 $X in cal(C)$ 满足余可表预层 $Map_(cal(C)) (X,-)$ 保持几何实现, 即对任意单纯对象 $X_bullet: Delta^opp->cal(C)$, 自然映射是等价
  $ abs(Map_(cal(C))(X,Y_bullet)) tilde.eq Map_(cal(C)) (X,abs(Y_bullet)) $
  则称之为 $cal(C)$ 的一个*投射对象*.
]

#remark(title:[1-投射对象])[
  若给定的余可表预层与任何反身的余等化子交换, 即对于
  $ X_1 arrows^(d_0)_(d_1) X_0, quad s:X_0->X_1 $
  满足 $d_0 s = d_1 s = id_(X_0)$, 有
  $ Map_(cal(C))(X,"coEq"(X_1 arrows^(d_0)_(d_1) X_0)) tilde.eq "coEq"(Map_(cal(C))(X,X_1) arrows^(d'_0)_(d'_1) Map_(cal(C))(X,X_0)) $
  则称之为 *1-投射对象*.
]

#definition(title:[紧投射对象])[
  若 $X in cal(C)$ 满足余可表预层 $Map_(cal(C)) (X,-)$ 与任何 $kappa$-小的筛余极限交换, 则称之为 $cal(C)$ 的一个 *$kappa$-紧投射对象*.
]

#theorem[
  $X$ 是紧投射对象 $<=>$ $X$ 是($omega$-)紧对象且是投射对象.
]

紧对象我们在上一节已经定义过. 特别地, 我们还有一个比较重要的 1-范畴上的定义, 后面还会用到

#definition(title:[紧 1-投射对象])[
  设 $cal(D)$ 是一个可呈示的 1-范畴, 称 $Y in cal(D)$ 是*紧 1-投射对象*是指 $Hom_(cal(D)) (Y,-):cal(D)->Set$ 与 1-筛的余极限交换.
]

现在开始, 我们记 $cal(C)^"abs", cal(C)^(omega"p"), cal(C)^omega$ 分别代表绝对对象, $omega$-紧投射对象和 $omega$-紧对象生成的全子范畴, 显然有包含链
$ cal(C)^"abs" arrow.hook cal(C)^(omega"p") arrow.hook cal(C)^omega $
若 $cal(C)$ 是可呈示的 1-范畴, 记 $cal(C)^(omega 1"p")$ 为紧 1-投射对象生成的全子范畴.

#remark[
  若 $cal(C)$ 是可呈示的 1-范畴, $X in cal(C)$ 是紧投射的, 那么一定是紧 1-投射的. 但反之不然, 典型的例子是 $cal(C)=Set$, $X = *$. 1-范畴意义下
  $ Hom_(Set) (*,-) tilde.eq id_(Set) $
  从而保持所有的余极限, 当然有所有的筛余极限, 但若将映射空间看作是离散空间, 则
  $ Map_(Set) (*,-) : Set -> Ani $
  是离散空间的嵌入, 一般不保持筛余极限, 例如我们知道 $Delta^opp$ 是筛的, 取一个单纯集 $K$ 使得其几何实现同伦等价于 $S^1$, 在 $Set$ 中取这个单纯集 $K:Delta^opp -> Set$ 的余极限得
  $ colim_([n] in Delta^opp)^Set K_n tilde.eq pi_0 (S^1) tilde.eq * $
  因此先是在 $Set$ 中取到余极限, 再映到生象, 得到
  $ Map(*,colim^(Set)_(Delta^opp) K) tilde.eq * $
  但如果先映到 $Ani$ 再取同一个筛极限
  $ colim_([n]in Delta^opp)^Ani Map(*,K_n) tilde.eq |K| tilde.eq S^1 $
  二者显然不同, 核心问题就是通过离散嵌入
  $ i : Set arrow.hook Ani $
  时我们只将集合视作离散空间, 这一步不保持一般的筛极限.
]

#proposition[
  设 $cal(C)$ 是小的 $oo$-范畴, 当其中对象通过 Yoneda 嵌入 $yo$ 视作 $PSh(cal(C))$ 中的对象时典范地是绝对对象.
]

#proof[平凡.]

#corollary[
  设 $cal(C)$ 是小的 $oo$-范畴, 当其中对象通过 Yoneda 嵌入 $yo$ 视作 $sInd(cal(C))$ 中的对象时典范地是紧投射对象.
]

#corollary[
  设 $cal(C)$ 是小的 $oo$-范畴, 当其中对象通过 Yoneda 嵌入 $yo$ 视作 $Ind(cal(C))$ 中的对象时典范地是紧对象.
]

== 三种生成

由伴随函子定理, $cal(C)$ 是可呈示的, 从而是余完备的, 记 $i:cal(C)^"abs" arrow.hook cal(C)$ 是嵌入, 于是 $yo:cal(C)^"abs" arrow.hook PSh(cal(C)^"abs")$ 存在唯一的左 Kan 延拓
$ L := Lan_yo (i) : PSh(cal(C)^"abs") -> cal(C) $
更显示地可以写成
$ L(F) tilde.eq colim_(yo(c)->F) c $
或者用余端的语言可作
$ L(F) tilde.eq integral^(c in cal(C)^"abs") F(c) times.o c $

#definition(title:[绝对生成])[
  设 $cal(C)$ 是可呈示的 $oo$-范畴, 那么我们称其为*绝对生成的*, 是指左伴随 $L:PSh(cal(C)^"abs")->cal(C)$ 是一个等价.
]

下面的左伴随也可以通过类似的论证典范地得到, 此处不再详细赘述.

#definition(title:[紧投射生成])[
  设 $cal(C)$ 是可呈示的 $oo$-范畴, 那么我们称其为*紧投射生成的*, 是指左伴随 $L:sInd(cal(C)^(omega"p"))->cal(C)$ 是一个等价.
]

#definition(title:[紧生成])[
  设 $cal(C)$ 是可呈示的 $oo$-范畴, 那么我们称其为*紧生成的*, 是指左伴随 $L:Ind(cal(C)^omega)->cal(C)$ 是一个等价.
]

显然这些条件顾名思义, 就是描述一个范畴如何被这三种对象以各自的方式生成, 我们还有条件强度序列

#theorem[
  绝对生成蕴含紧投射生成, 紧投射生成蕴含紧生成.
]

最后我们还有一个 1-范畴的定义

#definition(title:[1-紧投射生成])[
  设 $cal(C)$ 是可呈示的 1-范畴, 那么我们称其为 *1-紧投射生成的*, 是指左伴随 $sInd(cal(C)^(omega 1"p"))^suit.heart -> cal(C)$ 是一个等价.
]

= 生象化

== 生象化的定义解释

对于一个紧投射生成的 1-范畴 $cal(C)$, 我们可以将其写作

$ Fun^times ((cal(C)^(omega"p"))^opp,Set) tilde.eq "1-"sInd(cal(C)^(omega"p")) tilde.eq cal(C) $

左边表示保持有限乘积函子的全子范畴. 我们固然希望在 $oo$-范畴中推广这一概念:

#definition(title:[生象化])[
  设 $cal(C)$ 是一个紧 1-投射生成的范畴, 则 $cal(C)$ 的*生象化* (animation) 定义为
  $ Ani(cal(C)) tilde.eq sInd(cal(C)^(omega"p")) tilde.eq Fun^times ((cal(C)^(omega"p"))^opp,Ani) $ 
  其中的对象称之为 $cal(C)$ 的*生象对象* (animated objects).
]

#lemma[
  设 $cal(C)$ 是一个紧 1-投射生成的范畴, 则 $Ani(cal(C))$ 是紧投射生成的范畴, 且 $Ani(cal(C))^(omega"p") tilde.eq cal(C)^(omega 1"p")$.
]

#remark(title:[生象化的泛性质])[
  若 $cal(D)$ 具有筛余极限, 那么限制到紧投射生成元给出等价
  $ Fun^"sift" (Ani(cal(C)),cal(D)) tilde.eq Fun(cal(C)^(omega"p"),cal(D)) $
  左边代表全体保持筛余极限的函子, 也就是说, 任意函子
  $ f:cal(C)^(omega"p") -> cal(D) $
  都在可缩选择下存在唯一的保持筛余极限的延拓
  $ tilde(f):Ani(cal(C)) -> cal(D) $
  使得
  $ tilde(f) tilde.eq Lan_(yo) f $
  若 $cal(D)$ 甚至具有所有的余极限, 那么
  $ Fun^"L" (Ani(cal(C)),cal(D)) tilde.eq Fun^union.sq (cal(C)^(omega"p"),cal(D)) $
  左边是所有保持余极限的函子, 右边是保持有限余积的函子, 也就是说所有的余极限基本上可以理解为筛余极限+有限的余积. 粗略地, $Ani(cal(C))$ 就是使得下图构造
  #web-diagram(diagram({
	node((-1, -1), [$cal(C)^(omega 1"p")$])
	node((-1, 0), [$Ani(cal(C))$])
	node((0, -1), [$cal(D)$])
	node((0, 0), [$cal(D)$])
	edge((-1, -1), (-1, 0), [$yo$], label-side: right, "->")
	edge((-1, -1), (0, -1), [$f$], label-side: left, "->")
	edge((-1, 0), (0, 0), [$exists! Lan_yo f$], label-side: right, "->")
  }))
  成立的自由筛余完备化. 生象化的意义所在就是我们只需要在 $cal(C)^(omega"p")$ 上构筑函子, 左 Kan 延拓就能直接延拓到 $cal(C)$ 上的情形.
]

== 生象化的重要例子

#example[
  注意到对任意集合 $X$, 都有
  $ X tilde.eq product.co_(x in X) * $
  而 $*$ 显然是紧 1-投射对象, 于是 $Set$ 是紧 1-投射生成的. $Set$ 中的紧 1-投射对象恰好是有限集合. 普通的 $Set$ 可以通过这些小生成元恢复, 即
  $ Set tilde.eq "1-"sInd(cat("FinSet")) $
  换成生象化就是
  $ Ani tilde.eq Ani(Set) tilde.eq sInd(cat("FinSet")) $
]

#example(title:[环的模范畴])[
  设 $R$ 是一个结合环, (左) $R$-模范畴 $Mod_R$ 满足
  $ Mod_R^(omega"p") tilde.eq {"有限生成的投射左" R"-模"} $
  并且 $Mod_R = "1-"sInd(Mod_R^(omega"p"))$, 那么可以定义
  $ Ani(Mod_R) tilde.eq sInd(Mod^(omega"p")_R) $
  我们可以证明其等价于导出范畴 $Dcat(R)_(>=0)$. 这也是为什么有时候我们可以将生象化类比成 "非 Abel 导出范畴".
]

#example[
  虽然松对称幺半函子
  $ DK : simp(Alg) -> dga_(>=0) $
  不是范畴等价, 但其分别逆掉弱等价后确实是等价, 也就是说有等价
  $ Ani(Alg) tilde.eq simp(Alg)[W^(-1)] tilde.eq dga_(>=0)["qis"^(-1)] $
]

= 一个模型范畴刻画

Lurie 证明了当 $cal(C)$ 是一个有有限余积的 1-范畴时, 筛与完备化 $sInd$ 有一个非常不错的模型范畴刻画. 我们取范畴
$ Fun^times (cal(C)^opp,sSet) $
即保持有限积的函子的 1-范畴, 我们定义

+ $eta$ 是弱等价当且仅当对任意 $c in cal(C)$, $eta(c):F(c)->G(c)$ 是 $sSet$ 中的弱同伦等价.
+ $eta$ 是纤维化当且仅当对任意 $c in cal(C)$, $eta(c):F(c)->G(c)$ 是 $sSet$ 中的 Kan 纤维化.
+ 余纤维化由提升性质确定.

那么这个模型范畴称之为 $Fun^times (cal(C)^opp,sSet)$ 上的*投射模型范畴*, Lurie 证明了其局部化后恰好有
$ Fun^times (cal(C)^opp,sSet) tilde.eq sInd(cal(C)) $
