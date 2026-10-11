#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Projective Limit])[
    Let $I$ be a small #pedia("Filtered Category", <cofiltered>)[cofiltered] #pedia("Infinity Category")[$oo$-category] and $X: I -> cal(C)$ a diagram. Its _projective limit_ (inverse limit, or cofiltered limit) is the #pedia("Limit", <limit>)[limit]
    $ varprojlim(i in I) X_i := lim_(i in I) X_i, $
    when it exists. Its universal property is
    $ Map_(cal(C))(T,varprojlim(i in I) X_i) simeq lim_(i in I) Map_(cal(C))(T,X_i), $
    with the limit on the right taken in #pedia("Anima")[$Ani$].
] <definition>

#example[
    An inverse sequence $dots -> X_2 -> X_1 -> X_0$ is indexed by the cofiltered category $NN^opp$.
]
