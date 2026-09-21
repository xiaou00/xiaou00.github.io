#import "../../geopedia-template.typ": *

#encyclopedia(
  name: [$ZZ$],
  aliases: ([整数环], [Integers]),
  introduction: [含幺环范畴 $Ring$ 的始对象.],
  definition: [
    整数集合配备通常的加法与乘法, 构成交换含幺环 $ZZ$.

    对任意含幺环 $R$, 存在唯一的保幺环同态
    $ ZZ -> R, quad n |-> n dot 1_R. $
  ],
  properties: (
    [Euclid 整环],
    [主理想整环],
    [唯一分解整环],
    [Noether 环],
    [正规 (整闭)],
    [正则],
    [Cohen-Macaulay],
    [Gorenstein],
    [Dedekind 整环],
  ),
  invariants: (
    ([特征], [$0$]),
    ([Krull 维数], [$1$]),
    ([分式域], [$Frac(ZZ) = QQ$]),
    ([单位群], [$ZZ^times = {1, -1}$]),
  ),
  content: [
    每个理想唯一写成 $(n)$, 其中 $n >= 0$.
    素理想为 $(0)$ 以及 $(p)$, 其中 $p$ 为正素数.

    $ZZ$ 在分式域 $QQ$ 中整闭, 因而是正规整环.
    它还是一维 Noether 整环, 所以是 Dedekind 整环.

    对每个正素数 $p$, 局部环 $ZZ_((p))$ 是以 $p$ 为一致化元的离散赋值环,
    因而是一维正则局部环. 又有 $ZZ_((0)) = QQ$, 所以 $ZZ$ 是正则环,
    从而是 Gorenstein 环与 Cohen-Macaulay 环.

    $Spec ZZ$ 的泛点为 $(0)$, 剩余域是 $QQ$.
    每个正素数 $p$ 对应一个闭点 $(p)$, 剩余域为有限域 $FF_p$.
  ],
)
