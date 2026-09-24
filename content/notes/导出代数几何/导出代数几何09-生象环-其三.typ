#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 为任意交换环.

= 生象环的局部化

== 单个元素的局部化

#definition(title:[对单个元素的局部化])[
  设 $A in AniCAlg_k$, $f in pi_0 (A)$, 那么我们可以定义
  $ A[f^(-1)] := A dtens_(k[t]) k[t,t^(-1)] $
  其中 $k[t]->A, t |-> f$. 称之为*局部化* (localization).
]

类似地, 我们可以定义模的情形

#definition(title:[模的单元素局部化])[
  取 $M in Mod_A$, 我们定义
  $ M[f^(-1)] := A[f^(-1)] dtens_A M $
]

显然这个定义与前面的兼容.

#proposition(title:[局部化的望远镜结构])[
  作为 $A$-模, 有典范等价
  $ A[f^(-1)] simeq varinjlim("") (A->^(dot f) A->^(dot f) A->^(dot f)...) $
  这个构造称之为*局部化望远镜* (localization telescope).
]

#proof[
  我们知道作为 $k[t]$-模有
  $ k[t,t^(-1)] simeq varinjlim("") (k[t]->^(dot t) k[t]->^(dot t) k[t]->^(dot t)...) $
  由于 $A times.o_(k[t]) (-)$ 是左伴随, 有
  $
  A[f^(-1)] &simeq A times.o_(k[t]) k[t,t^(-1)] \
  &simeq A times.o_(k[t]) varinjlim("") (k[t]->^(dot t) k[t]->^(dot t) k[t]->^(dot t)...) \
  &simeq varinjlim("") (A times.o_(k[t]) k[t]->^(dot t) A times.o_(k[t]) k[t]->^(dot t) A times.o_(k[t]) k[t]->^(dot t)...) \
  &simeq varinjlim("") (A->^(dot f) A->^(dot f) A->^(dot f)...)
  $
]

#corollary[
  类似地, 对于一般的模也有
  $ M[f^(-1)] simeq varinjlim("") (M ->^(dot f) M ->^(dot f) M ->^(dot f) ...) $
]

#proposition[
  总有
  $ pi_n (A[f^(-1)]) simeq pi_n (A) [f^(-1)] $
  后面将 $pi_n (A)$ 看作 $pi_0 A$-模.
]

#proof[
  只需识别到
  $ pi_n (A[f^(-1)]) &simeq pi_n (varinjlim("") (A->^(dot f) A->^(dot f) A->^(dot f)...)) \
  &simeq varinjlim("") (pi_n (A) ->^(dot f) pi_n (A) ->^(dot f)...) \
  &simeq pi_n (A)[f^(-1)] $
]

== 乘性集的局部化

#definition(title:[对乘性集的局部化])[
  若 $S subset pi_0 A$ 是乘性子集, 则定义 $A[S^(-1)]$ 为满足全体 $s in S$ 都在 $pi_0 B$ 中变成单位的始 $A$-代数, 形式地, 我们可以定义
  $ A[S^(-1)] = colim_(s in S) A[s^(-1)] $
]

#proposition[
  对于同样的假设有
  $ pi_n (A[S^(-1)]) simeq S^(-1) pi_n (A) $
]

= 生象环的商

== 对一个元素的商

在生象环的语境下, 商的定义比较微妙.

#definition(title:[导出商])[
  给定 $A in AniCAlg_k$ 以及 $f in pi_0 A$, 我们定义*导出商* (derived quotient) 为
  $ A /\/ f  := A dtens_(k[t]) k $
  其中 $t|->f$, 而 $k[t]->k$ 将 $t$ 送到 $0$.
]

也就是说, 导出商是下列图表

