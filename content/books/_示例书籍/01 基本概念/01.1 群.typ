#import "../../../template.typ": *

#show: note

= 定义与例子

#definition(title: "群")[
  群是带有满足结合律的乘法、单位元与逆元的集合.
]

#theorem[
  群的单位元唯一.
] <unit-unique>

#proof[
  若 $e$ 与 $e'$ 都是单位元, 则 $e = e e' = e'$.
]

继续阅读 #book-ref("./01.2 进一步讨论.typ").
