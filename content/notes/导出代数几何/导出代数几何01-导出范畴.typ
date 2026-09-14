#import "../../template.typ": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" :*


#show: note

= 链复形

== 链复形的定义

#definition(title:[链复形])[
  固定一个加性范畴 $cal(A)$, 我们定义*链复形* (chain complex) 就是 $cal(A)$ 中的微分分次对象, 也就是说, 一个(上)链复形是一串
  $ ... --> X^(-1) -->^(d^(-1)) X^0 -->^(d^0) X^1 -->^(d^1) ... $
  满足相邻的*微分态射* $d$ 复合为零态射, 一个链复形的态射, 即*链映射*定义为一列逐对象的态射, 与各自的微分都交换, 这样构成一个加性范畴 $Ch(cal(A))$.
]

#proposition[
  若 $cal(A)$ 是Abel范畴, 则 $Ch(cal(A))$ 亦然.
]

关于链复形的详尽理论是同调代数的主题, 此处不过多赘述.

== 链复形的张量积

下面固定一个交换环 $k$. 或者更一般地固定一个加性对称幺半范畴 $(cal(A),times.o,bold(1))$, 下以交换环为例, 余者自然.

#definition(title:[全复形])[
  *全复形* (total complex) 可以理解作一个函子 $"Tot":Ch(Ch(cal(A)))->Ch(cal(A))$, 逐对象定义作
  $ "Tot"(X)^n := plus.o.big_(p+q=n) X^(p,q) $
  逐微分态射定义作
  $ d_"Tot" = d_"hor" + (-1)^p d_"ver" $
]

#remark[
  因为
  $ d^2_"Tot" x &= d^2_"hor" x + (-1)^(p+1) d_"ver" d_"hor" x + (-1)^p d_"hor" d_"ver" x + d^2_"ver" x \ &= (-1)^p (d_"hor" d_"ver" - d_"ver" d_"hor") = 0 $
  这确实是链复形.
]

#definition(title:[链复形的张量积])[
  设 $(cal(A),times.o,bold(1))$ 是加性对称幺半范畴, 定义链复形的张量积为
  $ A^bullet op(times.o) B^bullet := "Tot"(A^bullet times.square B^bullet) $
  其中 $(A^bullet times.square B^bullet)^(p,q)=A^p times.o B^q$ 是典范诱导的双复形.
]

显然这使得 $(Ch(cal(A)), times.o, bold(1)_(cal(A))[0])$ 构成对称幺半加性范畴.

== Hom复形

#definition(title:[Hom复形])[
  设 $X,Y in Ch(cal(A))$ 是上链复形, 那么可以定义
  $ underline(Hom)(X,Y)^n := product_(p in ZZ) Hom_(cal(A)) (X^p, Y^(p+n)) $
  也就是说次数 $n$ 的元素就是全体
  $ f^p : X^p -> Y^(p+n) $
  定义微分为
  $ d(f) = d_Y compose f - (-1)^n f compose d_X $
  容易验证这构成一个 $Ab$-链复形, 若 $cal(A)$ 是 $k$-线性的, 则构成 $Mod_k$-链复形.
]

这显然使得 $Ch(k)$ 是天然充实于自身的.

= dg-范畴

== dg-范畴的定义

#definition(title:[dg-范畴])[
  固定交换环 $k$, 一个*dg-范畴* (differtial graded category) $cal(C)$ 就是充实于 $(Ch(k), times.o_k, bold(1)_k [0])$ 的范畴. 也就是说, 任何对象之间的Hom集被替换成Hom复形 $Hom_(cal(C))(X,Y)$, 并且有复合态射
  $ compose : Hom_(cal(C))(Y,Z) times.o Hom_(cal(C)) (X,Y) -> Hom_(cal(C))(X,Z) $
  以及单位 $k->Hom_(cal(C))(X,X)$.
]

#example[
  $Ch(k)$ 自身就是一个重要的dg-范畴.
]

#example[
  对于概形 $X$, 有完美复形的dg-范畴 $Perf^"dg" (X)$, 对象为完美复形, Hom是导出Hom的dg-模型 $underline("RHom")^bullet (E,F)$ 满足
  $ H^n underline("RHom")(E,F) tilde.eq Ext^n_X (E,F) $
  其dg-脉应该给出稳定 $oo$-范畴 $Perf(X)$.
]

