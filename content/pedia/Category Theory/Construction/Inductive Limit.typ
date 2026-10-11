#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Inductive Limit])[
    Let $I$ be a small #pedia("Filtered Category")[filtered] #pedia("Infinity Category")[$oo$-category] and $X: I -> cal(C)$ a diagram. Its _inductive limit_ (direct limit, or filtered colimit) is the #pedia("Limit", <colimit>)[colimit]
    $ varinjlim(i in I) X_i := colim_(i in I) X_i, $
    when it exists. Its universal property is
    $ Map_(cal(C))(varinjlim(i in I) X_i,T) simeq lim_(i in I^opp) Map_(cal(C))(X_i,T), $
    with the limit on the right taken in #pedia("Anima")[$Ani$].
] <definition>

#example[
    For an increasing sequence of sets $X_0 subset X_1 subset dots$, the inductive limit is $union.big_(n >= 0) X_n$.
]
