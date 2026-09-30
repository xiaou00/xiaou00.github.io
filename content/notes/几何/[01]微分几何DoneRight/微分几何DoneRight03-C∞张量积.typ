#import "../../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

#quote[
  没有张量积的代数相当于没有⬛的男娘.

  --- xiaou0
]

本节固定 $k$ 是基底 $C^oo$-环, 若要得到普通 $C^oo$-环的理论, 取 $k=RR$ 即可.

= 光滑张量积

== 作为极限的定义

#definition(title:[光滑张量积])[
  对于 $A,B in CooAlg_k$, 定义*光滑张量积* (smooth tensor product) 为 $CooAlg$ 中的余积, 也就是下述图表
  #web-diagram(diagram({
    node((1, -1), [$k$])
    node((2, -1), [$A$])
    node((1, 0), [$B$])
    node((2, 0), [$A times.o^oo_k B$])
    edge((1, -1), (1, 0), "->")
    edge((1, -1), (2, -1), "->")
    edge((2, -1), (2, 0), "->")
    edge((1, 0), (2, 0), "->")
    edge((2, 0), (1, -1), [$corner.r.b$], label-side: center, label-pos: 0.1, shift:-0.05, " ")
  }))
  定义的推出.
]

#proposition[
  上述张量积诱导自然的对称幺半结构
  $ (CooAlg_k, times.o^oo_k, k) $
]

== 几何直观

我们之后会定义 $Spec_oo$ 来将 $C^oo$-代数转化成几何结构, 而上述的张量积在对偶之后恰好就是拉回

#web-diagram(diagram({
	node((2, 0), [$"Spec"_oo k$])
	node((2, -1), [$"Spec"_oo A$])
	node((1, 0), [$"Spec"_oo B$])
	node((1, -1), [$"Spec"_oo A times.o^oo_k B$])
	edge((1, 0), (2, 0), "->")
	edge((2, -1), (2, 0), "->")
	edge((1, -1), (2, -1), "->")
	edge((1, -1), (1, 0), "->")
	edge((1, -1), (2, 0), [$corner.r.b$], label-side: center, label-pos: 0.1, shift: -0.1, " ")
}))

告诉我们
$ Spec_oo (A times.o^oo_k B) simeq Spec_oo A times^oo_(Spec_oo k) Spec_oo B $

#remark[
  张量积 $A times.o^oo_k B$ 显然满足泛性质: 对任意 $C^oo$-环 $D$, 都有
  $ Hom_CooRing (A,D) times_(Hom_CooRing (k,D)) Hom_CooRing (B,D) \ simeq Hom_CooRing (A times.o_k^oo B, D) $
  全部视作 $k$-代数就可以简化成
  $ Hom_k (A times.o^oo_k B,D) simeq Hom_k (A,D) times Hom_k (B,D) $
]

= 重要实践

== 重访自由 $C^oo$-环

回顾 $RR$ 是 $CooRing$ 的始对象, 有限集合 
$ {x_1,...,x_n} $
上的自由 $C^oo$-环是
$ RR{x_1,...,x_n} := C^oo (RR^n) $
我们还可以对任意 $S in Set$ 定义 $RR{S}$, 我们先讨论有限的情形.

#lemma[
  $Hom_(CooRing)(RR{x_1,...,x_n},A) simeq A^n$. 也就是说态射完全由
  $ x_1,...,x_n $
  在 $A$ 中的像决定.
]

#proof[
  将前者改写为
  $ Nat(h_(RR^n),A) $
  由 Yoneda 引理,
  $ Nat(h_(RR^n),A) simeq A(RR^n) simeq A(RR)^n = A^n $
]

#lemma[
  $C^oo (RR^m) times.o^oo C^oo (RR^n) simeq C^oo (RR^(m+n))$.
]

#proof[
  由于 $A^(m+n) simeq A^m times A^n$ 对任意 $A$ 成立, 由上一条即可.
]

== 相对自由化