== dga 和 cdga

下面固定一个交换环 $k$.

#definition(title:[dg-代数])[
  一个*dg-代数*, 简写*dga*, 是 $(Ch(k), times.o)$ 的结合代数对象, 即
  $ cat("dgAlg")_k := Alg(Ch(k)) $
  而*交换dg-代数*, 简写*cdga* 就是其交换代数对象, 即
  $ cat("cdgAlg")_k := CAlg(Ch(k)) $
]

#example[
  一个dga可以典范地视作一个只有一个对象的dg-范畴.
]

dga和cdga也可以非常直接地定义, 本质上就是分次环+微分. 一个dga就是一个 $ZZ$-分次的 $k$-代数
$ A = plus.o.big_(n in ZZ) A^n $
满足乘法保持次数
$ A^p A^q subset A^(p+q) $
配备一个次数 $+1$ 的 $k$-线性映射
$ d:A^n -> A^(n+1) $
满足 $d^2=0$, 以及分次Leibniz律
$ d(a b) = d(a)b + (-1)^(deg a) a d (b) $
而cdga就是额外要求了Koszul符号律
$ a b = (-1)^(deg a deg b) b a $

== dg-脉

dg-脉是微分分次的核心构造. 现在开始我们固定一个dg-范畴 $cal(C)_"dg"$, 下面我们逐步给出目标无穷范畴 $cal(C)_oo$ 的构造:

+ 首先对每对 $X,Y$ 取 $tau_(<=0)underline(Hom)(X,Y)$, 这里取的是好截断,也就是说
  $ (tau_(<=0) C)^n := cases(
    C^n quad & n<0,
    Z^0C:=ker(d : C^0->C^1) quad & n=0,
    0 quad & n>0
  ) $
+ 将上述结果重新编号得
  $ K_n (X,Y) := (tau_(<=0)underline(Hom)(X,Y))^(-n) $
  得到了复形
  $ K_bullet (X,Y) = (Z^0 <- underline(Hom)^(-1) <- underline(Hom)^(-1) <- ...) $
+ 由Dold--Kan对应, 有范畴等价 $"DK":Ch_(>=0)(k) -->^~ cat("sMod")_k$, 于是我们规定
  $ Map_(cal(C)_Delta) (X,Y) := "DK"(K_bullet (X,Y)) $
  得到了一个单纯范畴. 单纯范畴是无穷范畴的一种模型. 我们也可以作同伦相干脉函子 $Ner^"hc" (cal(C)_Delta)$ 换成拟范畴模型. 通常我们定义
  $ Ner^"dg" (cal(C)) := Ner^"hc" (cal(C)_Delta) $

现在我们来考察这个函子的含义, 其 0-单形就是 $cal(C)$ 的对象, 一个 1-单形
$ X_0 -> X_1 $
就是一个
$ f_(01) in Z^0 underline(Hom)(X_0,X_1) $
满足 $d f_(01)=0$, 也就是说一个 1-单形就是一个闭的度为零的态射. 而 2-单形刻画一种"复合"关系, 要求给定三个
$ f_(01) : X_0 -> X_1, quad f_(12) : X_1 -> X_2, quad f_(02) : X_0 -> X_2 $
给出一个单形的 filling
$ f_(012) in Hom^(-1) (X_0, X_2) $
满足
$ d f_(012) = f_(02) - f_(12) f_(01) $
也就是要求 $f_(02)$ 和 $f_(12) f_(01)$ 不严格相等, 但链同伦. 更高阶的单形刻画更高阶的相容关系. 因此 dg-脉的核心思想就是将 Hom 复形的负次数方向解释为 $oo$-范畴中的高阶态射, 注意这并没有丢失正次数的信息, 正次数的信息通常可以通过平移来恢复. 核心公式是
$ pi_n Map_(Ner^"dg" (cal(C))) (X,Y) tilde.eq H^(-n) underline(Hom)_(cal(C)) (X,Y) $

从现在开始, 我们可以将 $Ch(A)$ 视作一个由链复形, 链映射和高阶链同伦组成的无穷范畴.

= 导出范畴

== $oo$-范畴的局部化
