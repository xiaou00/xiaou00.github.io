#import "../../../template.typ": *

#show: note

= 进一步讨论

上一节的结论见 #book-ref("./01.1 群.typ", target: <unit-unique>).

#theorem[
  群中每个元素的逆元唯一.
]

#proof[
  若 $b, c$ 都是 $a$ 的逆元, 则 $b = b (a c) = (b a) c = c$.
]
