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

#definition(title:[紧投影对象])[
  若 $X in cal(C)$ 满足余可表预层 $Map_(cal(C)) (X,-)$ 与任何 $kappa$-小的筛滤余极限交换, 则称之为 $cal(C)$ 的一个 *$kappa$-紧投影对象*.

]

紧对象我们在上一节已经定义过. 特别地, 我们还有一个比较重要的 1-范畴上的定义, 后面还会用到

#definition(title:[紧 1-投影对象])[
  设 $cal(D)$ 是一个可呈示的 1-范畴, 称 $Y in cal(D)$ 是*紧 1-投影对象*是指 $Hom_(cal(D)) (Y,-):cal(D)->Set$ 与 1-筛滤的余极限交换.
]

现在开始, 我们记 $cal(C)^"abs", cal(C)^(omega"proj"), cal(C)^omega$ 分别代表绝对对象, $omega$-紧投影对象和 $omega$-紧对象生成的全子范畴, 显然有包含链
$ cal(C)^"abs" arrow.hook cal(C)^(omega"proj") arrow.hook cal(C)^omega $
若 $cal(C)$ 是可呈示的 1-范畴, 记 $cal(C)^(omega 1"proj")$ 为紧 1-投影对象生成的全子范畴.

#remark[
  若 $cal(C)$ 是可呈示的 1-范畴, $X in cal(C)$ 是紧投射的, 那么一定是紧 1-投射的. 但反之不然, 典型的例子是 $cal(C)=Set$, $X = *$. 1-范畴意义下
  $ Hom_(Set) (*,-) tilde.eq id_(Set) $
  从而保持所有的余极限, 当然有所有的筛滤余极限, 但若将映射空间看作是离散空间, 则
  $ Map_(Set) (*,-) : Set -> Ani $
  是离散空间的嵌入, 一般不保持筛滤余极限, 例如我们知道 $Delta^opp$ 是筛滤的, 取一个单纯集 $K$ 使得其几何实现同伦等价于 $S^1$, 在 $Set$ 中取这个单纯集 $K:Delta^opp -> Set$ 的余极限得
  $ colim_([n] in Delta^opp)^Set K_n tilde.eq pi_0 (S^1) tilde.eq * $
  因此先是在 $Set$ 中取到余极限, 再映到生象, 得到
  $ Map(*,colim^(Set)_(Delta^opp) K) tilde.eq * $
  但如果先映到 $Ani$ 再取同一个筛滤极限
  $ colim_([n]in Delta^opp)^Ani Map(*,K_n) tilde.eq |K| tilde.eq S^1 $
  二者显然不同, 核心问题就是通过离散嵌入
  $ i : Set arrow.hook Ani $
  时我们只将集合视作离散空间, 这一步不保持一般的筛滤极限.
]

#proposition[
  设 $cal(C)$ 是小的 $oo$-范畴, 当其中对象通过 Yoneda 嵌入 $yo$ 视作 $PSh(cal(C))$ 中的对象时典范地是绝对对象.
]

#proof[平凡.]

#corollary[
  设 $cal(C)$ 是小的 $oo$-范畴, 当其中对象通过 Yoneda 嵌入 $yo$ 视作 $PSh_Sigma (cal(C))$ 中的对象时典范地是紧投射对象.
]

#corollary[
  设 $cal(C)$ 是小的 $oo$-范畴, 当其中对象通过 Yoneda 嵌入 $yo$ 视作 $Ind(cal(C))$ 中的对象时典范地是紧对象.
]

== 三种生成

