#import "../../template.typ": *

#show: note

This is an example file for testing the writing template. Replace or delete it when you start adding your own notes.

= A first definition <definition>

#definition(title: [Even integer])[
  An integer $n$ is even if $n = 2 k$ for some integer $k$.
] <even-integer>

#theorem[
  The sum of two even integers is even.
] <even-sum>

#proof[
  If $a = 2 m$ and $b = 2 n$, then $a + b = 2 (m + n)$.
]

== Further reading

Try the links in #note-ref("./Test links") or open #geopedia("Test entry").

#fold(title: "Show an exercise")[
  #exercise[Prove that the product of an even integer and any integer is even.]
]