#web-diagram(diagram({
	node((-1, 0), [$k[t]$])
	node((0, 0), [$A$])
	node((-1, 1), [$k$])
	node((0, 1), [$A\/\/f$])
	edge((-1, 0), (0, 0), [$t|-> f$], label-side: left, "->")
	edge((-1, 0), (-1, 1), [$t|-> 0$], label-side: right, "->")
	edge((-1, 1), (0, 1), "->")
	edge((0, 0), (0, 1), "->")
}))

的推出, 也就是说, 导出商是 "自由地施加 $f=0$ 这一关系" 的结构.

#proposition[
  作为底层 $A$-模, 有
  $ A /\/ f simeq cofib(A ->^(dot f) A) $
]

#proof[
  由基础代数学可构造出纤维序列
  $ k[t] ->^(dot t) k[t] -> k $
  也就是说
  $ k simeq cofib(k[t]->^(dot t)k[t]) $
  沿着 $k[t]->A$ 做基变换, 基变换保持纤维序列, 证毕.
]

#corollary[
  设 $A$ 是普通交换环, 那么 $pi_1 (A/\/f) simeq Ann_A (f)$.
]

#proof[
  显然由定义
  $ pi_1 (A/\/f) simeq ker(A ->^(dot f) A) = {a in A: a f = 0} =: Ann_A (f) $
]

== 对多个方程的商

#definition(title:[多个方程的导出商])[
  给定 $f_1,...,f_r in pi_0 (A)$, 我们定义
  $ A /\/ (f_1,...,f_r) := A dtens_(k[f_1,...,f_r]) k $
]

也就是说下列图表 

#web-diagram(diagram({
	node((-1, 0), [$k[t_1,...t_r]$])
	node((0, 0), [$A$])
	node((-1, 1), [$k$])
	node((0, 1), [$A\/\/(f_1,...,f_r)$])
	edge((-1, 0), (0, 0), [$t_i|-> f_i$], label-side: left, "->")
	edge((-1, 0), (-1, 1), [$t_i|-> 0$], label-side: right, "->")
	edge((-1, 1), (0, 1), "->")
	edge((0, 0), (0, 1), "->")
}))

的推出.

= Koszul 复形

== 基本定义

对于前面提到的

$ A /\/ f simeq cofib(A ->^(dot f) A) $
复形
$ [A ->^(dot f) A] $
这个复形非常具有研究价值, 也就是下面的定义

#definition(title:[Koszul 复形])[
  设 $A in AniCAlg_k$, $f in pi_0 A$, 那么 $f$ 给出乘法态射, 我们定义 *Koszul 复形* 为
  $ K_A (f) := cofib(A ->^(dot f) A) in Mod_A $
]

由前, 一元时, $K_A (f)$ 就是 $A/\/f$ 的底层复形.

#definition(title:[Koszul复形, 多元])[
  继承前假设, 对于有限序列 $f_1,...,f_r in pi_0 A$, 定义
  $ K_A (f_1,...,f_r) := K_A (f_1) dtens_A ... dtens_A K_A (f_r)  $
]

#proposition[
  显然有

  + $pi_0 K_A (f_1,...,f_r) simeq pi_0 A / (f_1,...,f_r)$.
  + $pi_r K_A (f_1,...,f_r) simeq Ann_A (f_1,...,f_r)$.
  + $U(A/\/(f_1,...,f_r)) simeq K_A (f_1,...,f_r)$.
]

== 正则序列

#definition(title:[正则序列])[
  设 $A$ 是普通交换环, 称 $f_1,...,f_r in A$, 称之为一个*正则序列*, 是指
  $ (f_1,...,f_r) != A $
  且对每个 $i$, $f_i$ 在 $A/(f_1,...,f_(i-1))$ 中是非零因子.
]

#lemma[
  显然有
  $ K_A (f_1,...,f_r) simeq cofib(K_A (f_1,...,f_(r-1)) ->^(dot f_r) K_A (f_1,...,f_(r-1)) ) $
]

