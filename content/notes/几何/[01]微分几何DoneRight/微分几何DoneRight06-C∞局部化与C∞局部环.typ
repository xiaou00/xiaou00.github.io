#import "../../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*

#show: note

本节固定 $k$ 是基底 $C^oo$-环, 若要得到普通 $C^oo$-环的理论, 取 $k=RR$ 即可.

= 局部化

== 单元素的局部化

#construction[
    我们定义
    $ k{t,t^(-1)} := k{t,u}/(t u - 1) $
]

若 $k = RR$, 那么
$ RR{t,u} = C^oo (RR^2) $
而
$ RR{t,t^(-1)} = C^oo (RR^2)/(t u - 1) $
几何上, 方程 $t u = 1$ 切出双曲线
#implicit-plot(
    (x,y) => x * y - 1,
)
即
$ H = {(t,u) in RR^2 : t u=1} $
而投影到第一个坐标给出了微分同胚
$ j^*:H -->^~ RR^times = RR\\{0}, quad (t,u)|->t $
其逆为
$ t |-> (t,t^(-1)) $
从而
$ RR{t,t^(-1)} simeq C^oo (RR^times), quad Spec_oo RR{t,t^(-1)} simeq RR^times $
其带有典范态射
$ j : k{t} -> k{t,t^(-1)} $
含义为先嵌入 $k{t,u}$, 再进行商. 几何意义就是
$ j^* : H larr^"嵌入" RR^2 larr^"投影到第一坐标" RR $
也就是上面给出的微分同胚映射.

#definition(title:[局部化])[
   设 $A$ 是 $k$-$C^oo$-代数, $f in A$, 有典范的映射
   $
   alpha_f : k{t} -> A, quad t |-> f \
   j : k{t} -> k{t,t^(-1)}
   $
   定义其在元素 $f$ 处的*局部化* (localization) 为
   $ A{f^(-1)} := A times.o^oo_(k{t}) k{t,t^(-1)} $
]

也就是说, 图表推出
#web-diagram(diagram({
	node((1, -1), [$k{t}$])
	node((2, -1), [$A$])
	node((1, 0), [$k{t,t^(-1)}$])
	node((2, 0), [$A{f^(-1)}$])
	edge((1, -1), (1, 0), [$j$], label-side: right, "->")
	edge((1, -1), (2, -1), [$t|->f$], label-side: left, "->")
	edge((2, -1), (2, 0), "->")
	edge((1, 0), (2, 0), "->")
	edge((1, -1), (2, 0), [$corner.r.b$], label-side: center, label-pos: 0.9, shift: 0.1, " ")
}))
这个图表可以取 $Spec_oo$, 得到
#web-diagram(diagram({
	node((2, 0), [$"Spec"_oo k{t}$])
	node((2, -1), [$"Spec"_oo A$])
	node((1, 0), [$"Spec"_oo k{t,t^(-1)}$])
	node((1, -1), [$"Spec"_oo A{f^(-1)}$])
	edge((2, 0), (1, 0), [$j^*$], label-side: left, "<-")
	edge((2, 0), (2, -1), "<-")
	edge((2, -1), (1, -1), "<-")
	edge((1, 0), (1, -1), "<-")
	edge((2, 0), (1, -1), [$corner.l$], label-side: center, label-pos: 0.9, shift: 0.1, " ")
}))
当 $k=RR$ 时, 也就是图表
#web-diagram(diagram({
	node((2, 0), [$RR$])
	node((2, -1), [$"Spec"_oo A$])
	node((1, 0), [$RR^times$])
	node((1, -1), [$"Spec"_oo A{f^(-1)}$])
	edge((1, 0), (2, 0), [$j^*$], label-side: right, "->")
	edge((2, -1), (2, 0), "->")
	edge((1, -1), (2, -1), "->")
	edge((1, -1), (1, 0), "->")
	edge((2, 0), (1, -1), [$corner.l$], label-side: center, label-pos: 0.9, shift: 0.1, " ")
}))
例如, 当 $A = C^oo (RR^2)$, $f(x,y)=x^2+y^2-1$ 时, 这个构造就是
#web-diagram(diagram({
	node((2, 0), [$RR$])
	node((2, -1), [$RR^2$])
	node((1, 0), [$RR^times$])
	node((1, -1), [$RR^2\\S^1$])
	edge((1, 0), (2, 0), [$j^*$], label-side: right, "->")
	edge((2, -1), (2, 0), [$f$], label-side: left, "->")
	edge((1, -1), (2, -1), "->")
	edge((1, -1), (1, 0), "->")
	edge((2, 0), (1, -1), [$corner.l$], label-side: center, label-pos: 0.9, shift: 0.1, " ")
}))

#remark[
    局部化 $A{f^(-1)}$ 和商 $A/(f)$ 在几何上形成一对非常自然的互补操作, 商对应取零点 $f=0$, 而局部化对应取非零点 $f!=0$.
]

#proposition(title:[商-局部化正交性])[
    设 $A$ 是 $k$-$C^oo$-代数, 且 $f in A$, 则
    $ (A/(f)) times.o^oo_A A{f^(-1)} simeq 0 $
]

#proof[
    这相当于计算 $A{f^(-1)}/(f)$, 由于 $f$ 可逆, $(f) = A{f^(-1)}$, 证毕.
]

== 乘性集的局部化
