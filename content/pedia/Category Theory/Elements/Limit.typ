#import "../../../template.typ": *

#show: note

= Definition

Let $cal(C)$ be an #pedia("Infinity Category")[$oo$-category] and $F: I -> cal(C)$ a small diagram. Write $I^triangle.l$ for $I$ with an initial cone point adjoined, and $I^triangle.r$ for $I$ with a terminal cone point adjoined. All mapping spaces below belong to #pedia("Anima")[$Ani$].

#definition(title: [Limit])[
    A _cone_ on $F$ is an extension $bar(F): I^triangle.l -> cal(C)$. It is a _limit cone_ if it is terminal in the $oo$-category of cones on $F$.

    Its vertex $L := lim_(i in I) F(i)$ is the _limit_. The cone induces equivalences
    $ Map_(cal(C))(T,L) simeq lim_(i in I) Map_(cal(C))(T,F(i)), $
    natural in $T$.
] <limit>

#definition(title: [Colimit])[
    A _cocone_ on $F$ is an extension $bar(F): I^triangle.r -> cal(C)$. It is a _colimit cocone_ if it is initial in the $oo$-category of cocones on $F$.

    Its vertex $Q := colim_(i in I) F(i)$ is the _colimit_. The cocone induces equivalences
    $ Map_(cal(C))(Q,T) simeq lim_(i in I^opp) Map_(cal(C))(F(i),T), $
    natural in $T$.
] <colimit>

#remark[
    Limits and colimits, when they exist, are unique up to a contractible space of choices. All cones and equivalences here include their higher homotopies.
]