#proposition[
  若 $f_1,...,f_r$ 是 $A$ 中的正则序列, 则
  $ H_i (K_A (f_1,...,f_r)) = 0, quad i>0 $
  此时作为模有
  $ K_A (f_1,...,f_r) simeq A/(f_1,...,f_r) $
]

#proof[
  归纳法. 对 $r=1$ 显然. 假设已经证明
  $ H_i (K_(r-1)) = 0, quad i>0 $
  且
  $ H_0 (K_(r-1)) simeq A/(f_1,...,f_(r-1)) $
  记上式为 $B$. 对引理给出的纤维序列
  $ K_(r-1) -->^(dot f_r) K_(r-1) --> K_r $
  作用长正合列
  $ ... -> H_i (K_(r-1)) -->^(f_r) H_i (K_(r-1)) --> H_i (K_r) --> H_(i-1) (K_(r-1)) --> ... $
  对 $i>=2$, 归纳假设给出两边都是 $0$, 从而 $H_i (K_r) = 0$, 对剩余的 $H_1$, 长正合列给出
  $ 0 --> H_1 (K_r) --> H_0 (K_(r-1)) -->^(f_r) H_0 (K_(r-1)) $
  也就是
  $ 0 --> H_1 (K_r) --> B -->^(f_r) B $
  正则序列的定义无非就是说 $f_r$ 在 $B$ 中是非零因子, 于是 $B-->^(f_r) B$ 是单射, 从而 $H_1 (K_r) = 0$.
]

上述论证可以典范地放进生象环的语境, 此处略.

可以看出, 正则序列给出的条件本质是 Koszul 复形没有高次同调, 后面的条件我们一般称之为 *Koszul 正则*, 这是导出商和常规环的商能够等同
$ A/\/(f_1,...,f_r) simeq A/(f_1,...,f_r) $
的等价条件.

= 一般态射的商

== 为什么不能直接商普通理想?

准确来说, 我们的定义
$ A/\/f = A dtens_(k[t]) k $
给出的泛性质不仅仅是说, 在目标 $B$ 中, $f$ 的像为 $0$, 它真正刻画的是 $f_B$ 到 $0$ 的一个零伦. 一个很好的例子是常规环论的普通理想
$ I = (x) $
可以用一个方程表示, 也可以冗余地用两个一样的方程
$ I = (x,x) $
在普通环论里当然没区别
$ A/(x) simeq A/(x,x) $
但是当上升到导出
$ A/\/(x,x) $
时, 底层的 Koszul 复形是
$ K_A (x,x) = K_A (x) dtens_A K_A (x) $
先有 $K_A (x) simeq k$, 所以
$ K_A (x,x) simeq k dtens_A k $
在常规的环论里, $k times.o_A k simeq k$, 但在导出层面这绝不是平凡的结构, 我们有
$ k dtens_A k simeq [A ->^x A] dtens_A k simeq [k ->^0 k] simeq k plus.o k[1] $
这很好地解释了为什么将方程包装成理想损失了大量信息.

== 一般导出商

#definition(title:[导出商])[
  设 $A in AniCAlg_k$, 给定一个导出 $k$-模和态射 $u:M->U(A)$, 自由交换代数的伴随诱导 $LSym_k (M)->A$, 零映射 $M->U(k)$ 诱导出 $LSym_k (M)->k$, 我们定义 $A$ 相对 $M$ 的*导出商*为
  $ A /\/ M := A dtens_(LSym_k (M)) k $
]

也就是下图是推出

#web-diagram(diagram({
	node((0, 0), [$"LSym"_k (M)$])
	node((0, 1), [$k$])
	node((1, 0), [$A$])
	node((1, 1), [$A\/\/M$])
	edge((0, 0), (0, 1), [$epsilon$], label-side: right, "->")
	edge((0, 0), (1, 0), "->")
	edge((1, 0), (1, 1), "->")
	edge((0, 1), (1, 1), "->")
}))

类似地, 我们可以定义 Koszul 复形
$ K_A (M,u) = A dtens_(LSym_k (M)) k $
