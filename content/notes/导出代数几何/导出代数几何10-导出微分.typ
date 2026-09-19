#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

= 为什么需要导出?

== 经典理论的弊端

经典的微分理论将很多信息都 "压扁" 了, 对于普通的 $k$-代数 $A$, 经典微分由
$ dif : A -> Omega^1_(A\/k) $
控制, 且有
$ Der_k (A,M) tilde.eq Hom_A (Omega^1_(A\/k),M) $
这确实完美地表示了普通的平方零扩张
$ A plus.o M, quad M^2 = 0 $
但也只告诉了你一阶上有很多方向, 并没有告诉你哪些可以延拓到二阶, 不同延拓之间如何比较. 例如普通的微分可以回答

#question[
  有给定 $M$ 有哪些 $k$-导子 $A->M$?
]

这个问题被 $Omega^1_(A\/k)$ 表示. 而问题

#question[
  有哪些平方零扩张
  $ 0 -> M -> A' -> A -> 0 $
]

属于更高一级的数据, 我们后面会知道它由 $Ext^1_A (LL_(A\/k),M)$ 控制.

== 一些基本直觉