#construction(title:[相对自由化])[
  固定 $k in CooRing$, 我们定义
  $ k{x_1,...,x_n} := k times.o^oo RR{x_1,...,x_n} $
  更一般地, 我们可以构造
  $ k{S} := k times.o^oo F(S) $
  这确实是 $k$-代数范畴里的自由对象, 因为
  $ Hom_k (k{S},B) &simeq Hom_k (k times.o^oo F(S),B)\
  &simeq Hom_CooRing (F(S),B)\
  &simeq Hom_Set (S,U(B)) $
  在有限情形, 就是说
  $ Hom_k (k{x_1,...,x_n},B) simeq B^n $
]

也就是说, 我们有伴随对
$ F_k : Set arrows.lr CooAlg_k : U_k $

== 自由张量积公式

#proposition(title:[自由张量积公式])[
  设 $k$ 是 $C^oo$-环, 则
  $ k{x_1,...,x_m} times.o^oo k{y_1,...,y_n} simeq k{x_1,...,x_m,y_1,...,y_n} $
]

#proof[
  利用泛性质有
  $
  &k{x_1,...,x_m} times.o^oo k{y_1,...,y_n}\
  simeq&(k times.o^oo RR{x_1,...,x_m}) times.o^oo_k (k times.o^oo RR{y_1,...,y_n})\
  simeq&k times.o^oo (RR{x_1,...,x_m} times.o^oo RR{y_1,...,y_n})\
  simeq&k times.o^oo RR{x_1,...,x_m,y_1,...,y_n}\
  simeq&k{x_1,...,x_m,y_1,...,y_n}
  $
]

#proposition(title:[一般自由张量积公式])[
  设 $k$ 是 $C^oo$-环, 则
  $ k{S} times.o^oo_k k{T} simeq k{S cop T} $
]

#proof[
  $F_k : Set -> CooAlg_k$ 是左伴随, 从而保持余极限, 于是
  $ F_k (S cop T) simeq F_k (S) cop F_k (T) $
]

== 标量扩张与标量限制

#construction(title:[标量限制])[
  设 $f : A->B$ 是 $C^oo$-环同态, 我们可以定义函子
  $
  f^* : CooAlg_B &-> CooAlg_A \
  (B->D) &|-> (A->^f B->D)
  $
  称之为*限制标量*函子, 容易看出这个函子本质上就是复合态射.
]

#construction(title:[标量扩张])[
  设 $f : A->B$ 是 $C^oo$-环同态, 我们可以定义函子
  $
  f_! : CooAlg_A&-> CooAlg_B \
  D &|-> B times.o^oo_A D
  $
  也就是通过推出
  #web-diagram(diagram({
	node((2, 0), [$B times.o^oo_A D$])
	node((1, -1), [$A$])
	node((2, -1), [$B$])
	node((1, 0), [$D$])
	edge((1, -1), (1, 0), "->")
	edge((1, -1), (2, -1), "->")
	edge((2, -1), (2, 0), "->")
	edge((1, 0), (2, 0), "->")
	edge((2, 0), (1, -1), [$corner.r.b$], label-side: center, label-pos: 0.1, " ")
  }))
  将 $D$ 典范地视作 $B$-光滑代数.
]

#theorem(title:[tensor-Hom 伴随])[
  我们有伴随关系
  $ f_! : CooAlg_A arrows.lr CooAlg_B : f^* $
] <thm-tensor-hom>

#proof[
  记 $C,D$ 的结构映射分别为
  $ alpha : A->C, quad beta : B->D $
  则对任意 $C^oo$-环 $D$ 都有
  $ Hom_CooRing (B,D) times_(Hom_CooRing (A,D)) Hom_CooRing (C,D) \ simeq Hom_CooRing (B times.o_A^oo C, D) $
  于是
  $
  &Hom_(CooAlg_B) (B times.o_A^oo C,D)\
  simeq&{g:C->D | g compose alpha = beta compose f}\
  =&Hom_(CooAlg_A)(C,f^*D)
  $
]
