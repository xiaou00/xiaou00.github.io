#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本篇笔记将详细介绍 pro-空间的理论. 固定 $cal(C)$ 是一个小 $oo$-范畴.

= pro-空间

== 形式极限的思想

我们先来回顾 ind-完备化和 pro-完备化的含义, 其定义与基本性质参考#note-ref("./1 完备化.typ").

通常情况下, Yoneda 嵌入
$ j : cal(C) -> PShv(cal(C)) $
保持全部极限, 但一般不保持余极限. 于是我们引入了 ind-对象的概念, 例如一个 ind-对象是
$ F = varinjlim(i) j(X_i) $
在预层范畴中的滤过余极限, 即使 $cal(C)$ 已经存在
$ X := varinjlim(i)X_i $
我们仍然一般有
$ varinjlim(i) j(X_i) != j(X) $
我们把 ind-版本的这个极限 $F$ 称作一个*形式余极限* (formal colimit), 这可以理解成_按泛性质自由地加入余极限, 不强迫其等于原范畴里已有的某个对象_, 这个构造我们一般记作
$ F = quot(varinjlim(i)) X_i $

#claim[
    我们所需的泛性质就是
    $ Map_(Ind(cal(C))) (C,quot(varinjlim(i)) X_i) simeq varinjlim(i) Map_(cal(C))(C,X_i) $
]
而 pro 版本就是完全的对偶.

#definition(title:[pro-对象])[
    范畴 $cal(C)$ 的 *pro-对象*或称*形式极限对象*, 就是 $Pro(cal(C))$ 中的对象. 我们可以将一个 pro-对象表作
    $ quot(varprojlim(i))X_i $
    并将这个过程称之为一个形式投射极限.
]

#remark[
    一般来说, 我们可以用一个余滤过的 $I->cal(C)$ 来表示一个 pro-对象, 不过注意一般不同的余滤过系统可以表示同一个 pro-对象.
]

#definition(title:[pro-空间])[
    一个 *pro-空间*就是范畴 $Pro(Ani)$ 的对象.
]

#remark[
    对于有有限极限的范畴 $cal(C)$, 总有
    $ Pro(cal(C)) simeq Fun^"lex" (cal(C),Ani)^opp $
]

== 实化

现在我们得到的形式极限
$ quot(varprojlim(i))X_i $
说白了并没有一个真正的极限值, 它只是存在在那里罢了.

#construction(title:[常值嵌入])[
    非常显然地, 我们可以进行一个常值图表的嵌入
    $ "con" : cal(C) arrow.hook Pro(cal(C)), quad X |-> quot(varprojlim(* in *)) X_* $
]

 直觉上, 如果 $cal(C)$ 本身就具有所有的投射极限, 那么应该存在一种 "取值" 操作.

#claim[
    当 $cal(C)$ 存在所有投射极限时, 这个嵌入 $"con"$ 有右伴随
    $ Mater : Pro(cal(C)) -> cal(C), quad quot(varprojlim(i))X_i |-> varprojlim(i)X_i $
    称之为 $Pro(cal(C))$ 上的*实化* (materialization).
]

#proposition(title:[映射空间公式])[
    设 $X = quot(varprojlim(i in I))X_i, quad Y = quot(varprojlim(j in J))Y_j$ 是 $Pro(cal(C))$ 的两个对象, $I,J$ 是余滤的, 则
    $ Map_(Pro(cal(C))) (X,Y) simeq varprojlim(j in J)varinjlim(i in I^opp) Map_(cal(C)) (X_i,Y_j) $
] <prop-mapping-space-formula>

#proof[
    记 $cal(D) = cal(C)^opp$, 则 $Pro(cal(C)) = Ind(cal(D))^opp$. $X$ 在 $cal(D)$ 中对应
    $ X^or = varinjlim(i in I^opp) X^opp_i $
    这是因为 $I^opp$ 滤过, 同理
    $ Y^or = varinjlim(j in J^opp) Y^opp_j $
    于是
    $ Map_(Pro(cal(C))) (X,Y) &simeq Map_(Ind(cal(D))) (Y^or, X^or) \
                              &simeq Map_(Ind(cal(D))) (varinjlim(j in J^opp)Y^opp_j, varinjlim(i in I^opp)X^opp_i)  $ 
    首先, 映射空间对于第一个变量将极限变为余极限, 从而上式化简为
    $ varprojlim(j in J) Map_(Ind(cal(D))) (Y^opp_j, varinjlim(i in I^opp)X^opp_i) $
    而每个 $Y^opp_j in cal(D) subset Ind(cal(D))$ 对于滤过余极限是紧的, 所以上式又化简为
    $ varprojlim(j in J) varinjlim(i in I^opp) Map_(cal(D)) (Y^opp_j, X^opp_i) simeq varprojlim(j in J) varinjlim(i in I^opp) Map_(cal(C)) (X_i,Y_j) $
]

现在我们可以说明上述伴随的泛性质成立, 设 $X = quot(varprojlim(i))X_i$, 则对任意 $C in cal(C)$, 由映射空间公式有
$ Map_(Pro(cal(C))) ("con"(C),X) simeq varprojlim(i)Map_(cal(C))(C,X_i) $
可表函子保持极限, 于是
$ varprojlim(i)Map_(cal(C))(C,X_i) simeq Map_(cal(C))(C,varprojlim(i)X_i) simeq Map_(cal(C))(C,Mater(X)) $

== pro-截断

回顾生象的 Postnikov 塔
$ ... -> tau_2 X -> tau_1 X -> tau_0 X $

#claim[
    生象满足
    $ X simeq varprojlim(n)tau_n X $
    也就是说 $Ani$ 是 *Postnikov 完备的*.
]

回顾 pro-完备化的泛性质是: _$Pro(cal(C))$ 是 $cal(C)$ 自由加入小投射极限得到的 $oo$-范畴_, 也就是说

#claim[
    沿着嵌入 $j:cal(C)->Pro(cal(C))$ 的限制函子给出等价
    $ j^* : Fun^"cofilt" (Pro(cal(C)),cal(D)) ->^~ Fun(cal(C),cal(D)) $
]

从而对于 $tau_n : Ani -> Ani_(<=n)$ 唯一延拓成
$ tau_n^"pro" : Pro(Ani) -> Pro(Ani_(<=n)) $
称之为 *pro-$n$-截断*.

#claim[
    我们有非常明显的公式
    $ tau^"pro"_n X simeq quot(varprojlim(i)) tau_n X_i $
]

#claim[
    对于嵌入 $iota_n:Ani_(<=n) -> Ani$ 诱导 $Pro(iota_n):Pro(Ani_(<=n))->Pro(Ani)$, 有伴随
    $ tau^"pro"_(n) tack.l Pro(iota_n) $
]

#construction[
    我们定义
    $ Ani_(<oo) := union.big_(n>=-2) Ani_(<=n) $
    也就是所有截断空间, 考虑
    $ Pro(Ani_(<oo)) -> Pro(Ani) $
    有左伴随 $tau_(oo)$, 称之为 *pro-截断*.
]

显然对于 $X in Ani$, pro-截断就是形式的 Postnikov 塔
$ tau_oo (j X) simeq quot(varprojlim(n))tau_n X $

#claim[
    一般的 pro-空间 $X = quot(varprojlim(i))X_i$ 的 pro-截断就是
    $ tau_oo X simeq quot(varprojlim((i,n)))tau_n X_i $
    这一个双重逆向系统的形式极限.
]

